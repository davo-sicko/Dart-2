import 'dart:io';



void ShowTable(
  Map <String, Map<String,int>> journal, 
  List<String> students,
  List<String> subjects,
  Map<String, double> StudentAvg,
  Map<String, double> SubjectAvg
){
  String header = "Студент";

  for (var subject in subjects){
    header += ' | $subject';
  }

  header += ' | Средний балл студента |';
  print(header);
  print('-----------------------------------------------------------------------------');

  for (var student in students){
    String row = student;
    var grades = journal[student]!;

    for (var subject in subjects){
      row += ' | ${grades[subject]}';
    }

    row += ' | ${StudentAvg[student]}';
    print(row);

  }
    print('----------------------------------------');

  String footer = 'Средний балл по предмету';
  for (var subject in subjects) {
    footer += ' | ${SubjectAvg[subject]}';
  }
  print(footer);
}

void UniqueGrades(Map <String, Map<String,int>> journal){
  Set <int> uniqueGrades = {};

  journal.forEach((student, grades){
    grades.forEach((subject, grade){
      uniqueGrades.add(grade);
    });
  });
  print("Уникальные оценки журнала: $uniqueGrades");
}

void CategoryStudent (Map<String, double> StudentAvg){
  
  StudentAvg.forEach((student, grades){
    if (4.5 <= grades && grades <= 5.0){
      print("Студент, $student отличник");
    } else if (3.5 <= grades && grades <= 4.4){
      print("Студент, $student хорошист");
    } else if (2.5 <= grades && grades <= 3.4){
      print("Студент, $student троечник");
    } else {
      print("Студент, $student двоечник!");
    }
  });
}

void highAvgSubjects(
  List <String> subjects, 
  double totalAvg,
  Map<String, double> SubjectAvg
){
  bool found = false;

  for (var subject in subjects){
    double subjectAvg = SubjectAvg[subject]!;
    
    if (subjectAvg > totalAvg){
      print("$subject - $subjectAvg");
      found = true;
    }
    else{
      print("Нет предметов выше общего среднего");
    }
  }
}

void findStudent(
  Map<String,
  Map<String, int>> journal, 
  Map<String, double> StudentAvg
){
  
  print("\nВведите фамилию студента, которого хотите найти: ");
  String name = stdin.readLineSync()!;

  if (journal.containsKey(name)){
    print("\nСтудент, $name");
    print("Оценки: ");

    journal[name]!.forEach((subject, grade){
      print("$subject: $grade");
    });

    double avg = StudentAvg[name]!;
    print("Средний балл $avg");

    if (4.5 <= avg && avg <= 5.0){
      print("Категория: отличник");
    } else if (3.5 <= avg && avg <= 4.4){
      print("Категория: хорошист");
    } else if (2.5 <= avg && avg <= 3.4){
      print("Категория: троечник");
    } else {
      print("Категория: двоечник");
    }
  }
  else {
    print("Студент с фамилией '$name' не найден");
  }
}

void showMinMax(Map<String, Map<String, int>> journal, List<String> subjects) {

  for (var subject in subjects) {
    List<int> gradesList = [];
    
    journal.forEach((student, grades) {
      if (grades.containsKey(subject)) {
        gradesList.add(grades[subject]!);
      }
    });

    if (gradesList.isEmpty) {
      continue;
    }

    int maxGrade = gradesList[0];
    int minGrade = gradesList[0];

    for (var grade in gradesList) {
      if (grade > maxGrade) {
        maxGrade = grade;
      }
      if (grade < minGrade) {
        minGrade = grade;
      }
    }

    print('\n$subject:');
    stdout.write('Максимум: $maxGrade (');
    journal.forEach((student, grades) {
      if (grades.containsKey(subject) && grades[subject] == maxGrade) {
        stdout.write('$student ');
      }
    });
    print(')');

    stdout.write('Минимум: $minGrade (');
    journal.forEach((student, grades) {
      if (grades.containsKey(subject) && grades[subject] == minGrade) {
        stdout.write('$student ');
      }
    });
    print(')');
  }
}

void showOneTwo(
  Map<String, Map<String, int>> journal,
  List<String> students
) {
  bool found = false;

  for (var student in students) {
    int twoCount = 0;
    String badSubject = '';

    journal[student]!.forEach((subject, grade) {
      if (grade == 2) {
        twoCount++;
        badSubject = subject;
      }
    });

    if (twoCount == 1) {
      print('$student — $badSubject');
      found = true;
    }
  }
  if (!found) {
    print('Таких студентов нет');
  }
} 

void main() {
  Map <String, Map<String, int>> journal = {
    "David": {
      "Математика": 5,
      "Физика": 4,
      "Английский": 5,
      "История": 5,
    },
    "Daniil": {
      "Математика": 5,
      "Физика": 5,
      "Английский": 3,
      "История": 5,
    },
    "Ivan": {
      "Математика": 4,
      "Физика": 5,
      "Английский": 4,
      "История": 5,
    },
  };

  List <String> students = journal.keys.toList();


  Set <String> subjects1 = {};

  journal.forEach((students, grades){
    subjects1.addAll(grades.keys);
  });

  List <String> subjects = subjects1.toList();

  Map <String, double> StudentAvg = {};
  
  journal.forEach((student, grades){
    double sum = 0;

    grades.forEach((subject, grade){
      sum += grade;
    });

    double avg = sum / grades.length;

    StudentAvg[student] = avg;
  });


  Map<String, double> SubjectAvg = {};

  for (String subject in subjects) {
    double sum = 0;
    int count = 0; 
  
  journal.forEach((student, grades) {
    if (grades.containsKey(subject)) {
      sum += grades[subject]!;
      count++;
    }
  });
  
  if (count > 0) {
    double avg = sum / count;
    SubjectAvg[subject] = double.parse(avg.toStringAsFixed(1));  
  }
  }

  double totalAvg = 0;
  int sum = 0;
  int count = 0;

  journal.forEach((student, subject){
    subject.forEach((subject, grades){
      sum += grades;
      count += 1;
    });
});
  totalAvg = sum / count;

  print("\n1. Показать сводную таблицу");
  print("2. Найти студента");
  print("3. Уникальные оценки");
  print("4. Макс/мин по предметам");
  print("5. Студенты с одной двойкой");
  print("6. Средние баллы предметов, которые выше среднего балла группы");
  print("7. Категории успеваемости");
  print("0. Выход");
  
  stdout.write("Ваш выбор: ");
  var answer1 = stdin.readLineSync()!;
  int answer = int.parse(answer1);

  switch(answer){
    case 1:
      ShowTable(journal, students, subjects, StudentAvg, SubjectAvg);
      break;
    case 2:
      findStudent(journal, StudentAvg);
      break;
    case 3:
      UniqueGrades(journal);
      break;
    case 4:
      showMinMax(journal, subjects);
      break;
    case 5:
      showOneTwo(journal, students);
      break;
    case 6:
      highAvgSubjects(subjects, totalAvg, SubjectAvg);
      break;
    case 7:
      CategoryStudent(StudentAvg);
      break;
    
  }
}
