import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/providers/restaurant_provider.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  late final RestaurantProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<RestaurantProvider>(context, listen: false);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Consumer<RestaurantProvider>(
        builder: (context, rp, _) {
          final state = rp.state;
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RestaurantError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is RestaurantEmpty) {
            return const Center(child: Text('No restaurants found'));
          }
          final data = (state as RestaurantData).restaurants;
          return RefreshIndicator(
            onRefresh: () => rp.fetchAll(),
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = data[index];
                return ListTile(
                  leading: SizedBox(
                    width: 72,
                    height: 56,
                    child: r['pictureId'] != null
                        ? Image.network(
                            'https://picsum.photos/seed/${r['pictureId']}/120/80',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    r['name'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  subtitle: Text(
                    r['city'] ?? '',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    (r['rating']?.toString() ?? ''),
                    style: const TextStyle(color: Colors.black87),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, '/details', arguments: r),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
