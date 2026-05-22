import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';

class HunchaButton extends StatefulWidget {
  const HunchaButton({super.key});

  @override
  State<HunchaButton> createState() => _HunchaButtonState();
}

class _HunchaButtonState extends State<HunchaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TutorialBloc, TutorialState>(
      buildWhen: (previous, current) =>
          previous.showHunchButton != current.showHunchButton,
      builder: (context, state) {
        if (!state.showHunchButton) {
          _controller.stop();
          return const SizedBox.shrink();
        }
        if (!_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }

        return GestureDetector(
          onTap: () {
            context.read<TutorialBloc>().add(
              const TutorialEvent.hunchaButtonPressed(),
            );
          },
          child: ScaleTransition(
            scale: _animation,
            child: SvgPicture.asset(
              'assets/tea_maker/svg/huncha.svg',
              height: size.height * 0.2,
              width: size.height * 0.2,
            ),
          ),
        );
      },
    );
  }
}
