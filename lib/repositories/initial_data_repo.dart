import 'dart:convert';
import 'dart:io';

import 'package:locale/network_helpers/api.dart';
import 'package:locale/repositories/marker_locations_repo.dart';

class InitialDataRepo {
  final Api api;

  InitialDataRepo({required this.api});

  static const LOCAL_URI =
      'http://localhost:5001/locale-346911/us-central1/allLocationList';

  static const REMOTE_URI =
      'https://us-central1-locale-346911.cloudfunctions.net/allLocationList';

  Future<dynamic> getAllCameras() async {
    try {
      final response = await api.get(url: REMOTE_URI);
      if (response.statusCode == 200) {
        return ApiSuccess(body: response.body, success: true);
      } else {
        final res = jsonDecode(response.body);
        return ApiError(errorMessage: res['message'], success: false);
      }
    } on SocketException {
      return ApiError(errorMessage: 'No internet connection', success: false);
    } catch (e) {
      return ApiError(errorMessage: e.toString(), success: false);
    }
  }
}
