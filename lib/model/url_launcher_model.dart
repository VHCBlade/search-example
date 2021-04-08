import 'package:search_example/events/event_names.dart';
import 'package:search_example/model/frontend/alert_model.dart';
import 'package:search_example/repository/url_launcher/url_launcher_repo.dart';
import 'package:search_example/repository/url_launcher/url_launcher_result.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

class UrlLauncherModel with Model {
  final ProviderEventChannel eventChannel;
  final UrlLauncherRepository repository;

  UrlLauncherModel(
      {ProviderEventChannel? parentChannel, required this.repository})
      : eventChannel = new ProviderEventChannel(parentChannel) {
    eventChannel.addEventListener(LAUNCH_URL_EVENT, (url) {
      final result = repository.launchUrl(url);
      switch (result) {
        case UrlLauncherResult.failed_to_launch:
          eventChannel.fireEvent(
              ERROR_ALERT_EVENT,
              AlertData(
                  name: "URL launch failed!",
                  info: "The url $url could not be launched."));
          break;
        case UrlLauncherResult.domain_not_allowed:
          eventChannel.fireEvent(
              ERROR_ALERT_EVENT,
              AlertData(
                  name: "URL domain not allowed!",
                  info:
                      "The url $url has a domain that is not allowed to be launched in this app."));
          break;
        default:
      }
      return true;
    });
  }
}
