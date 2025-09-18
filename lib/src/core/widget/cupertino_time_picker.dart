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
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                    SizedBox(
                      height: pickerHeight,
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
    final hour =
        selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
            : AppStyles.text16PxRegular);

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
              size: isTabletPortrait ? iconSize : null,
            ),
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
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double itemExtent = isTabletPortrait ? 40.0 : 32.0;

    final hourPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: (selectedHour - 1) % 12,
        ),
        itemExtent: itemExtent,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedHour = (index + 1);
            _onChanged();
          });
        },
        children: [
          for (int i = 1; i <= 12; i++)
            Center(
              child: Text(
                i.toString().padLeft(2, '0'),
                style:
                    isTabletPortrait
                        ? AppStyles.text28PxMedium
                        : AppStyles.text16PxMedium,
              ),
            ),
        ],
      ),
    );

    final minutePicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedMinute,
        ),
        itemExtent: itemExtent,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedMinute = index;
            _onChanged();
          });
        },
        children: [
          for (int i = 0; i < 60; i++)
            Center(
              child: Text(
                i.toString().padLeft(2, '0'),
                style:
                    isTabletPortrait
                        ? AppStyles.text28PxMedium
                        : AppStyles.text16PxMedium,
              ),
            ),
        ],
      ),
    );

    final periodPicker = Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedPeriod == DayPeriod.am ? 0 : 1,
        ),
        itemExtent: itemExtent,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedPeriod = index == 0 ? DayPeriod.am : DayPeriod.pm;
            _onChanged();
          });
        },
        children: [
          Center(
            child: Text(
              'AM',
              style:
                  isTabletPortrait
                      ? AppStyles.text28PxMedium
                      : AppStyles.text16PxMedium,
            ),
          ),
          Center(
            child: Text(
              'PM',
              style:
                  isTabletPortrait
                      ? AppStyles.text28PxMedium
                      : AppStyles.text16PxMedium,
            ),
          ),
        ],
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [hourPicker, minutePicker, periodPicker],
    );
  }
}
