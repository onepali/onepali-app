# Choose Correct Template

- Type: `choose_correct`
- View: `lib/src/features/lessons/templates/choose_correct/choose_correct_lesson_view.dart`
- Logic: `lib/src/features/lessons/templates/choose_correct/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart`

## Variables (`ChooseCorrectLessonContent`)
- `id`, `index`, `type`
- `items` (`List<Item>`)

## UI
- Displays multiple choices from `items`.
- User taps an option, bloc validates correct/wrong and controls progression.
