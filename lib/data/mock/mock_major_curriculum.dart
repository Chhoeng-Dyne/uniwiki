import '../models/university_model.dart';

/// Helper that hydrates a [UniversityMajorModel] with realistic semester curricula,
/// courses, tuition pricing, and introduction tailored to the university.
UniversityMajorModel getHydratedMajorDetails(
  UniversityMajorModel major,
  UniversityModel university,
) {
  // If the major already has fully loaded semesters, return it directly
  if (major.semesters.isNotEmpty && major.intro.isNotEmpty) {
    return major;
  }

  final uniName = university.name.toLowerCase();
  final majorName = major.name.toLowerCase();

  // 1. Resolve domain and hero image
  final domainInfo = _resolveMajorDomain(major.name);
  final heroImage = major.imageAsset.isNotEmpty
      ? major.imageAsset
      : domainInfo.imageAsset;

  // 2. Check for flagship university-specific curriculum
  if (uniName.contains('royal university of phnom penh') && majorName.contains('computer science')) {
    return _buildRuppComputerScience(major, heroImage);
  } else if (uniName.contains('technology of cambodia') && (majorName.contains('software') || majorName.contains('civil'))) {
    if (majorName.contains('software')) {
      return _buildItcSoftwareEngineering(major, heroImage);
    } else {
      return _buildItcCivilEngineering(major, heroImage);
    }
  } else if (uniName.contains('paragon') && majorName.contains('computer science')) {
    return _buildParagonComputerScience(major, heroImage);
  } else if (uniName.contains('puthisastra') && majorName.contains('medicine')) {
    return _buildPuthisastraMedicine(major, heroImage);
  } else if (uniName.contains('health sciences') && majorName.contains('medicine')) {
    return _buildUhsMedicine(major, heroImage);
  } else if (uniName.contains('cadt') && majorName.contains('software')) {
    return _buildCadtSoftwareEngineering(major, heroImage);
  } else if (uniName.contains('limkokwing')) {
    return _buildLimkokwingDesign(major, heroImage);
  } else if (uniName.contains('aupp')) {
    return _buildAuppProgram(major, heroImage);
  } else if (uniName.contains('national university of management')) {
    return _buildNumProgram(major, heroImage);
  }

  // 3. Fallback to domain-tailored realistic multi-semester curriculum
  return _buildDomainTailoredCurriculum(major, university, domainInfo, heroImage);
}

// ---------------------------------------------------------------------------
// Flagship University Curricula (Authentic Cambodian Curricula)
// ---------------------------------------------------------------------------

UniversityMajorModel _buildRuppComputerScience(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Bachelor of Science in Computer Science · 4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Science",
    imageAsset: image,
    totalCredits: 128,
    tuitionPerSemester: "\$350–\$450",
    intro:
        "The Computer Science program at RUPP is Cambodia's foundational CS program, combining deep theoretical fundamentals (discrete math, compiler logic, data structures) with practical software engineering, cloud architecture, and artificial intelligence, accredited under MoEYS guidelines.",
    careerPaths: const [
      "Full-Stack Software Developer",
      "Data Scientist & AI Engineer",
      "Cloud Infrastructure Architect",
      "Backend API Engineer",
      "IT Systems Analyst",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (Foundation Studies)",
        tuitionFee: "\$350",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS101", name: "Introduction to Computer Science & Computing", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "MATH101", name: "Calculus for Engineers & Scientists I", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "ENG101", name: "English for Technical Communication I", credits: 3, type: "General"),
          CourseSubjectModel(code: "PHYS101", name: "Applied Physics & Circuit Logic", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "KHM101", name: "Khmer Culture & History of Cambodia", credits: 3, type: "MoEYS Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2 (Programming Foundations)",
        tuitionFee: "\$350",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS102", name: "Structured Programming in C/C++", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CS103", name: "Discrete Mathematics for Computing", credits: 3, type: "Core"),
          CourseSubjectModel(code: "STAT102", name: "Probability & Applied Statistics", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "ENG102", name: "English for Technical Communication II", credits: 3, type: "General"),
          CourseSubjectModel(code: "ENV102", name: "Environmental Studies & Sustainable Tech", credits: 3, type: "MoEYS Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Semester 1 (Data & Architecture)",
        tuitionFee: "\$380",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS201", name: "Data Structures & Algorithm Design", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CS202", name: "Object-Oriented Programming with Java", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS203", name: "Computer Architecture & Organization", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH201", name: "Linear Algebra & Matrix Computation", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ENG201", name: "Academic Research & Writing", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Semester 2 (Systems & Databases)",
        tuitionFee: "\$380",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS204", name: "Relational Database Management (SQL & PostgreSQL)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CS205", name: "Operating Systems Architecture & UNIX", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS206", name: "Web Technologies (HTML5, CSS3, Modern JavaScript)", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS207", name: "Computer Networks & Cisco Networking", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS208", name: "Software Engineering Principles", credits: 3, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 5,
        title: "Year 3 · Semester 1 (AI & Advanced Software)",
        tuitionFee: "\$420",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS301", name: "Advanced Algorithm Analysis & Graph Theory", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS302", name: "Artificial Intelligence & Heuristic Search", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS303", name: "Mobile App Development with Flutter", credits: 4, type: "Major Elective"),
          CourseSubjectModel(code: "CS304", name: "Network Security & Cryptography", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS305", name: "Cloud Infrastructure (AWS/GCP)", credits: 3, type: "Major Elective"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 6,
        title: "Year 3 · Semester 2 (Machine Learning & Microservices)",
        tuitionFee: "\$420",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS306", name: "Machine Learning with Python & Scikit-Learn", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CS307", name: "Distributed Systems & RESTful Microservices", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS308", name: "Human-Computer Interaction (UI/UX)", credits: 3, type: "Elective"),
          CourseSubjectModel(code: "CS309", name: "IT Project Management & Agile Scrum", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS310", name: "Full-Stack Web Development Practicum", credits: 3, type: "Lab"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 7,
        title: "Year 4 · Semester 1 (Capstone & Big Data)",
        tuitionFee: "\$450",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS401", name: "Senior Capstone Research Project I", credits: 4, type: "Practicum"),
          CourseSubjectModel(code: "CS402", name: "Big Data Processing & Apache Spark", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS403", name: "Cybersecurity Defense & Pen-Testing", credits: 4, type: "Elective"),
          CourseSubjectModel(code: "CS404", name: "Tech Entrepreneurship & IP Law in Cambodia", credits: 4, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 8,
        title: "Year 4 · Semester 2 (Internship & Thesis)",
        tuitionFee: "\$450",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "CS405", name: "Senior Degree Thesis & Defense", credits: 8, type: "Thesis"),
          CourseSubjectModel(code: "CS406", name: "Professional Industry Internship (16 Weeks)", credits: 8, type: "Internship"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildItcSoftwareEngineering(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Diploma of Engineering (Diplôme d'Ingénieur) · 5 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Information & Comm. Tech",
    imageAsset: image,
    totalCredits: 150,
    tuitionPerSemester: "\$350–\$450",
    intro:
        "ITC's Software Engineering curriculum follows the rigorous French 'Grandes Écoles' engineering cycle. Students spend two preparatory years in intensive advanced calculus and physics before mastering low-level systems programming, embedded microcontrollers, Linux kernel internals, and distributed architectures.",
    careerPaths: const [
      "Embedded Systems Engineer",
      "Low-Level & Kernel Developer",
      "Network Protocol Architect",
      "DevOps & Infrastructure Engineer",
      "Industrial Automation Specialist",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Sem 1 (Tronc Commun - Math & Physics)",
        tuitionFee: "\$350",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "MATH101", name: "Analyse Mathématique I (Differential Calculus)", credits: 4, type: "Engineering Core"),
          CourseSubjectModel(code: "PHYS101", name: "Physique Générale: Mécanique du Point", credits: 4, type: "Engineering Core"),
          CourseSubjectModel(code: "INFO101", name: "Algorithmique & Programmation en Langage C", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CHIM101", name: "Chimie Générale & Propriétés de la Matière", credits: 3, type: "Engineering Core"),
          CourseSubjectModel(code: "FRA101", name: "Français Technique & Scientifique I", credits: 3, type: "Language"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Sem 2 (Tronc Commun - Systems Foundation)",
        tuitionFee: "\$350",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "MATH102", name: "Algèbre Linéaire & Espaces Vectoriels", credits: 4, type: "Engineering Core"),
          CourseSubjectModel(code: "ELEC102", name: "Électronique Générale & Lois des Circuits", credits: 4, type: "Engineering Core"),
          CourseSubjectModel(code: "INFO102", name: "Structures de Données Avancées & Pointeurs C", credits: 4, type: "Core"),
          CourseSubjectModel(code: "ANGL102", name: "English for International Engineers", credits: 3, type: "Language"),
          CourseSubjectModel(code: "THERM102", name: "Thermodynamique Appliquée", credits: 3, type: "Engineering Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Sem 1 (Systems & Kernel Architecture)",
        tuitionFee: "\$380",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "INFO201", name: "Programmation Système UNIX/Linux & Bash Scripting", credits: 4, type: "Core"),
          CourseSubjectModel(code: "INFO202", name: "Architecture des Microprocesseurs & Assembler x86", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MATH203", name: "Probabilités & Analyse Numérique", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ELEC201", name: "Traitement du Signal Numérique", credits: 3, type: "Core"),
          CourseSubjectModel(code: "FRA201", name: "Communication Professionnelle d'Ingénieur", credits: 3, type: "Language"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Sem 2 (Object-Oriented & Networks)",
        tuitionFee: "\$380",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "INFO203", name: "Conception Orientée Objet (C++ & Java Modern)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "RES201", name: "Réseaux Informatiques & Modèle OSI/TCP-IP", credits: 4, type: "Core"),
          CourseSubjectModel(code: "BDD201", name: "Systèmes de Gestion de Bases de Données (PostgreSQL)", credits: 3, type: "Core"),
          CourseSubjectModel(code: "PROJ201", name: "Projet Intégrateur d'Ingénierie Logicielle", credits: 3, type: "Practicum"),
          CourseSubjectModel(code: "ANGL202", name: "Technical English for Computer Science", credits: 3, type: "Language"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 5,
        title: "Year 3 · Sem 1 (Embedded Systems & Cloud)",
        tuitionFee: "\$420",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "EMB301", name: "Systèmes Embarqués & Microcontrôleurs ARM/STM32", credits: 4, type: "Core"),
          CourseSubjectModel(code: "GENLOG301", name: "Génie Logiciel, UML & Méthodologies Agiles", credits: 3, type: "Core"),
          CourseSubjectModel(code: "SEC301", name: "Cryptographie Appliquée & Sécurité des Systèmes", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CLOUD301", name: "Architectures Distribuées & Docker/Kubernetes", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ECON301", name: "Économie & Management de Projet Industriel", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 6,
        title: "Year 3 · Sem 2 (Internship & Advanced Systems)",
        tuitionFee: "\$420",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "IA302", name: "Intelligence Artificielle & Traitement d'Images", credits: 4, type: "Core"),
          CourseSubjectModel(code: "IOT302", name: "Internet des Objets (IoT) & Protocoles MQTT/CoAP", credits: 4, type: "Core"),
          CourseSubjectModel(code: "BIGDATA302", name: "Bases NoSQL & Calcul Parallèle", credits: 4, type: "Core"),
          CourseSubjectModel(code: "STAGE302", name: "Stage Technique en Entreprise (10 Semaines)", credits: 6, type: "Internship"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildItcCivilEngineering(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Diploma of Civil Engineering · 5 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Civil Engineering",
    imageAsset: image,
    totalCredits: 154,
    tuitionPerSemester: "\$350–\$450",
    intro:
        "ITC's Civil Engineering department is the backbone of Cambodia's infrastructure development. Educating the nation's premier structural, road, and hydraulic engineers, students master soil mechanics, seismic modeling, reinforced concrete design, and AutoCAD/Revit BIM simulations.",
    careerPaths: const [
      "Structural Engineer",
      "Bridge & Highway Construction Lead",
      "Geotechnical Engineer",
      "BIM Modeling Consultant",
      "Site Operations Director",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Sem 1 (Preparatory Mechanics & Math)",
        tuitionFee: "\$350",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "MATH101", name: "Calculus & Vector Analysis", credits: 4, type: "Core"),
          CourseSubjectModel(code: "PHYS101", name: "Solid Mechanics & Statics", credits: 4, type: "Core"),
          CourseSubjectModel(code: "CAD101", name: "Engineering Graphics & AutoCAD 2D/3D", credits: 4, type: "Core"),
          CourseSubjectModel(code: "GEO101", name: "Topography & Surveying Practicum", credits: 3, type: "Lab"),
          CourseSubjectModel(code: "LANG101", name: "Technical English for Construction", credits: 3, type: "Language"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Sem 2 (Materials & Fluid Mechanics)",
        tuitionFee: "\$350",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "MAT102", name: "Construction Materials & Testing (Cement & Aggregate)", credits: 4, type: "Lab"),
          CourseSubjectModel(code: "MEC102", name: "Strength of Materials (Résistance des Matériaux I)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "FLUID102", name: "Fluid Mechanics & Hydrostatics", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MATH102", name: "Differential Equations in Engineering", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ENV102", name: "Environmental Engineering in Urban Development", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Sem 1 (Structures & Geotech)",
        tuitionFee: "\$380",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "STRUCT201", name: "Structural Analysis I (Trusses & Beams)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SOIL201", name: "Soil Mechanics & Compaction Lab", credits: 4, type: "Lab"),
          CourseSubjectModel(code: "HYDRO201", name: "Hydrology & Stormwater Drainage Systems", credits: 3, type: "Core"),
          CourseSubjectModel(code: "BIM201", name: "Revit Architecture & BIM Modeling", credits: 3, type: "Core"),
          CourseSubjectModel(code: "GEOL201", name: "Engineering Geology in Cambodia", credits: 3, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Sem 2 (Reinforced Concrete Design)",
        tuitionFee: "\$380",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "CONC202", name: "Reinforced Concrete Design I (Eurocode 2)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "STEEL202", name: "Structural Steelwork & Metal Connections", credits: 4, type: "Core"),
          CourseSubjectModel(code: "ROAD202", name: "Highway & Pavement Engineering", credits: 3, type: "Core"),
          CourseSubjectModel(code: "FOUND202", name: "Foundation Engineering & Deep Piles", credits: 3, type: "Core"),
          CourseSubjectModel(code: "EST202", name: "Quantity Surveying & Cost Estimation", credits: 3, type: "Core"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildParagonComputerScience(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Bachelor of Science in Computer Science · 4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of ICT",
    imageAsset: image,
    totalCredits: 124,
    tuitionPerSemester: "\$1,450–\$1,750",
    intro:
        "Paragon International University's Computer Science program follows international ABET-aligned standards with 100% English instruction. Focusing on modern cloud systems, software engineering, mobile development, and data intelligence, students build real portfolio projects evaluated by global tech mentors.",
    careerPaths: const [
      "Software Engineer",
      "Cloud Architect (AWS/GCP)",
      "Mobile Application Developer (Flutter/iOS)",
      "AI & Data Engineer",
      "Tech Startup Founder",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1",
        tuitionFee: "\$1,450",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS105", name: "Intro to Computing with Modern Python", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH110", name: "Calculus for Computing Sciences", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ENG101", name: "Academic English & Critical Reading", credits: 3, type: "General"),
          CourseSubjectModel(code: "COMM101", name: "Public Speaking & Leadership", credits: 3, type: "General"),
          CourseSubjectModel(code: "HIS101", name: "Cambodian Culture & Southeast Asian History", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2",
        tuitionFee: "\$1,450",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS106", name: "Object-Oriented Programming in Java", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH120", name: "Discrete Structures & Logic", credits: 3, type: "Core"),
          CourseSubjectModel(code: "PHYS101", name: "Physics for Computing & Electronics", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "ENG102", name: "Academic Writing & Research Methods", credits: 3, type: "General"),
          CourseSubjectModel(code: "ECON101", name: "Principles of Microeconomics", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Semester 1",
        tuitionFee: "\$1,550",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS201", name: "Data Structures & Algorithm Complexity", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS203", name: "Computer Organization & Architecture", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH210", name: "Linear Algebra & Vector Spaces", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS205", name: "Web Application Development (React & Node.js)", credits: 3, type: "Core"),
          CourseSubjectModel(code: "BUS201", name: "Technology Entrepreneurship & Startups", credits: 3, type: "Elective"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Semester 2",
        tuitionFee: "\$1,550",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS204", name: "Database Management Systems & NoSQL", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS206", name: "Mobile App Development with Flutter", credits: 3, type: "Core"),
          CourseSubjectModel(code: "STAT201", name: "Probability & Applied Statistics", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS208", name: "Software Engineering & Scrum", credits: 3, type: "Core"),
          CourseSubjectModel(code: "PHIL201", name: "Professional Ethics & Digital Governance", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 5,
        title: "Year 3 · Semester 1",
        tuitionFee: "\$1,650",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS301", name: "Operating Systems Internals & Threads", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS303", name: "Computer Networks & Distributed Protocol", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS305", name: "Artificial Intelligence & Heuristics", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS307", name: "Cloud Architecture on AWS", credits: 3, type: "Elective"),
          CourseSubjectModel(code: "DES301", name: "User Interface & Experience (UI/UX) Design", credits: 3, type: "Elective"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 6,
        title: "Year 3 · Semester 2",
        tuitionFee: "\$1,650",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS302", name: "Machine Learning & Deep Learning", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS304", name: "Cybersecurity, Cryptography & Threat Defense", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS306", name: "DevOps, CI/CD Pipelines & Kubernetes", credits: 3, type: "Elective"),
          CourseSubjectModel(code: "CS308", name: "Software Testing & Quality Assurance", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MGMT301", name: "IT Project Management & Risk Analysis", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 7,
        title: "Year 4 · Semester 1",
        tuitionFee: "\$1,750",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "CS491", name: "Senior Capstone Project I (Product Architecture)", credits: 3, type: "Practicum"),
          CourseSubjectModel(code: "CS401", name: "Distributed Big Data Systems", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CS403", name: "Autonomous Systems & Computer Vision", credits: 3, type: "Elective"),
          CourseSubjectModel(code: "BUS401", name: "Commercialization & Intellectual Property", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 8,
        title: "Year 4 · Semester 2",
        tuitionFee: "\$1,750",
        totalCredits: 14,
        courses: [
          CourseSubjectModel(code: "CS492", name: "Senior Capstone Project II & Product Launch", credits: 4, type: "Thesis"),
          CourseSubjectModel(code: "CS495", name: "Corporate Industry Internship (Full-Time)", credits: 10, type: "Internship"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildPuthisastraMedicine(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Doctor of Medicine (MD) · 8 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Medicine",
    imageAsset: image,
    totalCredits: 240,
    tuitionPerSemester: "\$1,100–\$1,600",
    intro:
        "The University of Puthisastra's MD curriculum blends state-of-the-art simulation labs (UP Medical Simulation Center) with early patient contact, OSCE practical exams, and intensive clinical clerkships at top partner hospitals across Phnom Penh.",
    careerPaths: const [
      "Licensed General Physician",
      "Clinical Surgeon Resident",
      "Emergency Medicine Specialist",
      "Medical Researcher / Epidemiologist",
      "Hospital Administrator",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (Anatomy & Biomolecules)",
        tuitionFee: "\$1,100",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "MED101", name: "Gross Anatomy I: Thorax, Abdomen & Pelvis", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED102", name: "Medical Histology & Cell Biology Lab", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED103", name: "Medical Biochemistry & Human Genetics", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED104", name: "Medical Terminology & French/English", credits: 3, type: "General"),
          CourseSubjectModel(code: "MED105", name: "Medical Ethics, Professionalism & Patient Care", credits: 2, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2 (Physiology & Microbiology)",
        tuitionFee: "\$1,100",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "MED106", name: "Gross Anatomy II: Head, Neck, Limbs & Spine", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED107", name: "Human Physiology I (Cardiovascular & Renal)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED108", name: "Medical Microbiology & Virology", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED109", name: "Medical Biophysics & Clinical Imaging", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED110", name: "Introduction to Community Health in Cambodia", credits: 2, type: "Practicum"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Semester 1 (Pathology & Neuro)",
        tuitionFee: "\$1,250",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "MED201", name: "Neuroanatomy & Clinical Neurophysiology", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED202", name: "Human Physiology II (Endocrine & Digestive)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED203", name: "Medical Immunology & Hypersensitivity", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED204", name: "General Pathology & Cell Injury", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED205", name: "Doctor-Patient Clinical Communication", credits: 2, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Semester 2 (Pharmacology & Diagnostics)",
        tuitionFee: "\$1,250",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "MED206", name: "Systemic Pathology (Cardio, Pulmonary, Renal)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED207", name: "Basic Pharmacology & Pharmacokinetics", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED208", name: "Parasitology & Tropical Infections in Cambodia", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED209", name: "Physical Examination & OSCE Skills Lab", credits: 3, type: "Practicum"),
          CourseSubjectModel(code: "MED210", name: "Epidemiology & Clinical Biostatistics", credits: 2, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 5,
        title: "Year 3 · Semester 1 (Internal Medicine & Hospital Rotation)",
        tuitionFee: "\$1,400",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "MED301", name: "Internal Medicine I (Cardiology & Pulmonology)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED302", name: "Surgical Principles, Asepsis & Suturing Lab", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED303", name: "Clinical Pharmacology & Prescribing", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED304", name: "Diagnostic Radiology, CT & Ultrasound", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED305", name: "Hospital Inpatient Ward Clerkship I", credits: 3, type: "Clinical"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 6,
        title: "Year 3 · Semester 2 (Surgery & Gastroenterology)",
        tuitionFee: "\$1,400",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "MED306", name: "Internal Medicine II (Gastro & Nephrology)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED307", name: "General & Abdominal Surgery", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MED308", name: "Tropical & Infectious Disease Management", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED309", name: "Hematology & Transfusion Medicine", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MED310", name: "Hospital Inpatient Ward Clerkship II", credits: 3, type: "Clinical"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildUhsMedicine(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Doctorat en Médecine (State Medical Degree) · 8 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Medicine",
    imageAsset: image,
    totalCredits: 248,
    tuitionPerSemester: "\$250–\$450",
    intro:
        "The University of Health Sciences (UHS - Université des Sciences de la Santé) is Cambodia's premier national medical university founded in 1946. UHS students undergo rigorous clinical training at national referral hospitals including Calmette Hospital, Khmer-Soviet Friendship Hospital, and Kantha Bopha.",
    careerPaths: const [
      "Government Hospital Physician",
      "Specialist Surgeon (Chirurgien)",
      "Pediatrician & Child Health Specialist",
      "Ministry of Health Medical Officer",
      "Public Health Epidemiologist",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Année 1 · Semestre 1 (Anatomie & Biochimie)",
        tuitionFee: "\$250",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "ANAT101", name: "Anatomie Humaine Descriptive: Membres & Rachis", credits: 4, type: "Core"),
          CourseSubjectModel(code: "HIST101", name: "Histologie Générale & Embryologie", credits: 4, type: "Core"),
          CourseSubjectModel(code: "BIOCH101", name: "Biochimie Médicale & Métabolisme Énergétique", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ETHIC101", name: "Déontologie Médicale & Droits des Malades", credits: 3, type: "General"),
          CourseSubjectModel(code: "LANG101", name: "Français & Anglais Médical Fondamental", credits: 3, type: "Language"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Année 1 · Semestre 2 (Physiologie & Bactériologie)",
        tuitionFee: "\$250",
        totalCredits: 17,
        courses: [
          CourseSubjectModel(code: "ANAT102", name: "Anatomie du Tronc, Thorax & Médiastin", credits: 4, type: "Core"),
          CourseSubjectModel(code: "PHYS102", name: "Physiologie Cardiovasculaire & Respiratoire", credits: 4, type: "Core"),
          CourseSubjectModel(code: "BACT102", name: "Bactériologie & Virologie Clinique", credits: 3, type: "Core"),
          CourseSubjectModel(code: "BIOPHYS102", name: "Biophysique & Rayonnements Médicaux", credits: 3, type: "Core"),
          CourseSubjectModel(code: "SANTE102", name: "Santé Publique & Épidémiologie Nationale", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Année 2 · Semestre 1 (Sémiologie & Pathologie)",
        tuitionFee: "\$300",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "SEMIO201", name: "Sémiologie Médicale & Examen Clinique", credits: 4, type: "Clinical"),
          CourseSubjectModel(code: "ANAPATH201", name: "Anatomie Pathologique Générale", credits: 4, type: "Core"),
          CourseSubjectModel(code: "IMMUNO201", name: "Immunologie Fondamentale & Clinique", credits: 3, type: "Core"),
          CourseSubjectModel(code: "PHARMA201", name: "Pharmacologie Fondamentale", credits: 3, type: "Core"),
          CourseSubjectModel(code: "STAGE201", name: "Stage d'Initiation aux Soins Infirmiers (Hôpital Calmette)", credits: 4, type: "Clinical"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Année 2 · Semestre 2 (Sémiologie Chirurgicale & Parasitologie)",
        tuitionFee: "\$300",
        totalCredits: 18,
        courses: [
          CourseSubjectModel(code: "SEMIO202", name: "Sémiologie Chirurgicale & Traumatologie", credits: 4, type: "Clinical"),
          CourseSubjectModel(code: "PARASIT202", name: "Parasitologie & Mycologie Tropicale", credits: 4, type: "Core"),
          CourseSubjectModel(code: "PATHMED202", name: "Pathologie Cardiorespiratoire", credits: 4, type: "Core"),
          CourseSubjectModel(code: "TOXIC202", name: "Toxicologie & Pharmacovigilance", credits: 3, type: "Core"),
          CourseSubjectModel(code: "STAGE202", name: "Stage Hospitalier Semestriel (Hôpital Khmer-Soviétique)", credits: 3, type: "Clinical"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildCadtSoftwareEngineering(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Bachelor of Digital Technology in Software Engineering · 4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Institute of Digital Technology",
    imageAsset: image,
    totalCredits: 130,
    tuitionPerSemester: "\$500–\$750",
    intro:
        "CADT is the premier national digital academy under the Ministry of Post and Telecommunications (MPTC). The Software Engineering program delivers practical full-stack engineering, cloud-native architectures, Flutter mobile development, and modern DevOps practices directly aligned with Cambodia's Digital Economy Policy.",
    careerPaths: const [
      "Full-Stack Software Engineer",
      "Mobile App Architect (Flutter)",
      "Cloud Solutions Engineer",
      "Cybersecurity Defense Specialist",
      "Digital Transformation Consultant",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (Digital Fundamentals)",
        tuitionFee: "\$500",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "SE101", name: "Programming Fundamentals with Python", credits: 4, type: "Core"),
          CourseSubjectModel(code: "MATH101", name: "Discrete Mathematics & Logic for CS", credits: 4, type: "Core"),
          CourseSubjectModel(code: "ENG101", name: "English for Digital Professionals I", credits: 3, type: "General"),
          CourseSubjectModel(code: "DIG101", name: "Computer Architecture & Digital Logic", credits: 3, type: "Core"),
          CourseSubjectModel(code: "GOV101", name: "Digital Governance & Ethics in Cambodia", credits: 2, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2 (Data & Object Paradigms)",
        tuitionFee: "\$500",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "SE102", name: "Object-Oriented Programming (Java & C++)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SE103", name: "Data Structures & Algorithm Design", credits: 4, type: "Core"),
          CourseSubjectModel(code: "DB102", name: "Relational Database Design & PostgreSQL", credits: 3, type: "Core"),
          CourseSubjectModel(code: "NET102", name: "Networking Fundamentals & Protocol Analysis", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ENG102", name: "English for Digital Professionals II", credits: 2, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Semester 1 (Web & Mobile Stacks)",
        tuitionFee: "\$600",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "SE201", name: "Full-Stack Web Development (React & Node)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SE202", name: "Mobile App Development with Flutter & Dart", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SE203", name: "Operating Systems Internals & Linux Shell", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH201", name: "Linear Algebra & Statistics for Data", credits: 3, type: "Core"),
          CourseSubjectModel(code: "UX201", name: "UI/UX Design Thinking & Prototyping", credits: 2, type: "Elective"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Semester 2 (Cloud & Microservices)",
        tuitionFee: "\$600",
        totalCredits: 16,
        courses: [
          CourseSubjectModel(code: "SE204", name: "Cloud-Native Architecture (Docker & Kubernetes)", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SE205", name: "API Design, GraphQL & Microservices", credits: 4, type: "Core"),
          CourseSubjectModel(code: "SEC201", name: "Application Security & Secure Coding", credits: 3, type: "Core"),
          CourseSubjectModel(code: "SE206", name: "Software Testing, QA & Automation", credits: 3, type: "Core"),
          CourseSubjectModel(code: "PROJ201", name: "Digital Innovation Hackathon & Project", credits: 2, type: "Practicum"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildLimkokwingDesign(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Bachelor of Arts in Creative Multimedia & Design · 3–4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Design Innovation",
    imageAsset: image,
    totalCredits: 120,
    tuitionPerSemester: "\$1,000–\$1,500",
    intro:
        "Limkokwing University is Cambodia's premier international hub for visual creativity, branding, 3D animation, and interactive digital arts. Students gain studio-based expertise in industry-standard tools (Adobe Creative Suite, Maya, Blender, Figma) and complete live corporate portfolio briefs.",
    careerPaths: const [
      "Senior Graphic & Brand Identity Designer",
      "3D Animator & VFX Specialist",
      "UI/UX Product Designer",
      "Creative Art Director",
      "Digital Motion Graphics Producer",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (Visual Foundations)",
        tuitionFee: "\$1,000",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "DSGN101", name: "Drawing Fundamentals & Visual Observation", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "DSGN102", name: "Principles of 2D Design & Composition", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "TYPO101", name: "Typography & Expressive Lettering", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "HIST101", name: "History of Art & Global Design Movements", credits: 3, type: "General"),
          CourseSubjectModel(code: "COMM101", name: "Creative Thinking & Idea Generation", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2 (Digital Media Skills)",
        tuitionFee: "\$1,000",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "DIG102", name: "Digital Illustration & Vector Graphics (Illustrator)", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "PHOTO102", name: "Commercial Photography & Digital Imaging (Photoshop)", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "BRAND102", name: "Brand Identity Design & Logo Systems", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "WEB102", name: "Web Interface Design Principles & HTML/CSS", credits: 3, type: "Studio"),
          CourseSubjectModel(code: "ENG102", name: "English for Design Presentations", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 3,
        title: "Year 2 · Semester 1 (Animation & Motion)",
        tuitionFee: "\$1,150",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "ANIM201", name: "Principles of 2D & 3D Character Animation", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "MOTION201", name: "Motion Graphics & Kinetic Typography (After Effects)", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "UIUX201", name: "UI/UX Experience Design & User Research", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "AUDIO201", name: "Sound Design & Audio for Visual Media", credits: 3, type: "Studio"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 4,
        title: "Year 2 · Semester 2 (Portfolio & Industry)",
        tuitionFee: "\$1,150",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "ADV202", name: "Digital Advertising Campaign Strategies", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "VFX202", name: "Visual Effects (VFX) & Compositing", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "PORT202", name: "Professional Portfolio Packaging & Web Showcase", credits: 4, type: "Studio"),
          CourseSubjectModel(code: "INTERN202", name: "Agency Internship / Industry Practicum", credits: 3, type: "Internship"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildAuppProgram(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Dual US Accredited Degree (AUPP & University of Arizona) · 4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "School of Digital Technologies",
    imageAsset: image,
    totalCredits: 120,
    tuitionPerSemester: "\$2,500–\$3,500",
    intro:
        "AUPP provides an American-accredited academic curriculum in partnership with the University of Arizona and Fort Hays State University. With internationally recruited faculty and US credit transfers, students earn dual degrees recognized worldwide.",
    careerPaths: const [
      "Global Corporate Consultant",
      "Cybersecurity Strategist",
      "International Diplomat",
      "Software Systems Architect",
      "Venture Capital Analyst",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (US General Education)",
        tuitionFee: "\$2,500",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "ENGL101", name: "First-Year Composition & Rhetoric", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH122", name: "Calculus for Business and Life Sciences", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CSC110", name: "Introduction to Computer Programming I", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ECON200", name: "Basic Economic Issues & Micro Principles", credits: 3, type: "General"),
          CourseSubjectModel(code: "COMM119", name: "Public Speaking & Global Perspectives", credits: 3, type: "General"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2",
        tuitionFee: "\$2,500",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "ENGL102", name: "First-Year Composition & Literature", credits: 3, type: "Core"),
          CourseSubjectModel(code: "CSC120", name: "Introduction to Computer Programming II", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ISTA130", name: "Computational Thinking & Big Data", credits: 3, type: "Core"),
          CourseSubjectModel(code: "POL101", name: "Introduction to International Relations", credits: 3, type: "General"),
          CourseSubjectModel(code: "STAT205", name: "Introduction to Statistical Methods", credits: 3, type: "Core"),
        ],
      ),
    ],
  );
}

UniversityMajorModel _buildNumProgram(UniversityMajorModel base, String image) {
  return UniversityMajorModel(
    name: base.name,
    degree: "Bachelor of Business Administration (BBA) · 4 Years",
    faculty: base.faculty.isNotEmpty ? base.faculty : "Faculty of Management",
    imageAsset: image,
    totalCredits: 124,
    tuitionPerSemester: "\$300–\$500",
    intro:
        "The National University of Management (NUM) is Cambodia's premier national business and commerce university. Renowned for entrepreneurship, digital economy, banking, and accounting, NUM prepares leaders for the Kingdom's financial and commercial sectors.",
    careerPaths: const [
      "Commercial Banking Officer",
      "Financial Analyst & Auditor",
      "Digital Marketing Strategist",
      "Fintech Operations Manager",
      "Business Development Executive",
    ],
    semesters: const [
      SemesterCurriculumModel(
        semesterNumber: 1,
        title: "Year 1 · Semester 1 (Business Foundations)",
        tuitionFee: "\$300",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "MGT101", name: "Principles of Management & Organization", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ACC101", name: "Financial Accounting Fundamentals I", credits: 3, type: "Core"),
          CourseSubjectModel(code: "MATH101", name: "Business Mathematics & Statistics", credits: 3, type: "Foundation"),
          CourseSubjectModel(code: "ENG101", name: "Business English Communication I", credits: 3, type: "General"),
          CourseSubjectModel(code: "ECON101", name: "Microeconomics in Emerging Markets", credits: 3, type: "Core"),
        ],
      ),
      SemesterCurriculumModel(
        semesterNumber: 2,
        title: "Year 1 · Semester 2",
        tuitionFee: "\$300",
        totalCredits: 15,
        courses: [
          CourseSubjectModel(code: "MKT102", name: "Principles of Marketing & Consumer Behavior", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ACC102", name: "Financial Accounting Fundamentals II", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ECON102", name: "Macroeconomics & Monetary Policy", credits: 3, type: "Core"),
          CourseSubjectModel(code: "LAW102", name: "Business Law & Commercial Regulations in Cambodia", credits: 3, type: "Core"),
          CourseSubjectModel(code: "ENG102", name: "Business English Communication II", credits: 3, type: "General"),
        ],
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Domain-tailored Dynamic Fallback Generator
// ---------------------------------------------------------------------------

class _DomainConfig {
  final String imageAsset;
  final String introSnippet;
  final List<String> careerPaths;
  final List<String> coursePrefixes;
  final List<List<CourseSubjectModel>> sampleSemesters;

  const _DomainConfig({
    required this.imageAsset,
    required this.introSnippet,
    required this.careerPaths,
    required this.coursePrefixes,
    required this.sampleSemesters,
  });
}

_DomainConfig _resolveMajorDomain(String name) {
  final n = name.toLowerCase();

  if (n.contains('computer') || n.contains('data') || n.contains('ai') || n.contains('artificial')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_cs.jpg',
      introSnippet: 'Focuses on computational theory, algorithmic design, software architectures, artificial intelligence, and modern cloud technologies.',
      careerPaths: ['Software Engineer', 'Data Scientist', 'AI Specialist', 'Cloud Systems Developer'],
      coursePrefixes: ['CS', 'DATA', 'MATH', 'ENG'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'CS101', name: 'Introduction to Programming & Algorithms', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MATH101', name: 'Calculus for Computing', credits: 3, type: 'Foundation'),
          CourseSubjectModel(code: 'CS102', name: 'Computer Systems & Hardware Architecture', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ENG101', name: 'Professional English I', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'KHM101', name: 'Cambodian Studies & Civilization', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'CS103', name: 'Object-Oriented Programming (Java/C++)', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'CS104', name: 'Discrete Structures & Graph Theory', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'DB101', name: 'Relational Database Management (SQL)', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'STAT101', name: 'Probability & Statistics for Computing', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ENG102', name: 'Professional English II', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'CS201', name: 'Data Structures & Algorithm Analysis', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'NET201', name: 'Computer Networking & Protocols', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'WEB201', name: 'Full-Stack Web Development', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'OS201', name: 'Operating Systems & Linux Kernel', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MATH201', name: 'Linear Algebra & Numerical Methods', credits: 3, type: 'Core'),
        ],
        [
          CourseSubjectModel(code: 'AI301', name: 'Artificial Intelligence & Machine Learning', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'MOB301', name: 'Mobile Application Development (Flutter)', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'SEC301', name: 'Cybersecurity & Cryptography', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'SE301', name: 'Software Project Management & Agile', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'PROJ301', name: 'Industry Capstone Project / Internship', credits: 6, type: 'Practicum'),
        ],
      ],
    );
  } else if (n.contains('software') || n.contains('cyber') || n.contains('information') || n.contains('network')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_software.jpg',
      introSnippet: 'Provides comprehensive preparation in software engineering lifecycle, cloud systems, cyber defense, and network architecture.',
      careerPaths: ['Full-Stack Developer', 'Cybersecurity Analyst', 'DevOps Specialist', 'Network Administrator'],
      coursePrefixes: ['SE', 'NET', 'SEC', 'CS'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'SE101', name: 'Fundamentals of Software Engineering', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'PROG101', name: 'Programming in C++ & Modern Python', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'MATH101', name: 'Applied Mathematics for Software', credits: 3, type: 'Foundation'),
          CourseSubjectModel(code: 'ENG101', name: 'Technical English Communication', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'IT101', name: 'Information Systems Foundations', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'SE102', name: 'Data Structures & File Organization', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'NET102', name: 'Network Fundamentals & Cisco Routing', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'DB102', name: 'Database Design & Enterprise Storage', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'SEC102', name: 'Information Security & Digital Defense', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'WEB102', name: 'Modern Web Architecture & Cloud APIs', credits: 3, type: 'Core'),
        ],
      ],
    );
  } else if (n.contains('medicine') || n.contains('dental') || n.contains('pharmacy') || n.contains('nursing') || n.contains('biomedical') || n.contains('health')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_medicine.jpg',
      introSnippet: 'Prepares students for clinical licensing and medical excellence through clinical anatomy, pathology, pharmacology, and patient care rotations.',
      careerPaths: ['Licensed Medical Doctor', 'Clinical Specialist', 'Hospital Pharmacist', 'Healthcare Administrator'],
      coursePrefixes: ['MED', 'PHARM', 'NURS', 'ANAT'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'MED101', name: 'Human Gross Anatomy & Dissection I', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'BIO101', name: 'Medical Biochemistry & Physiology', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'HIST101', name: 'Histology & Cellular Biology', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'TERM101', name: 'Medical Terminology & Clinical Latin/French', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'ETHIC101', name: 'Bioethics & Patient Communication', credits: 2, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'MED102', name: 'Human Gross Anatomy & Dissection II', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'PHYS102', name: 'Systemic Physiology & Homeostasis', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'MICRO102', name: 'Medical Microbiology & Immunology', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'PHARM102', name: 'General Pharmacology Principles', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'CLIN102', name: 'First Aid & Clinical Hospital Observation', credits: 2, type: 'Clinical'),
        ],
      ],
    );
  } else if (n.contains('civil') || n.contains('engineering') || n.contains('geo') || n.contains('water') || n.contains('mechanic')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_civil.jpg',
      introSnippet: 'Covers physical engineering principles, materials science, structural mechanics, geotechnics, and infrastructure project execution.',
      careerPaths: ['Structural Engineer', 'Site Construction Manager', 'Geotechnical Consultant', 'Surveying Engineer'],
      coursePrefixes: ['ENG', 'CIV', 'MECH', 'CAD'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'ENG101', name: 'Engineering Mathematics & Calculus I', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'PHYS101', name: 'Engineering Physics & Statics', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'CAD101', name: 'Computer-Aided Design (AutoCAD)', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MAT101', name: 'Materials Science in Construction', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ENG102', name: 'Engineering Communication & Technical English', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'CIV102', name: 'Strength of Materials & Mechanics', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'SURV102', name: 'Land Surveying & GPS Topography', credits: 4, type: 'Core'),
          CourseSubjectModel(code: 'FLUID102', name: 'Fluid Mechanics & Hydraulics', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MATH102', name: 'Differential Equations for Engineers', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'SOIL102', name: 'Soil Mechanics & Geotechnical Lab', credits: 3, type: 'Core'),
        ],
      ],
    );
  } else if (n.contains('architecture') || n.contains('urban') || n.contains('interior')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_architecture.jpg',
      introSnippet: 'Explores spatial design, environmental sustainability, architectural theory, building information modeling (BIM), and urban planning.',
      careerPaths: ['Licensed Architect', 'Urban Planner', 'BIM Consultant', 'Interior Architect'],
      coursePrefixes: ['ARCH', 'DES', 'URB', 'CAD'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'ARCH101', name: 'Architectural Design Studio I', credits: 5, type: 'Studio'),
          CourseSubjectModel(code: 'DRAW101', name: 'Freehand Drawing & Visual Representation', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'HIST101', name: 'History of World & Khmer Architecture', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'CAD101', name: 'Digital Drafting & AutoCAD 2D', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MATH101', name: 'Geometry & Mathematics for Architecture', credits: 3, type: 'Foundation'),
        ],
        [
          CourseSubjectModel(code: 'ARCH102', name: 'Architectural Design Studio II', credits: 5, type: 'Studio'),
          CourseSubjectModel(code: 'BIM102', name: 'Revit & Building Information Modeling', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ENV102', name: 'Building Environmental Systems & Climate', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'STRUCT102', name: 'Architectural Structures & Materials', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ENG102', name: 'Architectural Presentation & Writing', credits: 3, type: 'General'),
        ],
      ],
    );
  } else if (n.contains('finance') || n.contains('banking') || n.contains('account') || n.contains('fintech')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_finance.jpg',
      introSnippet: 'Prepares students with financial modeling, banking operations, investment analysis, digital currencies, and regulatory standards.',
      careerPaths: ['Investment Banker', 'Financial Analyst', 'Fintech Specialist', 'Corporate Auditor'],
      coursePrefixes: ['FIN', 'ACC', 'BNK', 'ECON'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'FIN101', name: 'Financial Accounting Fundamentals', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ECON101', name: 'Principles of Microeconomics', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MATH101', name: 'Business Mathematics & Statistics', credits: 3, type: 'Foundation'),
          CourseSubjectModel(code: 'MGT101', name: 'Introduction to Business Management', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'ENG101', name: 'Business Communication in English I', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'FIN102', name: 'Corporate Finance & Valuation', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'BNK102', name: 'Commercial Banking Operations', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ECON102', name: 'Macroeconomics & Monetary Policy', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'TAX102', name: 'Cambodian Taxation & Commercial Law', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'FINTECH102', name: 'Digital Payments & Fintech Overview', credits: 3, type: 'Elective'),
        ],
      ],
    );
  } else if (n.contains('tourism') || n.contains('hospitality') || n.contains('hotel')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_tourism.jpg',
      introSnippet: 'Equips students with international hospitality management, cultural tourism leadership, event planning, and customer operations.',
      careerPaths: ['Hotel Operations Director', 'Eco-Tourism Lead', 'International Event Planner', 'Aviation Hospitality Manager'],
      coursePrefixes: ['TOUR', 'HOSP', 'MGT', 'LANG'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'TOUR101', name: 'Introduction to Tourism & Hospitality', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'HOSP101', name: 'Customer Experience & Front Office Operations', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'GEO101', name: 'Cultural Tourism Geography of Cambodia', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MGT101', name: 'Principles of Tourism Management', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'LANG101', name: 'Hospitality English I', credits: 3, type: 'Language'),
        ],
        [
          CourseSubjectModel(code: 'ECO102', name: 'Eco-Tourism & Sustainable Destination Planning', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'FB102', name: 'Food & Beverage Service Management', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'MKT102', name: 'Digital Marketing for Travel & Hotels', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'EVENT102', name: 'MICE & Event Management Practicum', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'LANG102', name: 'Hospitality English II / Second Foreign Language', credits: 3, type: 'Language'),
        ],
      ],
    );
  } else if (n.contains('relation') || n.contains('diploma') || n.contains('law') || n.contains('public') || n.contains('affair')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_ir.jpg',
      introSnippet: 'Explores global diplomacy, international law, geopolitical strategy, multilateral negotiations, and regional ASEAN governance.',
      careerPaths: ['Diplomatic Foreign Officer', 'Policy Analyst', 'International NGO Director', 'Corporate Legal Counsel'],
      coursePrefixes: ['IR', 'LAW', 'POL', 'GOV'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'IR101', name: 'Introduction to International Relations', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'POL101', name: 'Comparative Politics & Governance Systems', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'HIST101', name: 'Modern World History & Diplomatic Treaties', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'ENG101', name: 'Academic Writing for Social Sciences', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'KHM101', name: 'Constitutional History of Cambodia', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'LAW102', name: 'Public International Law & Treaties', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ASEAN102', name: 'ASEAN Regionalism & Southeast Asian Politics', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'DIP102', name: 'Diplomatic Protocols & Bilateral Negotiation', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'ECON102', name: 'International Political Economy', credits: 3, type: 'Core'),
          CourseSubjectModel(code: 'RES102', name: 'Research Methods in International Studies', credits: 3, type: 'Core'),
        ],
      ],
    );
  } else if (n.contains('design') || n.contains('multimedia') || n.contains('animation') || n.contains('fashion')) {
    return const _DomainConfig(
      imageAsset: 'assets/images/major_design.jpg',
      introSnippet: 'Focuses on visual storytelling, commercial branding, motion graphics, user interface experience, and creative multimedia production.',
      careerPaths: ['Visual Brand Designer', 'Motion Graphics Artist', 'UI/UX Designer', 'Multimedia Content Producer'],
      coursePrefixes: ['DES', 'ANIM', 'UIUX', 'ART'],
      sampleSemesters: [
        [
          CourseSubjectModel(code: 'DES101', name: 'Fundamentals of Design & Color Theory', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'DIG101', name: 'Digital Vector Graphics (Adobe Illustrator)', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'TYPO101', name: 'Typography & Layout Composition', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'HIST101', name: 'History of Art & Visual Culture', credits: 3, type: 'General'),
          CourseSubjectModel(code: 'ENG101', name: 'Design Communication & Portfolio Skills', credits: 3, type: 'General'),
        ],
        [
          CourseSubjectModel(code: 'DES102', name: 'Brand Identity & Commercial Packaging', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'PHOTO102', name: 'Digital Imaging & Photo Manipulation (Photoshop)', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'UIUX102', name: 'Introduction to UI/UX Design with Figma', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'MOTION102', name: 'Motion Graphics & Video Editing', credits: 3, type: 'Studio'),
          CourseSubjectModel(code: 'PORT102', name: 'Creative Portfolio Studio I', credits: 3, type: 'Studio'),
        ],
      ],
    );
  }

  // Default Business/General
  return const _DomainConfig(
    imageAsset: 'assets/images/major_business.jpg',
    introSnippet: 'Prepares students with contemporary management theory, corporate strategy, marketing execution, and financial decision-making.',
    careerPaths: ['Business Operations Manager', 'Marketing Executive', 'Entrepreneur & Founder', 'Corporate Strategy Associate'],
    coursePrefixes: ['BUS', 'MGT', 'MKT', 'ACC'],
    sampleSemesters: [
      [
        CourseSubjectModel(code: 'BUS101', name: 'Introduction to Business & Enterprise', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'MGT101', name: 'Organizational Behavior & Leadership', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'ACC101', name: 'Principles of Financial Accounting', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'MATH101', name: 'Business Mathematics & Statistics', credits: 3, type: 'Foundation'),
        CourseSubjectModel(code: 'ENG101', name: 'Business English & Executive Writing', credits: 3, type: 'General'),
      ],
      [
        CourseSubjectModel(code: 'MKT102', name: 'Principles of Modern Marketing', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'FIN102', name: 'Managerial Finance & Budgeting', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'ECON102', name: 'Microeconomics & Commercial Analysis', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'LAW102', name: 'Commercial Law & Business Contracts', credits: 3, type: 'Core'),
        CourseSubjectModel(code: 'DIG102', name: 'Digital Tools for Enterprise Collaboration', credits: 3, type: 'Core'),
      ],
    ],
  );
}

UniversityMajorModel _buildDomainTailoredCurriculum(
  UniversityMajorModel base,
  UniversityModel university,
  _DomainConfig config,
  String heroImage,
) {
  // Derive semester price from university tuition label
  String semesterFee = '\$350';
  final t = university.tuitionLabel;
  if (t.contains('\$')) {
    final parts = t.split('\$');
    if (parts.length > 1) {
      final sub = parts[1].split('–')[0].split('-')[0].split(' ')[0].replaceAll(',', '');
      semesterFee = '\$$sub';
    }
  }

  final semesters = <SemesterCurriculumModel>[];
  final totalCredits = config.sampleSemesters.length * 15;

  for (int i = 0; i < config.sampleSemesters.length; i++) {
    final semNum = i + 1;
    final year = ((semNum - 1) ~/ 2) + 1;
    final semInYear = ((semNum - 1) % 2) + 1;

    semesters.add(
      SemesterCurriculumModel(
        semesterNumber: semNum,
        title: 'Year $year · Semester $semInYear',
        tuitionFee: semesterFee,
        totalCredits: 15,
        courses: config.sampleSemesters[i],
      ),
    );
  }

  final introText = base.intro.isNotEmpty
      ? base.intro
      : '${base.name} at ${university.name} provides high-quality academic and practical training designed for modern careers. ${config.introSnippet}';

  return UniversityMajorModel(
    name: base.name,
    degree: base.degree.isNotEmpty ? base.degree : "Bachelor's Degree · 4 Years",
    faculty: base.faculty,
    imageAsset: heroImage,
    totalCredits: totalCredits > 0 ? totalCredits : 120,
    tuitionPerSemester: '$semesterFee / semester',
    intro: introText,
    careerPaths: config.careerPaths,
    semesters: semesters,
  );
}
