import 'package:flutter/material.dart';
import 'package:search_example/model/search_model.dart';

class GitHubSearchBarScreen extends StatelessWidget {
  final SearchModel searchModel;

  const GitHubSearchBarScreen({Key? key, required this.searchModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    searchModel;
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
