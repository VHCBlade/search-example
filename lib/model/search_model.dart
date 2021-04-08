import 'dart:async';

import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/frontend/alert_model.dart';
import 'package:search_example/repository/search/search_data.dart';
import 'package:search_example/repository/search/search_repo.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

const SUCCESSFUL_SEARCH_LIMIT = 10;
const _ERROR_MESSAGE = "Search Term Error";

class SearchModel with Model {
  final ProviderEventChannel eventChannel;
  final SearchRepository searchRepository;

  /// Shows a list of the last [SUCCESSFUL_SEARCH_LIMIT] number of
  /// successful search terms.
  final List<String> successfulSearchTerms = [];

  /// The results of the most recent search. If null, that means that the
  /// search was unsuccessful.
  List<SearchData>? get searchResults => _searchResults;
  List<SearchData>? _searchResults;

  /// Shows the last Successful Search that returned results. This is also
  /// the search term used to get the results of
  String? get lastSuccessfulSearchTerm => _lastSuccessfulSearchTerm;
  String? _lastSuccessfulSearchTerm;

  /// Shows the current search term that will be used if a SEARCH_EVENT
  /// is received.
  String get currentSearchTerm => _currentSearchTerm;
  String _currentSearchTerm = '';

  /// Informs us if the [SearchModel] is currently waiting for the results of a
  /// request.
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  bool get hasSearched => _lastSuccessfulSearchTerm != null;

  SearchModel(
      {required this.searchRepository, ProviderEventChannel? parentChannel})
      : eventChannel = new ProviderEventChannel(parentChannel) {
    // Update the current search term to the term in the event.
    eventChannel.addEventListener(SEARCH_TERM_EVENT, (val) {
      updateModelOnChange(
          change: () => _currentSearchTerm = val,
          tracker: () => [_currentSearchTerm]);
      return true;
    });

    // Start a search
    eventChannel.addEventListener(SEARCH_BUTTON_EVENT, (_) {
      startSearch();
      return true;
    });
  }

  /// Starts the search using the [currentSearchTerm].
  Future<void> startSearch() async {
    // Only make one request at a time.
    if (isLoading) {
      eventChannel.fireEvent(
          ERROR_ALERT_EVENT,
          AlertData(
              name: _ERROR_MESSAGE,
              info: "Only one search request can be made at a time."));
      return;
    }

    // Validate first
    // Quick and brute-force way to prevent SQL Injection and XSS
    if (_currentSearchTerm.contains('\'') ||
        _currentSearchTerm.contains('\"') ||
        _currentSearchTerm.contains('<') ||
        _currentSearchTerm.contains('>')) {
      eventChannel.fireEvent(
          ERROR_ALERT_EVENT,
          AlertData(
              name: _ERROR_MESSAGE,
              info:
                  "The search term cannot contain the following characters \', \", <, >."));
      return;
    }

    // Do not accept empty searches.
    if (_currentSearchTerm.isEmpty) {
      eventChannel.fireEvent(
          ERROR_ALERT_EVENT,
          AlertData(
              name: _ERROR_MESSAGE, info: "Please define a search term."));
      return;
    }

    _isLoading = true;
    updateLastSuccessfulSearchTerm(currentSearchTerm);
    _searchResults = null;
    updateModel();

    try {
      _searchResults = await searchRepository
          .search(currentSearchTerm)
          .timeout(Duration(seconds: 20));
    } on Exception {
      // If Timed out, signal that timeout occurred.
      _searchResults = null;

      eventChannel.fireEvent(
          "Connection Error",
          AlertData(
              name: _ERROR_MESSAGE,
              info:
                  "Unable to execute search of \"$currentSearchTerm\" due to connection issues."));
    }

    _isLoading = false;
    updateModel();
  }

  /// Updates the data stored in the model to reflect the newest
  /// [searchTerm] used.
  void updateLastSuccessfulSearchTerm(String searchTerm) {
    _lastSuccessfulSearchTerm = searchTerm;

    successfulSearchTerms.remove(searchTerm);
    successfulSearchTerms.add(searchTerm);

    // Only the first one needs to be removed to hit the limit since searches
    // can only be added one at a time.
    if (successfulSearchTerms.length > SUCCESSFUL_SEARCH_LIMIT) {
      successfulSearchTerms.removeAt(0);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
