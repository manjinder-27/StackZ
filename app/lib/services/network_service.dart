import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stackz/services/storage_service.dart';

class NetworkService {
  static const String _domain = "13.48.26.252";

  static Future<int> authenticateUser(String username, String password) async {
    var url = Uri.http(_domain, 'user/login/');
    var response = await http.post(
      url,
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      StorageService.saveAccessKey(data['access']);
      StorageService.saveRefreshKey(data['refresh']);
    }
    return response.statusCode;
  }

  static Future<int> registerUser(
    String username,
    String password,
    String fullname,
    String email,
  ) async {
    var url = Uri.http(_domain, 'user/register/');
    int index = fullname.indexOf(' ');
    String firstname,lastname;

    if (index != -1) {
      firstname = fullname.substring(0, index);
      lastname = fullname.substring(index + 1);
    }else{
      firstname = fullname;
      lastname = "N A"; // Not Applicable
    }
    var response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'email': email,
        'first_name': firstname,
        'last_name': lastname,
      },
    );
    return response.statusCode;
  }

  static Future<String?> refreshToken(String refresh) async {
    var url = Uri.http(_domain, 'user/token/refresh/');
    var response = await http.post(
      url,
      body: {'refresh': refresh},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      StorageService.saveAccessKey(data['access']);
      StorageService.saveRefreshKey(data['refresh']);
      return data['access'];
    }
    return null;
  }

  static Future<dynamic> fetchCourses({bool refreshed=false}) async {
    var url = Uri.http(_domain, 'course/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
    if (refreshed){
      return null;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return null;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return null;
      return await fetchCourses(refreshed: true);
    }
  }

  static Future<dynamic> getCourseDetails(String id,{bool refreshed=false}) async {
    var url = Uri.http(_domain, 'course/$id/modules/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
    if (refreshed){
      return null;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return null;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return null;
      return await getCourseDetails(id,refreshed: true);
    }
  }

  static Future<dynamic> getUserDetails({bool refreshed=false}) async {
    var url = Uri.http(_domain, 'user/profile/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
    if (refreshed){
      return null;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return null;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return null;
      return await getUserDetails(refreshed: true);
    }
  }

  static Future<dynamic> getModuleDetails(String id,{bool refreshed=false}) async {
    var url = Uri.http(_domain, 'course/modules/$id/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      data = jsonDecode(data['content']);
      return data;
    }
    if (refreshed){
      return null;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return null;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return null;
      return await getModuleDetails(id,refreshed: true);
    }
  }

  static Future<dynamic> getCourseProgress(String id,{bool refreshed=false}) async {
    var url = Uri.http(_domain, 'user/progress/$id/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.get(
      url,
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
    if (refreshed){
      return null;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return null;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return null;
      return await getCourseProgress(id,refreshed: true);
    }
  }

  static Future<int> updateProgress(String courseId,int moduleIndex,{bool refreshed=false}) async {
    var url = Uri.http(_domain, 'user/progress/');
    final String? token = await StorageService.getAccessKey();
    var response = await http.post(
      url,
      headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
      body: jsonEncode({
        'course_id': courseId,
        'module_index': moduleIndex,
      }),
    );
    if (response.statusCode == 204) {
      return response.statusCode;
    }
    if (refreshed){
      return response.statusCode;
    }else{
      String? refreshTok = await StorageService.getRefreshKey();
      if (refreshTok == null) return response.statusCode;
      String? tok = await refreshToken(refreshTok);
      if (tok == null) return response.statusCode;
      return await updateProgress(courseId,moduleIndex,refreshed: true);
    }
  }

}
