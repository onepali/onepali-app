# Grid-Based Positioning System - Implementation Proposal

## System Design

### Grid Configuration
- **Grid Size**: 16 columns (X) × 8 rows (Y)
- **Grid covers**: The usable area (startX to startX+usableWidth, startY to startY+usableHeight)
- **Grid cells**: Each cell = (usableWidth/16) × (usableHeight/8)

### Coordinate Systems

#### TAP TARGET System:
- Uses: `startX`, `startY`, `usableWidth`, `usableHeight`
- Grid covers: The park scene area

#### DRAG TO MATCH Target System:
- Uses: `startX`, `startY`, `usableWidth`, `usableHeight` (similar to tap_target)
- Grid covers: The park scene area

#### DRAG TO MATCH Draggable System:
- Uses: `startX`, `bottomY`, `usableWidth` (different Y reference point)
- Grid covers: Bottom area (needs separate grid or Y offset calculation)

## Grid Position Mapping

### Conversion Functions:
```dart
// Convert grid coordinates to pixel position
double gridToX(int gridX, double startX, double usableWidth) {
  return startX + (gridX * usableWidth / 16);
}

double gridToY(int gridY, double startY, double usableHeight) {
  return startY + (gridY * usableHeight / 8);
}

// Convert pixel position to grid coordinates
int positionToGridX(double left, double startX, double usableWidth) {
  return ((left - startX) / (usableWidth / 16)).round().clamp(0, 15);
}

int positionToGridY(double top, double startY, double usableHeight) {
  return ((top - startY) / (usableHeight / 8)).round().clamp(0, 7);
}
```

## Proposed Grid Coordinates

### TAP TARGET Positions (gridX, gridY):

| Animal | Mobile | Tablet Landscape | Notes |
|--------|--------|------------------|-------|
| Rabbit | (12, 5) | (15, 5) | Bottom right |
| Dog | (2, 3) | (2, 2) | Left side |
| Cat | (9, 4) | (10, 3) | Center-left |
| Fish | (4, 7) | (3, 6) | Bottom center |
| Bird | (1, 0) | (1, 0) | Top left |
| Tortoise | (8, 7) | (8, 7) | Bottom right |

### DRAG TO MATCH Target Positions (gridX, gridY):

| Animal | Mobile | Tablet Landscape | Notes |
|--------|--------|------------------|-------|
| Dog | (2, 3) | (2, 2) | Left side |
| Fish | (4, 7) | (3, 7) | Bottom |
| Rabbit | (9, 7) | (9, 7) | Bottom right |
| Bird | (2, 0) | (2, 0) | Top |
| Cat | (10, 4) | (10, 4) | Center-right |
| Tortoise | (8, 7) | (7, 7) | Bottom right |

### DRAG TO MATCH Draggable Positions:

**Note**: Draggables use `bottomY` as reference, so we need a different approach:
- Option 1: Use same grid but calculate Y from bottomY
- Option 2: Use separate grid for bottom area
- Option 3: Convert bottomY-based positions to startY-based grid

**Proposed**: Use gridX for X, and for Y, calculate relative to bottomY:
```dart
// For draggables, Y is relative to bottomY
double gridToYFromBottom(int gridY, double bottomY, double usableHeight) {
  // gridY 0 = top of bottom area, gridY 7 = bottom
  // We need to map this to actual screen Y
  // Assuming bottom area is ~20% of screen height
  double bottomAreaHeight = usableHeight * 0.2;
  return bottomY - (bottomAreaHeight * (7 - gridY) / 7);
}
```

## Benefits of Grid System:
1. **Systematic**: All positions defined in one place
2. **Maintainable**: Easy to adjust positions by changing grid coordinates
3. **Consistent**: Same grid system across tap_target and drag_to_match
4. **Responsive**: Automatically scales with screen size
5. **Visual**: Can overlay grid for debugging

## Implementation Steps:
1. Create helper class `GridPositionHelper` with conversion functions
2. Define grid coordinates as constants (Map<String, Map<String, List<int>>>)
3. Replace hardcoded percentage calculations with grid-based calculations
4. Test on mobile and tablet to ensure positions match current layout
5. Optionally add debug mode to visualize grid overlay

## Next Steps:
- Review these calculations
- Confirm grid coordinates match desired positions
- Proceed with implementation

