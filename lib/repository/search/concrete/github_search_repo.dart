import 'dart:convert';

import 'package:http/http.dart';
import 'package:search_example/repository/search/search_data.dart';
import 'package:search_example/repository/search/search_repo.dart';

class GitHubSearchRepository implements SearchRepository {
  @override
  Future<List<SearchData>> search(String searchString) async {
    final uri = Uri.https(
        'api.github.com', '/search/repositories', {'q': searchString});

    final response = await get(uri);
    if (response.statusCode != 200) {
      return [];
    }
    return convertGitHubSearchResponse(response.body);
  }
}

List<SearchData> convertGitHubSearchResponse(String response) {
  final responseMap = jsonDecode(response);

  return responseMap['items'].map<SearchData>((val) {
    return SearchData(
        url: val['html_url'],
        title: val['name'],
        subtitle: "by ${val['owner']['login']}");
  }).toList();
}
