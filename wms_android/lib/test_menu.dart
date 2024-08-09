import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_menu_lv2.dart';
// import 'package:intl/intl.dart';

class TestMenu_LV_1 extends StatefulWidget {
  @override
  _TestMenu_LV_1State createState() => _TestMenu_LV_1State();
}

class _TestMenu_LV_1State extends State<TestMenu_LV_1> {
  List<dynamic> dataMenu = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/menu_level_1'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataMenu =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataMenu : $dataMenu');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('ERROR IN Fetch Data : $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: dataMenu.map((item) {
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                // leading: Icon(Icons.check),
                title: Text(item['card_value'] ?? 'No Name'),
                subtitle: Text(item['menu_id'] ?? ''),
                onTap: () {
                  // นำทางไปยังหน้า TestMenuLv2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TestMenuLv2(menu_id: item['menu_id']),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
