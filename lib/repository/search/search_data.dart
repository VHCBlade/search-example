import 'package:equatable/equatable.dart';

class SearchData with EquatableMixin {
  final String url;
  final String title;
  final String? subtitle;

  SearchData({required this.url, required this.title, this.subtitle});

  @override
  List<Object?> get props => [url, title, subtitle];
}
