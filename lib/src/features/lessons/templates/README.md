# Lesson Templates

This folder documents each lesson content type as a reusable template.

Each template folder contains:
- lesson type key (`type` in `LessonContent`)
- primary view file
- primary logic file (bloc or equivalent)
- data variables used by UI
- UI behavior summary

## Templates

- `intro`
- `info`
- `choose_correct`
- `tap_to_reveal`
- `drag_to_match`
- `tap_to_pop`
- `listen_and_repeat`
- `char_tracing`
- `tea_making`
- `ball_slide`
- `flip_card`
- `slide_up_to_match`
- `balloon_fill`
- `gun_fill`
- `holi_animate`
- `tap_to_change`
- `tap_to_fill`
- `option_selection`
- `put_in_bag`
- `tap_the_button`
- `lesson_recommendation`

## Source of Truth

- Models: `lib/src/features/lessons/models/lesson.dart`
- Content routing: `lib/src/features/lessons/pages/lesson_page.dart`

When adding a new lesson type:
1. Add union variant in `LessonContent`.
2. Add routing case in `lesson_page.dart`.
3. Add or map view + logic.
4. Add a new template folder with `README.md` in this directory.
