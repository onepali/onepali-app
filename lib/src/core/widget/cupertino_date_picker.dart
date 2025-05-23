import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

/// A reusable Cupertino-style date picker that shows a bottom sheet when tapped.
///
/// Usage:
/// CupertinoDatePickerField(
///   initialDate: DateTime.now(),
///   onDateChanged: (date) {},
///   showMonth: false,
///   showDay: false,
/// )
class CupertinoDatePickerField extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final bool showMonth;
  final bool showDay;
  final int minYear;
  final int maxYear;
  final String? label;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final String? Function(DateTime)? validator;
  final String? errorText;

  const CupertinoDatePickerField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    this.showMonth = true,
    this.showDay = true,
    this.minYear = 1900,
    this.maxYear = 2100,
    this.label,
    this.textStyle,
    this.decoration,
    this.validator,
    this.errorText,
  });

  @override
  State<CupertinoDatePickerField> createState() =>
      _CupertinoDatePickerFieldState();
}

class _CupertinoDatePickerFieldState extends State<CupertinoDatePickerField> {
  late DateTime selectedDate;
  String? _error;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _showPicker(BuildContext context) async {
    setState(() {
      _error = null;
    });
    DateTime tempDate = selectedDate;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.kButtonGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 4,
                      width: 40,
                    ),
                    Gaps.verticalGapOf(16),
                    SizedBox(
                      height: 200,
                      child: _CupertinoDatePickerWidget(
                        initialDate: selectedDate,
                        onDateChanged: (date) {
                          tempDate = date;
                        },
                        showMonth: widget.showMonth,
                        showDay: widget.showDay,
                        minYear: widget.minYear,
                        maxYear: widget.maxYear,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(width: 8),
                        CustomTextButton(
                          text: 'Select',
                          onPressed: () {
                            final error = widget.validator?.call(tempDate);
                            if (error != null) {
                              setModalState(() => _error = error);
                            } else {
                              Navigator.of(context).pop();
                              setState(() {
                                selectedDate = tempDate;
                                widget.onDateChanged(tempDate);
                                _error = null;
                              });
                            }
                          },
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String get _displayText {
    if (widget.showMonth && widget.showDay) {
      return "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    } else if (widget.showMonth) {
      return "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}";
    } else if (widget.showDay) {
      return "${selectedDate.year}-${selectedDate.day.toString().padLeft(2, '0')}";
    } else {
      return selectedDate.year.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration:
            widget.decoration ??
            BoxDecoration(
              color: AppColors.kLightGrey.withValues(alpha: 0.2),
              border: Border.all(color: AppColors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
        child: Row(
          children: [
            Text(
              _displayText,
              style: widget.textStyle ?? TextStyle(fontSize: 16),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// Internal widget for the actual Cupertino pickers (not shown directly)
class _CupertinoDatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final bool showMonth;
  final bool showDay;
  final int minYear;
  final int maxYear;

  const _CupertinoDatePickerWidget({
    required this.initialDate,
    required this.onDateChanged,
    required this.showMonth,
    required this.showDay,
    required this.minYear,
    required this.maxYear,
  });

  @override
  State<_CupertinoDatePickerWidget> createState() =>
      _CupertinoDatePickerWidgetState();
}

class _CupertinoDatePickerWidgetState
    extends State<_CupertinoDatePickerWidget> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
    selectedDay = widget.initialDate.day;
  }

  int get daysInMonth => DateTime(selectedYear, selectedMonth + 1, 0).day;

  void _onChanged() {
    final date = DateTime(
      selectedYear,
      widget.showMonth ? selectedMonth : 1,
      widget.showDay ? selectedDay : 1,
    );
    widget.onDateChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    final yearPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedYear - widget.minYear,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedYear = widget.minYear + index;
            if (selectedDay > daysInMonth) selectedDay = daysInMonth;
            _onChanged();
          });
        },
        children: [
          for (int i = widget.minYear; i <= widget.maxYear; i++)
            Center(child: Text(i.toString())),
        ],
      ),
    );

    final monthPicker =
        widget.showMonth
            ? Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedMonth - 1,
                ),
                itemExtent: 32,

                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedMonth = index + 1;
                    if (selectedDay > daysInMonth) selectedDay = daysInMonth;
                    _onChanged();
                  });
                },
                children: [
                  for (int i = 1; i <= 12; i++)
                    Center(child: Text(i.toString().padLeft(2, '0'))),
                ],
              ),
            )
            : null;

    final dayPicker =
        widget.showDay
            ? Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedDay - 1,
                ),
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedDay = index + 1;
                    _onChanged();
                  });
                },
                children: [
                  for (int i = 1; i <= daysInMonth; i++)
                    Center(child: Text(i.toString().padLeft(2, '0'))),
                ],
              ),
            )
            : null;

    final pickers = <Widget>[yearPicker];
    if (widget.showMonth) pickers.add(monthPicker!);
    if (widget.showDay) pickers.add(dayPicker!);

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: pickers);
  }
}
