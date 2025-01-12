import 'package:adm_project/services/api_service.dart';
import 'package:adm_project/widgets/detail_card.dart';

import 'package:flutter/material.dart';

class MunicipalityScreen extends StatelessWidget {
  final String municipalityName;

  const MunicipalityScreen({super.key, required this.municipalityName});

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
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
       title: Text(
         municipalityName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
   
        backgroundColor: Colors.green[800], // Inspired by the green in the Italian flag
        elevation: 0,
        
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

          return 
          
      Row(
            children: [
              // Summary Details
                 DetailCard(malePopulation: population['male'] , femalePopulation: population['female'], maleEmployed: employment['male_employed'] as int, femaleEmployed: employment['female_employed'] as int, educationSummary: education)
  ,

  Expanded(
 flex: 1,
 child:  Container() )]
    );

        },
      ),
    );
  }
}