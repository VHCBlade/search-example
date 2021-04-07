import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_example/model/search_model.dart';
import 'package:search_example/screens/github_search/search_bar.dart';
import 'package:search_example/state/model_provider.dart';

const TITLE_TEXT = "GitHub Search";

class GitHubSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModelProvider(
        create: (_, parent) => SearchModel(parentChannel: parent),
        child: _InnerGitHubScreen());
  }
}

class _InnerGitHubScreen extends StatefulWidget {
  @override
  _InnerGitHubScreenState createState() => _InnerGitHubScreenState();
}

class _InnerGitHubScreenState extends State<_InnerGitHubScreen> {
  @override
  Widget build(BuildContext context) {
    final searchModel = context.watch<ModelNotifier<SearchModel>>().model;
    final title = searchModel.lastSuccessfulSearchTerm == null
        ? TITLE_TEXT
        : "$TITLE_TEXT - ${searchModel.lastSuccessfulSearchTerm}";

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        IconButton(
          icon: Icon(Icons.search),
          // Do not allow searching while already loading a current search.
          onPressed: searchModel.isLoading
              ? null
              : () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GitHubSearchBarScreen(
                        searchModel: searchModel,
                      ))),
        )
      ]),
      body: searchModel.isLoading
          ? Center(child: CircularProgressIndicator())
          :
          // TODO
          Container(),
    );
  }
}
