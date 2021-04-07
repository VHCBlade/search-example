import 'package:equatable/equatable.dart';

class SearchData with EquatableMixin {
  final String url;
  final String title;
  final String? subtitle;

  SearchData(this.url, this.title, this.subtitle);

  @override
  List<Object?> get props => [url, title, subtitle];
}
