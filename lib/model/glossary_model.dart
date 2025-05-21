class GlossaryModel {
  final String word;
  final String definition;

  GlossaryModel({
    required this.word,
    required this.definition,
  });

  factory GlossaryModel.fromJson(Map<String, dynamic> json) {
    return GlossaryModel(
      word: json['title'],
      definition: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': word,
      'note': definition,
    };
  }
}
