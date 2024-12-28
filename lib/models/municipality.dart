class Employment {
  final int totalEmployed;
  final int maleEmployed;
  final int femaleEmployed;

  Employment({
    required this.totalEmployed,
    required this.maleEmployed,
    required this.femaleEmployed,
  });

  factory Employment.fromJson(Map<String, dynamic> json) {
    return Employment(
      totalEmployed: json['total_employed'] ?? 0,
      maleEmployed: json['male_employed'] ?? 0,
      femaleEmployed: json['female_employed'] ?? 0,
    );
  }
}
