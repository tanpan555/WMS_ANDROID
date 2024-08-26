import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_MAIN.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_MENU.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottombar.dart';
import 'SSINDT01/SSINDT01_main.dart';
import 'SSFGDT04/SSFGDT04_main.dart';
import 'SSFGDT12/SSFGDT12_main.dart';
// Import หน้าหรือ widgets ต่างๆ ที่คุณต้องการนำทางไป

class TestMenuLv2 extends StatefulWidget {
  final String sessionID;
  final String menu_id;
  final String p_attr1;
  final String p_ou_code;

  const TestMenuLv2({
    Key? key,
    required this.sessionID,
    required this.menu_id,
    required this.p_attr1,
    required this.p_ou_code,
  }) : super(key: key);
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
          'http://172.16.0.82:8888/apex/wms/c/menu_level_2/${widget.sessionID}/${widget.menu_id}'));

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
      case 'SSFGDT17_MAIN':
      return SSFGDT17_MENU();
      case 'SSFGDT12_MAIN':
        return SSFGDT12_MAIN(
            p_attr1: widget.p_attr1, p_ou_code: widget.p_ou_code);
      // case 'YET_ANOTHER_PAGE':
      //   return YetAnotherPage();
      // เพิ่มเคสอื่นๆ ที่ต้องการแมป
      default:
        return null; // ถ้าไม่พบหน้า
    }
  }

  String getTitle(P_MAIN_MENU) {
    switch (P_MAIN_MENU) {
      case 'IW.10.00.00':
        return 'WMS คลังวัตถุดิบ';
      case 'IW.20.00.00':
        return 'WMS คลังสำเร็จรูป';
      case 'IW.30.00.00':
        return 'Bacode and Tag';
      case 'IW.40.00.00':
        return 'ตรวจนับประจำงวด';
      default:
        return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(
        title: getTitle(P_MAIN_MENU), // เรียกใช้ฟังก์ชัน getTitle
      ),
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: dataMenu.map((item) {
                  // Check card_value and set icon accordingly
                  String combinedValue =
                      '${item['card_value']}_${widget.menu_id}';
                  IconData iconData;
                  Color cardColor;
                  switch (combinedValue) {
                    ////      WMS คลังวัตถุดิบ
                    case 'รับจากการสั่งซื้อ_IW.10.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'รับตรง (ไม่อ้าง PO)_IW.10.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'Move Locator_IW.10.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'Move Warehouse_IW.10.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'เบิกจ่าย_IW.10.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'ตรวจนับ_IW.10.00.00':
                      iconData = Icons.assignment_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'รับคืนจากการเบิกเพื่อผลผลิต_IW.10.00.00':
                      iconData = Icons.shopping_bag_outlined;
                      cardColor = Colors.greenAccent;
                      break;

                    /////      WMS คลังสำเร็จรูป
                    case 'รับจากการผลิต_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;
                    case 'รับตรง (ไม่อ้าง PO)_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;
                    case 'Move Locator_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;
                    case 'Move Warehouse_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;
                    case 'เบิกจ่าย_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;
                    case 'ตรวจนับ_IW.20.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.blueAccent;
                      break;

                    /////   เพิ่ม Tag
                    case 'Gen FG-Tag_IW.30.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.pinkAccent;
                      break;
                    case 'Reprint Tag ม้วน_IW.30.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.pinkAccent;
                      break;

                    //// ตรวจนับประจำงวด
                    case 'ประมวลผลก่อนตรวจนับ_IW.40.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'บันทึกตรวจนับ_IW.40.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'รายงานเตรียมตรวจนับ_IW.40.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    case 'รายงานผลตรวจนับ_IW.40.00.00':
                      iconData = Icons.arrow_circle_right_outlined;
                      cardColor = Colors.greenAccent;
                      break;
                    default:
                      iconData = Icons.help; // Default icon
                      cardColor = Colors.grey;
                  }

                  return Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: cardColor,
                    child: ListTile(
                      leading: Icon(
                        iconData, // ไอคอนที่คุณต้องการ
                        color: Colors.black, // กำหนดสีไอคอนเป็นสีดำ
                      ),
                      title: Text(item['card_value'] ?? 'No Name'),
                      // subtitle: Text(item['menu_id'] ?? ''),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
