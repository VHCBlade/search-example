import 'package:search_example/repository/url_launcher/url_launcher_repo.dart';
import 'package:search_example/repository/url_launcher/url_launcher_result.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultUrlLauncherRepository implements UrlLauncherRepository {
  @override
  UrlLauncherResult launchUrl(String url) {
    final uri = Uri.parse(url);

    // only allow specific domains.
    if (uri.host != 'github.com') {
      return UrlLauncherResult.domain_not_allowed;
    }

    launch(url);
    return UrlLauncherResult.success;
  }
}
