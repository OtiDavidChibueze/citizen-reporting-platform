import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:citizen_report_incident/core/utils/custom_snackbar.dart';
import 'package:citizen_report_incident/core/utils/screen_util.dart';
import 'package:citizen_report_incident/features/auth/domain/entities/user_entity.dart';
import 'package:citizen_report_incident/features/incidents/presentation/bloc/incident_bloc.dart';
import 'package:citizen_report_incident/features/incidents/presentation/widgets/incident_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';

  final UserEntity? currentUser;

  const HomePage({super.key, this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final List<String> categories = [
  //   'All',
  //   'Accident',
  //   'Fighting',
  //   'Rioting',
  //   'Other',
  // ];

  @override
  void initState() {
    context.read<IncidentBloc>().add(GetIncidentsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(16)),
      child: RefreshIndicator(
        elevation: 0,
        color: AppColors.scaffold,
        backgroundColor: AppColors.white,
        onRefresh: () {
          context.read<IncidentBloc>().add(GetIncidentsEvent());

          return Future.value();
        },
        child: Scrollbar(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: sp(13),
                        ),
                      ),

                      Text(
                        '${widget.currentUser?.fullname}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: sp(23),
                        ),
                      ),
                    ],
                  ),

                  IconButton.outlined(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      size: 30,
                      color: AppColors.scaffold,
                    ),
                  ),
                ],
              ),

              VSpace(30),

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

                          return IncidentView(incident: incident);
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
          ),
        ),
      ),
    );
  }
}
