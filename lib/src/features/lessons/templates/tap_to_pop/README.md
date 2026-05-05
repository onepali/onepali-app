# Tap To Pop Template

- Type: `tap_to_pop`
- View: `lib/src/features/lessons/templates/tap_to_pop/tap_to_pop_lesson_view.dart`
- Logic: `lib/src/features/lessons/templates/tap_to_pop/tap_to_pop_bloc/tap_to_pop_bloc.dart`

## Variables (`TapToPopLessonContent`)
- `id`, `index`, `type`
- `bgImage`, `bgColor`
- `successImage`
- `audioWord`, `instructionAudio`
- `items` (`List<Item>`)

## UI
- Renders tappable floating items/bubbles.
- User taps based on instruction audio; bloc drives score/progress/success state.
