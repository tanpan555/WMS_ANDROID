import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Ssfgdt09lForm extends StatefulWidget {
  final String pWareCode; // ware code ที่มาจากเลือ lov
  final String pAttr1;
  final String pDocNo;
  final String pDocType;
  Ssfgdt09lForm({
    Key? key,
    required this.pWareCode,
    required this.pAttr1,
    required this.pDocNo,
    required this.pDocType,
  }) : super(key: key);
  @override
  _Ssfgdt09lFormState createState() => _Ssfgdt09lFormState();
}

class _Ssfgdt09lFormState extends State<Ssfgdt09lForm> {
  //
  List<dynamic> dataForm = [];
  List<dynamic> dataLovDocType = [];
  List<dynamic> dataLovMoDoNo = [];
  String? selectLovDocType;
  String returnStatusLovDocType = '';
  String? selectLovMoDoNo;
  int returnStatusLovMoDoNo = 0;
  String selectedDate = '';
  String custName = '';
  String noteData = '';
  //'${item['schid']} ${item['fg_code']} ${item['cust_name']}')
  // final String sDateFormat = "dd-MM-yyyy";
  TextEditingController dateController = TextEditingController();
  TextEditingController custNameController = TextEditingController();
  TextEditingController noteDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // fetchData();
    lovDocType();
    lovMoDoNo();
  }

  @override
  void dispose() {
    dateController.dispose();
    custNameController.dispose();
    noteDataController.dispose();
    // pSoNoController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> lovDocType() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovDocTypeFormPage/${widget.pAttr1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataLovDocType =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovDocType : $dataLovDocType');
      } else {
        throw Exception('dataLovDocType Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('dataLovDocType ERROR IN Fetch Data : $e');
    }
  }

  Future<void> lovMoDoNo() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectLovMoDoNo'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');

        setState(() {
          dataLovMoDoNo =
              List<Map<String, dynamic>>.from(responseData['items'] ?? []);
        });
        print('dataLovMoDoNo : $dataLovMoDoNo');
      } else {
        throw Exception('dataLovMoDoNo Failed to load fetchData');
      }
    } catch (e) {
      setState(() {});
      print('dataLovMoDoNo ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectCust(int pMoDoNo) async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGDT09L/SSFGDT09L_Step_2_SelectCust/$pMoDoNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'];
        print(items);
        if (items.isNotEmpty) {
          final Map<String, dynamic> item = items[0];
          //

          //
          print('Fetched data: $jsonDecode');

          setState(() {
            custName = item['cust'] ?? '';

            custNameController.text = custName;
          });
        } else {
          print('No items found.');
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = new DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        dateController.text = formattedDate;
        selectedDate = dateController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'เบิกจ่าย'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    iconSize: 20.0,
                    icon: Image.asset(
                      'assets/images/right.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      // controller: docNoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'เลขที่ใบเบิก WMS',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovDocType
                          .map<String>((item) =>
                              '${item['doc_type']} ${item['doc_desc']}')
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ประเภทการจ่าย',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectLovDocType = value;

                          // Find the selected item
                          var selectedItem = dataLovDocType.firstWhere(
                            (item) =>
                                '${item['doc_type']} ${item['doc_desc']}' ==
                                value,
                            orElse: () => <String, dynamic>{}, // แก้ไข orElse
                          );
                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovDocType =
                                selectedItem['doc_type'] ?? '';
                          }
                        });
                        print(
                            'dataLovDocType in body: $dataLovDocType type: ${dataLovDocType.runtimeType}');
                        // print(selectedItem);
                        print(
                            'returnStatusLovDocType in body: $returnStatusLovDocType type: ${returnStatusLovDocType.runtimeType}');
                      },
                      selectedItem: selectLovDocType,
                    ),

                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'วันที่บันทึก',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(item),
                            selected: isSelected,
                          );
                        },
                        constraints: BoxConstraints(
                          maxHeight: 250,
                        ),
                      ),
                      items: dataLovMoDoNo
                          .map<String>((item) =>
                              '${item['schid']} ${item['fg_code']} ${item['cust_name']}')
                          .toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'เลขที่คำสั่งผลผลิต',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          // Find the selected item
                          var selectedItem = dataLovMoDoNo.firstWhere(
                            (item) =>
                                '${item['schid']} ${item['fg_code']} ${item['cust_name']}' ==
                                value,
                            orElse: () => <String, dynamic>{},
                          );

                          // Update variables based on selected item
                          if (selectedItem.isNotEmpty) {
                            returnStatusLovMoDoNo = selectedItem['schid'] ?? '';
                            selectLovMoDoNo = selectedItem['schid'].toString();
                            selectCust(returnStatusLovMoDoNo);
                          }
                        });
                        print(
                            'dataLovMoDoNo in body: $dataLovMoDoNo type: ${dataLovMoDoNo.runtimeType}');
                        print(
                            'returnStatusLovMoDoNo in body: $returnStatusLovMoDoNo type: ${returnStatusLovMoDoNo.runtimeType}');
                      },
                      selectedItem: selectLovMoDoNo,
                    ),
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: custNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'ลูกค้า',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: noteDataController,
                      // readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        labelText: 'หมายเหตุ',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onChanged: (value) => {
                        setState(() {
                          noteData = value;
                        }),
                      },
                    ),
                    const SizedBox(height: 20),
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  // void showDialogSearchLovDocType() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Search'),
  //           content: SingleChildScrollView(

  //           ),
  //         );
  //       });
}
