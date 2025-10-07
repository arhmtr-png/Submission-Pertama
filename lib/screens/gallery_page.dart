import 'package:flutter/material.dart';
import 'dart:convert';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ScrollController _controller = ScrollController();
  final List<Map<String, String>> _items = [];
  bool _loadingMore = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(() {
      if (_controller.position.pixels >
              _controller.position.maxScrollExtent - 200 &&
          !_loadingMore) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadMore() async {
    setState(() => _loadingMore = true);
    // simulate network / loading delay
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
    setState(() {
      _items.addAll(newItems);
      _loadingMore = false;
    });
  }

  List<Map<String, String>> get _filtered => _items.where((it) {
    final q = _query.toLowerCase();
    return it['title']!.toLowerCase().contains(q) ||
        it['subtitle']!.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxis = screenWidth < 600 ? 2 : 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          Semantics(
            button: true,
            label: 'Search images',
            child: IconButton(
              tooltip: 'Search images',
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await showSearch<String?>(
                  context: context,
                  delegate: _SimpleSearchDelegate(),
                );
                if (result != null) setState(() => _query = result);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _controller,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final it = _filtered[index];
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Semantics(
                            image: true,
                            label: it['title'],
                            child: FadeInImage(
                              placeholder: MemoryImage(
                                const Base64Decoder().convert(
                                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMBAJ+YbZkAAAAASUVORK5CYII=',
                                ),
                              ),
                              image: NetworkImage(it['url']!),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                it['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                it['subtitle']!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_loadingMore)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SimpleSearchDelegate extends SearchDelegate<String?> {
  final List<String> suggestions = List.generate(8, (i) => 'Image ${i + 1}');

  @override
  String? get searchFieldLabel => 'Search images';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matches = suggestions
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: matches
          .map((m) => ListTile(title: Text(m), onTap: () => close(context, m)))
          .toList(),
    );
  }
}
