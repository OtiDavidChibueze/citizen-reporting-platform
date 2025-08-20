import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:citizen_report_incident/core/utils/fomat_date.dart';
import 'package:citizen_report_incident/core/utils/screen_util.dart';

import '../../domain/entities/incident_entity.dart';
import 'package:flutter/material.dart';

class IncidentView extends StatelessWidget {
  final IncidentEntity incident;

  const IncidentView({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chip(
          label: Text(incident.category),
          color: WidgetStatePropertyAll(AppColors.scaffold),
          labelStyle: TextStyle(color: AppColors.white),
        ),
        VSpace(10),
        Text(
          incident.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(22)),
        ),

        VSpace(10),

        Text(
          'UploadedBy: ${incident.createdByUsername}',
          style: TextStyle(fontSize: sp(16), fontWeight: FontWeight.w500),
        ),

        VSpace(5),

        Text(
          formatDateBydMMYYYY(incident.createdAt),
          style: TextStyle(fontSize: sp(16), fontWeight: FontWeight.w500),
        ),

        VSpace(20),

        ClipRRect(
          borderRadius: BorderRadius.circular(sr(10)),
          child: Image.network(incident.imageUrl),
        ),

        VSpace(20),

        Text(
          incident.description,
          style: TextStyle(
            fontSize: sp(16),
            fontWeight: FontWeight.w500,
            height: 2,
          ),
        ),

        VSpace(50),
      ],
    );
  }
}
