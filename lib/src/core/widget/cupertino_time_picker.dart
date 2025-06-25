import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

/// A reusable Cupertino-style time picker that shows a bottom sheet when tapped.
///
/// Usage:
/// CupertinoTimePickerField(
///   initialTime: TimeOfDay.now(),
///   onTimeChanged: (time) {},
/// )
class CupertinoTimePickerField extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String? label;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final String? Function(TimeOfDay)? validator;
  final String? errorText;

  const CupertinoTimePickerField({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.label,
    this.textStyle,
    this.decoration,
    this.validator,
    this.errorText,
  });

  @override
  State<CupertinoTimePickerField> createState() =>
      _CupertinoTimePickerFieldState();
}

class _CupertinoTimePickerFieldState extends State<CupertinoTimePickerField> {
  late TimeOfDay selectedTime;
  String? _error;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> _showPicker(BuildContext context) async {
    setState(() {
      _error = null;
    });
    TimeOfDay tempTime = selectedTime;
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
                      child: _CupertinoTimePickerWidget(
                        initialTime: selectedTime,
                        onTimeChanged: (time) {
                          tempTime = time;
                        },
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
                            final error = widget.validator?.call(tempTime);
                            if (error != null) {
                              setModalState(() => _error = error);
                            } else {
                              Navigator.of(context).pop();
                              setState(() {
                                selectedTime = tempTime;
                                widget.onTimeChanged(tempTime);
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
    final hour =
        selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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

/// Internal widget for the actual Cupertino time pickers (not shown directly)
class _CupertinoTimePickerWidget extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _CupertinoTimePickerWidget({
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<_CupertinoTimePickerWidget> createState() =>
      _CupertinoTimePickerWidgetState();
}

class _CupertinoTimePickerWidgetState
    extends State<_CupertinoTimePickerWidget> {
  late int selectedHour;
  late int selectedMinute;
  late DayPeriod selectedPeriod;

  @override
  void initState() {
    super.initState();
    selectedHour =
        widget.initialTime.hourOfPeriod == 0
            ? 12
            : widget.initialTime.hourOfPeriod;
    selectedMinute = widget.initialTime.minute;
    selectedPeriod = widget.initialTime.period;
  }

  void _onChanged() {
    int hour = selectedHour % 12;
    if (selectedPeriod == DayPeriod.pm) hour += 12;
    widget.onTimeChanged(TimeOfDay(hour: hour, minute: selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    final hourPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: (selectedHour - 1) % 12,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedHour = (index + 1);
            _onChanged();
          });
        },
        children: [
          for (int i = 1; i <= 12; i++)
            Center(child: Text(i.toString().padLeft(2, '0'))),
        ],
      ),
    );

    final minutePicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedMinute,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedMinute = index;
            _onChanged();
          });
        },
        children: [
          for (int i = 0; i < 60; i++)
            Center(child: Text(i.toString().padLeft(2, '0'))),
        ],
      ),
    );

    final periodPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedPeriod == DayPeriod.am ? 0 : 1,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedPeriod = index == 0 ? DayPeriod.am : DayPeriod.pm;
            _onChanged();
          });
        },
        children: const [Center(child: Text('AM')), Center(child: Text('PM'))],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [hourPicker, minutePicker, periodPicker],
    );
  }
}
