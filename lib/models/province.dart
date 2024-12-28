class Education {
  final int noEducation;
  final int elementary;
  final int middle;
  final int highSchool;
  final int tertiary;

  Education({
    required this.noEducation,
    required this.elementary,
    required this.middle,
    required this.highSchool,
    required this.tertiary,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      noEducation: json['no_education'] ?? 0,
      elementary: json['elementary'] ?? 0,
      middle: json['middle'] ?? 0,
      highSchool: json['high_school'] ?? 0,
      tertiary: json['tertiary'] ?? 0,
    );
  }
}
