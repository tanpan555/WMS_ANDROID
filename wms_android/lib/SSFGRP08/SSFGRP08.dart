import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wms_android/SSINDT01/SSINDT01_search.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:wms_android/bottombar.dart';
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;

class SSFGRP08_MAIN extends StatefulWidget {
  const SSFGRP08_MAIN({Key? key}) : super(key: key);

  @override
  _SSFGRP08_MAINState createState() => _SSFGRP08_MAINState();
}

class _SSFGRP08_MAINState extends State<SSFGRP08_MAIN> {
  // Controller for the text field
  final TextEditingController _F_eDateController = TextEditingController();
  String F_eDate = '';
  String SendF_eDate = '';
  final TextEditingController _Doc_NoController = TextEditingController();
  final TextEditingController _selectedController3 = TextEditingController();
  final TextEditingController _selectedController4 = TextEditingController();
  final TextEditingController _selectedController5 = TextEditingController();
  final TextEditingController _selectedController6 = TextEditingController();
  final TextEditingController _selectedController7 = TextEditingController();
  final TextEditingController _selectedController8 = TextEditingController();
  final TextEditingController _selectedController9 = TextEditingController();
  final TextEditingController _selectedController10 = TextEditingController();
  final TextEditingController _selectedController11 = TextEditingController();
  final TextEditingController _selectedController12 = TextEditingController();
  final TextEditingController _selectedController13 = TextEditingController();
  final TextEditingController _selectedController14 = TextEditingController();
  final TextEditingController _selectedController15 = TextEditingController();
  final TextEditingController _selectedController16 = TextEditingController();
  final TextEditingController _selectedController17 = TextEditingController();

  final DateFormat displayFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("MM/dd/yyyy");

  @override
  void initState() {
    super.initState();
    fetch_F_DATE();
    fetch_DOC_NO();
  }

  Widget _showDialog1() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: true,
          itemBuilder: (context, item, isSelected) {
            final itemData = prepareDatesItem.firstWhere(
              (element) => '${element['prepare_date']}' == item,
              orElse: () => {'prepare_date': ''},
            );

            return ListTile(
              title: Text(item),
              subtitle: Text(itemData['prepare_date'] ?? ''),
              selected: isSelected,
            );
          },
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'วันที่เตรียมการตรวจนับ',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        items: prepareDatesItem
            .map((item) => '${item['prepare_date']}'.toString())
            .toList(),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            labelText: "วันที่เตรียมการตรวจนับ",
            hintStyle: TextStyle(fontSize: 12.0),
          ),
        ),
        onChanged: (String? value) async {
          setState(() {
            selectedprepareDates = value;
            SendF_eDate = (selectedprepareDates ?? '').replaceAll('/', '-');

            if (value == '') {
              _F_eDateController.text = 'null';
            } else {
              final selectedItem = prepareDatesItem.firstWhere(
                (element) => '${element['prepare_date']}' == value,
                orElse: () => {'prepare_date': ''},
              );

              _F_eDateController.text = value ?? 'null';
            }
          });

          await fetch_DOC_NO();
        },
        selectedItem: selectedprepareDates ?? '',
      ),
    );
  }

  List<Map<String, dynamic>> prepareDatesItem = [];
  String? selectedprepareDates;
  Future<void> fetch_F_DATE() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_F_DATE/${gb.P_ERP_OU_CODE}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            prepareDatesItem = List<Map<String, dynamic>>.from(items);
            if (prepareDatesItem.isNotEmpty) {
              selectedprepareDates = prepareDatesItem[0]['prepare_date'];
            }
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

  List<Map<String, dynamic>> doc_noItem = [];
  String? selecteddoc_no;
  Future<void> fetch_DOC_NO() async {
    final url = Uri.parse(
        'http://172.16.0.82:8888/apex/wms/SSFGRP08/SSFGRP08_DOC_NO/${gb.P_ERP_OU_CODE}/$SendF_eDate');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = data['items'] ?? [];
        print(items);

        if (items.isNotEmpty) {
          setState(() {
            doc_noItem = List<Map<String, dynamic>>.from(items);
            if (doc_noItem.isNotEmpty) {
              selecteddoc_no = doc_noItem[0]['doc_no'];
            }
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

  Widget _showDialog2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: true,
          itemBuilder: (context, item, isSelected) {
            final itemData = doc_noItem.firstWhere(
              (element) => '${element['doc_no']}' == item,
              orElse: () => {'doc_no': ''},
            );

            return ListTile(
              title: Text(item),
              subtitle: Text(itemData['doc_no'] ?? ''),
              selected: isSelected,
            );
          },
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'วันที่เตรียมการตรวจนับ',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        items: doc_noItem
            .map((item) => '${item['prepare_date']}'.toString())
            .toList(),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            labelText: "วันที่เตรียมการตรวจนับ",
            hintStyle: TextStyle(fontSize: 12.0),
          ),
        ),
        onChanged: (String? value) async {
          setState(() {
            selecteddoc_no = value;

            if (value == '') {
              _F_eDateController.text = 'null';
            } else {
              final selectedItem = doc_noItem.firstWhere(
                (element) => '${element['doc_no']}' == value,
                orElse: () => {'doc_no': ''},
              );

              _Doc_NoController.text = value ?? 'null';
            }
          });

          await fetch_DOC_NO();
        },
        selectedItem: selecteddoc_no ?? '',
      ),
    );
  }

  void _showDialog3() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController3.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController3.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog4() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController4.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController4.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog5() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController5.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController5.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog6() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController6.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController6.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog7() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController7.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController7.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog8() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController8.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController8.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog9() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController9.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController9.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog10() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController10.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController10.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog11() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController11.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController11.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog12() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController12.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController12.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog13() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController13.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController13.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog14() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController14.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController14.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog15() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController15.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController15.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog16() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Seller'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Add your selection or any content here
                ListTile(
                  title: Text('Seller 1'),
                  onTap: () {
                    setState(() {
                      _selectedController16.text = 'Seller 1';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Seller 2'),
                  onTap: () {
                    setState(() {
                      _selectedController16.text = 'Seller 2';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17153B),
      appBar: CustomAppBar(title: 'รายงานเตรียมการตรวจนับ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(children: [
              _showDialog1(),
              SizedBox(
                height: 8,
              ),
              _showDialog2(),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog3,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController3,
                    decoration: InputDecoration(
                      labelText: '3st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog4,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController4,
                    decoration: InputDecoration(
                      labelText: '4st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog5,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController5,
                    decoration: InputDecoration(
                      labelText: '5st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog6,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController6,
                    decoration: InputDecoration(
                      labelText: '6st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog7,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController7,
                    decoration: InputDecoration(
                      labelText: '7st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog8,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController8,
                    decoration: InputDecoration(
                      labelText: '8st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog9,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController9,
                    decoration: InputDecoration(
                      labelText: '9st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog10,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController10,
                    decoration: InputDecoration(
                      labelText: '10st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog11,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController11,
                    decoration: InputDecoration(
                      labelText: '11st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog12,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController12,
                    decoration: InputDecoration(
                      labelText: '12st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog13,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController13,
                    decoration: InputDecoration(
                      labelText: '13st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog14,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController14,
                    decoration: InputDecoration(
                      labelText: '14st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog15,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController15,
                    decoration: InputDecoration(
                      labelText: '15st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _showDialog16,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _selectedController16,
                    decoration: InputDecoration(
                      labelText: '16st',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 113, 113, 113),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
