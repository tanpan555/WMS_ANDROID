import 'package:flutter/material.dart';
import 'styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showExitWarning;

  CustomAppBar({
    Key? key,
    required this.title,
    required this.showExitWarning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('showExitWarning : $showExitWarning');
    // return AppBar(
    //   centerTitle: false,
    //   backgroundColor: const Color.fromARGB(255, 17, 0, 56),
    //   iconTheme: const IconThemeData(
    //     color: Colors.white,
    //     size: 18, // Set the back icon color to white
    //   ),
    final isHomePage = ModalRoute.of(context)?.settings.name == '/home';
    return AppBar(
      automaticallyImplyLeading: false, //กำหนดการแสดงของ icon
      centerTitle: false,

      backgroundColor: const Color(0xFF17153B),
      leading: isHomePage
          // padding: const EdgeInsets.symmetric(horizontal: 0),
          ? null //SizedBox()
          : IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                if (showExitWarning) {
                  bool shouldLeave = await showExitWarningDialog(context);
                  if (shouldLeave) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      title: GestureDetector(
        onTap: () {
          // Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              height: 40.0, // Adjust the height as needed
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                softWrap: true, // ให้ข้อความตบบรรทัดใหม่อัตโนมัติ
                overflow: TextOverflow.visible, // แสดงข้อความที่เกิน
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showExitWarningDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogStyles.warningNotSaveDialog(
              context: context,
              textMessage: 'คุณต้องการออกจากหน้านี้โดยไม่บันทึกหรือไม่?',
              onCloseDialog: () {
                Navigator.of(context).pop(); // Close dialog
              },
              onConfirmDialog: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context)
                    .pop(); // Close main screen or perform desired action
              },
            );
          },
        ) ??
        false;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
