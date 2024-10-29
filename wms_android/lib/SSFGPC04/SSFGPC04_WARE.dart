import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_WAREHOUSE.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_LOC.dart';

class SSFGPC04_WARE extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const SSFGPC04_WARE({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _SSFGPC04_WAREState createState() => _SSFGPC04_WAREState();
}

class _SSFGPC04_WAREState extends State<SSFGPC04_WARE> {
  List<Map<String, dynamic>> tmpWhItems = [];
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
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_1_TMP_IN_WH/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $responseData');

        if (mounted) {
          setState(() {
            tmpWhItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
            isLoading = false;
          });
        }
        print('dataTable : $tmpWhItems');
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

  Future<void> nextPage() async {
    const url = 'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_2_next';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'APP_SESSION': gb.APP_SESSION,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
    });

    print('Request body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            if (mounted) {
              setState(() {
                // Perform any additional UI updates here
              });
            }
            print('Success: $responseData');
          } catch (e) {
            print('Error decoding JSON: $e');
          }
        } else {
          print('เช็คแล้วจ้าาา');
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error นะฮ๊าฟฟู๊วววว: $e');
    }
  }

  List<Map<String, dynamic>> getCurrentPageItems() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return widget.selectedItems.sublist(
        startIndex,
        endIndex > widget.selectedItems.length
            ? widget.selectedItems.length
            : endIndex);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.selectedItems.length / itemsPerPage).ceil();
    final currentPageItems =
        getCurrentPageItems(); // ดึงรายการของหน้าในปัจจุบัน
    return Scaffold(
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: true),
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
                        builder: (context) => SSFGPC04_WAREHOUSE(
                          selectedItems: widget.selectedItems,
                        ),
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
                  onPressed: () async {
                    await nextPage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGPC04_LOC(
                          selectedItems: widget.selectedItems
                              .map((item) => Map<String, dynamic>.from(item))
                              .toList(),
                        ),
                      ),
                    );
                  },
                  style: AppStyles.NextButtonStyle(),
                  child: Image.asset(
                    'assets/images/right.png',
                    width: 20,
                    height: 20,
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
                          color: Colors.white, // เปลี่ยนเป็นสีที่ต้องการ
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController, // ใช้ scrollController
                      itemCount: currentPageItems.length + 1,
                      itemBuilder: (context, index) {
                        if (index < currentPageItems.length) {
                          final item = currentPageItems[index];
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
                                    item['ware_name'] ?? '',
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
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
