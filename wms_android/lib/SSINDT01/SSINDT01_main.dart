import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
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
    fixedValue = valueMapping[_selectedValue] ?? 'C';
    fetchApCodes();

   fetchwhCodes().then((_) {
  checkWareCodeSelection();
  setState(() {
    isLoading = false;
  });
}).catchError((error) {
  setState(() {
    errorMessage = error.toString();
    isLoading = false;
  });
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

  void checkWareCodeSelection() {
    if (selectedwhCode == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWareCodeDialog();
      });
    }
  }

  void showWareCodeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Warehouse Code'),
        content: Container(
           width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButton<String>(
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
                                Navigator.of(context).pop();
                                setState(() {
                                  selectedwhCode = value;
                                });
                              },
                            ),
        ),
      );
    },
  );
}



  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                  AlertDialog(
                    title: Text('ตัวเลือกการกรอง'),
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedValue,
                              hint: Text('ประเภทสินค้า'),
                              items: <String>[
                                'รายการรอรับดำเนินการ',
                                'รายการใบสั่งซื้อ',
                                'ทั้งหมด'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value;
                                  fixedValue =
                                      valueMapping[_selectedValue] ?? '';
                                });
                              },
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedApCode,
                              hint: Text('ผู้ขาย'),
                              items: apCodes.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['ap_code'],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['ap_code'] ?? 'No code',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        item['ap_name'] ?? 'No name',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
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
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            fetchWareCodes();
                          });
                        },
                        child: Text('ยืนยัน'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ยกเลิก'),
                      ),
                    ],
                  ),
                ],
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

int _currentPage = 1;
final int _itemsPerPage = 15;
bool _hasMoreData = true;

  Future<void> fetchWareCodes({int page = 1}) async {
  try {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/c/new_card_list/$fixedValue?page=$page&limit=$_itemsPerPage'));
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(responseBody);
      final newData = jsonData['items'] ?? [];
      setState(() {
        data.addAll(newData);
        displayedData = data;
        _hasMoreData = newData.length == _itemsPerPage;
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
Widget _buildLoadMoreButton() {
  return Visibility(
    visible: _hasMoreData,
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          _currentPage++;
          fetchWareCodes(page: _currentPage);
        });
      },
      child: Text('แสดงเพิ่มเติม'),
    ),
  );
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        color: const Color(0xFF5BF5BF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.check),
          title: Text(item['ap_name'] ?? 'No Name'),
          subtitle: Text(
            '${item['po_no'] ?? 'No PO_NO'}\n'
            'สถานะ: ${item['status_desc'] ?? 'No Status'}\n'
            'Receive Date: ${item['receive_date'] ?? 'No Receive Date'}\n'
            'Item: ${item['item_stype_desc'] ?? 'No item'}\n'
            'receive no: ${item['receive_no'] ?? 'No item'}\n'
            'Warehouse: ${item['warehouse'] ?? 'No item'}\n',
          ),
          onTap: () => handleTap(context, item),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////
@override
Widget build(BuildContext context) {
  List<Widget> listItems = displayedData.map((item) {
    return buildListTile(context, item);
  }).toList();

  if (_hasMoreData) {
    listItems.add(_buildLoadMoreButton());
  }

  return Scaffold(
    appBar: const CustomAppBar(),
    drawer: const CustomDrawer(),
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
                        if (isPortrait) // Show search box only in portrait mode
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
                                      TextButton(
                                        onPressed: _showFilterDialog,
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black54,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: const Text('ค้นหา'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            children: listItems,
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
