# Tea Making Template

- Type: `tea_making`
- View: `lib/src/features/lessons/templates/tea_making/pages/kitchen_page.dart`
- Logic: feature-specific tea-making state/logic inside this lesson template

## Variables (`TeaMakingLessonContent`)
- `id`, `index`, `type`
- `audioInstruction`
- `teapotVapour`, `stoveImage`
- `abaPaniUmalaSound`, `teaReadySound`
- `dragIndicator`
- `hunchaButton`
- `hunchaButtonAudio`
- `checkIcon`
- `leopardTakingTeaTb`, `leopardTakingTeaMb`
- `ingredients` (`List<Item>`)
  - Items are sorted by `order`.
  - Items with `image` and `image_outline` are draggable.
  - The first ordered item without draggable media provides the boil-step label.

## UI
- Simulates a step-based tea making activity.
- Ingredient placement and animated kitchen sequence are driven by tea maker logic.
