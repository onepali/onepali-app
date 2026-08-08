import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
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

  Widget _buildButtonImage(String imageUrl) {
    if (isSvgMediaUrl(imageUrl)) {
      return SvgPicture.network(imageUrl, fit: BoxFit.contain);
    }
    return CustomCachedImage(imageUrl: imageUrl, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialBloc, TutorialState>(
      builder: (context, state) {
        if (!state.showHunchButton) {
          _controller.stop();
          return const SizedBox.shrink();
        }
        if (state.hunchaButton?.isNotEmpty != true) {
          _controller.stop();
          return const SizedBox.shrink();
        }
        if (!_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }

        return SizedBox(
          width: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: () {
                context.read<TutorialBloc>().add(
                  const TutorialEvent.hunchaButtonPressed(),
                );
              },
              child: ScaleTransition(
                scale: _animation,
                child: SizedBox.square(
                  dimension: 172,
                  child: _buildButtonImage(state.hunchaButton!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
