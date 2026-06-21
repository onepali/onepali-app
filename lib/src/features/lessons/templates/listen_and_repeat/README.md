# Listen And Repeat Template

- Type: `listen_and_repeat`
- View: `lib/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_view.dart`
- Logic: `lib/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_bloc/listen_and_repeat_bloc.dart`

## Variables (`ListenAndRepeatLessonContent`)
- `id`, `index`, `type`
- `nameEn`, `nameNp`
- `audioWord`, `audioBg`
- `bgImage`, `bgColor`
- `image`, `charImage`, `isImageSvg`

## UI
- Plays word audio, records learner voice, compares/replays as needed.
- Bloc coordinates playback, recording lifecycle, and result state.
