import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/frontend/alert_model.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

const SUCCESSFUL_SEARCH_LIMIT = 10;

class SearchModel with Model {
  final ProviderEventChannel eventChannel;

  /// Shows a list of the last [SUCCESSFUL_SEARCH_LIMIT] number of
  /// successful search terms.
  final List<String> successfulSearchTerms = [];

  /// Shows the last Successful Search that returned results. This is also
  /// the search term used to get the results of
  String? get lastSuccessfulSearchTerm => _lastSuccessfulSearchTerm;
  String? _lastSuccessfulSearchTerm;

  /// Shows the current search term that will be used if a SEARCH_EVENT
  /// is received.
  String get currentSearchTerm => _currentSearchTerm;
  String _currentSearchTerm = '';

  bool get hasSearched => _lastSuccessfulSearchTerm == null;

  SearchModel({ProviderEventChannel? parentChannel})
      : eventChannel = new ProviderEventChannel(parentChannel) {
    /// Update the current search term to the term in the event.
    eventChannel.addEventListener(SEARCH_TERM_EVENT, (val) {
      updateModelOnChange(
          change: () => _currentSearchTerm = val,
          tracker: () => [_currentSearchTerm]);
      return true;
    });

    /// Create a Search Event.
    eventChannel.addEventListener(SEARCH_BUTTON_EVENT, (_) {
      // TODO
      eventChannel.fireEvent(ERROR_ALERT_EVENT,
          AlertData(name: "Searching!", info: _currentSearchTerm));
      return true;
    });
  }
}
