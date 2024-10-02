// // lib/api_service.dart
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'Global_Parameter.dart' as globals;

// class ApiService {
//   String browser_language = globals.BROWSER_LANGUAGE;
//   String app_user = globals.APP_USER;
//   int app_session = 0;

//   Future<void> fetchSessionid() async {
//     final response = await http
//         .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/sessionid'));

//     if (response.statusCode == 200) {
//       try {
//         // Decode the response body to JSON
//         final responseBody = utf8.decode(response.bodyBytes);
//         final data = jsonDecode(responseBody);
//         print(data); // Decode JSON

//         globals.sessionid = data['items'][0]['sessionid'];
//         final app_session = globals.sessionid;
//         updateSessionId(app_session);
//       } catch (e) {
//         print('Error decoding JSON: $e');
//       }
//     } else {
//       print('Failed to load data');
//     }
//   }

//   Future<void> updateSessionId(int app_session) async {
//     final response = await http.get(Uri.parse(
//         'http://172.16.0.82:8888/apex/wms/c/sessionid_update/$browser_language/$app_user/$app_session'));

//     if (response.statusCode == 200) {
//       try {
//         final responseBody = utf8.decode(response.bodyBytes);
//         print('Response Body: $responseBody'); // ตรวจสอบข้อมูลที่ได้รับ
//         if (responseBody.isNotEmpty) {
//           final data = jsonDecode(responseBody);
//           final dataSessionId = data['app_session'];
//           // globals.APP_SESSION = int.parse(dataSessionId);
//           globals.APP_SESSION = dataSessionId;
//           print('globals.APP_SESSION');
//           print(globals.APP_SESSION);
//         } else {
//           print('Empty response body.');
//         }
//       } catch (e) {
//         print('Error decoding JSON: $e');
//       }
//     } else {
//       print('updateSessionId Failed to load data: ${response.statusCode}');
//     }
//   }
// }
