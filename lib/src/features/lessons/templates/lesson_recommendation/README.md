# Lesson Recommendation Template

- Type: `lesson_recommendation`
- View: `lib/src/features/lessons/views/lesson_recommendation_view.dart`
- Logic: view-driven (no dedicated bloc in lesson page)

## Variables (`LessonRecommendationLessonContent`)
- `id`, `index`, `type`
- `bgColor`
- `lessons` (`List<Map<String, dynamic>>`, typically lesson `id` + `image`)

## UI
- Shows recommended next lessons at lesson end.
- User can navigate to suggested lesson cards.
