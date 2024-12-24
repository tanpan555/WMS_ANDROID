import 'package:flutter/material.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import '../styles.dart';
import 'SSFGPC04_LOCATION.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'SSFGPC04_BTN_PROCESS.dart';
import '../centered_message.dart';
import '../loading.dart';

class SSFGPC04_LOC extends StatefulWidget {
  final String date;
  final String note;
  final String docNo;
  const SSFGPC04_LOC({
    Key? key,
    required this.date,
    required this.note,
    required this.docNo,
  }) : super(key: key);

  @override
  _SSFGPC04_LOCState createState() => _SSFGPC04_LOCState();
}

class _SSFGPC04_LOCState extends State<SSFGPC04_LOC> {
  List<Map<String, dynamic>> tmpLocItems = [];
  bool isLoading = true;
  int currentPage = 0;
  final int itemsPerPage = 15;
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

  int totalPages() {
    return (tmpLocItems.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
  }

  void _loadPrevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _scrollToTop();
    }
  }

  void _loadNextPage() {
    if ((currentPage + 1) * itemsPerPage < tmpLocItems.length) {
      setState(() {
        currentPage++;
      });
      _scrollToTop();
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return tmpLocItems.sublist(start, end.clamp(0, tmpLocItems.length));
  }

  void _scrollToTop() {
    if (_singleChildScrollController.hasClients) {
      _singleChildScrollController.jumpTo(0); // Scroll to the top
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_TMP_IN_LOC/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));
      print(Uri.parse(
          '${gb.IP_API}/apex/wms/SSFGPC04/Step_2_TMP_IN_LOC/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  // onPressed: () async {
                  //   final selectedItems = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => SSFGPC04_LOCATION(
                  //         date: widget.date,
                  //         note: widget.note,
                  //         docNo: widget.docNo,
                  //       ),
                  //     ),
                  //   ).then((value) {
                  //     fetchData();
                  //   });
                  //   if (selectedItems != null) {
                  //     setState(() {
                  //       tmpLocItems.clear();
                  //       tmpLocItems.addAll(selectedItems);
                  //     });
                  //   }
                  // },
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SSFGPC04_LOCATION(
                          date: widget.date,
                          note: widget.note,
                          docNo: widget.docNo,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        isLoading = true; // Set loading to true immediately
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        fetchData().then((_) {
                          setState(() {
                            isLoading =
                                false; // Reset loading to false after fetchData completes
                          });
                        });
                      });
                    });
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
                        builder: (context) => SSFGPC04_BTN_PROCESS(
                          selectedItems: tmpLocItems
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
                  : tmpLocItems.isEmpty
                      ? const Center(child: CenteredMessage())
                      : SingleChildScrollView(
                          controller: _singleChildScrollController,
                          child: ListView.builder(
                            controller: _listViewScrollController,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: tmpLocItems.length,
                            // itemBuilder: (context, index) {
                            //   final item = tmpLocItems[index];
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
                                            'คลังสินค้า : ${item['ware_code'] ?? ''}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.black26,
                                            thickness: 1),
                                        // Text(item['location_code'] ?? ''),
                                        // Text(item['nb_location_name'] ?? ''),
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              const Text(
                                                'ตำแหน่งจัดเก็บ : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              CustomContainerStyles
                                                  .styledContainer(
                                                item['location_code'] ??
                                                    '', // ค่าที่ใช้ในการตรวจสอบสีพื้นหลัง
                                                child: Text(
                                                  item['location_code'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize
                                                .min, // ให้ Row ใช้ขนาดที่จำเป็น
                                            children: [
                                              const Text(
                                                'ตำแหน่งจัดเก็บ : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Flexible(
                                                // ใช้ Flexible แทน Expanded เพื่อให้ขยายตามขนาดที่จำเป็น
                                                child: CustomContainerStyles
                                                    .styledContainer(
                                                  item['nb_location_name'],
                                                  child: Text(
                                                    item['nb_location_name'] ?? '',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                    softWrap:
                                                        true, // เปิดให้ตัดบรรทัดเมื่อความยาวเกิน
                                                    overflow: TextOverflow
                                                        .visible, // แสดงข้อความทั้งหมด
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return getCurrentData().length > 4
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
                                                      onPressed: currentPage > 0
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
                                                  '${(currentPage * itemsPerPage) + 1} - ${tmpLocItems.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, tmpLocItems.length) : 0}',
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
                          )),
            ),
            !isLoading && getCurrentData().length > 0
                ? getCurrentData().length <= 4
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
                                  '${(currentPage * itemsPerPage) + 1} - ${tmpLocItems.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, tmpLocItems.length) : 0}',
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
