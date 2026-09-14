class ScholarshipModel {
  final String id;
  final String provider;
  final String universityName;
  final String discountPercent; // e.g. '100%', '50%', '30%'
  final int daysLeft;
  final String deadline;
  final String description;
  final bool isSaved;
  final bool isApplied;

  const ScholarshipModel({
    required this.id,
    required this.provider,
    required this.universityName,
    required this.discountPercent,
    required this.daysLeft,
    required this.deadline,
    this.description = '',
    this.isSaved = false,
    this.isApplied = false,
  });

  ScholarshipModel copyWith({
    String? id,
    String? provider,
    String? universityName,
    String? discountPercent,
    int? daysLeft,
    String? deadline,
    String? description,
    bool? isSaved,
    bool? isApplied,
  }) {
    return ScholarshipModel(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      universityName: universityName ?? this.universityName,
      discountPercent: discountPercent ?? this.discountPercent,
      daysLeft: daysLeft ?? this.daysLeft,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      isSaved: isSaved ?? this.isSaved,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
