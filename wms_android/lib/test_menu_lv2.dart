import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SSINDT01/SSINDT01_card_main.dart';
import 'SSFGDT04/SSFGDT04_main.dart';
// Import หน้าหรือ widgets ต่างๆ ที่คุณต้องการนำทางไป

class TestMenuLv2 extends StatefulWidget {
  final String menu_id;
  TestMenuLv2({required this.menu_id});
  @override
  _TestMenuLv2State createState() => _TestMenuLv2State();
}

class _TestMenuLv2State extends State<TestMenuLv2> {
  List<dynamic> dataMenu = [];
  String? P_MAIN_MENU;

  @override
  void initState() {
    super.initState();
    P_MAIN_MENU = widget.menu_id;
    fetchData();

    print('P_MAIN_MENU : $P_MAIN_MENU');
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/menu_level_2/$P_MAIN_MENU'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

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

  // ฟังก์ชันที่ใช้ในการแมปชื่อเพจกับ Widget
  Widget? _mapPageNameToWidget(String pageName) {
  switch (pageName) {
    case 'SSINDT01_MAIN':
      return SSINDT01_MAIN();
    case 'SSFGDT04_MAIN':
      return SSFGDT04_MAIN();
    // case 'YET_ANOTHER_PAGE':
    //   return YetAnotherPage();
    // เพิ่มเคสอื่นๆ ที่ต้องการแมป
    default:
      return null; // ถ้าไม่พบหน้า
  }
}

  @override
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
                title: Text(item['card_value'] ?? 'No Name'),
                subtitle: Text(item['menu_id'] ?? ''),
                // onTap: () {
                  // นำทางไปยังหน้า TestMenuLv2
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => item['page_main'],
                //     ),
                //   );
                // },
                onTap: () {
                  String pageName = item['page_main'] ?? '';
                  Widget? pageWidget = _mapPageNameToWidget(pageName);

                  if (pageWidget != null) {
                    _navigateToPage(context, pageWidget);
                  } else {
                    print('Page not found for name: $pageName');
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
