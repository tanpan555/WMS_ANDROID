import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../custom_appbar.dart';
import '../bottombar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGDT04_FORM extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  // final String pAttr1;
  final String po_doc_no;
  final String? po_doc_type;
  SSFGDT04_FORM({
    Key? key,
    required this.pWareCode,
    // required this.pAttr1,
    required this.po_doc_no,
    required this.po_doc_type,
  }) : super(key: key);
  // SSFGDT04_FORM({required this.po_doc_no, this.po_doc_type});
  @override
  _SSFGDT04_FORMState createState() => _SSFGDT04_FORMState();
}

class _SSFGDT04_FORMState extends State<SSFGDT04_FORM> {
  List<Map<String, dynamic>> fromItems = [];
  List<Map<String, dynamic>> docTypeItems = [];
  List<Map<String, dynamic>> modonoItems = [];
  String? selectedDocType;
  String? selectedMoDoNo;
  // String? selectedValue;

  TextEditingController _docNoController = TextEditingController();
  TextEditingController _docDateController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  TextEditingController _refReceiveController =
      TextEditingController(); // REF_RECEIVE
  TextEditingController _oderNoController = TextEditingController(); // order_no
  TextEditingController _moDoNoController = TextEditingController(); // mo_do_no
  // staff_code
  TextEditingController _noteController = TextEditingController();
  TextEditingController _erpDocNoController = TextEditingController();
  TextEditingController _custController = TextEditingController();
  TextEditingController _searchController =
      TextEditingController(); // เพิ่ม Controller สำหรับการค้นหา

  // เพิ่ม DateFormat สำหรับฟอร์แมทวันที่
  // final TextEditingController _docDateController = TextEditingController();
  final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    _docDateController.text = _dateTimeFormatter.format(DateTime.now());
    super.initState();
    fetchFromItems();
    fetchDocTypeItems();
    // fetchModonoItems();
  }

  Future<void> fetchFromItems() async {
    print('get form');
    print('po_doc_no : ${widget.po_doc_no} : ${widget.po_doc_no.runtimeType}');
    print(
        'po_doc_type : ${widget.po_doc_type} Type : ${widget.po_doc_type.runtimeType}');
    final response = await http
        //http://172.16.0.82:8888/apex/wms/SSFGDT04/form/:P_OU_CODE/:P_DOC_NO/:P_DOC_TYPE
        .get(Uri.parse(
            'http://172.16.0.82:8888/apex/wms/SSFGDT04/form/${gb.P_ERP_OU_CODE}/${widget.po_doc_no}/${widget.po_doc_type}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(responseBody);
      setState(() {
        fromItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
        if (fromItems.isNotEmpty) {
          // _docNoController.text = widget.po_doc_no;
          _docNoController.text = fromItems[0]['doc_no'] ?? '';
          _docDateController.text = fromItems[0]['cr_date'] ?? '';
          _refNoController.text = fromItems[0]['ref_no'] ?? ''; // REF_RECEIVE
          _oderNoController.text = fromItems[0]['order_no'] ?? ''; // order_no
          _moDoNoController.text = fromItems[0]['mo_do_no'] ?? ''; // mo_do_no
          // staff_code
          _noteController.text = fromItems[0]['note'] ?? '';
          _erpDocNoController.text = fromItems[0]['erp_doc_no'] ?? '';
        }
      });
    } else {
      throw Exception('Failed to load from items');
    }
  }

  Future<void> fetchDocTypeItems() async {
    final response = await http.get(Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGDT04/TYPE/${gb.ATTR1}'));

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

  // Future<void> fetchModonoItems() async {
  //   final response = await http
  //       .get(Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGDT31/mo_do_no'));

  //   if (response.statusCode == 200) {
  //     final responseBody = utf8.decode(response.bodyBytes);
  //     final data = jsonDecode(responseBody);
  //     setState(() {
  //       modonoItems = List<Map<String, dynamic>>.from(data['items'] ?? []);
  //     });
  //   } else {
  //     throw Exception('Failed to load MO_DO_NO items');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'รับตรง (ไม่อ้าง PO'),
      backgroundColor: const Color.fromARGB(255, 17, 0, 56),
      body: fromItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //ปุ่ม ถัดไป//
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Next" button press here
                        // For example, you might want to validate the form and navigate to another screen
                      },
                      child: Image.asset(
                        'assets/images/right.png', // เปลี่ยนเป็นเส้นทางของรูปภาพของคุณ
                        width: 20, // ปรับขนาดตามที่ต้องการ
                        height: 20, // ปรับขนาดตามที่ต้องการ
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize:
                            const Size(50, 40), // ปรับขนาดตามที่ต้องการ
                        padding:
                            const EdgeInsets.all(0), // ปรับให้ไม่มี padding
                      ),
                    ),
                  ),

                  // เลขที่ใบเบิก WMS* //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'เลขที่เอกสาร WMS*',
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
                        labelText: 'ประเภทการรับ*',
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
                      controller: _docDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'วันที่บันทึก',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        // เลือกวันที่
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          // Format pickedDate as dd/MM/yyyy
                          setState(() {
                            _docDateController.text =
                                _dateTimeFormatter.format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),

                  // อ้างอิงใบนำส่งเลขที่ //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'อ้างอิงใบนำส่งเลขที่',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _refNoController,
                    ),
                  ),
                  // อ้างอิง SO //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'อ้างอิง SO',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _oderNoController,
                    ),
                  ),

                  // เลขที่คำสั่งผลผลิต* //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'เลขที่คำสั่งผลผลิต*',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      controller: _moDoNoController,
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
                                                        searchQuery) ||
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
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    selectedMoDoNo = schid;
                                                    _custController.text =
                                                        '$fgCode  $custName';
                                                    // fetchModonoItems();
                                                  });
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
                        labelText: 'ผู้รับมอบสินค้า*',
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
