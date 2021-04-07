import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

class UrlLauncherModel with Model {
  final ProviderEventChannel eventChannel;

  UrlLauncherModel({ProviderEventChannel? parentChannel})
      : eventChannel = new ProviderEventChannel(parentChannel);
}
