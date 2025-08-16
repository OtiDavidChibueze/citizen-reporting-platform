import '../../domain/entities/incident_entity.dart';
import 'package:flutter/material.dart';

class IncidentView extends StatelessWidget {
  final IncidentEntity incident;

  const IncidentView({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Text(incident.title);
  }
}
