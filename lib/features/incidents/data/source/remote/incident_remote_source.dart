import 'package:citizen_report_incident/core/service/supabase_service.dart';
import 'package:citizen_report_incident/features/incidents/data/dto/upload_incident_img_dto.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/local_storage_service.dart';
import '../../model/incident_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

abstract interface class IncidentRemoteSource {
  Future<IncidentModel> uploadInicident(IncidentModel incident);
  Future<String> uploadIncidentImage(UploadIncidentImgDto req);
}

class IncidentRemoteSourceImpl implements IncidentRemoteSource {
  final SupabaseService _supabaseService;
  final InternetConnectionChecker _internetConnectionChecker;

  IncidentRemoteSourceImpl({
    required Uuid uuid,
    required SupabaseService supabaseService,
    required InternetConnectionChecker internetConnectionChecker,
    required LocalStorageService localStorageService,
  }) : _supabaseService = supabaseService,
       _internetConnectionChecker = internetConnectionChecker;

  @override
  Future<IncidentModel> uploadInicident(IncidentModel incident) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final response = await _supabaseService.client
          .from('incidents')
          .insert(incident.toJson())
          .select()
          .single();

      AppLogger.i('Incident uploaded successfully: $response');

      return IncidentModel.fromJson(response);
    } catch (e) {
      AppLogger.e('Incident upload Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadIncidentImage(UploadIncidentImgDto req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      await _supabaseService.client.storage
          .from('incident_img')
          .upload(req.incident.id, req.image);

      return _supabaseService.client.storage
          .from('incident_img')
          .getPublicUrl(req.incident.id);
    } catch (e) {
      AppLogger.e('Incident upload Error: $e');
      throw ServerException(e.toString());
    }
  }
}
