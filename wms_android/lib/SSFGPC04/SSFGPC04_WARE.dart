import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_WAREHOUSE.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_LOC.dart';
import '../loading.dart';
import '../centered_message.dart';

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
  final int itemsPerPage = 15;
  String? errorMessage;
  final ScrollController _singleChildScrollController = ScrollController();
  final ScrollController _listViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _singleChildScrollController.dispose();
    _listViewScrollController.dispose();
    super.dispose();
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

  int totalPages() {
    return (widget.selectedItems.length / itemsPerPage)
        .ceil(); // คำนวณจำนวนหน้าทั้งหมด
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

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return widget.selectedItems
        .sublist(start, end.clamp(0, widget.selectedItems.length));
  }

  void _scrollToTop() {
    if (_singleChildScrollController.hasClients) {
      _singleChildScrollController.jumpTo(0); // Scroll to the top
    }
  }

  Future<void> nextPage() async {
    final url = '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_next';
    print('next : $url');

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
    return Scaffold(
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: true),
      // backgroundColor: const Color.fromARGB(255, 17, 0, 56),
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
                child: isLoading
                    ? Center(child: LoadingIndicator())
                    : widget.selectedItems.isEmpty
                        ? const Center(child: CenteredMessage())
                        : SingleChildScrollView(
                            controller: _singleChildScrollController,
                            child: ListView.builder(
                              controller: _listViewScrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getCurrentData().length + 1,
                              itemBuilder: (context, index) {
                                if (index < getCurrentData().length) {
                                  var item = getCurrentData()[index];
                                  return Card(
                                    color: Colors.lightBlue[100],
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              item['ware_code'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                  return getCurrentData().length > 3
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                currentPage > 0
                                                    ? ElevatedButton(
                                                        onPressed:
                                                            currentPage > 0
                                                                ? () {
                                                                    _loadPrevPage();
                                                                  }
                                                                : null,
                                                        style: ButtonStyles
                                                            .previousButtonStyle,
                                                        child: ButtonStyles
                                                            .previousButtonContent,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disablePreviousButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    '${(currentPage * itemsPerPage) + 1} - ${widget.selectedItems.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, widget.selectedItems.length) : 0}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            // const SizedBox(width: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                currentPage < totalPages() - 1
                                                    ? ElevatedButton(
                                                        onPressed: currentPage <
                                                                totalPages() - 1
                                                            ? () {
                                                                _loadNextPage();
                                                              }
                                                            : null,
                                                        style: ButtonStyles
                                                            .nextButtonStyle,
                                                        child: ButtonStyles
                                                            .nextButtonContent(),
                                                      )
                                                    : ElevatedButton(
                                                        onPressed: null,
                                                        style: DisableButtonStyles
                                                            .disableNextButtonStyle,
                                                        child: DisableButtonStyles
                                                            .disablePreviousButtonContent,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                }
                              },
                            ),
                          )),
            !isLoading && getCurrentData().length > 0
                ? getCurrentData().length <= 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              currentPage > 0
                                  ? ElevatedButton(
                                      onPressed: currentPage > 0
                                          ? () {
                                              _loadPrevPage();
                                            }
                                          : null,
                                      style: ButtonStyles.previousButtonStyle,
                                      child: ButtonStyles.previousButtonContent,
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disablePreviousButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '${(currentPage * itemsPerPage) + 1} - ${widget.selectedItems.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, widget.selectedItems.length) : 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // const SizedBox(width: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              currentPage < totalPages() - 1
                                  ? ElevatedButton(
                                      onPressed: currentPage < totalPages() - 1
                                          ? () {
                                              _loadNextPage();
                                            }
                                          : null,
                                      style: ButtonStyles.nextButtonStyle,
                                      child: ButtonStyles.nextButtonContent(),
                                    )
                                  : ElevatedButton(
                                      onPressed: null,
                                      style: DisableButtonStyles
                                          .disableNextButtonStyle,
                                      child: DisableButtonStyles
                                          .disablePreviousButtonContent,
                                    ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentPage: 'show'),
    );
  }
}
