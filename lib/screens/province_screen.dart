import 'package:adm_project/widgets/detail_card.dart';
import 'package:adm_project/widgets/list_item.dart';
import 'package:flutter/material.dart';

import 'municipality_screen.dart';

class ProvinceScreen extends StatelessWidget {
  final String provinceName;
  final List<Map<String, dynamic>> data;

  ProvinceScreen({required this.provinceName, required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate summaries for population, education, and employment
    final int populationSummary = data.fold<int>(
      0,
      (sum, item) => sum + (item['population']['total'] as num).toInt(),
    );

    final Map<String, int> educationSummary = {
      'no_education': 0,
      'elementary': 0,
      'middle': 0,
      'high_school': 0,
      'tertiary': 0,
    };
    final Map<String, int> employmentSummary = {
      'total_employed': 0,
      'male_employed': 0,
      'female_employed': 0,
    };

    for (var item in data) {
      educationSummary['no_education'] =
          educationSummary['no_education']! + (item['education']['no_education'] as num).toInt();
      educationSummary['elementary'] =
          educationSummary['elementary']! + (item['education']['elementary'] as num).toInt();
      educationSummary['middle'] =
          educationSummary['middle']! + (item['education']['middle'] as num).toInt();
      educationSummary['high_school'] =
          educationSummary['high_school']! + (item['education']['high_school'] as num).toInt();
      educationSummary['tertiary'] =
          educationSummary['tertiary']! + (item['education']['tertiary'] as num).toInt();

      employmentSummary['total_employed'] =
          employmentSummary['total_employed']! + (item['employment']['total_employed'] as num).toInt();
      employmentSummary['male_employed'] =
          employmentSummary['male_employed']! + (item['employment']['male_employed'] as num).toInt();
      employmentSummary['female_employed'] =
          employmentSummary['female_employed']! + (item['employment']['female_employed'] as num).toInt();
    }

    final municipalities = data.map((item) => item['municipality']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(provinceName),
      ),
      body: ListView(
        children: [
          DetailCard(
            title: 'Population',
            content: 'Total: $populationSummary',
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: municipalities.length,
            itemBuilder: (context, index) {
              final municipality = municipalities[index];
              return ListItem(
                title: municipality,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MunicipalityScreen(
                        municipalityName: municipality,
                        data: data.where((item) => item['municipality'] == municipality).toList(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
