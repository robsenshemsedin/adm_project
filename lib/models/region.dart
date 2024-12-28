class Region {
  final String name;
  final int totalPopulation;
  final int malePopulation;
  final int femalePopulation;
  final int noEducation;
  final int elementary;
  final int middle;
  final int highSchool;
  final int tertiary;
  final int totalEmployed;
  final int maleEmployed;
  final int femaleEmployed;

  Region({
    required this.name,
    required this.totalPopulation,
    required this.malePopulation,
    required this.femalePopulation,
    required this.noEducation,
    required this.elementary,
    required this.middle,
    required this.highSchool,
    required this.tertiary,
    required this.totalEmployed,
    required this.maleEmployed,
    required this.femaleEmployed,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['region'],
      totalPopulation: json['population']['total'],
      malePopulation: json['population']['male'],
      femalePopulation: json['population']['female'],
      noEducation: json['education']['no_education'],
      elementary: json['education']['elementary'],
      middle: json['education']['middle'],
      highSchool: json['education']['high_school'],
      tertiary: json['education']['tertiary'],
      totalEmployed: json['employment']['total_employed'],
      maleEmployed: json['employment']['male_employed'],
      femaleEmployed: json['employment']['female_employed'],
    );
  }
}
