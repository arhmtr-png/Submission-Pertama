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
              // Detail skeleton
              final mq = MediaQuery.of(context);
              final isWide = mq.size.width > 700;
              final imageHeight = isWide ? 320.0 : 220.0;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: imageHeight,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withAlpha(0x66),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            width: 240,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withAlpha(0x66),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 14,
                            width: double.infinity,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withAlpha(0x66),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: double.infinity,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withAlpha(0x66),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (result is ErrorResult<RestaurantDetail>) {
              return ErrorRetry(
                message: 'Failed to load detail. ${result.message}',
                onRetry: () => provider.fetchDetail(widget.id),
              );
            } else if (result is Success<RestaurantDetail> &&
                provider.detail != null) {
              final detail = provider.detail!;
              final cs = Theme.of(context).colorScheme;
              final textTheme = Theme.of(context).textTheme;
              final mq = MediaQuery.of(context);
              final isWide = mq.size.width > 700;
              final imageHeight = isWide ? 320.0 : 220.0;

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
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return SizedBox(
                                    height: imageHeight,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: imageHeight,
                              child: Container(
                                color: cs.surfaceContainerHighest,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detail.name, style: textTheme.headlineSmall),
                          const SizedBox(height: 6),
                          Semantics(
                            label:
                                'Rating: ${detail.rating.toStringAsFixed(1)} out of 5',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  detail.rating.toStringAsFixed(1),
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (detail.customerReviews.isNotEmpty)
                                  Text(
                                    '(${detail.customerReviews.length} reviews)',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(0xAA),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        detail.description,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Address: ${detail.address} • ${detail.city}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(0xCC),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Foods', style: textTheme.titleMedium),
                    ),
                    const SizedBox(height: 8),
                    ...detail.foods.map(
                      (f) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 1,
                        child: ListTile(
                          title: Text(f.name, style: textTheme.bodyMedium),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Drinks', style: textTheme.titleMedium),
                    ),
                    const SizedBox(height: 8),
                    ...detail.drinks.map(
                      (d) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 1,
                        child: ListTile(
                          title: Text(d.name, style: textTheme.bodyMedium),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Customer Reviews',
                        style: textTheme.titleMedium,
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
                          title: Text(r.name, style: textTheme.bodyMedium),
                          subtitle: Text(r.review, style: textTheme.bodyMedium),
                          trailing: Text(r.date, style: textTheme.bodySmall),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Add a Review', style: textTheme.titleLarge),
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
                            child: Consumer<RestaurantDetailProvider>(
                              builder: (context, p, _) {
                                final submitting = p.submitting;
                                return ElevatedButton(
                                  onPressed: submitting
                                      ? null
                                      : () async {
                                          final name = _nameController.text
                                              .trim();
                                          final review = _reviewController.text
                                              .trim();
                                          if (name.isEmpty || review.isEmpty) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Please enter name and review',
                                                  style: textTheme.bodyMedium,
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          final messenger =
                                              ScaffoldMessenger.of(context);
                                          final ok = await p.submitReview(
                                            widget.id,
                                            name,
                                            review,
                                          );
                                          if (!mounted) return;
                                          if (ok) {
                                            _nameController.clear();
                                            _reviewController.clear();
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Review submitted',
                                                  style: textTheme.bodyMedium,
                                                ),
                                              ),
                                            );
                                          } else {
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to submit review',
                                                  style: textTheme.bodyMedium,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: submitting
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Submit Review'),
                                );
                              },
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
