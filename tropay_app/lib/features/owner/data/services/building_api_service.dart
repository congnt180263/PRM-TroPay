import 'package:dio/dio.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/services/http_client_service.dart';
import '../models/building_model.dart';

/// API Service for Building-related operations
///
/// This service handles all HTTP requests related to buildings,
/// including fetching, creating, updating, and deleting building data.
class BuildingApiService {
  final HttpClientService _http = HttpClientService();

  /// Ensures API response is successful
  ///
  /// Throws an exception if the response indicates failure
  void _ensureSuccess(Response response) {
    if (response.data is Map && response.data['success'] == true) {
      return;
    }
    throw Exception(response.data['message'] ?? 'Request failed');
  }

  /// Get building of the currently authenticated owner
  ///
  /// Returns null if the owner doesn't have a building yet
  /// Throws exception on other errors
  Future<BuildingModel?> getMyBuilding() async {
    try {
      final response = await _http.get(ApiConfig.myBuilding);

      // Some backends return 200 with success=false when no building exists.
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        final success = data?['success'] == true;
        final payload = data?['data'] as Map<String, dynamic>?;

        if (!success && (payload == null)) {
          // Treat "no building" responses as null instead of throwing.
          return null;
        }

        _ensureSuccess(response);
        if (payload == null) return null;
        return BuildingModel.fromJson(payload);
      }

      _ensureSuccess(response);
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return BuildingModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Building not found - owner hasn't created one yet
      }
      rethrow;
    }
  }

  /// Create a new building for the current owner
  ///
  /// [buildingData] should contain all required building information
  /// Returns the newly created BuildingModel
  /// Throws exception if creation fails
  Future<BuildingModel> createBuilding(Map<String, dynamic> buildingData) async {
    final response = await _http.post(
      ApiConfig.buildings,
      data: buildingData,
    );
    _ensureSuccess(response);

    final data = response.data['data'] as Map<String, dynamic>;
    return BuildingModel.fromJson(data);
  }

  /// Update existing building information
  ///
  /// [buildingId] is the ID of the building to update
  /// [updates] contains the fields to be updated
  /// Returns the updated BuildingModel
  /// Throws exception if update fails
  Future<BuildingModel> updateBuilding(
    String buildingId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _http.put(
      ApiConfig.buildingById(buildingId),
      data: updates,
    );
    _ensureSuccess(response);

    final data = response.data['data'] as Map<String, dynamic>;
    return BuildingModel.fromJson(data);
  }

  /// Delete a building
  ///
  /// [buildingId] is the ID of the building to delete
  /// Throws exception if deletion fails
  Future<void> deleteBuilding(String buildingId) async {
    final response = await _http.delete(ApiConfig.buildingById(buildingId));
    _ensureSuccess(response);
  }

  /// Get statistical data for a building
  ///
  /// [buildingId] is the ID of the building
  /// Returns BuildingStatsModel with occupancy and room statistics
  /// Throws exception if retrieval fails
  Future<BuildingStatsModel> getBuildingStats(String buildingId) async {
    final response = await _http.get(ApiConfig.buildingStats(buildingId));
    _ensureSuccess(response);

    final data = response.data['data'] as Map<String, dynamic>;
    return BuildingStatsModel.fromJson(data);
  }

  /// Check if the current owner has a building
  ///
  /// Returns true if building exists, false otherwise
  /// Useful for determining if owner needs to create a building first
  Future<bool> hasBuilding() async {
    try {
      final building = await getMyBuilding();
      return building != null;
    } catch (_) {
      // On transient errors, assume no building to avoid blocking login loops.
      return false;
    }
  }
}
