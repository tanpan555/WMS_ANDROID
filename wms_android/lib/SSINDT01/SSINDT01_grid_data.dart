import 'package:flutter/material.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Ssindt01GridData extends StatefulWidget {
  final Map<String, dynamic> datas;

  const Ssindt01GridData({super.key, required this.datas});

  @override
  _Ssindt01GridDataState createState() => _Ssindt01GridDataState();
}

class _Ssindt01GridDataState extends State<Ssindt01GridData> {
  late String P_ERP_OU_CODE;
  late String P_PREV_REC_NO;
  String? itemDescription;
  String? code_Row;

  @override
  void initState() {
    super.initState();
    // รับค่า datas จาก widget
    P_ERP_OU_CODE = widget.datas['receiveNo'] ?? '';
    P_PREV_REC_NO = widget.datas['receiveNo2'] ?? '';
    // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูล
    _fetchData();
  }

  List<DataRow> _dataRows = [];

  Future<void> _fetchData() async {
    // URL ของ API ที่ต้องการเรียก
    final String apiUrl =
        'http://172.16.0.82:8888/apex/wms/c/get_data_grid/$P_ERP_OU_CODE/$P_PREV_REC_NO';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Received data: $data, type: ${data.runtimeType}');

        if (data is Map && data.containsKey('items')) {
          final List<dynamic> items = data['items'];
          print('Items data: $items, type: ${items.runtimeType}');

          if (items is List && items.isNotEmpty) {
            // สมมติว่า itemDescription มาจาก item แรกในรายการ
            itemDescription = items[0]['item_desc'] ?? 'ไม่มีข้อมูล';
            code_Row = items[0]['rowid'] ?? 'rowID : มันไม่มา!!!'; // ดึงค่า rowid จากรายการแรก
            List<DataRow> fetchedRows = items.map<DataRow>((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(item['item'] ?? ''),
                    onTap: () => _updateItemDescription(item), // เพิ่ม onTap เพื่อเรียกฟังก์ชัน _updateItemDescription
                  ),
                  DataCell(Text(item['receive_qty'] ?? '')),
                  DataCell(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 255, 0, 0), // กำหนดสีพื้นหลังเป็นสีแดง
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => LotDetail()),
                        // );
                      },
                      child: const Text(
                        'Lot',
                        style: TextStyle(
                          color: Colors.white, // กำหนดสีข้อความเป็นสีขาว
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(item['pending_qty'] ?? '')),
                  DataCell(Text(item['locator_det'] ?? '')),
                  DataCell(Text(item['lot_total'] ?? '')),
                  DataCell(Text(item['uom'] ?? '')),
                  // Add more cells as needed
                ],
              );
            }).toList();

            setState(() {
              _dataRows = fetchedRows;
            });
          } else {
            print('Items is not a List or is empty');
          }
        } else {
          print('Data is not a Map with key "items"');
        }
      } else {
        print('Failed to load data');
        setState(() {
          _dataRows = [];
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _dataRows = [];
      });
    }
  }

  void _updateItemDescription(Map<String, dynamic> item) {
    setState(() {
      itemDescription = item['item_desc'] ?? 'ไม่มีข้อมูล';
      code_Row = item['rowid'] ?? 'rowID : มันไม่มา!!!'; // อัพเดต code_Row ด้วย
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 69, 53, 193),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 69, 53, 193),
                      ),
                      onPressed: () {
                        _fetchData(); // กดปุ่มดึง PO และอัพเดต DataTable
                      },
                      child: const Text(
                        'ดึงPO',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 69, 53, 193),
                      ),
                      onPressed: () {
                        // กดปุ่มลบ PO
                      },
                      child: const Text(
                        'ลบPO',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 69, 53, 193),
                      ),
                      onPressed: () {
                        // กดปุ่มเพิ่ม Tag
                      },
                      child: const Text(
                        'เพิ่มTag',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 69, 53, 193),
                      ),
                      onPressed: () {
                        // กดปุ่มถัดไป
                      },
                      child: const Text(
                        'ถัดไป',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  '${widget.datas['receiveNo']}',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'เลขที่เอกสาร WMS*',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${widget.datas['receiveNo2']}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 216, 216),
              ),
              margin: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('จำนวนรับ')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('ค้างรับ')),
                    DataColumn(label: Text('Locator')),
                    DataColumn(label: Text('จำนวนรวม')),
                    DataColumn(label: Text('UOM')),
                    // Add more columns as needed
                  ],
                  rows: _dataRows, // ใช้ข้อมูลจากตัวแปร _dataRows
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Item Desc*',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      itemDescription ?? '', // แสดงข้อมูลที่ดึงมาจาก API
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 207, 206, 206),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text('${_dataRows.length}  :   X'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
