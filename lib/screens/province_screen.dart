import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'municipality_screen.dart';
import '../widgets/detail_card.dart';
import '../widgets/list_item.dart';

import 'package:flutter/material.dart';
import 'municipality_screen.dart';


class ProvinceScreen extends StatelessWidget {
  final String provinceName;

  ProvinceScreen({required this.provinceName});

  
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
        title: Text(provinceName),
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
          int totalPopulation = 0;
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
            totalPopulation += (population['total'] ?? 0) as int;
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

          return ListView(
            children: [
              // Summary Details
              DetailCard(
                title: 'Population',
                content: '''
Total: $totalPopulation
Male: $malePopulation
Female: $femalePopulation
                ''',
              ),
              DetailCard(
                title: 'Education',
                content: '''
No Education: ${educationSummary['no_education']}
Elementary: ${educationSummary['elementary']}
Middle: ${educationSummary['middle']}
High School: ${educationSummary['high_school']}
Tertiary: ${educationSummary['tertiary']}
                ''',
              ),
              DetailCard(
                title: 'Employment',
                content: '''
Total Employed: ${employmentSummary['total_employed']}
Male Employed: ${employmentSummary['male_employed']}
Female Employed: ${employmentSummary['female_employed']}
                ''',
              ),
              // Municipalities List
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Municipalities',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: municipalities.length,
                itemBuilder: (context, index) {
                  final municipality = municipalities[index]['municipality'];
                  return ListTile(
                    title: Text(municipality ?? 'Unknown'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MunicipalityScreen(
                            municipalityName: municipality,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
