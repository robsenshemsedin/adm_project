from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pymongo import MongoClient

# Initialize FastAPI app
app = FastAPI()

# Add CORS middleware to allow web app access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (for development). Use specific domains in production.
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB connections to all four hosts
from pymongo import MongoClient

# Reduce socketTimeoutMS and connectTimeoutMS to 2000ms (1 seconds)
clients = [
    MongoClient("mongodb://localhost:27017/", serverSelectionTimeoutMS=1000, socketTimeoutMS=1000, connectTimeoutMS=1000),
    MongoClient("mongodb://localhost:27018/", serverSelectionTimeoutMS=1000, socketTimeoutMS=1000, connectTimeoutMS=1000),
    MongoClient("mongodb://localhost:27019/", serverSelectionTimeoutMS=1000, socketTimeoutMS=1000, connectTimeoutMS=1000),
    MongoClient("mongodb://localhost:27020/", serverSelectionTimeoutMS=1000, socketTimeoutMS=1000, connectTimeoutMS=1000),
]


# Access 'region' collection from all hosts
regions_collections = [client["italian_census"]["region"] for client in clients]

# Helper function to query all collections
def query_all_collections(query):
    results = []
    active_hosts = 0
    for collection in regions_collections:
        try:
            data = list(collection.find(query, {"_id": 0}))
            if data:
                results.extend(data)
                active_hosts += 1  # Track active hosts
        except Exception as e:
            print(f"Skipping unavailable host: {e}")
    
    if active_hosts == 0:
        raise HTTPException(status_code=503, detail="All database hosts are unavailable. Please try again later.")

    return results

@app.get("/")
def root():
    return {"message": "Welcome to the Distributed Italian Census Data API!"}

# Get all distinct regions
@app.get("/regions")
def get_regions():
    try:
        regions = set()
        for collection in regions_collections:
            regions.update(collection.distinct("region"))
        return {"regions": list(regions)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get details of a specific region
@app.get("/regions/{region_name}")
def get_region_details(region_name: str):
    try:
        query = {"region": region_name}
        results = query_all_collections(query)
        if not results:
            raise HTTPException(status_code=404, detail="Region not found")
        return {"region": region_name, "data": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get province details
@app.get("/provinces/{province_name}")
def get_province_details(province_name: str):
    try:
        query = {"province": province_name}
        results = query_all_collections(query)
        if not results:
            raise HTTPException(status_code=404, detail="Province not found")
        return {"province": province_name, "data": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Search across regions, provinces, and municipalities
@app.get("/search")
def search_data(query: str):
    try:
        search_query = {
            "$or": [
                {"region": {"$regex": query, "$options": "i"}},
                {"province": {"$regex": query, "$options": "i"}},
                {"municipality": {"$regex": query, "$options": "i"}},
            ]
        }
        results = query_all_collections(search_query)
        if not results:
            raise HTTPException(status_code=404, detail="No matching data found.")
        return {"results": results}
    except HTTPException as e:
        raise e  # Pass through HTTP exceptions
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Server error: {str(e)}")

# Get employment summary
@app.get("/regions/{region_name}/employment_summary")
def get_employment_summary(region_name: str):
    try:
        pipeline = [
            {"$match": {"region": region_name}},
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

        results = []
        for collection in regions_collections:
            try:
                results.extend(collection.aggregate(pipeline))
            except Exception as e:
                print(f"Skipping unavailable host during aggregation: {e}")

        if not results:
            raise HTTPException(status_code=404, detail="No employment data available")

        return results[0]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

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

        