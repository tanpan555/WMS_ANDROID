import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/SSINDT01/SSINDT01_grid_data.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/styles.dart';
import 'SSINDT01_form.dart';
import 'dart:async';
import 'package:wms_android/Global_Parameter.dart' as gb;
import '../loading.dart';
import '../centered_message.dart';

class SSINDT01_MAIN extends StatefulWidget {
  final String pWareCode;
  final String pWareName;
  final String p_ou_code;
  final String selectedValue;
  final String apCode;
  final String documentNumber;

  const SSINDT01_MAIN({
    Key? key,
    required this.pWareCode,
    required this.pWareName,
    required this.p_ou_code,
    required this.selectedValue,
    required this.apCode,
    required this.documentNumber,
  }) : super(key: key);
  @override
  _SSINDT01_MAINState createState() => _SSINDT01_MAINState();
}

class _SSINDT01_MAINState extends State<SSINDT01_MAIN> {
  List<dynamic> data = [];
  List<dynamic> displayedData = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();
  final ScrollController _singleChildScrollController = ScrollController();
  final ScrollController _listViewScrollController = ScrollController();
  String searchQuery = '';

  String? ATTR = gb.Raw_Material;

  List<dynamic> apCodes = [];
  String? selectedApCode;

  List<dynamic> whCodes = [];
  String? selectedwhCode;

  String? fixedValue;

  int itemsPerPage = 15; // Number of records per page
  int currentPage = 0; // Total number of records

  @override
  void initState() {
    super.initState();
    selectedwhCode = widget.pWareCode;
    selectedApCode = widget.apCode;
    String documentNumber = widget.documentNumber;

    // Debug statements
    print('Card Global Ware Code: ${gb.P_WARE_CODE}');

    print('+----------------------------------------');
    print(gb.ATTR1);
    print(widget.selectedValue);
    print(fixedValue);
    print(widget.apCode);
    print('Original widget.documentNumber: ${widget.documentNumber}');
    fixedValue = valueMapping[widget.selectedValue];
    if (widget.apCode.isEmpty || selectedApCode == 'ทั้งหมด') {
      selectedApCode = 'null';
      fetchWareCodes();
    } else {
      selectedApCode = widget.apCode;
      fetchWareCodes();
    }
    print('Document Number (with default if null): $documentNumber');
  }

  @override
  void dispose() {
    _singleChildScrollController.dispose();
    _listViewScrollController.dispose();
    super.dispose();
  }

  final Map<String, String> valueMapping = {
    'รายการรอรับดำเนินการ': 'A',
    'รายการใบสั่งซื้อ': 'B',
    'ทั้งหมด': 'C',
  };

  Future<void> fetchWareCodes([String? url]) async {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print('URL : $url ');
    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSINDT01/Step_1_Card_list/$selectedApCode/$ATTR/${widget.documentNumber}/$fixedValue/${gb.BROWSER_LANGUAGE}';
    print('URL : $requestUrl ');
    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);

        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              data = parsedResponse['items'];
            } else {
              data = [];
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            print('Failed to load data: ${response.statusCode}');
          });
        }
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (mounted) {
        isLoading = false;
        setState(() {
          print('Error occurred: $e');
        });
      }
      print('Exception: $e');
    }
  }

  int totalPages() {
    return (data.length / itemsPerPage).ceil(); // คำนวณจำนวนหน้าทั้งหมด
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
    if ((currentPage + 1) * itemsPerPage < data.length) {
      setState(() {
        currentPage++;
      });
      _scrollToTop();
    }
  }

  List<dynamic> getCurrentData() {
    final start = currentPage * itemsPerPage;
    final end = start + itemsPerPage;

    return data.sublist(start, end.clamp(0, data.length));
  }

  void _scrollToTop() {
    if (_singleChildScrollController.hasClients) {
      _singleChildScrollController.jumpTo(0); // Scroll to the top
    }
  }

  String? poStatus;
  String? poMessage;
  String? poStep;

  Future<void> fetchPoStatus(String poNo, String? receiveNo) async {
    final String receiveNoParam = receiveNo ?? 'null';
    final String apiUrl =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_1_check_rcv/$poNo/$receiveNoParam/${gb.P_OU_CODE}/${gb.P_ERP_OU_CODE}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (mounted) {
          setState(() {
            poStatus = responseBody['po_status'];
            poMessage = responseBody['po_message'];
            poStep = responseBody['po_goto_step'];

            print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
            print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
            print('poStep : $poStep Type : ${poStep.runtimeType}');
          });
        }
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          poStatus = 'Error';
          poMessage = e.toString();

          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
        });
      }
    }
  }

  String? poStatusconform;
  String? poMessageconform;

  Future<void> fetchPoStatusconform(String? receiveNo) async {
    // final String receiveNoParam = receiveNo ?? 'null';
    final String apiUrl =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_1_conform_reciveIN_refPO/${receiveNo}/${gb.P_ERP_OU_CODE}/${gb.APP_SESSION}';

    try {
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (mounted) {
          setState(() {
            poStatusconform = responseBody['po_status'];
            poMessageconform = responseBody['po_message'];

            print(
                'poStatus : $poStatusconform Type : ${poStatusconform.runtimeType}');
            print(
                'poMessage : $poMessageconform Type : ${poMessageconform.runtimeType}');
          });
        }
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          poStatus = 'Error';
          poMessage = e.toString();

          print(
              'poStatus : $poStatusconform Type : ${poStatusconform.runtimeType}');
          print(
              'poMessage : $poMessageconform Type : ${poMessageconform.runtimeType}');
        });
      }
    }
  }

  String? poReceiveNo;

  Future<void> sendPostRequest(
      String poNo, String receiveNo, String selectedwhCode) async {
    final url = '${gb.IP_API}/apex/wms/SSINDT01/Step_1_create_inhead_wms';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'P_OU_CODE': gb.P_OU_CODE,
      'P_PO_NO': poNo,
      'P_RECEIVE_NO': receiveNo,
      'P_WH_CODE': selectedwhCode,
      'P_ERP_OU_CODE': gb.P_ERP_OU_CODE,
      'APP_SESSION': gb.APP_SESSION,
      'APP_USER': gb.APP_USER,
    });

    print('headers : $headers Type : ${headers.runtimeType}');
    print('body : $body Type : ${body.runtimeType}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            poReceiveNo = responseData['po_receive_no'];
            poStatus = responseData['po_status'];
            poMessage = responseData['po_message'];

            print(
                'poReceiveNo : $poReceiveNo Type : ${poReceiveNo.runtimeType}');
            print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
            print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          });
        }
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool isNavigating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: isLoading
                    ? Center(child: LoadingIndicator())
                    : data.isEmpty
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
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.lightBlue[100],
                                    child: InkWell(
                                      onTap: isNavigating
                                          ? null // Disable tap if navigating
                                          : () async {
                                              setState(() {
                                                isNavigating =
                                                    true; // Set to true to block further taps
                                              });
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                setState(() {
                                                  isNavigating =
                                                      false; // Re-enable tap after some time (e.g., after navigation completes)
                                                });
                                              }); // Set flag to true when navigation starts

                                              if (selectedwhCode == null) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DialogStyles
                                                        .alertMessageDialog(
                                                      context: context,
                                                      content: const Text(
                                                          'โปรดเลือกคลังสินค้า'),
                                                      onClose: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      onConfirm: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    );
                                                  },
                                                );
                                                isNavigating =
                                                    false; // Reset flag when the alert is shown
                                                return;
                                              }

                                              final pPoNo = item['po_no'] ?? '';
                                              final vReceiveNo =
                                                  item['receive_no'] ?? 'null';

                                              await fetchPoStatus(
                                                  pPoNo, vReceiveNo);
                                              await fetchPoStatusconform(
                                                  vReceiveNo);

                                              if (poStatus == '0' &&
                                                  poStep == '2') {
                                                // Navigate to Form page
                                                await sendPostRequest(
                                                    pPoNo,
                                                    vReceiveNo,
                                                    selectedwhCode ?? '');
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Ssindt01Form(
                                                      poReceiveNo:
                                                          poReceiveNo ?? '',
                                                      pWareCode:
                                                          widget.pWareCode,
                                                      pWareName:
                                                          widget.pWareName,
                                                      p_ou_code:
                                                          widget.p_ou_code,
                                                    ),
                                                  ),
                                                );
                                              } else if (poStatus == '0' &&
                                                  poStep == '4') {
                                                // Navigate to Grid page
                                                await sendPostRequest(
                                                    pPoNo,
                                                    vReceiveNo,
                                                    selectedwhCode ?? '');
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Ssindt01Grid(
                                                      poReceiveNo:
                                                          poReceiveNo ?? '',
                                                      poPONO: pPoNo,
                                                      pWareCode:
                                                          widget.pWareCode,
                                                      pWareName:
                                                          widget.pWareName,
                                                      p_ou_code:
                                                          widget.p_ou_code,
                                                    ),
                                                  ),
                                                );
                                              } else if (poStatus == '0') {
                                                // Original flow - Navigate to Form page
                                                await sendPostRequest(
                                                    pPoNo,
                                                    vReceiveNo,
                                                    selectedwhCode ?? '');
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Ssindt01Form(
                                                      poReceiveNo:
                                                          poReceiveNo ?? '',
                                                      pWareCode:
                                                          widget.pWareCode,
                                                      pWareName:
                                                          widget.pWareName,
                                                      p_ou_code:
                                                          widget.p_ou_code,
                                                    ),
                                                  ),
                                                );
                                              } else if (poStatus == '1' &&
                                                  poStep == '9') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DialogStyles
                                                        .alertMessageDialog(
                                                      context: context,
                                                      content: Text(
                                                          '${poMessage ?? 'No message available'}'),
                                                      onClose: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      onConfirm: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (poStatusconform ==
                                                            '1') {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DialogStyles
                                                                  .alertMessageDialog(
                                                                context:
                                                                    context,
                                                                content: Text(
                                                                    '${poMessageconform ?? 'No message available'}'),
                                                                onClose: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                onConfirm:
                                                                    () async {
                                                                  await fetchPoStatusconform(
                                                                      vReceiveNo);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              } else if (poStatus == '1' &&
                                                  poStep == '') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DialogStyles
                                                        .alertMessageDialog(
                                                      context: context,
                                                      content: Text(
                                                          '${poMessageconform ?? 'No message available'}'),
                                                      onClose: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      onConfirm: () async {
                                                        await fetchPoStatusconform(
                                                            vReceiveNo);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['ap_name'] ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                                const Divider(
                                                    color: Colors.black26,
                                                    thickness: 1),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: (() {
                                                          switch (item[
                                                              'status_desc']) {
                                                            case 'ตรวจรับบางส่วน':
                                                              return const Color
                                                                  .fromARGB(255,
                                                                  17, 109, 110);
                                                            case 'บันทึก':
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  118,
                                                                  113,
                                                                  113);
                                                            case 'รอยืนยัน':
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  246,
                                                                  250,
                                                                  112);
                                                            case 'ปกติ':
                                                              return const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  186,
                                                                  186,
                                                                  186);
                                                            case 'อนุมัติ':
                                                              return const Color
                                                                  .fromARGB(255,
                                                                  146, 208, 80);
                                                            case 'ทั้งหมด':
                                                            default:
                                                              return const Color.fromARGB(255, 255, 255, 255);
                                                          }
                                                        })(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        item['status_desc'],
                                                        style: TextStyle(
                                                          color: (() {
                                                            switch (item[
                                                                'status_desc']) {
                                                              case 'ตรวจรับบางส่วน':
                                                                return Colors
                                                                    .white; // ตัวหนังสือสีขาว
                                                              default:
                                                                return Colors
                                                                    .black; // ตัวหนังสือสีดำ
                                                            }
                                                          })(),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Center(
                                                      child: (() {
                                                        if (item['card_qc'] ==
                                                            '#APP_IMAGES#rt_machine_on.png') {
                                                          return Image.asset(
                                                            'assets/images/rt_machine_on.png',
                                                            width: 50,
                                                            height: 50,
                                                          );
                                                        } else if (item[
                                                                'card_qc'] ==
                                                            '#APP_IMAGES#rt_machine_off.png') {
                                                          return Image.asset(
                                                            'assets/images/rt_machine_off.png',
                                                            width: 50,
                                                            height: 50,
                                                          );
                                                        } else if (item[
                                                                'card_qc'] ==
                                                            '') {
                                                          return const SizedBox
                                                              .shrink();
                                                        } else {
                                                          return const Text('');
                                                        }
                                                      })(),
                                                    ),
                                                    Center(
                                                      child:
                                                          item['status_desc'] !=
                                                                  null
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        72,
                                                                        145,
                                                                        144,
                                                                        144),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      // เพิ่ม Expanded เพื่อให้ข้อความสามารถขยายเต็มพื้นที่
                                                      child: Text(
                                                        '${item['po_date'] ?? ''} ${item['po_no'] ?? ''} ${item['item_stype_desc'] ?? ''}'
                                                        '\n${item['receive_date'] ?? ''} ${item['receive_no'] ?? ''} ${item['warehouse'] ?? ''}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                        softWrap:
                                                            true, // อนุญาตให้ข้อความตัดบรรทัด
                                                        overflow: TextOverflow
                                                            .visible, // ทำให้ข้อความสามารถมองเห็นได้
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return getCurrentData().length > 0
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
                                                    '${(currentPage * itemsPerPage) + 1} - ${data.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, data.length) : 0}',
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
                            ))),
            !isLoading && getCurrentData().length > 0
                ? getCurrentData().length <= 0
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
                                  '${(currentPage * itemsPerPage) + 1} - ${data.isNotEmpty ? ((currentPage + 1) * itemsPerPage).clamp(1, data.length) : 0}',
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
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
