import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';

class BearWithTea extends StatelessWidget {
  const BearWithTea({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TutorialBloc, TutorialState>(
      builder: (context, state) {
        return state.status == TutorialStatus.instructionPlaying
            ? SvgPicture.asset(
                'assets/tea_maker/svg/bear_with_tea.svg',
                height: size.height * 0.5,
              )
            : SizedBox.shrink();
      },
    );
  }
}
