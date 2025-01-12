// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'municipality_screen.dart';
import '../widgets/detail_card.dart';

class ProvinceScreen extends StatelessWidget {
  final String provinceName;

  const ProvinceScreen({super.key, required this.provinceName});

  
    Future<Map<String, dynamic>> fetchProvinceData(String name) async {
    final response = await fetchProvinceDetails(name); // Call the endpoint
    if (response['province'] == null) {
      throw Exception("Failed to load province details");
    }
    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
       title: Text(
         provinceName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
   
        backgroundColor: Colors.green[800], // Inspired by the green in the Italian flag
        elevation: 0,
        
),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProvinceData(provinceName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available for $provinceName"));
          }

          final provinceData = snapshot.data!;
          final municipalities = provinceData['data'] ?? [];

          // Aggregate data for summaries
          int malePopulation = 0;
          int femalePopulation = 0;
          Map<String, int> educationSummary = {
            "no_education": 0,
            "elementary": 0,
            "middle": 0,
            "high_school": 0,
            "tertiary": 0,
          };
          Map<String, int> employmentSummary = {
            "total_employed": 0,
            "male_employed": 0,
            "female_employed": 0,
          };

          for (var municipality in municipalities) {
            final population = municipality['population'] ?? {};
            malePopulation += (population['male'] ?? 0) as int;
            femalePopulation += (population['female'] ?? 0) as int;

            final education = municipality['education'] ?? {};
            educationSummary['no_education'] =
                educationSummary['no_education']! + (education['no_education'] ?? 0) as int;
            educationSummary['elementary'] =
                educationSummary['elementary']! + (education['elementary'] ?? 0) as int;
            educationSummary['middle'] =
                educationSummary['middle']! + (education['middle'] ?? 0) as int;
            educationSummary['high_school'] =
                educationSummary['high_school']! + (education['high_school'] ?? 0) as int;
            educationSummary['tertiary'] =
                educationSummary['tertiary']! + (education['tertiary'] ?? 0) as int;

            final employment = municipality['employment'] ?? {};
            employmentSummary['total_employed'] =
                employmentSummary['total_employed']! + (employment['total_employed'] ?? 0) as int;
            employmentSummary['male_employed'] =
                employmentSummary['male_employed']! + (employment['male_employed'] ?? 0) as int;
            employmentSummary['female_employed'] =
                employmentSummary['female_employed']! + (employment['female_employed'] ?? 0) as int;
          }


          return Row(
            children: [
              // Summary Details
                 DetailCard(malePopulation: malePopulation, femalePopulation: femalePopulation, maleEmployed: employmentSummary['male_employed'] as int, femaleEmployed: employmentSummary['female_employed'] as int, educationSummary: educationSummary)
  ,

  //             Expanded(
  // flex: 1,
  // child: Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Text(
  //         "Municipalities",
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.green[800],
  //         ),
  //       ),
  //     ),
  //     Expanded(
  //       child: ListView.builder(
  //         itemCount:municipalities.length,
  //         itemBuilder: (context, index) {
  //          final municipality = municipalities[index]['municipality'];
  //           return GestureDetector(
  //             onTap: () {
  //                Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => MunicipalityScreen(
  //                           municipalityName: municipality,
  //                         ),
  //                       ),
  //                     );
  //             },
  //             child: Card(
  //               elevation: 4,
  //               shadowColor: Colors.red[700] ,
  //               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Text(
  //                    municipality ?? 'Unknown',
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //          ),
            
      
  //           ],   ),   ),
            
            
            ]  
          );
        },
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String content;

  const _DetailCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}
