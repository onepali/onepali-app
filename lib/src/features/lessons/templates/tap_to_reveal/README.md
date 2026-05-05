# Tap To Reveal Template

- Type: `tap_to_reveal`
- View: `lib/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_view.dart`
- Logic: `lib/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart`

## Variables (`TapToRevealLessonContent`)
- `id`, `index`, `type`
- `bgImage`, `bgImageTb`
- `items` (`List<Item>`)

## UI
- Shows positioned items on a background scene.
- Question audio asks user to find a target item.
- Taps are validated by bloc; correct/wrong feedback animations and audio are played.
