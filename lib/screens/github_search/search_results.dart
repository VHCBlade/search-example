import 'package:flutter/material.dart';
import 'package:search_example/events/event_names.dart';
import 'package:search_example/repository/search/search_data.dart';
import 'package:provider/provider.dart';
import 'package:search_example/state/event_channel.dart';

class SearchResults extends StatelessWidget {
  final List<SearchData>? searchData;
  final bool hasSearched;

  const SearchResults({Key? key, this.searchData, this.hasSearched = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!hasSearched) {
      return Center(
          child: Text(
        "Start a search using the search button!",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline3,
      ));
    }

    // No Data means that the search failed.
    if (searchData == null) {
      return Center(
          child: Text(
        "Search Failed!",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline3,
      ));
    }

    if (searchData!.isEmpty) {
      return Center(
          child: Text(
        "No Search Results Found!",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline3,
      ));
    }

    return Scrollbar(
        isAlwaysShown: true,
        child: ListView.builder(
          itemBuilder: (_, i) => IndividualSearchResult(datum: searchData![i]),
          itemCount: searchData!.length,
        ));
  }
}

class IndividualSearchResult extends StatelessWidget {
  final SearchData datum;

  const IndividualSearchResult({Key? key, required this.datum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(datum.title),
      subtitle: Text(datum.subtitle ?? ""),
      onTap: () => context
          .read<ProviderEventChannel>()
          .fireEvent(LAUNCH_URL_EVENT, datum.url),
    );
  }
}
