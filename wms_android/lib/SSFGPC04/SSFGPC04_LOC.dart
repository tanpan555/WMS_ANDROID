import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_LOCATION.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_BTN_PROCESS.dart';

class SSFGPC04_LOC extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const SSFGPC04_LOC({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _SSFGPC04_LOCState createState() => _SSFGPC04_LOCState();
}

class _SSFGPC04_LOCState extends State<SSFGPC04_LOC> {
  List<Map<String, dynamic>> tmpLocItems = [];
  bool isLoading = true;
  int currentPage = 0;
  final int itemsPerPage = 15;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_TMP_IN_LOC/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {
          setState(() {
            tmpLocItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            isLoading = false;
          });
        }
        print('dataTable tmpLocItems : $tmpLocItems');
      } else {
        throw Exception('Failed to load fetchData');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('ERROR IN Fetch Data : $e');
    }
  }

  List<Map<String, dynamic>> getCurrentPageItems() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return tmpLocItems.sublist(startIndex,
        endIndex > tmpLocItems.length ? tmpLocItems.length : endIndex);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.selectedItems.length / itemsPerPage).ceil();
    final currentPageItems = getCurrentPageItems();
    return Scaffold(
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: false),
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
                        builder: (context) => SSFGPC04_LOCATION(),
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
                    'เลือกสถานที่จัดเก็บ',
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
                        builder: (context) => SSFGPC04_BTN_PROCESS(),
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
              child: widget.selectedItems.isEmpty
                  ? Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Change to your preferred color
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController, // ใช้ scrollController
                      itemCount: currentPageItems.length +
                          1, // +1 เพื่อรองรับปุ่มถัดไป/ย้อนกลับ
                      itemBuilder: (context, index) {
                        if (index < currentPageItems.length) {
                          final item = tmpLocItems[index];
                          return Card(
                            color: Colors.lightBlue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      item['ware_code'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                      color: Colors.black26,
                                      thickness: 1), // เส้นแบ่ง
                                  Text(
                                    item['location_code'] ?? '',
                                  ),
                                  Text(
                                    item['nb_location_name'] ?? '',
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // แสดงปุ่มถัดไปและย้อนกลับในท้ายรายการ
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: currentPage > 0
                                    ? () {
                                        setState(() {
                                          currentPage--;
                                          _scrollToTop(); // เลื่อนไปยังจุดเริ่มต้นเมื่อกดย้อนกลับ
                                        });
                                      }
                                    : null,
                                child: const Text('Previous'),
                              ),
                              // ตรวจสอบว่าจำนวน Card ใน currentPageItems ถึง 15 หรือไม่
                              if (currentPageItems.length == itemsPerPage) ...[
                                Text(
                                  'Page ${currentPage + 1} of $totalPages',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                              ElevatedButton(
                                onPressed: currentPage < totalPages - 1
                                    ? () {
                                        setState(() {
                                          currentPage++;
                                          _scrollToTop(); // เลื่อนไปยังจุดเริ่มต้นเมื่อกดถัดไป
                                        });
                                      }
                                    : null,
                                child: const Text('Next'),
                              ),
                            ],
                          );
                        }
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