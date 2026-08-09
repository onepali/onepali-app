import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/core/widget/common/speaker_icon.dart';
import 'package:onepali/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_bloc/listen_and_repeat_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/mic_progress_button.dart';

class ListenAndRepeatView extends StatefulWidget {
  const ListenAndRepeatView({
    super.key,
    required this.content,
    required this.onCompleted,
  });
  final ListenAndRepeatLessonContent content;
  final VoidCallback onCompleted;

  @override
  State<ListenAndRepeatView> createState() => _ListenAndRepeatViewState();
}

class _ListenAndRepeatViewState extends State<ListenAndRepeatView>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListenAndRepeatBloc>().add(
        ListenAndRepeatEvent.started(widget.content),
      );
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<ListenAndRepeatBloc, ListenAndRepeatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideIn,
              child: Stack(
                children: [
                  LessonContentFrame(
                    builder: (context, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Gaps.verticalGapOf(size.height * 0.1),
                          const Spacer(),
                          _buildCenterContent(
                            context,
                            widget.content.charImage ?? '',
                            widget.content.image ?? '',
                          ),
                          const Spacer(),
                          _buildMicSection(),
                          Gaps.verticalGapOf(size.height * 0.1),
                        ],
                      );
                    },
                  ),

                  TopRightPositionedCloseButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),

                  if (state.isRecorded)
                    CenterRightAlignedForwardButton(onTap: widget.onCompleted),

                  Positioned(
                    top: isMobile ? 24 : 32,
                    left: lessonContentInsetStart(context),
                    right: lessonContentInsetEnd(context),
                    child: Center(
                      child: SpeakerIcon(
                        onTap: state.isRecorded || state.hasError
                            ? () => context.read<ListenAndRepeatBloc>().add(
                                const ListenAndRepeatEvent.retryRequested(),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterContent(
    BuildContext context,
    String charImage,
    String imageUrl,
  ) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return BlocBuilder<ListenAndRepeatBloc, ListenAndRepeatState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.network(
                  charImage,
                  width: isMobile ? size.width * 0.15 : size.width * 0.25,
                  height: isMobile ? size.width * 0.15 : size.width * 0.25,
                ),
              ),

              SizedBox(width: size.width * 0.12),
              SvgPicture.network(
                imageUrl,
                width: isMobile ? size.width * 0.15 : size.width * 0.25,
                height: isMobile ? size.width * 0.15 : size.width * 0.25,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMicSection() {
    return BlocBuilder<ListenAndRepeatBloc, ListenAndRepeatState>(
      builder: (context, state) {
        return Column(
          children: [
            MicProgressButton(
              recordingDuration: state.recordingDuration,
              isActive: state.isRecording,
              isCompleted: state.isRecorded,
              onCompletedTap: widget.onCompleted,
            ),
            if (state.hasError) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.read<ListenAndRepeatBloc>().add(
                  const ListenAndRepeatEvent.retryRequested(),
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        );
      },
    );
  }
}
