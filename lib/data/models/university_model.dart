class CourseSubjectModel {
  final String code;
  final String name;
  final int credits;
  final String type;

  const CourseSubjectModel({
    required this.code,
    required this.name,
    this.credits = 3,
    this.type = 'Core',
  });
}

class SemesterCurriculumModel {
  final int semesterNumber;
  final String title;
  final String tuitionFee;
  final int totalCredits;
  final List<CourseSubjectModel> courses;

  const SemesterCurriculumModel({
    required this.semesterNumber,
    required this.title,
    required this.tuitionFee,
    this.totalCredits = 15,
    this.courses = const [],
  });
}

class UniversityMajorModel {
  final String name;
  final String degree;
  final String faculty;
  final String intro;
  final String tuitionPerSemester;
  final int totalCredits;
  final String imageAsset;
  final List<String> careerPaths;
  final List<SemesterCurriculumModel> semesters;

  const UniversityMajorModel({
    required this.name,
    this.degree = "Bachelor's Degree · 4 Years",
    this.faculty = '',
    this.intro = '',
    this.tuitionPerSemester = '',
    this.totalCredits = 120,
    this.imageAsset = '',
    this.careerPaths = const [],
    this.semesters = const [],
  });
}

class UniversityModel {
  final String name;
  final String location;
  final String campus;
  final String address;
  final String imageAsset;
  final String tuitionLabel;
  final String description;
  final List<UniversityMajorModel> majors;

  const UniversityModel({
    required this.name,
    required this.location,
    required this.campus,
    this.address = '',
    required this.imageAsset,
    required this.tuitionLabel,
    this.description = '',
    this.majors = const [],
  });
}
