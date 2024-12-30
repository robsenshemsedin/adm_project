from fastapi import FastAPI, HTTPException
from pymongo import MongoClient
from bson.json_util import dumps
from bson.objectid import ObjectId
from fastapi.middleware.cors import CORSMiddleware



# Initialize FastAPI app
app = FastAPI()
# Add CORS middleware to the app

app.add_middleware( 
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for testing; use specific domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# MongoDB connection
client = MongoClient("mongodb://localhost:27017/")  # Adjust if your MongoDB is hosted elsewhere
db = client["italian_census"]
regions_collection = db["regions"]

@app.get("/")
def root():
    return {"message": "Welcome to the Italian Census Data API!"}

@app.get("/municipalities/{municipality_name}")
def get_municipality_details(municipality_name: str):
    try:
        # Query for a specific municipality
        municipality = regions_collection.find_one(
            {"municipality": municipality_name},
            {"_id": 0}
        )
        if not municipality:
            raise HTTPException(status_code=404, detail="Municipality not found")
        return {"municipality": municipality}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/provinces/{province_name}")
def get_province_details(province_name: str):
    try:
        # Query all municipalities under the province
        province_data = list(regions_collection.find(
            {"province": province_name},
            {"_id": 0}
        ))
        if not province_data:
            raise HTTPException(status_code=404, detail="Province not found")
        return {"province": province_name, "data": province_data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get all distinct regions
@app.get("/regions")
def get_regions():
    try:
        regions = regions_collection.distinct("region")  # Fetch distinct regions
        return {"regions": regions}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get details of a specific region by name, including all provinces/municipalities
@app.get("/regions/{region_name}")
def get_region_details(region_name: str):
    try:
        # Query all documents matching the region name
        regions = list(regions_collection.find({"region": region_name}, {"_id": 0}))
        if not regions:
            raise HTTPException(status_code=404, detail="Region not found")
        
        # Return all related data for the region
        return {"region": region_name, "data": regions}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Get provinces in a specific region
@app.get("/regions/{region_name}/provinces")
def get_provinces(region_name: str):
    try:
        provinces = list(regions_collection.find({"region": region_name}, {"_id": 0, "province": 1}))
        if not provinces:
            raise HTTPException(status_code=404, detail="Region not found")
        return {"provinces": [prov["province"] for prov in provinces]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Search for region, province, or municipality
@app.get("/search")
def search_data(query: str):
    try:
        results = list(regions_collection.find(
            {
                "$or": [
                    {"region": {"$regex": query, "$options": "i"}},
                    {"province": {"$regex": query, "$options": "i"}},
                    {"municipality": {"$regex": query, "$options": "i"}}
                ]
            },
            {"_id": 0}
        ))
        return {"results": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Population filter
@app.get("/regions/population/greater_than/{threshold}")
def get_regions_with_population_greater_than(threshold: int):
    try:
        pipeline = [
            {
                "$group": {
                    "_id": "$region",  # Group by region
                    "total_population": {"$sum": "$population.total"}  # Sum total population
                }
            },
            {
                "$match": {
                    "total_population": {"$gt": threshold}  # Match regions with population > threshold
                }
            }
        ]
        results = list(regions_collection.aggregate(pipeline))
        if not results:
            return {"regions": []}
        return {"regions": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/regions/{region_name}/employment_summary")
def get_employment_summary(region_name: str):
    try:
        # Aggregate employment data for the given region
        pipeline = [
            {"$match": {"region": region_name}},  # Filter by region
            {
                "$group": {
                    "_id": "$region",
                    "total_employed": {"$sum": "$employment.total_employed"},
                    "male_employed": {"$sum": "$employment.male_employed"},
                    "female_employed": {"$sum": "$employment.female_employed"},
                }
            },
            {"$project": {"_id": 0, "region": "$_id", "employment_summary": "$$ROOT"}}
        ]

        result = list(regions_collection.aggregate(pipeline))
        if not result:
            raise HTTPException(status_code=404, detail="Region not found or no employment data available")

        return result[0]["employment_summary"]  # Return the aggregated employment summary

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Age group population distribution
@app.get("/regions/{region_name}/age_distribution")
def age_distribution(region_name: str = None):
    try:
        match_stage = {"$match": {"region": region_name}} if region_name else {}
        pipeline = [
            match_stage,
            {
                "$group": {
                    "_id": "$region",
                    "age_group_<5": {"$sum": "$population.age_groups.<5"},
                    "age_group_5-9": {"$sum": "$population.age_groups.5-9"},
                    "age_group_10-14": {"$sum": "$population.age_groups.10-14"}
                }
            }
        ]
        result = list(regions_collection.aggregate(pipeline))
        return {"age_distribution": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/regions/{region_name}/education_summary")
def get_education_summary(region_name: str):
    try:
        # Aggregate education data for the given region
        pipeline = [
            {"$match": {"region": region_name}},  # Filter by region
            {
                "$group": {
                    "_id": "$region",
                    "total_no_education": {"$sum": "$education.no_education"},
                    "total_elementary": {"$sum": "$education.elementary"},
                    "total_middle": {"$sum": "$education.middle"},
                    "total_high_school": {"$sum": "$education.high_school"},
                    "total_tertiary": {"$sum": "$education.tertiary"},
                }
            },
            {"$project": {"_id": 0, "region": "$_id", "education_summary": "$$ROOT"}}
        ]

        result = list(regions_collection.aggregate(pipeline))
        if not result:
            raise HTTPException(status_code=404, detail="Region not found or no education data available")

        return result[0]  # Return the aggregated education summary

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
