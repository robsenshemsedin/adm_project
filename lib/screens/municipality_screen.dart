import 'package:adm_project/services/api_service.dart';
import 'package:adm_project/widgets/detail_card.dart';
import 'package:flutter/material.dart';

class MunicipalityScreen extends StatelessWidget {
  final String municipalityName;

  MunicipalityScreen({required this.municipalityName});

  Future<Map<String, dynamic>> fetchMunicipalityData(String name) async {
    final response = await fetchMunicipalityDetails(name); // Call the endpoint
    if (response['municipality'] == null) {
      throw Exception("Failed to load municipality details");
    }
    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(municipalityName),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMunicipalityData(municipalityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available for $municipalityName"));
          }

          final municipalityData = snapshot.data!['municipality'];
          final population = municipalityData['population'] ?? {};
          final education = municipalityData['education'] ?? {};
          final employment = municipalityData['employment'] ?? {};

          return ListView(
            children: [
              DetailCard(
                title: 'Population',
                content: '''
Total: ${population['total'] ?? 'N/A'}
Male: ${population['male'] ?? 'N/A'}
Female: ${population['female'] ?? 'N/A'}
                ''',
              ),
              DetailCard(
                title: 'Education',
                content: '''
No Education: ${education['no_education'] ?? 'N/A'}
Elementary: ${education['elementary'] ?? 'N/A'}
Middle: ${education['middle'] ?? 'N/A'}
High School: ${education['high_school'] ?? 'N/A'}
Tertiary: ${education['tertiary'] ?? 'N/A'}
                ''',
              ),
              DetailCard(
                title: 'Employment',
                content: '''
Total Employed: ${employment['total_employed'] ?? 'N/A'}
Male Employed: ${employment['male_employed'] ?? 'N/A'}
Female Employed: ${employment['female_employed'] ?? 'N/A'}
                ''',
              ),
            ],
          );
        },
      ),
    );
  }
}
