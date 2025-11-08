# Grid-Based Positioning System - Clarified

## Grid Cell Size Calculation

### Important: Grid is based on USABLE AREA, not full screen

The grid covers the **usable area** which is already calculated to fit within the screen with proper margins.

### Grid Cell Dimensions:
```
cellWidth = usableWidth / 16
cellHeight = usableHeight / 8
```

### Example Calculations:

#### Mobile (screenWidth=400, screenHeight=800):
- marginX = 400 * 0.05 = 20px
- marginY = 800 * 0.15 = 120px
- usableWidth = 400 * 0.9 = 360px
- usableHeight = 800 * 0.5 = 400px
- **cellWidth = 360 / 16 = 22.5px**
- **cellHeight = 400 / 8 = 50px**
- Grid covers: (20, 120) to (380, 520) - all within screen bounds ✓

#### Tablet Landscape (screenWidth=1024, screenHeight=768):
- marginX = 1024 * 0.08 = 81.92px
- marginY = 768 * 0.12 = 92.16px
- usableWidth = 1024 * 0.85 = 870.4px
- usableHeight = 768 * 0.7 = 537.6px
- **cellWidth = 870.4 / 16 = 54.4px**
- **cellHeight = 537.6 / 8 = 67.2px**
- Grid covers: (81.92, 92.16) to (952.32, 629.76) - all within screen bounds ✓

## Grid Coverage

The grid covers the **usable area** which is:
- **X range**: startX to (startX + usableWidth)
- **Y range**: startY to (startY + usableHeight)

This ensures:
1. All positions are within screen bounds (margins already accounted for)
2. Grid cells scale proportionally with screen size
3. Animals and outlines fit within the grid area

## Position Conversion

### Grid to Pixel:
```dart
double gridToX(int gridX, double startX, double usableWidth) {
  // Clamp gridX to valid range [0, 15]
  gridX = gridX.clamp(0, 15);
  return startX + (gridX * usableWidth / 16);
}

double gridToY(int gridY, double startY, double usableHeight) {
  // Clamp gridY to valid range [0, 7]
  gridY = gridY.clamp(0, 7);
  return startY + (gridY * usableHeight / 8);
}
```

### Pixel to Grid:
```dart
int positionToGridX(double left, double startX, double usableWidth) {
  double relativeX = left - startX;
  int gridX = (relativeX / (usableWidth / 16)).round();
  return gridX.clamp(0, 15);
}

int positionToGridY(double top, double startY, double usableHeight) {
  double relativeY = top - startY;
  int gridY = (relativeY / (usableHeight / 8)).round();
  return gridY.clamp(0, 7);
}
```

## Grid Boundaries

- **X coordinates**: 0 to 15** (16 columns)
- **Y coordinates**: 0 to 7 (8 rows)
- **All positions clamped**: Ensures nothing goes outside usable area
- **Grid cells scale**: Automatically adjust to screen size

## Current Position Mapping (Validated)

### TAP TARGET - All positions within grid [0-15, 0-7]:

| Animal | Mobile Grid | Tablet Grid | Status |
|--------|-------------|-------------|--------|
| Rabbit | (12, 5) | (15, 5) | ✓ Valid |
| Dog | (2, 3) | (2, 2) | ✓ Valid |
| Cat | (9, 4) | (10, 3) | ✓ Valid |
| Fish | (4, 7) | (3, 6) | ✓ Valid |
| Bird | (1, 0) | (1, 0) | ✓ Valid |
| Tortoise | (8, 7) | (8, 7) | ✓ Valid |

### DRAG TO MATCH Targets - All positions within grid [0-15, 0-7]:

| Animal | Mobile Grid | Tablet Grid | Status |
|--------|-------------|-------------|--------|
| Dog | (2, 3) | (2, 2) | ✓ Valid |
| Fish | (4, 7) | (3, 7) | ✓ Valid |
| Rabbit | (9, 7) | (9, 7) | ✓ Valid |
| Bird | (2, 0) | (2, 0) | ✓ Valid |
| Cat | (10, 4) | (10, 4) | ✓ Valid |
| Tortoise | (8, 7) | (7, 7) | ✓ Valid |

## Draggable Items Special Case

Draggables use `bottomY` reference point, which is:
- `bottomY = screenHeight * 0.8`
- This is still within screen bounds
- We can map this to grid coordinates by:
  1. Calculate relative Y from bottomY
  2. Convert to grid Y coordinate
  3. Or use a separate grid system for bottom area

## Implementation Safety

All grid coordinates are:
- **Clamped to [0, 15]** for X (16 columns)
- **Clamped to [0, 7]** for Y (8 rows)
- **Converted to pixels** using usableWidth/usableHeight
- **Added to startX/startY** to get final screen position
- **Guaranteed to fit** within screen bounds

## Summary

✅ Grid cell size = usableWidth/16 × usableHeight/8
✅ Grid covers usable area (already within screen bounds)
✅ All animals and outlines will fit within screen
✅ Grid scales automatically with screen size
✅ Positions are clamped to valid grid coordinates

