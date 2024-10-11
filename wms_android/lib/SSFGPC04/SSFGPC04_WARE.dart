import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_WAREHOUSE.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_LOC.dart';

class SSFGPC04_CARD extends StatefulWidget {
  final String soNo;
  final String date;
  final List<Map<String, dynamic>> selectedItems;

  const SSFGPC04_CARD({
    Key? key,
    required this.soNo,
    required this.date,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _SSFGPC04_CARDState createState() => _SSFGPC04_CARDState();
}

class _SSFGPC04_CARDState extends State<SSFGPC04_CARD> {
  List<Map<String, dynamic>> tmpWhItems = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_1_TMP_IN_WH/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {setState(() {
          tmpWhItems =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          isLoading = false;
        });}
        print('dataTable : $tmpWhItems');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {setState(() {
        isLoading = false;
      });}
      print('ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selectedItems = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGPC04_WAREHOUSE(),
                      ),
                    );
                    if (selectedItems != null) {
                      setState(() {
                        widget.selectedItems.clear();
                        widget.selectedItems.addAll(selectedItems);
                      });
                    }
                  },
                  child: const Text(
                    'เลือกคลังสินค้า',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: AppStyles.cancelButtonStyle(),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGPC04_LOC(
                          selectedItems:
                                    widget.selectedItems.map((item) => Map<String, dynamic>.from(item)).toList(),
                        ),
                      ),
                    );
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20, // ปรับขนาดตามที่ต้องการ
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['ware_code'] ?? ''),
                      subtitle: Text(item['ware_name'] ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
