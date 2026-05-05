# Conversation Template

- Type: used by `ball_slide` when `direction` is `none`
- View: `lib/src/features/lessons/templates/conversation/conversation_view.dart`
- Logic: view-driven conversation playback (no dedicated bloc)

## Variables (`BallSlideLessonContent`)
- `conversation` (`List<String>`) audio sequence
- `bgImageMobile`, `bgImageTablet`
- `message` (optional completion text)

## UI
- Plays conversation audio clips in sequence.
- Shows background scene while audio runs and allows user to proceed afterward.
