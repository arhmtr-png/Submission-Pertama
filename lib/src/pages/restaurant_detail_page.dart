import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/restaurant_detail_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/error_retry.dart';
import '../models/restaurant_detail.dart';
import '../utils/result.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String pictureId;
  final ApiService? apiService;

  const RestaurantDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.pictureId,
    this.apiService,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  late RestaurantDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    // Try to obtain ApiService from an existing RestaurantProvider synchronously.
    final api =
        widget.apiService ??
        (() {
          try {
            final rp = Provider.of<RestaurantProvider>(context, listen: false);
            return rp.apiService;
          } catch (_) {
            return ApiService();
          }
        })();
    _provider = RestaurantDetailProvider(apiService: api);
    // Begin fetching detail
    _provider.fetchDetail(widget.id);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, _) {
            final result = provider.detailResult;
            if (result is Loading<RestaurantDetail>) {
              return const Center(child: CircularProgressIndicator());
            } else if (result is ErrorResult<RestaurantDetail>) {
              return ErrorRetry(
                message: 'Failed to load detail. ${result.message}',
                onRetry: () => provider.fetchDetail(widget.id),
              );
            } else if (result is Success<RestaurantDetail> &&
                provider.detail != null) {
              final detail = provider.detail!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: widget.id,
                      child: widget.pictureId.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/medium/${widget.pictureId}',
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        detail.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(detail.description),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Address: ${detail.address} • ${detail.city}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Foods',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...detail.foods.map(
                      (f) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 1,
                        child: ListTile(title: Text(f.name)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Drinks',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...detail.drinks.map(
                      (d) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 1,
                        child: ListTile(title: Text(d.name)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Customer Reviews',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...detail.customerReviews.map(
                      (r) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 1,
                        child: ListTile(
                          title: Text(r.name),
                          subtitle: Text(r.review),
                          trailing: Text(r.date),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Add a Review',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _reviewController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Your review',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.teal.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final name = _nameController.text.trim();
                                final review = _reviewController.text.trim();
                                if (name.isEmpty || review.isEmpty) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter name and review',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final messenger = ScaffoldMessenger.of(context);
                                final ok = await provider.submitReview(
                                  widget.id,
                                  name,
                                  review,
                                );
                                if (!mounted) return;
                                if (ok) {
                                  _nameController.clear();
                                  _reviewController.clear();
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Review submitted'),
                                    ),
                                  );
                                } else {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to submit review'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Submit Review'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
