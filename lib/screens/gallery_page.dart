import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<Map<String, String>> items = List.generate(
    8,
    (i) => {
      'title': 'Image ${i + 1}',
      'subtitle': 'Description ${i + 1}',
      // using same welcome image as placeholder; users can replace with actual assets
      'asset': 'assets/welcome.png',
    },
  );

  String _query = '';

  List<Map<String, String>> get filtered => items.where((it) {
        final q = _query.toLowerCase();
        return it['title']!.toLowerCase().contains(q) || it['subtitle']!.toLowerCase().contains(q);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxis = screenWidth < 600 ? 2 : 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String?>(context: context, delegate: _SimpleSearchDelegate());
              if (result != null) setState(() => _query = result);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: crossAxis,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: filtered.map((it) {
            return Card(
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      it['asset']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(it['subtitle']!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
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
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matches = suggestions.where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: matches.map((m) => ListTile(title: Text(m), onTap: () => close(context, m))).toList(),
    );
  }
}
