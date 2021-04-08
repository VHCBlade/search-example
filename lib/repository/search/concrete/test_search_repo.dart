import 'package:search_example/repository/search/search_data.dart';
import 'package:search_example/repository/search/search_repo.dart';

class TestSearchRepository implements SearchRepository {
  int waitTime = 5;
  List<SearchData> searchData = [
    SearchData(
        title: 'search_example',
        url: 'https://github.com/VHCBlade/search-example',
        subtitle: 'by VHCBlade'),
    SearchData(
        title: 'VHCSite',
        url: 'https://github.com/VHCBlade/VHCSite',
        subtitle: 'by VHCBlade'),
    SearchData(
        title: 'flutter_clock',
        url: 'https://github.com/VHCBlade/flutter_clock',
        subtitle: 'by VHCBlade'),
    SearchData(
        title: 'Fake Result', url: 'https://vhcblade.com', subtitle: 'by Fake'),
  ];

  @override
  Future<List<SearchData>> search(String searchString) async {
    await Future.delayed(Duration(seconds: waitTime));
    return searchData;
  }
}
