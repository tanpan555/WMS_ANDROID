import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wms_android/ICON.dart';
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
  String searchQuery = '';

  String? ATTR = gb.Raw_Material;

  List<dynamic> apCodes = [];
  String? selectedApCode;

  List<dynamic> whCodes = [];
  String? selectedwhCode;

  String? _selectedValue;
  String? fixedValue;

  String? nextLink;
  String? prevLink;
  int showRecordRRR = 0;

  int pageSize = 15; // Number of records per page
  int currentPage = 1; // Current page number
  int totalRecords = 0; // Total number of records

  @override
  void initState() {
    super.initState();

    // Initialize values
    _selectedValue = 'ทั้งหมด';
    selectedwhCode = widget.pWareCode;
    selectedApCode = widget.apCode;
    // Use a variable to hold the documentNumber with default value
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

    // fetchWareCodes();

    print('Document Number (with default if null): $documentNumber');
  }

  final Map<String, String> valueMapping = {
    'รายการรอรับดำเนินการ': 'A',
    'รายการใบสั่งซื้อ': 'B',
    'ทั้งหมด': 'C',
  };

  Future<void> fetchWareCodes([String? url]) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // Reset currentPage if this is a new search (no url provided)
    if (url == null) {
      currentPage = 1;
    }

    final String requestUrl = url ??
        '${gb.IP_API}/apex/wms/SSINDT01/Step_1_Card_list/$selectedApCode/$ATTR/${widget.documentNumber}/$fixedValue/${gb.BROWSER_LANGUAGE}';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        print(requestUrl);
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = json.decode(responseBody);
        if (mounted) {
          setState(() {
            if (parsedResponse is Map && parsedResponse.containsKey('items')) {
              data = parsedResponse['items'];
              totalRecords = parsedResponse['total_count'] ??
                  (currentPage * pageSize + data.length);
            } else {
              data = [];
              totalRecords = 0;
            }

            List<dynamic> links = parsedResponse['links'] ?? [];
            nextLink = getLink(links, 'next');
            prevLink = getLink(links, 'prev');
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load data: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
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

  void _loadNextPage() {
    if (nextLink != null) {
      if (mounted) {
        setState(() {
          currentPage++;
          // isLoading = true;
        });
      }
      fetchWareCodes(nextLink);
    }
  }

  void _loadPrevPage() {
    if (prevLink != null) {
      if (mounted) {
        setState(() {
          currentPage--;
          // isLoading = true;
        });
      }
      fetchWareCodes(prevLink);
    }
  }

  String _getPageIndicatorText() {
    final startRecord = ((currentPage - 1) * pageSize) + 1;
    final endRecord = startRecord +
        data.length -
        1; // Use actual data length instead of page size
    return '$startRecord - $endRecord';
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
    final String receiveNoParam = receiveNo ?? 'null';
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
    final url =
        '${gb.IP_API}/apex/wms/SSINDT01/Step_1_create_inhead_wms';

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

  bool isNavigating = false; // Flag to track navigation

void handleTap(BuildContext context, Map<String, dynamic> item) async {
  // Prevent double-tapping
  if (isNavigating) return; // If already navigating, do nothing.
  
  isNavigating = true; // Set flag to true when navigation starts
  
  if (selectedwhCode == null) {
    AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.notification_important,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text('แจ้งเตือน'),
        ],
      ),
      content: Text('โปรดเลือกคลังสินค้า'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    isNavigating = false; // Reset flag when the alert is shown
    return;
  }

  final pPoNo = item['po_no'] ?? '';
  final vReceiveNo = item['receive_no'] ?? 'null';

  await fetchPoStatus(pPoNo, vReceiveNo);
  await fetchPoStatusconform(vReceiveNo);

  if (poStatus == '0' && poStep == '2') {
    // Navigate to Form page
    await sendPostRequest(pPoNo, vReceiveNo, selectedwhCode ?? '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Ssindt01Form(
          poReceiveNo: poReceiveNo ?? '',
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          p_ou_code: widget.p_ou_code,
        ),
      ),
    );
  } else if (poStatus == '0' && poStep == '4') {
    // Navigate to Grid page
    await sendPostRequest(pPoNo, vReceiveNo, selectedwhCode ?? '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Ssindt01Grid(
          poReceiveNo: poReceiveNo ?? '',
          poPONO: pPoNo,
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          p_ou_code: widget.p_ou_code,
        ),
      ),
    );
  } else if (poStatus == '0') {
    // Original flow - Navigate to Form page
    await sendPostRequest(pPoNo, vReceiveNo, selectedwhCode ?? '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Ssindt01Form(
          poReceiveNo: poReceiveNo ?? '',
          pWareCode: widget.pWareCode,
          pWareName: widget.pWareName,
          p_ou_code: widget.p_ou_code,
        ),
      ),
    );
  } else if (poStatus == '1' && poStep == '9') {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text('${poMessage ?? 'No message available'}'),
          onClose: () {
            Navigator.of(context).pop();
          },
          onConfirm: () async {
            Navigator.of(context).pop();
            if (poStatusconform == '1') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogStyles.alertMessageDialog(
                    context: context,
                    content: Text('${poMessageconform ?? 'No message available'}'),
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      await fetchPoStatusconform(vReceiveNo);
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  } else if (poStatus == '1' && poStep == '') {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogStyles.alertMessageDialog(
          context: context,
          content: Text('${poMessageconform ?? 'No message available'}'),
          onClose: () {
            Navigator.of(context).pop();
          },
          onConfirm: () async {
            await fetchPoStatusconform(vReceiveNo);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  isNavigating = false; // Reset the flag when navigation is complete
}

Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
  // Define a map for status values to background colors
  Map<String, Color> statusColors = {
    'ตรวจรับบางส่วน': const Color.fromARGB(255, 17, 109, 110),
    'บันทึก': const Color.fromARGB(255, 118, 113, 113),
    'รอยืนยัน': const Color.fromARGB(255, 246, 250, 112),
    'ปกติ': const Color.fromARGB(255, 186, 186, 186),
    'อนุมัติ': const Color.fromARGB(255, 146, 208, 80),
  };

  Color statusColor = statusColors[item['status_desc']] ?? Colors.white;

  TextStyle statusStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  BoxDecoration statusDecoration = BoxDecoration(
    color: statusColor, // Set background color from statusColors
    borderRadius: BorderRadius.circular(12.0),
  );

  // Determine the content for card_qc
  Widget cardQcWidget;
  if (item['card_qc'] == '#APP_IMAGES#rt_machine_on.png') {
    cardQcWidget = Image.asset(
      'assets/images/rt_machine_on.png',
      width: 64.0,
      height: 64.0,
    );
  } else if (item['card_qc'] == '#APP_IMAGES#rt_machine_off.png') {
    cardQcWidget = Image.asset(
      'assets/images/rt_machine_off.png',
      width: 64.0,
      height: 64.0,
    );
  } else if (item['card_qc'] == 'No item') {
    cardQcWidget = SizedBox.shrink();
  } else {
    cardQcWidget = Text('');
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Card(
      color: const Color.fromRGBO(204, 235, 252, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(item['ap_name'] ?? 'No Name'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: const Color.fromARGB(255, 0, 0, 0)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: statusDecoration,
                      child: Text(
                        '${item['status_desc'] ?? 'No Status'}',
                        style: statusStyle,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    cardQcWidget,
                  ],
                ),
                Text(
                  '${item['po_date'] ?? ''} ${item['po_no'] ?? ''} \n${item['item_stype_desc'] ?? '\n'}'
                  '${item['receive_date'] ?? ''} ${item['receive_no'] ?? ''} ${item['warehouse'] ?? ''}',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                SizedBox(height: 8.0),
              ],
            ),
            contentPadding: EdgeInsets.all(16.0),
            onTap: () => handleTap(context, item),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ', showExitWarning: false),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (isPortrait) const SizedBox(height: 4),
                Expanded(
                  child: isLoading
                      ? Center(child: LoadingIndicator())
                          : data.isEmpty
                              ? const Center(child: CenteredMessage())
                              : ListView(
                                  children: [
                                    // Build the list items
                                    ...data
                                        .map((item) =>
                                            buildListTile(context, item))
                                        .toList(),
                                    // Add spacing
                                    const SizedBox(height: 10),
                                    // Navigation controls
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Previous Button
                                        prevLink != null
                                            ? ElevatedButton.icon(
                                                onPressed: _loadPrevPage,
                                                icon: const Icon(
                                                  MyIcons
                                                      .arrow_back_ios_rounded,
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
                                                style: AppStyles
                                                    .PreviousButtonStyle(),
                                              )
                                            : ElevatedButton.icon(
                                                onPressed: null,
                                                icon: const Icon(
                                                  MyIcons
                                                      .arrow_back_ios_rounded,
                                                  color: Color.fromARGB(
                                                      255, 23, 21, 59),
                                                  size: 20.0,
                                                ),
                                                label: const Text(
                                                  'Previous',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 23, 21, 59),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                style: AppStyles
                                                    .DisablePreviousButtonStyle(),
                                              ),
                                        // Page Indicator
                                        Text(
                                          _getPageIndicatorText(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Next Button
                                        nextLink != null
                                            ? ElevatedButton(
                                                onPressed: _loadNextPage,
                                                style: AppStyles
                                                    .NextRecordDataButtonStyle(),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Next',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(width: 7),
                                                    Icon(
                                                      MyIcons
                                                          .arrow_forward_ios_rounded,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Next',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 23, 21, 59),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    SizedBox(width: 7),
                                                    Icon(
                                                      MyIcons
                                                          .arrow_forward_ios_rounded,
                                                      color: Color.fromARGB(
                                                          255, 23, 21, 59),
                                                      size: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(currentPage: 'not_show'),
    );
  }
}
