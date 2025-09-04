# Tap Target Lesson Card Implementation

## Overview
The `TapTargetLessonCard` widget has been implemented to handle `tap_target` type lessons with an interactive park scene animation. This implementation follows the exact flow specifications provided.

## Features Implemented

### Core Flow
1. **Step 1**: Automatically plays the Nepali audio question (`word_audio`) when the lesson starts
2. **Step 2**: Child hears the voice, sees the animals in a park scene, and taps the correct animal
3. **Step 3**: When child taps an animal, they hear the animal name audio (`audio`) and see the Nepali letter name (`name_np`) appear on top
4. **Step 4**: Shows mini feedback with audio, lottie star animation, and text with Nepali name for correct answers

### Additional Features
- **Wrong Answer Handling**: When clicking other animals, the child hears the word in Nepali without mini feedback
- **Reminder System**: After 3 wrong attempts, the system replays the question audio and shows a hint animation on the correct target
- **Haptic Feedback**: Light vibration on animal tap for better user experience
- **Responsive Design**: Adapts to mobile, tablet, and web platforms
- **Natural Positioning**: Animals are positioned naturally across the park scene

## Technical Implementation

### File Structure
```
lib/src/screen/course/lesson/widget/
├── lesson_content_screen.dart (updated)
├── tap_target_lesson_card.dart (new)
└── tap_send_lesson_card.dart (existing)
```

### Integration Points
The widget integrates seamlessly with the existing lesson system:

1. **lesson_content_screen.dart**: Updated to detect `tap_target` type and render the appropriate widget
2. **Responsive handling**: Maintains consistency with existing responsive design patterns
3. **Audio management**: Uses the existing `LessonAudioProvider` and `CustomAudioWidget` infrastructure
4. **Progress tracking**: Integrates with existing progress saving mechanisms

### Data Structure Requirements
The widget expects the following data structure in the lesson content:

```json
{
  "type": "tap_target",
  "word_audio": "url_to_question_audio.mp3",
  "text": "बिरालो कहाँ छ?",
  "mb_image": "url_to_mobile_background.svg",
  "tb_image": "url_to_tablet_background.svg", 
  "tap_targets": [
    {
      "id": "cat",
      "name_en": "Cat",
      "name_np": "बिरालो",
      "image": "url_to_cat_image.svg",
      "audio": "url_to_cat_audio.mp3"
    }
  ],
  "correct_answer_id": "cat",
  "feedback": {
    "correct": {
      "audio": "url_to_success_audio.mp3",
      "text": "ठिक छ",
      "animation": "star_pop"
    },
    "incorrect": {
      "audio": "url_to_error_audio.mp3", 
      "text": "फेरि प्रयास गर्नुहोस्"
    },
    "reminder_after_attempts": 3
  }
}
```

### Animation System
The widget includes multiple animation controllers:

1. **_feedbackController**: Handles success feedback animations (star appearance)
2. **_textController**: Manages Nepali text appearance animation
3. **_hintController**: Controls hint bounce animation for correct target after 3 wrong attempts

### Responsive Design
Animal positioning adapts based on screen size:
- **Mobile**: Smaller animal sizes (60px), optimized spacing
- **Tablet/Desktop**: Larger animal sizes (80px), expanded layout
- **Background**: Uses different background images for mobile (`mb_image`) and tablet (`tb_image`)

### Audio Management
- **Question Audio**: Plays automatically when lesson starts
- **Target Audio**: Plays when any animal is tapped  
- **Feedback Audio**: Plays for correct/incorrect responses
- **Disposal**: All audio widgets are properly disposed to prevent memory leaks

## Usage
The widget is automatically used when a lesson content has `type: "tap_target"`. No manual integration is required - the `LessonContentScreen` will automatically detect and render the appropriate widget.

## Testing
To test the implementation:
1. Ensure your lesson data includes `tap_target` type content with the required structure
2. Navigate to a lesson containing this content type
3. Verify the flow: question audio → animal tapping → feedback system → completion

## Consistency with Existing Code
The implementation maintains full consistency with:
- Existing responsive design patterns (`AppCardResponsive`, `PlatformUtility`)
- Audio management systems (`LessonAudioProvider`, `CustomAudioWidget`)
- Styling and theming (`AppStyles`, `AppColors`, `AppConstants`)
- Error handling and logging patterns
- Progress tracking and lesson completion flows
