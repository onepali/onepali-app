# Put In Bag Template

- Type: `put_in_bag`
- View: `lib/src/features/lessons/templates/put_in_bag/put_in_bag_view.dart`
- Logic: `lib/src/features/lessons/templates/put_in_bag/put_in_bag_bloc/put_in_bag_bloc.dart`

## Variables (`PutInBagLessonContent`)
- `id`, `index`, `type`
- `onlyOneChoice`
- `instructionAudio`
- `bagImage`
- `bgColor`, `bgImage`, `bgImageTb`
- `items` (`List<Item>`)
- `topBagPaddingRatio`

## UI
- User taps/drags valid items into bag region.
- Bloc tracks selected items, validates rule (`onlyOneChoice`), and handles completion.
