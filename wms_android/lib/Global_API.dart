import 'dart:convert';
import 'package:http/http.dart' as http;

const IP_API = '172.16.0.125:8080';

Future<List> apiget1(String apiName, Map<String, dynamic>? data) async {
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final url = Uri.http(IP_API, '/apex/wms/$apiName', data);
  List<dynamic> ret = [];
  try {
    print(url);
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);
      ret = List<dynamic>.from(responseData['items'] ?? []);

      return ret;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return ret;
    }
  } catch (e) {
    print('Error: $e');
    return ret;
  }
}

Future<List> apiget2(String apiName, Map<String, dynamic>? data) async {
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final url = Uri.http(IP_API, '/apex/wms/$apiName', data);
  List<dynamic> ret = [];

  try {
    print(url);
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);

      ret = responseData.isNotEmpty ? List<dynamic>.from([responseData]) : [];

      return ret;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return ret;
    }
  } catch (e) {
    print('Error: $e');
    return ret;
  }
}

Future<List> apipost(String apiName, Map<String, dynamic>? data) async {
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final url = Uri.http(IP_API, '/apex/wms/$apiName');
  List<dynamic> ret = [];

  final body = jsonEncode(data);

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);

      ret = responseData.entries
          .map((entry) => {entry.key: entry.value})
          .toList();
      return ret[0];
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return ret;
    }
  } catch (e) {
    print('Error: $e');
    return ret;
  }
}

Future<List> apiput(String apiName, Map<String, dynamic>? data) async {
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final url = Uri.http(IP_API, '/apex/wms/$apiName');
  List<dynamic> ret = [];

  final body = jsonEncode(data);

  try {
    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);

      // ret = List<dynamic>.from(responseData ?? []);
      ret = responseData.entries
          .map((entry) => {entry.key: entry.value})
          .toList();
      return ret;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return ret;
    }
  } catch (e) {
    print('Error: $e');
    return ret;
  }
}

Future<List> apidelete(String apiName, Map<String, dynamic>? data) async {
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final url = Uri.http(IP_API, '/apex/wms/$apiName');
  List<dynamic> ret = [];

  final body = jsonEncode(data);

  try {
    final response = await http.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);

      // ret = List<dynamic>.from(responseData ?? []);
      ret = responseData.entries
          .map((entry) => {entry.key: entry.value})
          .toList();
      return ret;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return ret;
    }
  } catch (e) {
    print('Error: $e');
    return ret;
  }
}
