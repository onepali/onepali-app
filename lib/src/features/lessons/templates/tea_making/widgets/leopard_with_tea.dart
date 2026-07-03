import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/src.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';

class LeopardWithTea extends StatelessWidget {
  const LeopardWithTea({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TutorialBloc, TutorialState>(
      builder: (context, state) {
        final image = PlatformUtility.isMobile(context)
            ? state.content?.leopardTakingTeaMb
            : state.content?.leopardTakingTeaTb;
        if (state.status != TutorialStatus.instructionPlaying ||
            image == null ||
            image.isEmpty) {
          return SizedBox.shrink();
        }
        return SvgPicture.network(image, height: size.height * 0.5);
      },
    );
  }
}
