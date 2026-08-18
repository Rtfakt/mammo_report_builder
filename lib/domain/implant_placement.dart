/// Расположение эндопротеза молочной железы.
enum ImplantPlacement {
  retromammary,
  submuscular;

  /// Подпись в UI (чипы).
  String get label => switch (this) {
    ImplantPlacement.retromammary => 'Ретромаммарные',
    ImplantPlacement.submuscular => 'Субмускулярные',
  };

  /// Наречие для строки описания: «Ретромаммарно визуализируется…».
  String get adverb => switch (this) {
    ImplantPlacement.retromammary => 'Ретромаммарно',
    ImplantPlacement.submuscular => 'Субмускулярно',
  };

  /// Прилагательное для заключения: «Ретромаммарные импланты…».
  String get adjective => switch (this) {
    ImplantPlacement.retromammary => 'Ретромаммарные',
    ImplantPlacement.submuscular => 'Субмускулярные',
  };
}
