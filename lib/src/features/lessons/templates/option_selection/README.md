# Option Selection Template

- Type: `option_selection`
- View: `lib/src/features/lessons/templates/option_selection/option_selection_view.dart`
- Logic: `lib/src/features/lessons/templates/option_selection/option_selection_bloc/option_slection_bloc.dart`

## Variables (`OptionSelectionLessonContent`)
- `id`, `index`, `type`
- `image`
- `instruction`
- `bgImage`, `bgImageTb`
- `options` (`List<Option>`)

## UI
- User selects the best option from provided options list.
- Bloc handles selection, correctness, and navigation readiness.
