import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SSFGDT31_FROM extends StatefulWidget {
  @override
  _SSFGDT31_FROMState createState() => _SSFGDT31_FROMState();
}

class _SSFGDT31_FROMState extends State<SSFGDT31_FROM> {
  List<Map<String, dynamic>> fromItems = [];
  List<Map<String, dynamic>> docTypeItems = [];
  List<Map<String, dynamic>> modonoItems = [];
  String? selectedDocType;
  String? selectedMoDoNo;
  String? selectedValue;

  TextEditingController _docNoController = TextEditingController();
  TextEditingController _docDateController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _erpDocNoController = TextEditingController();
  TextEditingController _custController = TextEditingController();
  TextEditingController _searchController =
      TextEditingController(); // เพิ่ม Controller สำหรับการค้นหา

  @override
  void initState() {
    super.initState();
    fetchFromItems();
    fetchDocTypeItems();
    fetchModonoItems();
  }

  Future<void> fetchFromItems() async {
    final response = await http
        .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/from'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        fromItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (fromItems.isNotEmpty) {
          _docNoController.text = fromItems[0]['doc_no'] ?? 'No Data';
          _docDateController.text = fromItems[0]['doc_date'] ?? 'No Data';
          _refNoController.text = fromItems[0]['ref_no'] ?? 'No Data';
          _noteController.text = fromItems[0]['note'] ?? '';
          _erpDocNoController.text = fromItems[0]['erp_doc_no'] ?? 'No Data';
        }
      });
    } else {
      throw Exception('Failed to load from items');
    }
  }

  Future<void> fetchDocTypeItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT31/DOC_TYPE/p_ATTR1'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        docTypeItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (docTypeItems.isNotEmpty) {
          selectedDocType = docTypeItems[0]['doc_desc']; // Default selection
        }
      });
    } else {
      throw Exception('Failed to load DOC_TYPE items');
    }
  }

  Future<void> fetchModonoItems() async {
    final response = await http
        .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/mo_do_no'));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        modonoItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
      });
    } else {
      throw Exception('Failed to load MO_DO_NO items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับคืนจากการเบิกผลิต'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: fromItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // เลขที่ใบเบิก WMS* //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'เลขที่ใบเบิก WMS*',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _docNoController,
                    ),
                  ),

                  //ประเภทการจ่าย*//
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ประเภทการจ่าย*',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      items: docTypeItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item['doc_desc'],
                                child: Text(
                                  item['doc_desc'] ?? 'doc_desc = null',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedDocType = value;
                        });
                      },
                      onSaved: (value) {
                        selectedDocType = value;
                      },
                      value: selectedDocType, // Set the default selected value
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        maxHeight: 150,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  // วันที่บันทึก //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'วันที่บันทึก',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _docDateController,
                    ),
                  ),

                  // เลขที่เอกสารอ้างอิง //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'เลขที่เอกสารอ้างอิง',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _refNoController,
                    ),
                  ),

                  // เลขที่คำสั่งผลผลิต* //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    height:
                                        300, // ปรับความสูงของ Popup ตามต้องการ
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'เลขที่คำสั่งผลผลิต',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // ปิด Popup
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        // ช่องค้นหา
                                        TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: 'ค้นหา...',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (query) {
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: modonoItems
                                                .where((item) {
                                                  // แปลง schid เป็น int ก่อนการเปรียบเทียบ
                                                  final schidString =
                                                      item['schid'].toString();
                                                  final fgCode = item['fg_code']
                                                      .toString();
                                                  final custName =
                                                      item['cust_name']
                                                          .toString();
                                                  final searchQuery =
                                                      _searchController.text
                                                          .trim();

                                                  // ตรวจสอบว่า searchQuery เป็นจำนวนเต็มหรือไม่
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);

                                                  // แปลง schid เป็น int ถ้าค่ามันเป็นจำนวนเต็ม
                                                  final schidInt =
                                                      int.tryParse(schidString);

                                                  // เปรียบเทียบกับ searchQuery
                                                  return (searchQueryInt !=
                                                              null &&
                                                          schidInt != null &&
                                                          schidInt ==
                                                              searchQueryInt) ||
                                                      schidString.contains(
                                                          searchQuery) ||
                                                      fgCode.contains(
                                                          searchQuery) ||
                                                      custName.contains(
                                                          searchQuery);
                                                })
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              final filteredItems =
                                                  modonoItems.where((item) {
                                                final schidString =
                                                    item['schid'].toString();
                                                final fgCode =
                                                    item['fg_code'].toString();
                                                final custName =
                                                    item['cust_name']
                                                        .toString();
                                                final searchQuery =
                                                    _searchController.text
                                                        .trim();

                                                final searchQueryInt =
                                                    int.tryParse(searchQuery);
                                                final schidInt =
                                                    int.tryParse(schidString);

                                                return (searchQueryInt !=
                                                            null &&
                                                        schidInt != null &&
                                                        schidInt ==
                                                            searchQueryInt) ||
                                                    schidString.contains(
                                                        searchQuery) ||
                                                    fgCode.contains(
                                                        searchQuery)||
                                                    custName
                                                        .contains(searchQuery);
                                              }).toList();

                                              final item = filteredItems[index];
                                              final schid =
                                                  item['schid'].toString();
                                              final fgCode =
                                                  item['fg_code'].toString();
                                              final custName =
                                                  item['cust_name'].toString();
                                              // final displayValue =
                                              //     '$schid  $fgCode  $custName';

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '$schid\n',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '$fgCode  $custName',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    selectedMoDoNo = schid;
                                                    _custController.text =
                                                        '$fgCode  $custName';
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'เลขที่คำสั่งผลผลิต*',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.list,
                              color: Colors.black,
                            ),
                          ),
                          controller:
                              TextEditingController(text: selectedMoDoNo),
                        ),
                      ),
                    ),
                  ),

                  // ลูกค้า //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'ลูกค้า',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _custController,
                    ),
                  ),

                  // หมายเหตุ //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'หมายเหตุ',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _noteController,
                    ),
                  ),

                  // เลขที่เอกสาร ERP //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'เลขที่เอกสาร ERP',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _erpDocNoController,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
