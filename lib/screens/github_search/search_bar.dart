import 'package:flutter/material.dart';
import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/search_model.dart';
import 'package:provider/provider.dart';
import 'package:search_example/state/event_channel.dart';

class GitHubSearchBarScreen extends StatefulWidget {
  final SearchModel searchModel;

  const GitHubSearchBarScreen({Key? key, required this.searchModel})
      : super(key: key);

  @override
  _GitHubSearchBarScreenState createState() => _GitHubSearchBarScreenState();
}

class _GitHubSearchBarScreenState extends State<GitHubSearchBarScreen> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    controller.addListener(() => widget.searchModel.eventChannel
        .fireEvent(SEARCH_TERM_EVENT, controller.text));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.text = widget.searchModel.currentSearchTerm;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
      title: TextField(
        controller: controller,
        autofocus: true,
        style: theme.textTheme.headline6!.copyWith(color: theme.canvasColor),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => widget.searchModel.eventChannel
              .fireEvent(SEARCH_BUTTON_EVENT, null),
        )
      ],
    ));
  }
}
