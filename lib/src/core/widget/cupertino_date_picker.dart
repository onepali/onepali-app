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
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _combinedController = TextEditingController();
  bool _showYearInput = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _yearController.text = selectedDate.year.toString();
    _monthController.text = selectedDate.month.toString();
    _updateCombinedController();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _combinedController.dispose();
    super.dispose();
  }

  void _updateCombinedController() {
    if (widget.showMonth && widget.showDay) {
      _combinedController.text =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}";
    } else if (widget.showMonth) {
      _combinedController.text =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}";
    } else {
      _combinedController.text = selectedDate.year.toString();
    }
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

  String? _validateCombined(String? value) {
    if (value == null || value.isEmpty) {
      return widget.showMonth
          ? 'Please enter year and month (YYYY-MM)'
          : 'Please enter a year';
    }

    if (!widget.showMonth) {
      return _validateYear(value);
    }

    // For combined year-month input (YYYY-MM format)
    final parts = value.split('-');
    if (parts.length != 2) {
      return 'Please enter date in YYYY-MM format';
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);

    if (year == null || month == null) {
      return 'Please enter valid year and month';
    }

    if (year < widget.minYear || year > widget.maxYear) {
      return 'Year must be between ${widget.minYear} and ${widget.maxYear}';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 1 and 12';
    }

    // Check against lastDate if provided
    if (widget.lastDate != null) {
      if (year > widget.lastDate!.year) {
        return 'Year cannot be later than ${widget.lastDate!.year}';
      }
      if (year == widget.lastDate!.year && month > widget.lastDate!.month) {
        return 'Date cannot be later than ${widget.lastDate!.year}-${widget.lastDate!.month.toString().padLeft(2, '0')}';
      }
    }

    return null;
  }

  DateTime? _parseCombinedInput(String value) {
    if (!widget.showMonth) {
      final year = int.tryParse(value);
      if (year != null) {
        return DateTime(year, 1, 1);
      }
      return null;
    }

    final parts = value.split('-');
    if (parts.length == 2) {
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      if (year != null && month != null) {
        return DateTime(year, month, widget.showDay ? selectedDate.day : 1);
      }
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

    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing for dialog
    final double dialogMargin = isTabletPortrait ? 24.0 : 16.0;
    final double dialogPadding = isTabletPortrait ? 24.0 : 16.0;
    final double borderRadius = isTabletPortrait ? 24.0 : 20.0;
    final double handleWidth = isTabletPortrait ? 50.0 : 40.0;
    final double handleHeight = isTabletPortrait ? 5.0 : 4.0;
    final double pickerHeight = isTabletPortrait ? 240.0 : 200.0;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                margin: EdgeInsets.all(dialogMargin),
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(dialogPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.kButtonGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: handleHeight,
                      width: handleWidth,
                    ),
                    Gaps.verticalGapOf(16),
                    // Year/Month input toggle button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextButton(
                          textStyle: AppStyles.text14PxMedium.copyWith(
                            color: AppColors.kButtonGreen,
                            fontSize: isTabletPortrait ? 20.0 : 14.0,
                          ),
                          text:
                              _showYearInput
                                  ? 'Use Picker'
                                  : (widget.showMonth
                                      ? 'Enter Year & Month'
                                      : 'Enter Year'),
                          onPressed: () {
                            setModalState(() {
                              _showYearInput = !_showYearInput;
                              if (!_showYearInput) {
                                _updateCombinedController();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Gaps.verticalGapOf(8), // Year/Month input field or picker
                    _showYearInput
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _combinedController,
                                hintText:
                                    widget.showMonth
                                        ? 'Enter date (YYYY-MM)'
                                        : 'Enter year (${widget.minYear}-${widget.maxYear})',
                                keyboardType: TextInputType.number,
                                validation: _validateCombined,
                                paddingHorizontal: 16,
                                paddingVertical: 16,
                                onChanged: (value) {
                                  final parsedDate = _parseCombinedInput(value);
                                  if (parsedDate != null) {
                                    setModalState(() {
                                      tempDate = parsedDate;
                                    });
                                  }
                                },
                              ),
                              if (widget.showMonth) ...[
                                Gaps.verticalGapOf(8),
                                Text(
                                  'Format: YYYY-MM (e.g., 2024-03)',
                                  style: AppStyles.text12PxRegular.copyWith(
                                    color: AppColors.kGrey,
                                  ),
                                ),
                              ],
                              Gaps.verticalGapOf(16),
                            ],
                          ),
                        )
                        : SizedBox(
                          height: pickerHeight,
                          child: _CupertinoDatePickerWidget(
                            initialDate:
                                selectedDate.isAfter(maxDate)
                                    ? maxDate
                                    : selectedDate,
                            onDateChanged: (date) {
                              tempDate = date;
                              _yearController.text = date.year.toString();
                              _monthController.text = date.month.toString();
                              if (widget.showMonth) {
                                _combinedController.text =
                                    "${date.year}-${date.month.toString().padLeft(2, '0')}";
                              } else {
                                _combinedController.text = date.year.toString();
                              }
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
                          textStyle: AppStyles.text14PxMedium.copyWith(
                            color: AppColors.kGrey,
                            fontSize: isTabletPortrait ? 20.0 : 14.0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Gaps.horizontalGapOf(8),
                        CustomTextButton(
                          text: 'Select',
                          textStyle: AppStyles.text14PxMedium.copyWith(
                            color: AppColors.kButtonGreen,
                            fontSize: isTabletPortrait ? 20.0 : 14.0,
                          ),
                          onPressed: () {
                            String? error;

                            // Validate based on input method
                            if (_showYearInput) {
                              error = _validateCombined(
                                _combinedController.text,
                              );
                              if (error == null) {
                                final parsedDate = _parseCombinedInput(
                                  _combinedController.text,
                                );
                                if (parsedDate != null) {
                                  tempDate = parsedDate;
                                }
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
                                _updateCombinedController();
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
                          style: AppStyles.text12PxRegular.copyWith(
                            color: AppColors.kRed,
                            fontSize: isTabletPortrait ? 16.0 : 12.0,
                          ),
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
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double verticalPadding = isTabletPortrait ? 16.0 : 12.0;
    final double horizontalPadding = isTabletPortrait ? 16.0 : 12.0;
    final double borderRadius = isTabletPortrait ? 12.0 : 8.0;
    final double iconSize = isTabletPortrait ? 28.0 : 24.0;

    final TextStyle textStyle =
        widget.textStyle ??
        (isTabletPortrait
            ? AppStyles.text18PxMedium
            : AppStyles.text16PxMedium);

    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration:
            widget.decoration ??
            BoxDecoration(
              color: AppColors.kLightGrey.withValues(alpha: 0.2),
              border: Border.all(color: AppColors.kTransparentColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
        child: Row(
          children: [
            Text(_displayText, style: textStyle),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
              size: iconSize,
            ),
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
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double itemExtent = isTabletPortrait ? 40.0 : 32.0;

    final int maxYear = widget.lastDate?.year ?? widget.maxYear;
    final int maxMonth = widget.lastDate?.month ?? 12;
    final int maxDay = widget.lastDate?.day ?? 31;

    final yearPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedYear - widget.minYear,
        ),
        itemExtent: itemExtent,
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
            Center(
              child: Text(
                i.toString(),
                style:
                    isTabletPortrait
                        ? AppStyles.text28PxMedium
                        : AppStyles.text16PxMedium,
              ),
            ),
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
                itemExtent: itemExtent,
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
                    Center(
                      child: Text(
                        i.toString().padLeft(2, '0'),
                        style:
                            isTabletPortrait
                                ? AppStyles.text18PxMedium
                                : AppStyles.text16PxMedium,
                      ),
                    ),
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
                itemExtent: itemExtent,
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
                    Center(
                      child: Text(
                        i.toString().padLeft(2, '0'),
                        style:
                            isTabletPortrait
                                ? AppStyles.text18PxMedium
                                : AppStyles.text16PxMedium,
                      ),
                    ),
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
