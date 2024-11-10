class Description {
  final String text;
  final DateTime updated;
  final String author;

  Description({
    required this.text,
    required this.updated,
    required this.author,
  });

  Description copyWith({
    String? text,
    DateTime? updated,
    String? author,
  }) {
    return Description(
      text: text ?? this.text,
      updated: updated ?? this.updated,
      author: author ?? this.author,
    );
  }
}