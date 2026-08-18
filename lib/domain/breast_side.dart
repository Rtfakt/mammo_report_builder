enum BreastSide {
  right,
  left;

  String get label => switch (this) {
    BreastSide.right => 'Справа',
    BreastSide.left => 'Слева',
  };

  String get fullLabel => switch (this) {
    BreastSide.right => 'ПРАВАЯ МОЛОЧНАЯ ЖЕЛЕЗА В ДВУХ ПРОЕКЦИЯХ',
    BreastSide.left => 'ЛЕВАЯ МОЛОЧНАЯ ЖЕЛЕЗА В ДВУХ ПРОЕКЦИЯХ',
  };

  /// Заголовок блока описания, если железа удалена (без «в двух проекциях»).
  String get removedHeading => switch (this) {
    BreastSide.right => 'ПРАВАЯ МОЛОЧНАЯ ЖЕЛЕЗА',
    BreastSide.left => 'ЛЕВАЯ МОЛОЧНАЯ ЖЕЛЕЗА',
  };

  String get genitiveLabel => switch (this) {
    BreastSide.right => 'правой',
    BreastSide.left => 'левой',
  };

  String get removedConclusionSentence => switch (this) {
    BreastSide.right => 'Правая молочная железа удалена.',
    BreastSide.left => 'Левая молочная железа удалена.',
  };

  BreastSide get opposite =>
      this == BreastSide.right ? BreastSide.left : BreastSide.right;
}
