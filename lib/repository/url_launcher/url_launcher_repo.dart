import 'package:search_example/repository/url_launcher/url_launcher_result.dart';

abstract class UrlLauncherRepository {
  /// Attempts to launch the [url]
  ///
  /// Returns the result of attempted launching (ie. whether it was successful)
  UrlLauncherResult launchUrl(String url);
}
