// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Global_Parameter.dart' as globals;

class ApiService {
  String browser_language = globals.BROWSER_LANGUAGE;
  String app_user = globals.APP_USER;
  int app_session = 0;

  Future<void> fetchSessionid() async {
    final response = await http
        .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/sessionid'));

    if (response.statusCode == 200) {
      try {
        // Decode the response body to JSON
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        print(data); // Decode JSON

        globals.sessionid = data['items'][0]['sessionid'];
        final app_session = globals.sessionid;

        print(globals.sessionid);
        print(
            'browser_language : $browser_language Type : ${browser_language.runtimeType}');
        print('app_user : $app_user Type : ${app_user.runtimeType}');
        print('app_session : $app_session Type : ${app_session.runtimeType}');

        updateSessionId(app_session);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Failed to load data');
    }
  }

  Future<void> updateSessionId(int app_session) async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/c/sessionid_update/$browser_language/$app_user/$app_session'));

    if (response.statusCode == 200) {
      print('updateSessionId Response Status Code: ${response.statusCode}');
      try {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        print('updateSessionId Fetched data: $data');
      } catch (e) {
        print('updateSessionId Error decoding JSON: $e');
      }
    } else {
      print('updateSessionId Failed to load data: ${response.statusCode}');
    }
  }
}
