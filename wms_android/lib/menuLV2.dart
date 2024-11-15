import 'package:flutter/material.dart';
import 'package:wms_android/SSFGDT17/SSFGDT17_WARE.dart';
import 'package:wms_android/SSFGRP08/SSFGRP08.dart';
import 'custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottombar.dart';
import 'SSFGDT04/SSFGDT04_main.dart';
import 'SSFGDT12/SSFGDT12_main.dart';
import 'SSFGDT09L/SSFGDT09L_main.dart';
import 'SSFGRP09/SSFGRP09_main.dart';
import 'SSFGPC04/SSFGPC04_MAIN.dart';
import 'package:wms_android/SSINDT01/SSINDT01_WARE.dart';
import 'SSFGDT31/SSFGDT31_MAIN.dart';
import 'Global_Parameter.dart' as gb;
import 'package:wms_android/Global_Parameter.dart' as globals;
import 'loading.dart';
// import 'centered_message.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    P_MAIN_MENU = widget.menu_id;
    fetchData();

    print('P_MAIN_MENU : $P_MAIN_MENU');
    print('=======================================');
    print(gb.ATTR1);
    print(
        '${globals.IP_API}/apex/wms/c/menu_level_2/${widget.sessionID}/${widget.menu_id}');
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
          '${globals.IP_API}/apex/wms/c/menu_level_2/${widget.sessionID}/${widget.menu_id}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {
          setState(() {
            dataMenu =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataMenu : $dataMenu');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  Widget? _mapPageNameToWidget(String pageName) {
    String checkPage = '$pageName ${widget.p_attr1}';
    switch (checkPage) {
      case 'SSINDT01_MAIN Raw Material':
      case 'SSINDT04_MAIN Finishing':
        return SSFGDT01_WARE(
            p_attr1: widget.p_attr1, p_ou_code: widget.p_ou_code);
      case 'SSFGDT04_MAIN Raw Material':
      case 'SSFGDT04_MAIN Finishing':
        return SSFGDT04_MAIN(
            p_attr1: widget.p_attr1, p_ou_code: widget.p_ou_code);
      case 'SSFGDT17_MAIN Raw Material':
      case 'SSFGDT17_MAIN Finishing':
        return SSFGDT17_WARE(
          p_attr1: widget.p_attr1,
          p_ou_code: widget.p_ou_code,
        );
      case 'SSFGDT09L_MAIN Raw Material':
      case 'SSFGDT09L_MAIN Finishing':
        return SSFGDT09L_MAIN(
            pAttr1: widget.p_attr1,
            pErpOuCode: widget.p_ou_code,
            pOuCode: globals.P_OU_CODE);
      case 'SSFGDT12_MAIN Raw Material':
      case 'SSFGDT12_MAIN Finishing':
        return SSFGDT12_MAIN(
            p_attr1: widget.p_attr1, pErpOuCode: widget.p_ou_code);
      case 'SSFGDT31_MAIN Raw Material':
        return const SSFGDT31_MAIN();
      //---------------------------------- ตรวจนับประจำงวด----------------------------\\
      case 'SSFGRP09_MAIN Raw Material':
        return SSFGRP09_MAIN();
      // case 'SSFGDT12_MAIN Raw Material':
      //   return SSFGDT12_MAIN(
      //       p_attr1: widget.p_attr1, pErpOuCode: widget.p_ou_code);
      case 'SSFGRP08_MAIN Raw Material':
        return SSFGRP08_MAIN();
      case 'SSFGPC04_MAIN Raw Material':
        return SSFGPC04_MAIN();

      default:
        return null;
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
      appBar: CustomAppBar(
          title: getTitle(P_MAIN_MENU),
          showExitWarning: false // เรียกใช้ฟังก์ชัน getTitle
          ),
      // drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: LoadingIndicator())
                  // : dataMenu.isEmpty
                  //     ? const Center(child: CenteredMessage())
                  : ListView(
                      children: dataMenu.map((item) {
                        // Check card_value and set icon accordingly
                        String combinedValue =
                            '${item['card_value']}_${widget.menu_id}';
                        IconData iconData;
                        Color? cardColor;
                        switch (combinedValue) {
                          ////      WMS คลังวัตถุดิบ
                          case 'รับจากการสั่งซื้อ_IW.10.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'รับตรง (ไม่อ้าง PO)_IW.10.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'Move Locator_IW.10.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'Move Warehouse_IW.10.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'เบิกจ่าย_IW.10.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'ตรวจนับ_IW.10.00.00':
                            iconData = Icons.assignment_outlined;
                            cardColor = Colors.green[200];
                            break;
                          case 'รับคืนจากการเบิกเพื่อผลผลิต_IW.10.00.00':
                            iconData = Icons.shopping_bag_outlined;
                            cardColor = Colors.green[200];
                            break;

                          /////      WMS คลังสำเร็จรูป
                          case 'รับจากการผลิต_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;
                          case 'รับตรง (ไม่อ้าง PO)_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;
                          case 'Move Locator_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;
                          case 'Move Warehouse_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;
                          case 'เบิกจ่าย_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;
                          case 'ตรวจนับ_IW.20.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.blue[200];
                            break;

                          /////   เพิ่ม Tag
                          case 'Gen FG-Tag_IW.30.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.pink[100];
                            break;
                          case 'Reprint Tag ม้วน_IW.30.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.pink[100];
                            break;

                          //// ตรวจนับประจำงวด
                          case 'ประมวลผลก่อนตรวจนับ_IW.40.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.orange[200];
                            break;
                          case 'บันทึกตรวจนับ_IW.40.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.orange[200];
                            break;
                          case 'รายงานเตรียมตรวจนับ_IW.40.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.orange[200];
                            break;
                          case 'รายงานผลตรวจนับ_IW.40.00.00':
                            iconData = Icons.arrow_circle_right_outlined;
                            cardColor = Colors.orange[200];
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
                              Widget? pageWidget =
                                  _mapPageNameToWidget(pageName);

                              if (pageWidget != null) {
                                _navigateToPage(context, pageWidget);
                              } else {
                                print(
                                    'Page not found for name: $pageName ${widget.p_attr1}');
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
