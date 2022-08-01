import 'package:equatable/equatable.dart';

class ClubHistoryModel extends Equatable {
  final String name;
  final List<String> authors;
  final int pageCount;
  final String? coverImage;
  final DateTime? dueDate;

  const ClubHistoryModel({
    required this.authors,
    required this.pageCount,
    required this.name,
    this.coverImage,
    this.dueDate,
  });

  ClubHistoryModel copyWith({
    List<String>? authors,
    int? pageCount,
    String? coverImage,
    DateTime? dueDate,
    String? name,
  }) {
    return ClubHistoryModel(
      authors: authors ?? this.authors,
      pageCount: pageCount ?? this.pageCount,
      coverImage: coverImage ?? this.coverImage,
      dueDate: dueDate ?? this.dueDate,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authors': authors,
      'pageCount': pageCount,
      'coverImage': coverImage,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'name': name,
    };
  }

  factory ClubHistoryModel.fromMap(Map<String, dynamic> map) {
    return ClubHistoryModel(
      authors: List<String>.from(map['authors']),
      pageCount: map['pageCount'] ?? 0,
      coverImage: map['coverImage'] as String?,
      dueDate: map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] * 1000) : null,
      name: map['name'] as String,
    );
  }

  @override
  List<Object?> get props {
    return [
      authors,
      pageCount,
      coverImage,
      dueDate,
      name,
    ];
  }
}
