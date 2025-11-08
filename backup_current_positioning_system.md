# Backup: Current Positioning System Implementation

## Date: Before Grid System Implementation

This document preserves the current percentage-based positioning system before implementing the grid-based approach.

## TAP TARGET - Current Implementation

### File: `tap_target_lesson_card.dart`
### Method: `_getTargetPositions()`

```dart
List<Map<String, double>> _getTargetPositions(
  double screenWidth,
  double screenHeight,
  bool isMobile,
) {
  final isTablet = PlatformUtility.isTablet(context);
  final isLandscape = PlatformUtility.isLandscape(context);

  // Adjust margins and usable space based on device type
  final double marginX, marginY, usableWidthPercent, usableHeightPercent;

  if (isMobile) {
    marginX = screenWidth * 0.05; // 5% margin
    marginY = screenHeight * 0.15; // 15% from top
    usableWidthPercent = 0.9; // 90% of width
    usableHeightPercent = 0.5; // 50% of height
  } else {
    // Tablet handling
    marginX = screenWidth * 0.08; // 8% margin
    marginY = isLandscape ? screenHeight * 0.12 : screenHeight * 0.18;
    usableWidthPercent = isLandscape ? 0.85 : 0.82;
    usableHeightPercent = isLandscape ? 0.7 : 0.55;
  }

  final double usableWidth = screenWidth * usableWidthPercent;
  final double usableHeight = screenHeight * usableHeightPercent;
  final double startX = marginX;
  final double startY = marginY;

  return [
    // Rabbit position (bottom right, on grass, butt all the way to the right end)
    {
      'left': startX + usableWidth * (isMobile ? 0.75 : (isTablet && isLandscape ? 0.95 : 0.95)),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.65 : 0.6),
    },

    // Dog position (left side, on grass, lowered further - only on mobile)
    {
      'left': startX + usableWidth * (isTablet && isLandscape ? 0.12 : 0.12),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.30 : 0.28) + (isMobile ? screenHeight * 0.025 : 0),
    },

    // Cat position (center-left, near trees, moved a bit to the right)
    {
      'left': startX + usableWidth * (isTablet && isLandscape ? 0.62 : 0.58),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.4 : 0.46),
    },

    // Fish position (in water area - bottom center)
    {
      'left': startX + usableWidth * (isTablet && isLandscape ? 0.18 : 0.22),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.8 : 1.05),
    },

    // Bird position (on tree branch - top area)
    {
      'left': startX + usableWidth * (isTablet && isLandscape ? 0.04 : 0.07),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.015 - 0.05 : 0.01 - 0.18),
    },

    // Tortoise position (right side on grass, not in water - only adjusted on mobile)
    {
      'left': startX + usableWidth * (isMobile ? 0.48 : (isTablet && isLandscape ? 0.50 : 0.50)),
      'top': startY + usableHeight * (isTablet && isLandscape ? 0.85 : 0.94),
    },

    // Additional positions for more animals
    {'left': startX + usableWidth * 0.45, 'top': startY + usableHeight * 0.3},
    {'left': startX + usableWidth * 0.6, 'top': startY + usableHeight * 0.6},
  ];
}
```

### Image Size Calculation:
```dart
double _getTargetSizeForAnimal(String animalId, bool isMobile) {
  final isLandscape = PlatformUtility.isLandscape(context);
  
  final double baseSize;
  if (isMobile) {
    baseSize = 80.0;
  } else {
    baseSize = isLandscape ? 150.0 : 80.0;
  }

  switch (animalId.toLowerCase()) {
    case 'rabbit': return baseSize * 1.75;
    case 'cat': return baseSize * 1.55;
    case 'dog': return baseSize * 2.35;
    case 'fish': return baseSize * 1.15;
    case 'bird': return baseSize * 1.15;
    case 'tortoise': return baseSize * 1.15;
    default: return baseSize;
  }
}
```

## DRAG TO MATCH - Current Implementation

### File: `drag_to_match_lesson_card.dart`
### Method: `_getDragTargetPositions()`

```dart
List<Map<String, double>> _getDragTargetPositions(
  double screenWidth,
  double screenHeight,
  bool isMobile,
) {
  final double usableWidth = screenWidth * 0.9;
  final double usableHeight = screenHeight * 0.5;
  final double startX = screenWidth * 0.05;
  final double startY = screenHeight * 0.15;
  final isTabletLandscape = !isMobile && 
      PlatformUtility.isTablet(context) && 
      PlatformUtility.isLandscape(context);
      
  return [
    // Dog - moved a bit to the right
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.10 : 0.10),
      'top': startY + usableHeight * (isTabletLandscape ? 0.30 : 0.28) + (isMobile ? screenHeight * 0.025 : 0),
    },
    
    // Fish
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.18 : 0.22),
      'top': startY + usableHeight * (isTabletLandscape ? 1.15 : 1.08),
    },
    
    // Rabbit - moved further to the right
    {
      'left': startX + usableWidth * (isMobile ? 0.58 : (isTabletLandscape ? 0.56 : 0.58)),
      'top': startY + usableHeight * (isTabletLandscape ? 1.05 : 1.05),
    },
    
    // Bird
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.15 : 0.15),
      'top': startY + usableHeight * (isTabletLandscape ? 0.015 - 0.07 : 0.015 - 0.19),
    },
    
    // Cat - right side, moved a bit more to the right
    {
      'left': startX + usableWidth * (isMobile ? 0.60 : (isTabletLandscape ? 0.64 : 0.64)),
      'top': startY + usableHeight * (isTabletLandscape ? 0.52 : 0.47),
    },
    
    // Tortoise
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.46 : 0.48),
      'top': startY + usableHeight * (isTabletLandscape ? 1.05 : 1.05),
    },
  ];
}
```

### Method: `_getDraggableItemPositions()`

```dart
List<Map<String, double>> _getDraggableItemPositions(
  double screenWidth,
  double screenHeight,
  bool isMobile,
) {
  final double marginX, usableWidthPercent, safetyMarginX;

  if (isMobile) {
    marginX = screenWidth * 0.02;
    usableWidthPercent = 0.96;
    safetyMarginX = screenWidth * 0.01;
  } else {
    marginX = screenWidth * 0.03;
    usableWidthPercent = 0.94;
    safetyMarginX = screenWidth * 0.02;
  }

  final double usableWidth = screenWidth * usableWidthPercent;
  final double startX = marginX + safetyMarginX;
  final double bottomY = screenHeight * 0.8;
  final isTabletLandscape = !isMobile &&
      PlatformUtility.isTablet(context) &&
      PlatformUtility.isLandscape(context);
      
  return [
    // Dog - moved further to the left
    {
      'left': startX + usableWidth * (isTabletLandscape ? -0.05 : -0.05),
      'top': bottomY * (isTabletLandscape ? 0.90 : 0.80) + (isMobile ? screenHeight * 0.025 : 0),
    },
    
    // Fish
    {
      'left': startX + usableWidth * (isMobile ? 0.74 : (isTabletLandscape ? 0.72 : 0.72)),
      'top': bottomY * (isTabletLandscape ? 0.15 : 0.23),
    },
    
    // Rabbit - right side, butt all the way to the right end
    {
      'left': startX + usableWidth * (isMobile ? 0.78 : (isTabletLandscape ? 0.95 : 0.95)),
      'top': bottomY * (isTabletLandscape ? 0.45 : 0.45),
    },
    
    // Bird
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.0 : 0.0),
      'top': bottomY * (isTabletLandscape ? 0.55 : 0.5),
    },
    
    // Cat
    {
      'left': startX + usableWidth * (isTabletLandscape ? 0.05 : 0.05),
      'top': bottomY * (isTabletLandscape ? 0.15 : 0.1),
    },
    
    // Tortoise - right side, moved a bit more left (visible)
    {
      'left': startX + usableWidth * (isMobile ? 0.85 : (isTabletLandscape ? 0.87 : 0.87)),
      'top': bottomY * (isTabletLandscape ? 0.88 : 0.88),
    },
  ];
}
```

### Image Size Calculation:
```dart
double _getTargetSizeForItem(String itemId, bool isMobile) {
  final baseSizeMobile = isMobile ? 70.0 : 140.0;
  
  switch (itemId.toLowerCase()) {
    case 'rabbit': return baseSizeMobile * (isMobile ? 1.75 : 1.55);
    case 'cat': return baseSizeMobile * 1.75;
    case 'dog': return baseSizeMobile * 2.85;
    case 'fish': return baseSizeMobile * 1.15;
    case 'bird': return baseSizeMobile * 1.15;
    case 'tortoise': return baseSizeMobile * 1.15;
    default: return baseSizeMobile;
  }
}

double _getDraggableItemSizeForItem(String itemId, bool isMobile) {
  final targetSize = _getTargetSizeForItem(itemId, isMobile);
  final isDog = itemId.toLowerCase() == 'dog';
  final isFish = itemId.toLowerCase() == 'fish';
  final size = isDog
      ? targetSize * (isMobile ? 0.55 : 0.5)
      : isFish
      ? targetSize * (isMobile ? 0.85 : 1.05)
      : targetSize * 0.85;
  return size;
}
```

## Notes:
- All positions use percentage-based calculations relative to usableWidth/usableHeight
- Image sizes use fixed pixel values (80px mobile, 150px tablet)
- Positions are calculated dynamically based on screen dimensions
- Different logic for mobile vs tablet, portrait vs landscape



