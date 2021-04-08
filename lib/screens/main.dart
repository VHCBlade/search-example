import 'package:flutter/material.dart';
import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/frontend/alert_model.dart';
import 'package:search_example/model/url_launcher_model.dart';
import 'package:search_example/repository/search/concrete/test_search_repo.dart';
import 'package:search_example/repository/search/search_repo.dart';
import 'package:search_example/repository/url_launcher/concrete/default_url_launcher.dart';
import 'package:search_example/repository/url_launcher/url_launcher_repo.dart';
import 'package:search_example/screens/github_search/github_search.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<SearchRepository>(create: (_) => TestSearchRepository()),
          Provider<UrlLauncherRepository>(
              create: (_) => DefaultUrlLauncherRepository()),
        ],
        child: ModelProvider(
            create: (context, parent) => AlertModel(parentChannel: parent),
            child: ModelProvider(
                create: (context, parent) => UrlLauncherModel(
                    repository: context.read<UrlLauncherRepository>(),
                    parentChannel: parent),
                child: MaterialApp(
                  title: 'Flutter Github Search Example',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: _InnerMainScreen(),
                ))));
  }
}

class _InnerMainScreen extends StatefulWidget {
  @override
  _InnerMainScreenState createState() => _InnerMainScreenState();
}

class _InnerMainScreenState extends State<_InnerMainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderEventChannel>().fireEvent(CONTEXT_EVENT, context);
  }

  @override
  Widget build(BuildContext context) {
    return GitHubSearchScreen();
  }
}
