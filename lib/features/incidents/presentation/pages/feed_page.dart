import 'package:citizen_report_incident/features/incidents/data/dto/fetch_incident_by_category.dart';
import 'package:flutter/material.dart';

import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:citizen_report_incident/core/utils/custom_snackbar.dart';
import 'package:citizen_report_incident/core/utils/screen_util.dart';
import 'package:citizen_report_incident/features/incidents/presentation/bloc/incident_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? selectedCategory;
  final List<String> categories = ['Accident', 'Fighting', 'Rioting', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(16),

        Text(
          'View Incidents By Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(20)),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: selectedCategory ?? 'Accident',
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedCategory = val;
              });

              context.read<IncidentBloc>().add(
                FetchIncidentsByCategoryEvent(
                  req: CategoryDto(category: selectedCategory ?? 'Accident'),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<IncidentBloc, IncidentState>(
            listener: (context, state) {
              if (state is IncidentErrorState) {
                CustomSnackbar.error(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is IncidentLoadingState) {
                return Center(
                  child: SpinKitThreeBounce(
                    color: AppColors.scaffold,
                    size: 30,
                  ),
                );
              }

              if (state is GetIncidentsSuccessState) {
                return ListView.builder(
                  itemCount: state.incidents.length,
                  itemBuilder: (context, index) {
                    final incident = state.incidents[index];
                    final imageUrl = incident.imageUrl;

                    if (incident.category == selectedCategory ||
                        incident.category == 'Accident') {
                      Widget leadingWidget;
                      if (imageUrl.startsWith('http')) {
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
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: w(12),
                          vertical: h(8),
                        ),
                        child: ListTile(
                          leading: leadingWidget,
                          title: Text(
                            incident.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${incident.category}'),
                              Text('Description: ${incident.description}'),
                              Text(
                                'Location: (${incident.latitude}, ${incident.latitude})',
                              ),
                              Text('By: ${incident.createdByUsername}'),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {}, //  TODO: implement view incident
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                );
              }

              return Center(
                child: Text(
                  'No incident uploaded',
                  style: TextStyle(fontSize: sp(16)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class FeedPage extends StatelessWidget {
//   static const String routeName = 'feed';

//   const FeedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Feed')),
//       body: const Center(child: Text('Feed Page')),
//     );
//   }
// }

// class FeedPage extends StatelessWidget {
//   static const String routeName = 'feed';

//   const FeedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Feed')),
//       body: const Center(child: Text('Feed Page')),
//     );
//   }
// }
