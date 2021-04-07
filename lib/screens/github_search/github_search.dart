import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_example/model/search_model.dart';
import 'package:search_example/screens/github_search/search_bar.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model_provider.dart';

class GitHubSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModelProvider(
        create: (_, ProviderEventChannel? parent) =>
            SearchModel(parentChannel: parent),
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
    return Scaffold(
      appBar: AppBar(title: Text("GitHub Search"), actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GitHubSearchBarScreen(
                    searchModel:
                        context.read<ModelNotifier<SearchModel>>().model,
                  ))),
        )
      ]),
      body: Container(),
    );
  }
}
