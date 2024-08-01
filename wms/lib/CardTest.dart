import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms/form.dart';

class CardTest extends StatefulWidget {
  @override
  _CardTestState createState() => _CardTestState();
}

class _CardTestState extends State<CardTest> {
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

  @override
  void initState() {
    super.initState();
    fetchApCodes();
    fetchwhCodes();
  }

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

  Future<void> fetchWareCodes() async {
    try {
      final apCodeParam = selectedApCode != null && selectedApCode != 'ทั้งหมด'
          ? '?ap_code=$selectedApCode'
          : '';
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/c/list$apCodeParam'));

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
        });
      } else {
        throw Exception('Failed to load PO status');
      }
    } catch (e) {
      setState(() {
        poStatus = 'Error';
        poMessage = e.toString();
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
        });
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse Codes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedwhCode,
                        hint: Text('select warehouse'),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  item['ap_name'] ?? 'No name',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedApCode = value;
                            fetchWareCodes();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'เลขที่เอกสาร',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = '';
                                filterData();
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            filterData();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Items: ${displayedData.length}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: displayedData.isEmpty
                          ? Center(child: Text('No data available'))
                          : ListView.builder(
                              itemCount: displayedData.length,
                              itemBuilder: (context, index) {
                                final item = displayedData[index];
                                IconData icon = Icons.check;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Card(
                                    color:
                                        const Color.fromARGB(255, 77, 219, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Icon(icon),
                                        title:
                                            Text(item['ap_name'] ?? 'No Name'),
                                        subtitle: Text(
                                            '${item['po_no'] ?? 'No PO_NO'}\n'
                                            'สถานะ: ${item['status_desc'] ?? 'No Status'}\n'
                                            'Receive Date: ${item['receive_date'] ?? 'No Receive Date'}\n'
                                            'Item: ${item['item_stype_desc'] ?? 'No item'}\n'
                                            'receive no: ${item['receive_no'] ?? 'No item'}\n'
                                            'Warehouse: ${item['warehouse'] ?? 'No item'}\n'),
                                        onTap: () async {
                                          final pPoNo = item['po_no'] ?? '';
                                          final vReceiveNo =
                                              item['receive_no'] ?? 'null';
                                          await fetchPoStatus(
                                              pPoNo, vReceiveNo);

                                          if (poStatus == '0') {
                                            await sendPostRequest(
                                                pPoNo,
                                                vReceiveNo,
                                                selectedwhCode ?? '');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('PO Status'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Status: ${poStatus ?? 'No status available'}'),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                          'Message: ${poMessage ?? 'No message available'}'),
                                                      Text(
                                                          'Step: ${poStep ?? 'No message available'}'),
                                                      Text(
                                                          'po_receive_no: ${poReceiveNo ?? 'No message available'}'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                form(
                                                                    poReceiveNo:
                                                                        poReceiveNo ??
                                                                            ''),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          if (poStatus == '1' &&
                                              poStep == '9') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('PO Status'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Status: ${poStatus ?? 'No status available'}'),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                          'Message: ${poMessage ?? 'No message available'}'),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                          'Step: ${poStep ?? 'No message available'}'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (poStatus == '1' &&
                                              poStep == '') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('PO Status'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Status: ${poStatus ?? 'No status available'}'),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                          'Message: ${poMessage ?? 'No message available'}'),
                                                      Text(
                                                          'Step: ${poStep ?? 'No message available'}'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
