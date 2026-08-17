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

  String get genitiveLabel => switch (this) {
        BreastSide.right => 'правой',
        BreastSide.left => 'левой',
      };

  BreastSide get opposite =>
      this == BreastSide.right ? BreastSide.left : BreastSide.right;
}
