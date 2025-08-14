import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/service/local_storage_hive.dart';
import '../../../../core/storage/app_storage_keys.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? selectedCategory;
  bool showMyIncidents = false;
  final List<String> categories = [
    'All',
    'Accident',
    'Fighting',
    'Rioting',
    'Other',
  ];

  String? get currentUserId => LocalStorageService().get(AppStorageKeys.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recent Incidents',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory ?? 'All',
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('incidents')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No incidents found.'));
                }
                final docs = snapshot.data!.docs;
                var filtered = docs;
                if (selectedCategory != null && selectedCategory != 'All') {
                  filtered = filtered
                      .where((doc) => doc['category'] == selectedCategory)
                      .toList();
                }
                if (showMyIncidents && currentUserId != null) {
                  filtered = filtered
                      .where((doc) => doc['createdByUserId'] == currentUserId)
                      .toList();
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final data = filtered[idx].data() as Map<String, dynamic>;
                    final imageUrl = data['imageUrl'] ?? '';
                    Widget leadingWidget;
                    if (imageUrl is String && imageUrl.startsWith('http')) {
                      leadingWidget = SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    } else {
                      leadingWidget = const SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.image_not_supported),
                      );
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: leadingWidget,
                        title: Text(data['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category: ${data['category'] ?? ''}'),
                            Text('Description: ${data['description'] ?? ''}'),
                            Text(
                              'Location: (${data['latitude'] ?? ''}, ${data['longitude'] ?? ''})',
                            ),
                            Text('By: ${data['createdByEmail'] ?? ''}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
