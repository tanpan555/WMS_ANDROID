import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
// import 'package:wms_android/custom_drawer.dart';
import 'SSINDT01_form.dart';

class SSINDT01_MAIN extends StatefulWidget {
  // const Ssindt01Card({super.key});
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

  List<dynamic> apCodes = [];
  String? selectedApCode;

  List<dynamic> whCodes = [];
  String? selectedwhCode;

  String? _selectedValue;
  String? fixedValue;

  // final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // fixedValue = valueMapping[_selectedValue] ?? 'C';

    fetchApCodes().then((_) {
      return fetchwhCodes();
    }).then((_) {
      if (selectedwhCode == null) {
        _showSelectWareCodeDialog();
      }
    }).catchError((e) {
      print('Error during fetch operations: $e');
    });

    print(
        'searchController: $searchController  type: ${searchController.runtimeType}');
    print(
        '_scrollController: $_scrollController  type: ${_scrollController.runtimeType}');
    print(
        'selectedwhCode: $selectedwhCode  type: ${selectedwhCode.runtimeType}');
    print('whCodes: $whCodes  type: ${whCodes.runtimeType}');
    print(
        'selectedApCode: $selectedApCode  type: ${selectedApCode.runtimeType}');
    print('apCodes: $apCodes  type: ${apCodes.runtimeType}');
    print('searchQuery: $searchQuery  type: ${searchQuery.runtimeType}');
    print('errorMessage: $errorMessage  type: ${errorMessage.runtimeType}');
    print('isLoading: $isLoading  type: ${isLoading.runtimeType}');
    print('displayedData: $displayedData  type: ${displayedData.runtimeType}');
    print('data: $data  type: ${data.runtimeType}');
    print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
    print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
    print('poStep : $poStep Type : ${poStep.runtimeType}');
  }

  void _handleSelected(String? value) {
    setState(() {
      _selectedValue = value;
      print('Selected value in handle: $_selectedValue');
    });
  }

  final Map<String, String> valueMapping = {
    'รายการรอรับดำเนินการ': 'A',
    'รายการใบสั่งซื้อ': 'B',
    'ทั้งหมด': 'C',
  };

  Future<void> fetchApCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/c/AP_CODE'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          apCodes = jsonData['items'] ?? [];
          apCodes.insert(0, {'ap_code': 'ทั้งหมด', 'ap_name': 'ทั้งหมด'});
          selectedApCode = 'ทั้งหมด';
          fetchWareCodes();
        });
      } else {
        throw Exception('Failed to load AP codes');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print(
            'errorMessage : $errorMessage Type : ${errorMessage.runtimeType}');
      });
    }
  }

  Future<void> fetchwhCodes() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.16.0.82:8888/apex/wms/WH/WHCode'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);

        print('Fetched data: $jsonData');

        setState(() {
          whCodes = jsonData['items'];
          if (data.isNotEmpty) {
            selectedwhCode = whCodes[0]['ware_code'];
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ตัวเลือกการกรอง',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedwhCode,
                        hint: Text('เลือกคลังปฏิบัติการ'),
                        items: whCodes.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['ware_code'],
                            child: Text(item['ware_code'] ?? 'No code'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedwhCode = value;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedValue,
                        hint: Text(
                          'ประเภทสินค้า',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        items: <String>[
                          'รายการรอรับดำเนินการ',
                          'รายการใบสั่งซื้อ',
                          'ทั้งหมด',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                            fixedValue = valueMapping[_selectedValue] ?? '';
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedApCode,
                        hint: Text('ผู้ขาย'),
                        items: apCodes.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['ap_code'],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['ap_code'] ?? 'No code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  item['ap_name'] ?? 'No name',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 8),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedApCode = value;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'ค้นหา',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                fetchWareCodes();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              'ยืนยัน',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              'ยกเลิก',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void performSearch() {
    filterData();
  }

  int _displayLimit = 15;

  void _loadMoreItems() {
    setState(() {
      _displayLimit += 15;
    });
  }

  Future<void> fetchWareCodes() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/c/new_card_list/$fixedValue'));
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseBody);
        setState(() {
          data = jsonData['items'] ?? [];
          filterData();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void filterData() {
    setState(() {
      displayedData = data.where((item) {
        final poNo = item['po_no']?.toString().toLowerCase() ?? '';
        final matchesSearchQuery = poNo.contains(searchQuery.toLowerCase());
        final matchesApCode =
            selectedApCode == 'ทั้งหมด' || item['ap_code'] == selectedApCode;
        return matchesSearchQuery && matchesApCode;
      }).toList();
      print(
          'displayedData : $displayedData Type : ${displayedData.runtimeType}');
    });
  }

  String? poStatus;
  String? poMessage;
  String? poStep;

  Future<void> fetchPoStatus(String poNo, String? receiveNo) async {
    final String receiveNoParam = receiveNo ?? 'null';
    final String apiUrl =
        'http://172.16.0.82:8888/apex/wms/c/check_rcv/$poNo/$receiveNoParam';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          poStatus = responseBody['po_status'];
          poMessage = responseBody['po_message'];
          poStep = responseBody['po_goto_step'];

          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
          print('poStep : $poStep Type : ${poStep.runtimeType}');
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();

        print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
        print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
      });
    }
  }

  String? poReceiveNo;

  Future<void> sendPostRequest(
      String poNo, String receiveNo, String selectedwhCode) async {
    final url = 'http://172.16.0.82:8888/apex/wms/c/create_inhead_wms';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'p_po_no': poNo,
      'p_receive_no': receiveNo,
      'p_wh_code': selectedwhCode,
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
        setState(() {
          poReceiveNo = responseData['po_receive_no'];
          poStatus = responseData['po_status'];
          poMessage = responseData['po_message'];

          print('poReceiveNo : $poReceiveNo Type : ${poReceiveNo.runtimeType}');
          print('poStatus : $poStatus Type : ${poStatus.runtimeType}');
          print('poMessage : $poMessage Type : ${poMessage.runtimeType}');
        });
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showSelectWareCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Warehouse'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: selectedwhCode,
            hint: Text('เลือกคลังปฏิบัติการ'),
            items: whCodes.map((item) {
              return DropdownMenuItem<String>(
                value: item['ware_code'],
                child: Text(item['ware_code'] ?? 'No code'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedwhCode = value;
                Navigator.of(context).pop();
                _showFilterDialog();
              });
            },
          ),
        );
      },
    );
  }

  void handleTap(BuildContext context, Map<String, dynamic> item) async {
    if (selectedwhCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a warehouse.'),
        ),
      );
      return;
    }
    final pPoNo = item['po_no'] ?? '';
    final vReceiveNo = item['receive_no'] ?? 'null';
    await fetchPoStatus(pPoNo, vReceiveNo);

    if (poStatus == '0') {
      await sendPostRequest(pPoNo, vReceiveNo, selectedwhCode ?? '');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Ssindt01Form(poReceiveNo: poReceiveNo ?? ''),
        ),
      );
    } else if (poStatus == '1' && poStep == '9') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PO Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${poStatus ?? 'No status available'}'),
                SizedBox(height: 8.0),
                Text('Message: ${poMessage ?? 'No message available'}'),
                SizedBox(height: 8.0),
                Text('Step: ${poStep ?? 'No message available'}'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (poStatus == '1' && poStep == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('PO Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${poStatus ?? 'No status available'}'),
                SizedBox(height: 8.0),
                Text('Message: ${poMessage ?? 'No message available'}'),
                Text('Step: ${poStep ?? 'No message available'}'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildListTile(BuildContext context, Map<String, dynamic> item) {
    // Define a map for status values to colors
    Map<String, Color> statusColors = {
      'ตรวจรับบางส่วน': Colors.orange,
      'บันทึก': Colors.blue,
      'รอยืนยัน': Colors.yellow,
      'ปกติ': Colors.grey,
      'อนุมัติ': Colors.green,
    };

    Color statusColor = statusColors[item['status_desc']] ?? Colors.grey;

    TextStyle statusStyle = TextStyle(
      color: statusColor,
      fontWeight: FontWeight.bold,
    );

    BoxDecoration statusDecoration = BoxDecoration(
      border: Border.all(color: statusColor, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
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
      cardQcWidget = SizedBox.shrink(); // No widget displayed
    } else {
      cardQcWidget = Text('');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        color: const Color(0xFF5BF5BF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: ListTile(
          title: Text(item['ap_name'] ?? 'No Name'),
          subtitle: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${item['receive_date'] ?? 'No Receive Date'} ${item['po_no'] ?? 'No PO_NO'} ${item['item_stype_desc'] ?? 'No item'}\n',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: '\n',
                        style: DefaultTextStyle.of(context).style,
                      ),
                      WidgetSpan(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: statusDecoration,
                          child: Text(
                            '${item['status_desc'] ?? 'No Status'}',
                            style: statusStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              cardQcWidget,
            ],
          ),
          onTap: () => handleTap(context, item),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รับจากการสั่งซื้อ'),
      // drawer: const CustomDrawer(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text('Error: $errorMessage'))
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          if (isPortrait)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    color: Colors.deepPurple,
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'รับจากการสั่งซื้อ',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _showFilterDialog,
                                          child: Image.asset(
                                            'assets/images/search_color.png',
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: displayedData.isEmpty
                                ? Center(child: Text('No data available'))
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount:
                                        (_displayLimit < displayedData.length)
                                            ? _displayLimit + 1
                                            : displayedData.length,
                                    itemBuilder: (context, index) {
                                      if (index == _displayLimit) {
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: _loadMoreItems,
                                            child: Text('แสดงเพิ่มเติม'),
                                          ),
                                        );
                                      }
                                      if (index < displayedData.length) {
                                        final item = displayedData[index];
                                        return buildListTile(context, item);
                                      }
                                      return Container();
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
