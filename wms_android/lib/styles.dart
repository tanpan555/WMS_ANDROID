import 'package:flutter/material.dart';
import 'icon.dart';

class AppColors {
  static const primaryColor = Color(0xFF17153B);
}

class CustomContainerStyles {
  static Container styledContainer(String? itemValue,
      {double padding = 5.0, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: (itemValue != null && itemValue.trim().isNotEmpty)
            ? Colors.white
            : Colors.transparent,
      ),
      child: child,
    );
  }
}
// -----------------------------------------------------------------------------------

class AppStyles {
  static ButtonStyle ConfirmbuttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 212, 245, 212),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static TextStyle ConfirmbuttonTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle cancelButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      minimumSize: const Size(70, 40),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  static ButtonStyle createButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white, // Green background for the button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Rounded rectangle border
        side: const BorderSide(color: Colors.white, width: 2), // White outline
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5), // Padding to control button size
      minimumSize: const Size(80, 45), // Button size can be adjusted
    );
  }

  static ButtonStyle ClearButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      minimumSize: const Size(80, 45),
    );
  }

  static TextStyle CancelbuttonTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static ButtonStyle NextButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle CheckButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle ConfirmChecRecievekButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.green, width: 1.5),
      ),
      minimumSize: const Size(60, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle EraserButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(100, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle SearchButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(100, 40),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle PreviousButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle NextRecordDataButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle DisablePreviousButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 23, 21, 59),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }

  static ButtonStyle DisableNextRecordDataButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 23, 21, 59),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(90, 35),
      padding: const EdgeInsets.all(0),
    );
  }
}
// ----------------------------------------------------------------------------------- ButtonStyles  Previous & Next

class ButtonStyles {
  static final ButtonStyle nextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static Widget nextButtonContent() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Next',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        SizedBox(width: 7),
        Icon(
          MyIcons.arrow_forward_ios_rounded,
          color: Colors.black,
          size: 20.0,
        ),
      ],
    );
  }

  static final ButtonStyle previousButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static final Widget previousButtonContent = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        MyIcons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 20.0,
      ),
      const SizedBox(width: 7),
      const Text(
        'Previous',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );

  static final ButtonStyle NextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(60, 40),
    padding: const EdgeInsets.all(0),
  );

  // --------------------------------------------------------------------------------------------------------------- disable

  static final ButtonStyle disableNextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static Widget disableNextButtonContent() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Next',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        SizedBox(width: 7),
        Icon(
          MyIcons.arrow_forward_ios_rounded,
          color: AppColors.primaryColor,
          size: 20.0,
        ),
      ],
    );
  }

  static final ButtonStyle disablePreviousButtonStyle =
      ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static final Widget disablePreviousButtonContent = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        MyIcons.arrow_back_ios_rounded,
        color: AppColors.primaryColor,
        size: 20.0,
      ),
      const SizedBox(width: 7),
      Text(
        'Previous',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );

  static final ButtonStyle createButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: const BorderSide(color: Colors.white, width: 2),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    minimumSize: const Size(80, 45),
  );

  // เนื้อหาปุ่มที่มีเฉพาะไอคอน
  static Widget createButtonContent() {
    return Image.asset(
      'assets/images/plus.png', // เส้นทางไอคอน
      width: 30, // ความกว้างไอคอน
      height: 30, // ความสูงไอคอน
    );
  }

  static Widget deleteButtonContent() {
    return Image.asset(
      'assets/images/bin.png', // เส้นทางไอคอน
      width: 30, // ความกว้างไอคอน
      height: 30, // ความสูงไอคอน
    );
  }
}

class DisableButtonStyles {
  static final ButtonStyle disableNextButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static Widget disableNextButtonContent() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Next',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        SizedBox(width: 7),
        Icon(
          MyIcons.arrow_forward_ios_rounded,
          color: AppColors.primaryColor,
          size: 20.0,
        ),
      ],
    );
  }

  static final ButtonStyle disablePreviousButtonStyle =
      ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(90, 35),
    padding: const EdgeInsets.all(0),
  );

  static final Widget disablePreviousButtonContent = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        MyIcons.arrow_back_ios_rounded,
        color: AppColors.primaryColor,
        size: 20.0,
      ),
      const SizedBox(width: 7),
      Text(
        'Previous',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );
}

// ----------------------------------------------------------------------------------- DialogStyles

class DialogStyles {
  // ---------------------------------------------------------------------  dialog แจ้งเตือนย้อนกลับ
  static AlertDialog warningNotSaveDialog({
    required BuildContext context,
    required String textMessage,
    required VoidCallback onCloseDialog,
    required VoidCallback onConfirmDialog,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(MyIcons.close),
                onPressed: onCloseDialog, // Directly call onCloseDialog here
              ),
            ],
          ),
        ],
      ),
      content: Text(textMessage),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onCloseDialog, // Directly call onCloseDialog here
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: onConfirmDialog, // Directly call onConfirmDialog here
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('OK'),
            ),
          ],
        )
      ],
    );
  }

  // ---------------------------------------------------------------------  dialog แจ้งเตือนย้อนกลับปุ่ม Home
  static AlertDialog homeDialog({
    required BuildContext context,
    required String textMessage,
    required VoidCallback onCloseDialog,
    required VoidCallback onConfirmDialog,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
      content: Text(textMessage),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onCloseDialog, // Directly calling onCloseDialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ยกเลิก'),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: onConfirmDialog, // Directly calling onConfirmDialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ตกลง'),
            ),
          ],
        )
      ],
    );
  }

  // ---------------------------------------------------------------------  dialog สาเหตุการยกเลิก
  static AlertDialog cancelDialog({
    required BuildContext context,
    required VoidCallback onCloseDialog,
    required VoidCallback onConfirmDialog,
    required VoidCallback onTap,
    required TextEditingController controller,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'สาเหตุการยกเลิก',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          IconButton(
            icon: const Icon(MyIcons.close),
            onPressed: onCloseDialog,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                readOnly: true,
                onTap: onTap,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'สาเหตุการยกเลิก',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onCloseDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: onConfirmDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ---------------------------------------------------------------------  alertMessageDialog

  static AlertDialog alertMessageDialog({
    required BuildContext context,
    required Widget content,
    required VoidCallback onClose,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(MyIcons.close),
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      ],
    );
  }

  static AlertDialog alertMessageCheckDialog({
    required BuildContext context,
    required Widget content,
    required VoidCallback onClose,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'แจ้งเตือน',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(MyIcons.close),
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      ],
    );
  }

// ----------------------------------------------------------------------

  static Dialog customSelectLovDialog({
    required BuildContext context,
    required String? headerText,
    required List<dynamic> data,
    required String Function(Map<String, dynamic> item) displayItem,
    // required VoidCallback onClose,
    required void Function(Map<String, dynamic> item) onTap,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        headerText.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(MyIcons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var item = data[index];
                          return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  displayItem(item),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              onTap: () => onTap(item));
                        },
                      ),
                    ],
                  ),
                )

                // ช่องค้นหา
              ],
            ),
          );
        },
      ),
    );
  }

  static Dialog customLovSearchDialog({
    required BuildContext context,
    required String? headerText,
    required TextEditingController searchController,
    required List<dynamic> data,
    required String Function(dynamic item) docString,
    required String Function(Map<String, dynamic> item) titleText,
    required String Function(Map<String, dynamic> item) subtitleText,
    required void Function(Map<String, dynamic> item) onTap,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300, // ปรับความสูงตามต้องการ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headerText.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(MyIcons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // ช่องค้นหา
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'ค้นหา',
                          border: const OutlineInputBorder(),
                          suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 3,
                                    height: 3,
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Icon(
                                      MyIcons.close,
                                      size: 15,
                                      color: Color(0xFF676767),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (query) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filteredItems = data.where((item) {
                        final docValue = docString(item).toLowerCase();
                        final searchQuery =
                            searchController.text.trim().toLowerCase();
                        return docValue.contains(searchQuery);
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text('No data found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              titleText(item),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(subtitleText(item)),
                            onTap: () => onTap(item),
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
  }

  static Dialog customRequiredLovSearchDialog({
    required BuildContext context,
    required String headerText, // ปรับเป็น String
    required TextEditingController searchController,
    required List<dynamic> data,
    required String Function(dynamic item) docString,
    required String Function(Map<String, dynamic> item) titleText,
    required String Function(Map<String, dynamic> item) subtitleText,
    required void Function(Map<String, dynamic> item) onTap,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: headerText,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        children: const [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(MyIcons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        searchController.clear();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'ค้นหา',
                          border: const OutlineInputBorder(),
                          suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    searchController.clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 3,
                                    height: 3,
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Icon(
                                      MyIcons.close,
                                      size: 15,
                                      color: Color(0xFF676767),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (query) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final filteredItems = data.where((item) {
                        final docValue = docString(item).toLowerCase();
                        final searchQuery =
                            searchController.text.trim().toLowerCase();
                        return docValue.contains(searchQuery);
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text('No data found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              titleText(item),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(subtitleText(item)),
                            onTap: () => onTap(item),
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
  }
}

class ElevatedButtonStyle {
  static ElevatedButton nextpage({
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        minimumSize: MaterialStateProperty.all(const Size(60, 40)),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
      ),
      child: Image.asset(
        'assets/images/right.png',
        width: 25,
        height: 25,
      ),
    );
  }

  // // ปุ่ม Cancel Page
  // static ElevatedButton cancelpage({
  //   required VoidCallback? onPressed,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onPressed,
  //     style: AppStyles.CancelButtonStyle(),
  //     child: Image.asset(
  //       'assets/images/DDDD.png',
  //       width: 25,
  //       height: 25,
  //     ),
  //   );
  // }
}
