import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wms_android/styles.dart';
import 'package:wms_android/Global_Parameter.dart' as gb;
import 'package:wms_android/custom_appbar.dart';
import 'package:wms_android/bottombar.dart';

class SSFGPC04_BTN_PROCESS extends StatefulWidget {
  SSFGPC04_BTN_PROCESS({
    Key? key,
  }) : super(key: key);
  @override
  _SSFGPC04_BTN_PROCESSState createState() => _SSFGPC04_BTN_PROCESSState();
}

class _SSFGPC04_BTN_PROCESSState extends State<SSFGPC04_BTN_PROCESS> {
  List<dynamic> dataStartGroup = [];
  List<dynamic> dataEndtGroup = [];
  String? selectStartGroup;
  String? selectEndGroup;

  TextEditingController startGroupController = TextEditingController();
  TextEditingController endGroupController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
//----------------------------------------------------------------------------//
  List<dynamic> dataStartCat = [];
  List<dynamic> dataEndtCat = [];
  String? selectStartCat;
  String? selectEndCat;

  TextEditingController startCatController = TextEditingController();
  TextEditingController endCatController = TextEditingController();
  TextEditingController searchController3 = TextEditingController();
  TextEditingController searchController4 = TextEditingController();
//----------------------------------------------------------------------------//
  List<dynamic> dataStartSubCat = [];
  List<dynamic> dataEndSubCat = [];
  String? selectStarSubtCat;
  String? selectEndSubCat;

  TextEditingController startSubCatController = TextEditingController();
  TextEditingController endSubCatController = TextEditingController();
  TextEditingController searchController5 = TextEditingController();
  TextEditingController searchController6 = TextEditingController();
//----------------------------------------------------------------------------//
  List<dynamic> dataStartBrand = [];
  List<dynamic> dataEndBrand = [];
  String? selectStartBrand;
  String? selectEndBrand;

  TextEditingController startBrandController = TextEditingController();
  TextEditingController endBrandController = TextEditingController();
  TextEditingController searchController7 = TextEditingController();
  TextEditingController searchController8 = TextEditingController();
//----------------------------------------------------------------------------//
  List<dynamic> dataStartItems = [];
  List<dynamic> dataEndItems = [];
  String? selectStartItems;
  String? selectEndItems;

  TextEditingController startItemsController = TextEditingController();
  TextEditingController endItemsController = TextEditingController();
  TextEditingController searchController9 = TextEditingController();
  TextEditingController searchController10 = TextEditingController();
//----------------------------------------------------------------------------//

  @override
  void initState() {
    selectLovStartGroup();
    selectLovEndGroup();
    selectLovStartCat();
    selectLovEndCat();
    selectLovStartSubCat();
    selectLovEndSubCat();
    selectLovStartBrand();
    selectLovEndBrand();
    selectLovStastItems();
    selectLovEndItems();
    super.initState();
  }

  @override
  void dispose() {
    searchController1.dispose();
    searchController2.dispose();
    searchController3.dispose();
    searchController4.dispose();
    searchController5.dispose();
    searchController6.dispose();
    searchController7.dispose();
    searchController8.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  //จากกลุ่มสินค้า//
  Future<void> selectLovStartGroup() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_GROUP/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartGroup : $dataStartGroup');
      } else {
        throw Exception(
            'dataStartGroup Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartGroup ERROR IN Fetch Data : $e');
    }
  }

  //ถึงกลุ่มสินค้า//
  // String sGroupCode = '';
  String? pSGroup;
  Future<void> selectLovEndGroup() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_GROUP_E/${gb.ATTR1}/$pSGroup'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataEndtGroup =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataLovEndLoc : $dataEndtGroup');
      } else {
        throw Exception(
            'dataLovEndLoc Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataLovEndLoc ERROR IN Fetch Data : $e');
    }
  }

  //จากCategory//
  String? pSCat;
  String? pECat;
  Future<void> selectLovStartCat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_CAT/$pSCat/$pECat/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartCat =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartCat : $dataStartCat');
      } else {
        throw Exception(
            'dataStartCat Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartCat ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndCat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_CAT_E/$pSCat/$pECat/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataEndtCat =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataEndtCat : $dataEndtCat');
      } else {
        throw Exception(
            'dataEndtCat Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataEndtCat ERROR IN Fetch Data : $e');
    }
  }

  String? pESubCat;
  String? pSSubCat;
  Future<void> selectLovStartSubCat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_SUB_CAT/$pESubCat/${gb.ATTR1}/$pSSubCat'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartSubCat =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartSubCat : $dataStartSubCat');
      } else {
        throw Exception(
            'dataStartSubCat Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartSubCat ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovEndSubCat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_SUB_CAT_E/$pSSubCat/$pESubCat/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataEndSubCat =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataEndSubCat : $dataEndSubCat');
      } else {
        throw Exception(
            'dataEndSubCat Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataEndSubCat ERROR IN Fetch Data : $e');
    }
  }

  Future<void> selectLovStartBrand() async {
    try {
      final response = await http.get(
          Uri.parse('http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_BRAND'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartBrand =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartBrand : $dataStartBrand');
      } else {
        throw Exception(
            'dataStartBrand Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartBrand ERROR IN Fetch Data : $e');
    }
  }

  String? pSBrand;
  Future<void> selectLovEndBrand() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_BRAND_E/$pSBrand'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataEndBrand =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataEndBrand : $dataEndBrand');
      } else {
        throw Exception(
            'dataEndBrand Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataEndBrand ERROR IN Fetch Data : $e');
    }
  }

  String? pEBrand;
  String? pEGroup;
  Future<void> selectLovStastItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_ITM/${gb.BROWSER_LANGUAGE}/$pSGroup/$pEGroup/$pSCat/$pECat/$pSSubCat/$pESubCat/$pSBrand/$pEBrand/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartItems : $dataStartItems');
      } else {
        throw Exception(
            'dataStartItems Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartItems ERROR IN Fetch Data : $e');
    }
  }

  String? pSItems;
  Future<void> selectLovEndItems() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.16.0.82:8888/apex/wms/SSFGPC04/Step_3_ITM_E/${gb.BROWSER_LANGUAGE}/$pSItems/$pSGroup/$pEGroup/$pSCat/$pECat/$pSSubCat/$pESubCat/$pSBrand/$pEBrand/${gb.ATTR1}'));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        print('Fetched data: $jsonDecode');
        if (mounted) {
          setState(() {
            dataStartItems =
                List<Map<String, dynamic>>.from(responseData['items'] ?? []);
          });
        }
        print('dataStartItems : $dataStartItems');
      } else {
        throw Exception(
            'dataStartItems Failed to load fetchData ||  Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('dataStartItems ERROR IN Fetch Data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: CustomAppBar(title: 'ประมวลผลก่อนการตรวจนับ'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //กลุ่มสินค้า//
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'จากกลุ่ม',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController1
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController1,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataStartGroup
                                                        .where((item) {
                                                  final codeString =
                                                      '${item['group_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['group_name'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController1.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final gCode =
                                                        '${item['group_code'] ?? ''}'
                                                            .toString();
                                                    final gName =
                                                        '${item['group_name'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$gCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$gName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectStartGroup =
                                                              gCode;
                                                          startGroupController
                                                                  .text =
                                                              selectStartGroup!;
                                                          selectLovStartGroup();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController1.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'จาก กลุ่ม',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: startGroupController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
//----------------------------------------------------------------------------------------------------------//
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ถึงกลุ่ม',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController2
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController2,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataEndtGroup.where((item) {
                                                  final codeString =
                                                      '${item['group_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['group_name'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController2.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final gCode =
                                                        '${item['group_code'] ?? ''}' //'${ ?? ''}'
                                                            .toString();
                                                    final gName =
                                                        '${item['group_name'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$gCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$gName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectEndGroup =
                                                              gCode;
                                                          endGroupController
                                                                  .text =
                                                              selectEndGroup!;
                                                          selectLovEndGroup();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController2.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ถึง กลุ่ม',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: endGroupController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
////////////////////////////////////////////////////////////////////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'จากCategory',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController3
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController3,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataStartCat.where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_desc'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController3.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final cCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final cName =
                                                        '${item['category_desc'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$cCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$cName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectStartCat =
                                                              cCode;
                                                          startCatController
                                                                  .text =
                                                              selectStartCat!;
                                                          selectLovStartCat();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController3.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'จาก Category',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: startCatController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Space between the two TextFields
//------------------------------------------------------------------------------------------------//
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ถึงCategory',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController4
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController4,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataEndtCat.where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_desc'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController4.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final cCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final cName =
                                                        '${item['category_desc'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$cCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$cName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectEndCat = cCode;
                                                          endCatController
                                                                  .text =
                                                              selectEndCat!;
                                                          selectLovEndCat();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController4.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ถึง Category',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: endCatController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'จาก Sub Category',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController5
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController5,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataStartSubCat
                                                        .where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_desc'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController5.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final gCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final gName =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$gCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$gName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectStarSubtCat =
                                                              gCode;
                                                          startSubCatController
                                                                  .text =
                                                              selectStarSubtCat!;
                                                          selectLovStartSubCat();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController5.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'จาก Sub Category',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: startSubCatController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
//-------------------------------------------------------------------------------------------------------//
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ถึง Sub Category',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController6
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController6,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataEndSubCat.where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_desc'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController6.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final cCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final cName =
                                                        '${item['category_desc'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$cCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$cName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectEndSubCat =
                                                              cCode;
                                                          endSubCatController
                                                                  .text =
                                                              selectEndSubCat!;
                                                          selectLovEndSubCat();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController6.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ถึง Sub Category',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: endSubCatController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//////////////////////////////////////////////////////////////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'จาก ยี่ห้อ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController7
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController7,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataStartBrand
                                                        .where((item) {
                                                  final codeString =
                                                      '${item['BRAND_CODE'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['BRAND_NAME'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController7.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final bCode =
                                                        '${item['BRAND_CODE'] ?? ''}'
                                                            .toString();
                                                    final bName =
                                                        '${item['BRAND_NAME'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$bCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$bName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectStartBrand =
                                                              bCode;
                                                          startBrandController
                                                                  .text =
                                                              selectStartBrand!;
                                                          selectLovStartBrand();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController7.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'จาก ยี่ห้อ',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: startBrandController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Space between the two TextFields
//---------------------------------------------------------------------------------------------------//
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ถึง ยี่ห้อ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController8
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController8,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataEndBrand.where((item) {
                                                  final codeString =
                                                      '${item['BRAND_CODE'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['BRAND_NAME'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController8.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final bCode =
                                                        '${item['BRAND_CODE'] ?? ''}'
                                                            .toString();
                                                    final bName =
                                                        '${item['BRAND_NAME'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$bCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$bName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectEndBrand =
                                                              bCode;
                                                          endBrandController
                                                                  .text =
                                                              selectEndBrand!;
                                                          selectLovEndBrand();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController8.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ถึง ยี่ห้อ',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: endBrandController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
////////////////////////////////////////////////////////////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  children: [
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'จาก รหัสสินค้า',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController9
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController9,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataStartItems
                                                        .where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController9.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final gCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final gName =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$gCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$gName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectStartItems =
                                                              gCode;
                                                          startItemsController
                                                                  .text =
                                                              selectStartItems!;
                                                          selectLovStastItems();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController9.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'จาก รหัสสินค้า',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: startItemsController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Space between the two TextFields
//----------------------------------------------------------------------------------------------------------//
                    Expanded(
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
                                          300, // Adjust height of Popup as needed
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ถึง รหัสสินค้า',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close Popup
                                                  searchController2
                                                      .clear(); // Clear search value on close
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Search box
                                          TextField(
                                            controller: searchController2,
                                            decoration: InputDecoration(
                                              hintText: 'ค้นหา',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final filteredItems =
                                                    dataEndtGroup.where((item) {
                                                  final codeString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final nameString =
                                                      '${item['category_code'] ?? ''}'
                                                          .toString();
                                                  final searchQuery =
                                                      searchController2.text
                                                          .trim()
                                                          .toLowerCase();
                                                  final searchQueryInt =
                                                      int.tryParse(searchQuery);
                                                  final docInt =
                                                      int.tryParse(codeString);

                                                  return (searchQueryInt !=
                                                              null &&
                                                          docInt != null &&
                                                          docInt ==
                                                              searchQueryInt) ||
                                                      codeString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery) ||
                                                      nameString
                                                          .toLowerCase()
                                                          .contains(
                                                              searchQuery);
                                                }).toList();

                                                if (filteredItems.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          'No data found')); // Display message when no data
                                                }

                                                return ListView.builder(
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        filteredItems[index];
                                                    final gCode =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    final gName =
                                                        '${item['category_code'] ?? ''}'
                                                            .toString();
                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '$gCode\n',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' ', // Add a space between gCode and gName
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '$gName',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          selectEndGroup =
                                                              gCode;
                                                          endGroupController
                                                                  .text =
                                                              selectEndGroup!;
                                                          selectLovStartGroup();
                                                        });
                                                      },
                                                    );
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
                          ).then((_) {
                            searchController2.clear();
                          });
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ถึง รหัสสินค้า',
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromARGB(255, 113, 113, 113),
                              ),
                            ),
                            controller: endGroupController,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: AppStyles.ConfirmbuttonStyle(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ประมวลผล',
                          style: AppStyles.ConfirmbuttonTextStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentPage: 'not_show',
      ),
    );
  }

  void showDialogAlert(
    BuildContext context,
    String messageAlert,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Text(
                    messageAlert,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }
}
