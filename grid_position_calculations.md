# Grid-Based Positioning System Calculations

## Grid System Design
- **Grid Size**: 16 columns × 8 rows (16x8)
- **Grid covers**: usableWidth × usableHeight area
- **Grid cell size**: usableWidth/16 × usableHeight/8

## Position Mapping Formula
```
gridX = (left - startX) / (usableWidth / 16)
gridY = (top - startY) / (usableHeight / 8)
```

## TAP TARGET - Current Positions to Grid Mapping

### Assumptions (for calculation):
- Mobile: screenWidth=400, screenHeight=800
- Tablet Landscape: screenWidth=1024, screenHeight=768

### Mobile Calculations:
- marginX = 400 * 0.05 = 20
- marginY = 800 * 0.15 = 120
- usableWidth = 400 * 0.9 = 360
- usableHeight = 800 * 0.5 = 400
- startX = 20
- startY = 120
- cellWidth = 360/16 = 22.5
- cellHeight = 400/8 = 50

### Tablet Landscape Calculations:
- marginX = 1024 * 0.08 = 81.92
- marginY = 768 * 0.12 = 92.16
- usableWidth = 1024 * 0.85 = 870.4
- usableHeight = 768 * 0.7 = 537.6
- startX = 81.92
- startY = 92.16
- cellWidth = 870.4/16 = 54.4
- cellHeight = 537.6/8 = 67.2

## TAP TARGET Positions:

### Rabbit:
- Mobile: left = 20 + 360*0.75 = 290, top = 120 + 400*0.6 = 360
  - gridX = (290-20)/22.5 = 12.0, gridY = (360-120)/50 = 4.8 → (12, 5)
- Tablet: left = 81.92 + 870.4*0.95 = 908.8, top = 92.16 + 537.6*0.65 = 441.6
  - gridX = (908.8-81.92)/54.4 = 15.2, gridY = (441.6-92.16)/67.2 = 5.2 → (15, 5)

### Dog:
- Mobile: left = 20 + 360*0.12 = 63.2, top = 120 + 400*0.28 + 20 = 252
  - gridX = (63.2-20)/22.5 = 1.92, gridY = (252-120)/50 = 2.64 → (2, 3)
- Tablet: left = 81.92 + 870.4*0.12 = 186.37, top = 92.16 + 537.6*0.30 = 253.44
  - gridX = (186.37-81.92)/54.4 = 1.92, gridY = (253.44-92.16)/67.2 = 2.4 → (2, 2)

### Cat:
- Mobile: left = 20 + 360*0.58 = 228.8, top = 120 + 400*0.46 = 304
  - gridX = (228.8-20)/22.5 = 9.28, gridY = (304-120)/50 = 3.68 → (9, 4)
- Tablet: left = 81.92 + 870.4*0.62 = 621.57, top = 92.16 + 537.6*0.4 = 307.2
  - gridX = (621.57-81.92)/54.4 = 9.92, gridY = (307.2-92.16)/67.2 = 3.2 → (10, 3)

### Fish:
- Mobile: left = 20 + 360*0.22 = 99.2, top = 120 + 400*1.05 = 540 (outside, needs adjustment)
  - gridX = (99.2-20)/22.5 = 3.52, gridY = (540-120)/50 = 8.4 → (4, 7) [clamped to row 7]
- Tablet: left = 81.92 + 870.4*0.18 = 238.59, top = 92.16 + 537.6*0.8 = 522.24
  - gridX = (238.59-81.92)/54.4 = 2.88, gridY = (522.24-92.16)/67.2 = 6.4 → (3, 6)

### Bird:
- Mobile: left = 20 + 360*0.07 = 45.2, top = 120 + 400*(0.01-0.18) = 120 + 400*(-0.17) = 52 (negative, needs adjustment)
  - gridX = (45.2-20)/22.5 = 1.12, gridY = max(0, (52-120)/50) = 0 → (1, 0)
- Tablet: left = 81.92 + 870.4*0.04 = 116.74, top = 92.16 + 537.6*(0.015-0.05) = 92.16 + 537.6*(-0.035) = 73.34
  - gridX = (116.74-81.92)/54.4 = 0.64, gridY = max(0, (73.34-92.16)/67.2) = 0 → (1, 0)

### Tortoise:
- Mobile: left = 20 + 360*0.48 = 192.8, top = 120 + 400*0.94 = 496
  - gridX = (192.8-20)/22.5 = 7.68, gridY = (496-120)/50 = 7.52 → (8, 7)
- Tablet: left = 81.92 + 870.4*0.50 = 517.12, top = 92.16 + 537.6*0.85 = 549.12
  - gridX = (517.12-81.92)/54.4 = 8.0, gridY = (549.12-92.16)/67.2 = 6.8 → (8, 7)

## DRAG TO MATCH - Target Positions:

### Dog (target):
- Mobile: left = 400*0.05 + 360*0.10 = 56, top = 800*0.15 + 400*0.28 + 20 = 252
  - gridX = (56-20)/22.5 = 1.6, gridY = (252-120)/50 = 2.64 → (2, 3)
- Tablet: left = 1024*0.05 + 360*0.10 = 87.2, top = 768*0.15 + 400*0.30 = 235.2
  - gridX = (87.2-20)/22.5 = 2.99, gridY = (235.2-120)/50 = 2.3 → (3, 2)

### Fish (target):
- Mobile: left = 20 + 360*0.22 = 99.2, top = 120 + 400*1.08 = 552 (outside)
  - gridX = (99.2-20)/22.5 = 3.52, gridY = min(7, (552-120)/50) = 7 → (4, 7)
- Tablet: left = 20 + 360*0.18 = 84.8, top = 120 + 400*1.15 = 580 (outside)
  - gridX = (84.8-20)/22.5 = 2.88, gridY = min(7, (580-120)/50) = 7 → (3, 7)

### Rabbit (target):
- Mobile: left = 20 + 360*0.58 = 228.8, top = 120 + 400*1.05 = 540 (outside)
  - gridX = (228.8-20)/22.5 = 9.28, gridY = min(7, (540-120)/50) = 7 → (9, 7)
- Tablet: left = 20 + 360*0.56 = 221.6, top = 120 + 400*1.05 = 540 (outside)
  - gridX = (221.6-20)/22.5 = 8.96, gridY = min(7, (540-120)/50) = 7 → (9, 7)

### Bird (target):
- Mobile: left = 20 + 360*0.15 = 74, top = 120 + 400*(0.015-0.19) = 120 + 400*(-0.175) = 50 (negative)
  - gridX = (74-20)/22.5 = 2.4, gridY = max(0, (50-120)/50) = 0 → (2, 0)
- Tablet: left = 20 + 360*0.15 = 74, top = 120 + 400*(0.015-0.07) = 120 + 400*(-0.055) = 98
  - gridX = (74-20)/22.5 = 2.4, gridY = max(0, (98-120)/50) = 0 → (2, 0)

### Cat (target):
- Mobile: left = 20 + 360*0.60 = 236, top = 120 + 400*0.47 = 308
  - gridX = (236-20)/22.5 = 9.6, gridY = (308-120)/50 = 3.76 → (10, 4)
- Tablet: left = 20 + 360*0.64 = 250.4, top = 120 + 400*0.52 = 328
  - gridX = (250.4-20)/22.5 = 10.24, gridY = (328-120)/50 = 4.16 → (10, 4)

### Tortoise (target):
- Mobile: left = 20 + 360*0.48 = 192.8, top = 120 + 400*1.05 = 540 (outside)
  - gridX = (192.8-20)/22.5 = 7.68, gridY = min(7, (540-120)/50) = 7 → (8, 7)
- Tablet: left = 20 + 360*0.46 = 185.6, top = 120 + 400*1.05 = 540 (outside)
  - gridX = (185.6-20)/22.5 = 7.36, gridY = min(7, (540-120)/50) = 7 → (7, 7)

## DRAG TO MATCH - Draggable Positions:

### Note: Draggables use different coordinate system (bottomY)
- bottomY = screenHeight * 0.8
- Mobile: bottomY = 800 * 0.8 = 640
- Tablet: bottomY = 768 * 0.8 = 614.4

### Dog (draggable):
- Mobile: left = 400*0.02 + 400*0.96*0.01 + 384*(-0.05) = 8 + 3.84 - 19.2 = -7.36 (negative!)
  - Needs adjustment: use gridX = 0
- Tablet: left = 1024*0.03 + 1024*0.94*0.02 + 962.56*(-0.05) = 30.72 + 19.25 - 48.13 = 1.84
  - gridX = (1.84 - startX) / cellWidth → needs separate calculation

## Proposed Grid Coordinates (Normalized):

### TAP TARGET Grid Positions:
- Rabbit: Mobile(12,5), Tablet(15,5)
- Dog: Mobile(2,3), Tablet(2,2)
- Cat: Mobile(9,4), Tablet(10,3)
- Fish: Mobile(4,7), Tablet(3,6)
- Bird: Mobile(1,0), Tablet(1,0)
- Tortoise: Mobile(8,7), Tablet(8,7)

### DRAG TO MATCH Target Grid Positions:
- Dog: Mobile(2,3), Tablet(3,2)
- Fish: Mobile(4,7), Tablet(3,7)
- Rabbit: Mobile(9,7), Tablet(9,7)
- Bird: Mobile(2,0), Tablet(2,0)
- Cat: Mobile(10,4), Tablet(10,4)
- Tortoise: Mobile(8,7), Tablet(7,7)

## Implementation Plan:
1. Create helper functions: `_gridToPosition(gridX, gridY)` and `_positionToGrid(left, top)`
2. Define grid coordinates as constants
3. Use grid coordinates in position calculations
4. Ensure grid coordinates are clamped to 0-15 (X) and 0-7 (Y)

