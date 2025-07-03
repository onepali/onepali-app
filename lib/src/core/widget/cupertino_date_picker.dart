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
  final DateTime? lastDate;
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
    this.lastDate,
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
  final TextEditingController _yearController = TextEditingController();
  bool _showYearInput = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _yearController.text = selectedDate.year.toString();
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a year';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'Please enter a valid year';
    }

    if (year < widget.minYear || year > widget.maxYear) {
      return 'Year must be between ${widget.minYear} and ${widget.maxYear}';
    }

    // Check against lastDate if provided
    if (widget.lastDate != null && year > widget.lastDate!.year) {
      return 'Year cannot be later than ${widget.lastDate!.year}';
    }

    return null;
  }

  Future<void> _showPicker(BuildContext context) async {
    setState(() {
      _error = null;
    });
    DateTime tempDate = selectedDate;
    final DateTime maxDate =
        widget.lastDate ?? DateTime(widget.maxYear, 12, 31);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      routeSettings: const RouteSettings(name: AppConstants.datePickerModal),
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
                    // Year input toggle button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextButton(
                          text: _showYearInput ? 'Use Picker' : 'Enter Year',
                          onPressed: () {
                            setModalState(() {
                              _showYearInput = !_showYearInput;
                              if (!_showYearInput) {
                                _yearController.text = tempDate.year.toString();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Gaps.verticalGapOf(8),
                    // Year input field or picker
                    _showYearInput
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _yearController,
                                hintText:
                                    'Enter year (${widget.minYear}-${widget.maxYear})',
                                keyboardType: TextInputType.number,
                                validation: _validateYear,
                                paddingHorizontal: 16,
                                paddingVertical: 16,
                                onChanged: (value) {
                                  final year = int.tryParse(value);
                                  if (year != null &&
                                      year >= widget.minYear &&
                                      year <= widget.maxYear) {
                                    setModalState(() {
                                      tempDate = DateTime(
                                        year,
                                        widget.showMonth ? tempDate.month : 1,
                                        widget.showDay ? tempDate.day : 1,
                                      );
                                    });
                                  }
                                },
                              ),
                              Gaps.verticalGapOf(16),
                            ],
                          ),
                        )
                        : SizedBox(
                          height: 200,
                          child: _CupertinoDatePickerWidget(
                            initialDate:
                                selectedDate.isAfter(maxDate)
                                    ? maxDate
                                    : selectedDate,
                            onDateChanged: (date) {
                              tempDate = date;
                              _yearController.text = date.year.toString();
                            },
                            showMonth: widget.showMonth,
                            showDay: widget.showDay,
                            minYear: widget.minYear,
                            maxYear: widget.maxYear,
                            lastDate: maxDate,
                          ),
                        ),
                    Gaps.verticalGapOf(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Gaps.horizontalGapOf(8),
                        CustomTextButton(
                          text: 'Select',
                          onPressed: () {
                            String? error;

                            // Validate based on input method
                            if (_showYearInput) {
                              error = _validateYear(_yearController.text);
                              if (error == null) {
                                final year = int.parse(_yearController.text);
                                tempDate = DateTime(
                                  year,
                                  widget.showMonth ? tempDate.month : 1,
                                  widget.showDay ? tempDate.day : 1,
                                );
                              }
                            }

                            // Apply widget validator if provided
                            error ??= widget.validator?.call(tempDate);

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
                        Gaps.horizontalGapOf(16),
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
  final DateTime? lastDate;

  const _CupertinoDatePickerWidget({
    required this.initialDate,
    required this.onDateChanged,
    required this.showMonth,
    required this.showDay,
    required this.minYear,
    required this.maxYear,
    this.lastDate,
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
    final int maxYear = widget.lastDate?.year ?? widget.maxYear;
    final int maxMonth = widget.lastDate?.month ?? 12;
    final int maxDay = widget.lastDate?.day ?? 31;

    final yearPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedYear - widget.minYear,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedYear = widget.minYear + index;
            if (widget.lastDate != null && selectedYear > maxYear) {
              selectedYear = maxYear;
            }
            if (selectedDay > daysInMonth) selectedDay = daysInMonth;
            _onChanged();
          });
        },
        children: [
          for (int i = widget.minYear; i <= maxYear; i++)
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
                    if (widget.lastDate != null &&
                        selectedYear == maxYear &&
                        selectedMonth > maxMonth) {
                      selectedMonth = maxMonth;
                    }
                    if (selectedDay > daysInMonth) selectedDay = daysInMonth;
                    _onChanged();
                  });
                },
                children: [
                  for (
                    int i = 1;
                    i <=
                        (selectedYear == maxYear && widget.lastDate != null
                            ? maxMonth
                            : 12);
                    i++
                  )
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
                    if (widget.lastDate != null &&
                        selectedYear == maxYear &&
                        selectedMonth == maxMonth &&
                        selectedDay > maxDay) {
                      selectedDay = maxDay;
                    }
                    _onChanged();
                  });
                },
                children: [
                  for (
                    int i = 1;
                    i <=
                        (selectedYear == maxYear &&
                                selectedMonth == maxMonth &&
                                widget.lastDate != null
                            ? maxDay
                            : daysInMonth);
                    i++
                  )
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
