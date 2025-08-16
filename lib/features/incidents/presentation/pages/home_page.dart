// import 'package:citizen_report_incident/features/auth/domain/entities/user_entity.dart';

// import '../../../../core/utils/screen_util.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../../core/service/local_storage_service.dart';
// import '../../../../core/storage/app_storage_keys.dart';

// class HomePage extends StatelessWidget {
//   static const String routeName = 'home';

//   final UserEntity? currentUser;

//   const HomePage({super.key, this.currentUser});

//   String? get currentUserId => LocalStorageService().get(AppStorageKeys.uid);

//   @override
//   Widget build(BuildContext context) {
//     final userId = currentUserId;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Welcome back ${currentUser?.email ?? 'User'}',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(15)),
//         ),
//         centerTitle: true,
//       ),
//       body: userId == null
//           ? const Center(child: Text('User not logged in.'))
//           : StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('incidents')
//                   .where('createdByUserId', isEqualTo: userId)
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'You have\'nt uploaded any incidents yet.',
//                       style: TextStyle(fontSize: sp(16)),
//                     ),
//                   );
//                 }
//                 final docs = snapshot.data!.docs;
//                 return ListView.builder(
//                   itemCount: docs.length,
//                   itemBuilder: (context, idx) {
//                     final data = docs[idx].data() as Map<String, dynamic>;
//                     final imageUrl = data['imageUrl'] ?? '';
//                     Widget leadingWidget;
//                     if (imageUrl is String && imageUrl.startsWith('http')) {
//                       leadingWidget = SizedBox(
//                         width: 60,
//                         height: 60,
//                         child: Image.network(imageUrl, fit: BoxFit.cover),
//                       );
//                     } else {
//                       leadingWidget = const SizedBox(
//                         width: 60,
//                         height: 60,
//                         child: Icon(Icons.image_not_supported),
//                       );
//                     }
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       child: ListTile(
//                         leading: leadingWidget,
//                         title: Text(data['title'] ?? ''),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Category: ${data['category'] ?? ''}'),
//                             Text('Description: ${data['description'] ?? ''}'),
//                             Text(
//                               'Location: (${data['latitude'] ?? ''}, ${data['longitude'] ?? ''})',
//                             ),
//                             Text('By: ${data['createdByEmail'] ?? ''}'),
//                           ],
//                         ),
//                         isThreeLine: true,
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:citizen_report_incident/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  final UserEntity? currentUser;

  const HomePage({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Page')),
    );
  }
}
