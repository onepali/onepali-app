import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';

class LeopardWithTea extends StatelessWidget {
  const LeopardWithTea({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    final topIngredientBarHeight = size.height * 0.25;
    final topClearance = size.height * (isMobile ? 0.04 : 0.02);
    final imageHeight = size.height - topIngredientBarHeight - topClearance;

    return BlocBuilder<TutorialBloc, TutorialState>(
      builder: (context, state) {
        final image = isMobile
            ? state.leopardTakingTeaMb
            : state.leopardTakingTeaTb;
        return state.showLeopardWithTea && image?.isNotEmpty == true
            ? SvgPicture.network(image!, height: imageHeight)
            : const SizedBox.shrink();
      },
    );
  }
}
