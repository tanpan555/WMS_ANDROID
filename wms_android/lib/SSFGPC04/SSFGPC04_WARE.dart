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
  final String date;
  final String note;
  final String docNo;
  const SSFGPC04_WARE({
    Key? key,
    required this.selectedItems,
    required this.date,
    required this.note,
    required this.docNo,
  }) : super(key: key);

  @override
  _SSFGPC04_WAREState createState() => _SSFGPC04_WAREState();
}

class _SSFGPC04_WAREState extends State<SSFGPC04_WARE> {
  List<Map<String, dynamic>> tmpWhItems = [];
  bool isLoading = true;
  int currentPage = 0;
  final int itemsPerPage = 15; // จำนวนการ์ดต่อหน้า
  List<dynamic> dataCard = [];
  String? next;
  String? previous;
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData([String? url]) async {
    if (!mounted) return; // ตรวจสอบว่าตัว component ยังถูก mount อยู่หรือไม่

    setState(() {
      isLoading = true;
    });

    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSFGPC04/Step_1_TMP_IN_WH/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}';

    try {
      final response = await http.get(Uri.parse(requestUrl));
      print(requestUrl);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (!mounted) return;

        if (mounted) {
          setState(() {
            // ตรวจสอบข้อมูลก่อนการอัปเดต
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              tmpWhItems = parsedResponse['items'];
            } else {
              tmpWhItems = [];
            }
            int totalCards = tmpWhItems.length;
            List<Map<String, dynamic>> getCurrentPageItems() {
              int startIndex = currentPage * itemsPerPage;
              int endIndex = (startIndex + itemsPerPage > totalCards)
                  ? totalCards
                  : startIndex + itemsPerPage;
              return widget.selectedItems.sublist(
                  startIndex,
                  endIndex > widget.selectedItems.length
                      ? widget.selectedItems.length
                      : endIndex);
            }

            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error occurred: $e';
        });
      }
    }
  }

  String? getLink(List<dynamic> links, String rel) {
    final link =
        links.firstWhere((item) => item['rel'] == rel, orElse: () => null);
    return link != null ? link['href'] : null;
  }

  void _loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  void _loadNextPage() {
    if ((currentPage + 1) * itemsPerPage < widget.selectedItems.length) {
      setState(() {
        currentPage++;
        // No need to call fetchData here, just update the UI
      });
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0); // เลื่อนไปยังตำแหน่งเริ่มต้น (index 0)
    }
  }

  Future<void> nextPage() async {
    final url = '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_next';

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

  @override
  Widget build(BuildContext context) {
    int totalCards = widget.selectedItems.length;
    bool hasPreviousPage = currentPage > 0;
    bool hasNextPage = (currentPage + 1) * itemsPerPage < totalCards;
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
                          date: widget.date,
                          note: widget.note,
                          docNo: widget.docNo,
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
                      controller: _scrollController,
                      itemCount: itemsPerPage + 1, // +1 for the pagination row
                      itemBuilder: (context, index) {
                        if (index < itemsPerPage) {
                          int actualIndex =
                              (currentPage * itemsPerPage) + index;

                          // Check if we have reached the end of the data
                          if (actualIndex >= widget.selectedItems.length) {
                            return const SizedBox.shrink();
                          }

                          final item = widget.selectedItems[actualIndex];
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
                              // Previous Button
                              hasPreviousPage
                                  ? ElevatedButton.icon(
                                      onPressed: _loadPrevPage,
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.black,
                                        size: 20.0,
                                      ),
                                      label: const Text(
                                        'Previous',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      style: AppStyles.PreviousButtonStyle(),
                                    )
                                  : ElevatedButton.icon(
                                      onPressed: null,
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Color.fromARGB(0, 23, 21, 59),
                                        size: 20.0,
                                      ),
                                      label: const Text(
                                        'Previous',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(0, 255, 255, 255),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      style: AppStyles
                                          .DisablePreviousButtonStyle(),
                                    ),

                              // Page Indicator
                              Text(
                                '${(currentPage * itemsPerPage) + 1}-${(currentPage + 1) * itemsPerPage > totalCards ? totalCards : (currentPage + 1) * itemsPerPage}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Next Button
                              hasNextPage
                                  ? ElevatedButton(
                                      onPressed: _loadNextPage,
                                      style:
                                          AppStyles.NextRecordDataButtonStyle(),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: AppStyles
                                          .DisableNextRecordDataButtonStyle(),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Next',
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(0, 23, 21, 59),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color:
                                                Color.fromARGB(0, 23, 21, 59),
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
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
