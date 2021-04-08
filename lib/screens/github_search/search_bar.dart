import 'package:flutter/material.dart';
import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/search_model.dart';

class GitHubSearchBarScreen extends StatefulWidget {
  final SearchModel searchModel;

  /// Screen that displays the Search bar for the GitHub Search Screen.
  ///
  /// [searchModel] is the model inherited from the GitHubSearch Screen.
  const GitHubSearchBarScreen({Key? key, required this.searchModel})
      : super(key: key);

  @override
  _GitHubSearchBarScreenState createState() => _GitHubSearchBarScreenState();
}

class _GitHubSearchBarScreenState extends State<GitHubSearchBarScreen> {
  late final TextEditingController controller;

  void resetState() {
    setState(() {
      // If model is loading, go back to the main search screen immediately.
      if (widget.searchModel.isLoading) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    controller.addListener(() => widget.searchModel.eventChannel
        .fireEvent(SEARCH_TERM_EVENT, controller.text));

    widget.searchModel.modelUpdated.add(resetState);
  }

  @override
  void dispose() {
    super.dispose();
    widget.searchModel.modelUpdated.remove(resetState);
  }

  void startSearch() {
    widget.searchModel.eventChannel.fireEvent(SEARCH_BUTTON_EVENT, null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => startSearch(),
            style:
                theme.textTheme.headline6!.copyWith(color: theme.canvasColor),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: startSearch,
            )
          ],
        ),
        body: SuggestedSearchTerms(
            searchTerms: widget.searchModel.successfulSearchTerms,
            updateSearch: (val) => controller.text = val));
  }
}

class SuggestedSearchTerms extends StatelessWidget {
  final List<String> searchTerms;
  final Function(String) updateSearch;

  /// Shows a list of Suggested Search Terms that the user can click.
  ///
  /// [updateSearch] defines what happens when the search term is clicked.
  /// [searchTerms] is the list of search terms to be displayed as suggestions.
  const SuggestedSearchTerms(
      {Key? key, required this.searchTerms, required this.updateSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerms.isEmpty) {
      return Container();
    }

    final theme = Theme.of(context);

    final children = <Widget>[
      Text("Recent Searches", style: theme.textTheme.subtitle1)
    ];

    for (int i = searchTerms.length - 1; i > -1; i--) {
      children.add(TextButton(
          onPressed: () => updateSearch(searchTerms[i]),
          child: Text(
            searchTerms[i],
            style: theme.textTheme.bodyText1,
            textAlign: TextAlign.left,
          )));
    }

    return ListView(
      children: children,
      padding: EdgeInsets.all(10),
    );
  }
}
