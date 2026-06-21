# Tap To Fill Template

- Type: `tap_to_fill`
- View: `lib/src/features/lessons/templates/tap_to_fill/tap_to_fill_view.dart`
- Logic: `lib/src/features/lessons/templates/tap_to_fill/tap_to_fill_bloc/tap_to_fill_bloc.dart`

## Variables (`TapToFillLessonContent`)
- `id`, `index`, `type`
- `instruction`
- `bgImage`, `bgImageTb`
- `options` (`List<Option>`)

## UI
- Shows sentence/context with tappable options to fill blanks.
- Bloc validates option selection and controls next-step progression.
