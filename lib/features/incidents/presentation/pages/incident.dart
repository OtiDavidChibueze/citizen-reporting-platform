import '../../../../core/common/cubit/navigation_cubit/navigation_cubit.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'upload_incident_page.dart';
import 'feed_page.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Incident extends StatefulWidget {
  final UserEntity? currentUser;

  static const String routeName = 'main';

  const Incident({super.key, this.currentUser});

  @override
  State<Incident> createState() => _IncidentState();
}

class _IncidentState extends State<Incident> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            switch (state.selectedIndex) {
              case 0:
                return HomePage(currentUser: widget.currentUser);
              case 1:
                return UploadIncidentPage();
              case 2:
                return FeedPage();
              default:
                return SizedBox();
            }
          },
        ),

        bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return NavigationBar(
              backgroundColor: Colors.grey.shade100,
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (val) =>
                  context.read<NavigationCubit>().setSelectedIndex(val),
              indicatorColor: Colors.transparent,
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: sp(12)),
              ),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  selectedIcon: Icon(Icons.home),
                ),

                NavigationDestination(
                  icon: Icon(Icons.add_outlined),
                  label: 'Upload',
                  selectedIcon: Icon(Icons.add),
                ),

                NavigationDestination(
                  icon: Icon(Icons.list_outlined),
                  label: 'Uploads',
                  selectedIcon: Icon(Icons.list),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
