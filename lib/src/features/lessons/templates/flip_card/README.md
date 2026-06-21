# Flip Card Template

- Type: `flip_card`
- View: `lib/src/features/lessons/templates/flip_card/flip_card_view.dart`
- Logic: view-driven (no dedicated bloc in lesson page)

## Variables (`FlipCardLessonContent`)
- `id`, `index`, `type`
- `bgImage`
- `items` (`List<Item>`)

## UI
- Renders cards that can be flipped to reveal content.
- Completion flow is handled by view-level interaction logic.
