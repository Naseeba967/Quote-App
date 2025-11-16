import 'dart:convert';

class QuoteModel {
  final String id;
  final String content;
  final String author;
  final List<String> tags;
  final int length;

  QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
    required this.length,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    final content = (json['content'] ?? json['q'] ?? '').toString().trim();
    final author = (json['author'] ?? json['a'] ?? 'Unknown').toString().trim();

    // ✅ Generate unique ID if not provided by API
    final generatedId =
        json['_id'] ?? json['id'] ?? _generateUniqueId(content, author);

    return QuoteModel(
      id: generatedId,
      content: content,
      author: author,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      length: json['length'] ?? (content.length),
    );
  }

  // ✅ OPTION 1: Using base64 encoding (NO extra package needed!)
  static String _generateUniqueId(String content, String author) {
    final combined = '$content|$author';
    return base64Url
        .encode(utf8.encode(combined))
        .replaceAll('=', '')
        .substring(0, 16);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'tags': tags,
      'length': length,
    };
  }

  String get displayQuote => content;
  String get displayAuthor => author.isNotEmpty ? author : 'Unknown';

  @override
  String toString() => 'Quote(id: $id, author: $author)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
