import 'package:flutter/foundation.dart';

class GalleryProvider with ChangeNotifier {
  final List<Map<String, String>> _items = [];
  bool _loadingMore = false;
  String _query = '';

  List<Map<String, String>> get items => List.unmodifiable(_items);
  bool get loadingMore => _loadingMore;
  String get query => _query;

  List<Map<String, String>> get filtered => _items.where((it) {
    final q = _query.toLowerCase();
    return it['title']!.toLowerCase().contains(q) ||
        it['subtitle']!.toLowerCase().contains(q);
  }).toList();

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_loadingMore) return;
    _loadingMore = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    final start = _items.length;
    final newItems = List.generate(
      8,
      (i) => {
        'title': 'Image ${start + i + 1}',
        'subtitle': 'Description ${start + i + 1}',
        'url': 'https://picsum.photos/seed/${start + i + 1}/600/400',
      },
    );
    _items.addAll(newItems);
    _loadingMore = false;
    notifyListeners();
  }
}
