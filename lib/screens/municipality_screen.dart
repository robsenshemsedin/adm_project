import 'package:adm_project/widgets/detail_card.dart';
import 'package:flutter/material.dart';

class MunicipalityScreen extends StatelessWidget {
  final String municipalityName;
  final List<Map<String, dynamic>> data;

  MunicipalityScreen({required this.municipalityName, required this.data});

  @override
  Widget build(BuildContext context) {
    // Assuming the data has only one entry for a municipality
    final municipalityData = data.first;

    final int populationTotal = (municipalityData['population']['total'] as num).toInt();
    final int malePopulation = (municipalityData['population']['male'] as num).toInt();
    final int femalePopulation = (municipalityData['population']['female'] as num).toInt();

    final Map<String, int> educationSummary = {
      'no_education': (municipalityData['education']['no_education'] as num).toInt(),
      'elementary': (municipalityData['education']['elementary'] as num).toInt(),
      'middle': (municipalityData['education']['middle'] as num).toInt(),
      'high_school': (municipalityData['education']['high_school'] as num).toInt(),
      'tertiary': (municipalityData['education']['tertiary'] as num).toInt(),
    };

    final Map<String, int> employmentSummary = {
      'total_employed': (municipalityData['employment']['total_employed'] as num).toInt(),
      'male_employed': (municipalityData['employment']['male_employed'] as num).toInt(),
      'female_employed': (municipalityData['employment']['female_employed'] as num).toInt(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(municipalityName),
      ),
      body: ListView(
        children: [
          DetailCard(
            title: 'Population',
            content: '''
Total: $populationTotal
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
        ],
      ),
    );
  }
}
