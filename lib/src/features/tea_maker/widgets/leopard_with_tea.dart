import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/features/tea_maker/bloc/tutorial_bloc.dart';

class LeopardWithTea extends StatelessWidget {
  const LeopardWithTea({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TutorialBloc, TutorialState>(
      builder: (context, state) {
        return state.showLeopardWithTea
            ? SvgPicture.asset(
                'assets/tea_maker/svg/leopard_with_tea.svg',
                height: size.height * 0.5,
              )
            : SizedBox.shrink();
      },
    );
  }
}
