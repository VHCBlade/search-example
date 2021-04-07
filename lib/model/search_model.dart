import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

class SearchModel with Model {
  final ProviderEventChannel eventChannel;

  SearchModel({ProviderEventChannel? parentChannel})
      : eventChannel = new ProviderEventChannel(parentChannel);
}
