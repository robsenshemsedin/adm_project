import 'package:adm_project/widgets/detail_card.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'province_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class RegionScreen extends StatelessWidget {
  final String regionName;

  RegionScreen({required this.regionName});

  Future<Map<String, dynamic>> fetchRegionData() async {
    return await fetchRegionDetails(regionName); // API call to get region details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
       title: Text(
         regionName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
   
        backgroundColor: Colors.green[800], // Inspired by the green in the Italian flag
        elevation: 0,
        
),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchRegionData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available for $regionName"));
          }

          final regionData = snapshot.data!;
          final provinces = regionData['data'] ?? [];
          final uniqueProvinces = provinces
              .map((province) => province['province'])
              .toSet()
              .toList();

          // Aggregate summaries for the region
          int totalPopulation = 0;
          int malePopulation = 0;
          int femalePopulation = 0;
          Map<String, int> educationSummary = {
            "No Education": 0,
            "Elementary": 0,
            "Middle": 0,
            "High School": 0,
            "Tertiary": 0,
          };
          int totalEmployment = 0, maleEmployed = 0, femaleEmployed = 0;

          for (var province in provinces) {
            final population = province['population'] ?? {};
            totalPopulation += (population['total'] ?? 0) as int;
            malePopulation += (population['male'] ?? 0) as int;
            femalePopulation += (population['female'] ?? 0) as int;

            final education = province['education'] ?? {};
       educationSummary['No Education'] =
    (educationSummary['No Education'] ?? 0) +
    (education['no_education'] ?? 0) as int;
educationSummary['Elementary'] =
    (educationSummary['Elementary'] ?? 0) +
    (education['elementary'] ?? 0) as int;
educationSummary['Middle'] =
    (educationSummary['Middle'] ?? 0) +
    (education['middle'] ?? 0) as int;
educationSummary['High School'] =
    (educationSummary['High School'] ?? 0) +
    (education['high_school'] ?? 0) as int;
educationSummary['Tertiary'] =
    (educationSummary['Tertiary'] ?? 0) +
    (education['tertiary'] ?? 0) as int;


            final employment = province['employment'] ?? {};
            totalEmployment += (employment['total_employed'] ?? 0) as int;
            maleEmployed += (employment['male_employed'] ?? 0) as int;
            femaleEmployed += (employment['female_employed'] ?? 0) as int;
          }

          return Row(
            children: [
              // Left side: Visualization Section
             DetailCard(femalePopulation: femalePopulation, malePopulation: malePopulation, maleEmployed: maleEmployed, educationSummary: educationSummary, femaleEmployed: femaleEmployed),
              // Right side: Province List
             Expanded(
  flex: 1,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Provinces",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: uniqueProvinces.length,
          itemBuilder: (context, index) {
            final provinceName = uniqueProvinces[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProvinceScreen(
                      provinceName: provinceName,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shadowColor: Colors.red[700] ,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    provinceName,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),

            ],
          );
        },
      ),
    );
  }
}
