import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class CustomPinput extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final String? Function(String)? validator;
  final double boxSize;
  final double boxSpacing;
  final Color activeColor;
  final Color inactiveColor;
  final Color errorColor;

  const CustomPinput({
    super.key,
    required this.length,
    required this.controller,
    this.validator,
    this.boxSize = 56,
    this.boxSpacing = 12,
    this.activeColor = AppColors.kButtonGreen,
    this.inactiveColor = AppColors.kLightGrey,
    this.errorColor = AppColors.kRed,
  });

  @override
  State<CustomPinput> createState() => _CustomPinputState();
}

class _CustomPinputState extends State<CustomPinput>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  String? _errorText;
  late List<String> _inputList;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _inputList = List.filled(widget.length, '');
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    setState(() {
      for (int i = 0; i < widget.length; i++) {
        _inputList[i] = i < text.length ? text[i] : '';
      }
      // Only validate if length matches required length
      if (widget.validator != null) {
        if (text.length < widget.length) {
          _errorText = "Please enter all digits";
        } else {
          _errorText = widget.validator!(text);
        }
      }
    });
  }

  void _onTap() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null && _errorText!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final isActive =
                  widget.controller.text.length == index && _focusNode.hasFocus;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: widget.boxSpacing / 2),
                width: widget.boxSize,
                height: widget.boxSize,
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(widget.boxSize / 3),
                  border: Border.all(
                    color:
                        hasError
                            ? widget.errorColor
                            : isActive
                            ? widget.activeColor
                            : widget.inactiveColor,
                    width: isActive ? 2.5 : 1.2,
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: widget.activeColor.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  child: Text(
                    _inputList[index],
                    key: ValueKey(_inputList[index] + index.toString()),
                    style: AppStyles.text24PxMedium.copyWith(
                      color: AppColors.kBlack,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Hidden TextField for input
        SizedBox(
          height: 0,
          width: 0,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            maxLength: widget.length,
            autofocus: false,
            enableSuggestions: false,
            autocorrect: false,
            showCursor: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            style: AppStyles.text14PxRegular.copyWith(
              color: AppColors.kTransparentColor,
            ),
            cursorColor: AppColors.kTransparentColor,
            onChanged: (val) {
              if (widget.validator != null) {
                setState(() {
                  if (val.length < widget.length) {
                    _errorText = "Please enter all digits";
                  } else {
                    _errorText = widget.validator!(val);
                  }
                });
              }
            },
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorText!,
              style: AppStyles.text12PxRegular.copyWith(
                color: widget.errorColor,
              ),
            ),
          ),
      ],
    );
  }
}
