import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextFormField extends StatefulWidget {
  // final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueNotifier<bool> isDateInvalidNotifier;
  final bool showBorder;
  final bool showAsterisk;

  const CustomTextFormField({
    Key? key,
    // this.hintText,
    this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
    required this.isDateInvalidNotifier,
    this.showBorder = false,
    this.showAsterisk = false,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final dateInputFormatter = DateInputFormatter();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      if (mounted) {
        setState(() {
          widget.controller?.text = formattedDate;
          widget.isDateInvalidNotifier.value = false;

          if (widget.onChanged != null) {
            widget.onChanged!(formattedDate);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.isDateInvalidNotifier,
          builder: (context, isDateInvalid, child) {
            return TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                dateInputFormatter,
              ],
              decoration: InputDecoration(
                border: widget.showBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                    : InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                label: RichText(
                  text: TextSpan(
                    text: widget.labelText ?? '',
                    style: TextStyle(
                      color: isDateInvalid ? Colors.red : Colors.black87,
                      fontSize: 16,
                    ),
                    children: widget.showAsterisk
                        ? [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ]
                        : [],
                  ),
                ),
                hintText: 'DD/MM/YYYY',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              onChanged: (value) {
                widget.isDateInvalidNotifier.value =
                    dateInputFormatter.noDateNotifier.value;
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isDateInvalidNotifier,
          builder: (context, isDateInvalid, child) {
            return isDateInvalid
                ? const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      'กรุณาระบุรูปแบบวันที่ให้ถูกต้อง เช่น 31/01/2024',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  ValueNotifier<bool> noDateNotifier = ValueNotifier<bool>(false);
  String day = '';
  String month = '';
  String year = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    int cursorPosition = newValue.selection.baseOffset;
    int additionalOffset = 0;

    if (text.isEmpty) {
      noDateNotifier.value = false;
    } else if (text.length <= 7) {
      noDateNotifier.value = true;
    } else if (text.length == 8) {
      day = text.substring(0, 2);
      month = text.substring(2, 4);
      year = text.substring(4, 8);
      noDateNotifier.value = !isValidDate(day, month, year);
    } else {
      noDateNotifier.value = false;
    }

    if (text.length > 2 && text.length <= 4) {
      text = text.substring(0, 2) + '/' + text.substring(2);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
    } else if (text.length > 4 && text.length <= 8) {
      text = text.substring(0, 2) +
          '/' +
          text.substring(2, 4) +
          '/' +
          text.substring(4);
      if (cursorPosition > 2) {
        additionalOffset++;
      }
      if (cursorPosition > 4) {
        additionalOffset++;
      }
    }

    print('data text : $text');

    return TextEditingValue(
      text: text,
      selection:
          TextSelection.collapsed(offset: cursorPosition + additionalOffset),
    );
  }

  bool isValidDate(String day, String month, String year) {
    int dayInt = int.parse(day);
    int monthInt = int.parse(month);
    int yearInt = int.parse(year);

    if (monthInt < 1 || monthInt > 12) {
      return false;
    }

    List<int> daysInMonth = [
      31,
      isLeapYear(yearInt) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int maxDays = daysInMonth[monthInt - 1];

    if (dayInt < 1 || dayInt > maxDays) {
      return false;
    }

    return true;
  }

  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
