import 'package:flutter/foundation.dart';

import 'mammography_exam.dart';

/// Держит текущее состояние конструктора и уведомляет UI об изменениях.
/// Общий для вкладок "Конструктор" и "История", чтобы можно было
/// загрузить сохранённое заключение обратно как черновик.
class ExamController extends ChangeNotifier {
  MammographyExam _exam = MammographyExam.initial();

  MammographyExam get exam => _exam;

  void update(MammographyExam Function(MammographyExam current) updater) {
    _exam = updater(_exam);
    notifyListeners();
  }

  void load(MammographyExam newExam) {
    _exam = newExam;
    notifyListeners();
  }

  void reset() {
    _exam = MammographyExam.initial();
    notifyListeners();
  }
}
