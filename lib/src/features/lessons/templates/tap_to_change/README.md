# Tap To Change Template

- Type: `tap_to_change`
- View: `lib/src/features/lessons/templates/tap_to_change/tap_to_change_view.dart`
- Logic: `lib/src/features/lessons/templates/tap_to_change/tap_to_change_bloc/tap_to_change_bloc.dart`

## Variables (`TapToChangeLessonContent`)
- `id`, `index`, `type`
- `audio`
- `bgImage`, `afterBgImage`
- `bgImageTb`, `afterBgImageTb`
- `tapGesture`, `splashImage`
- `items` (`List<Item>`)

## UI
- User taps target area to transform scene from before -> after assets.
- Bloc manages tap events, state transitions, and completion trigger.
