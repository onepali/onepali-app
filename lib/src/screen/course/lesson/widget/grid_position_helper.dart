/// Helper class for grid-based positioning system
/// Uses a 16x10 grid (16 columns, 10 rows) for consistent positioning
class GridPositionHelper {
  /// Grid dimensions
  static const int gridColumns = 16;
  static const int gridRows = 10;

  /// Calculate pixel position from grid coordinates
  /// Returns absolute pixel positions for bottom-left alignment
  ///
  /// [screenWidth] - Full screen width in pixels
  /// [screenHeight] - Full screen height in pixels
  /// [gridX] - Column number (0-15)
  /// [gridY] - Row number (0-9)
  ///
  /// Returns a map with 'left' and 'bottom' keys (absolute pixels):
  /// - 'left': pixels from screen left edge (absolute from left)
  /// - 'bottom': pixels from screen bottom edge (absolute from bottom)
  ///
  /// The image's bottom-left will align with the grid cell's bottom-left.
  /// Using 'bottom' in Positioned widget is simpler - no need to know image height.
  ///
  /// Note: Uses exact calculations to avoid rounding errors:
  /// - Column 0 always gives left = 0
  /// - Column 15 always gives left = (15/16) * screenWidth
  /// - Row 9 always gives bottom = 0 (at screen bottom)
  /// - Row 0 always gives bottom = (9/10) * screenHeight
  static Map<String, double> gridToPixelPosition(
    double screenWidth,
    double screenHeight,
    int gridX,
    int gridY,
  ) {
    // Clamp grid coordinates to valid range
    gridX = gridX.clamp(0, gridColumns - 1);
    gridY = gridY.clamp(0, gridRows - 1);

    // Calculate absolute pixel positions
    // Left: (gridX / gridColumns) * screenWidth (pixels from left edge)
    // Bottom: screenHeight - ((gridY + 1) / gridRows) * screenHeight (pixels from bottom edge)
    //
    // Verification examples:
    // - Column 0: left = (0/16) * screenWidth = 0 ✓
    // - Column 15: left = (15/16) * screenWidth = 0.9375 * screenWidth ✓
    // - Row 9: bottom = screenHeight - (10/10) * screenHeight = 0 ✓
    // - Row 0: bottom = screenHeight - (1/10) * screenHeight = 0.9 * screenHeight ✓
    final double left = (gridX / gridColumns) * screenWidth;
    final double bottom =
        screenHeight - (((gridY + 1) / gridRows) * screenHeight);

    return {'left': left, 'bottom': bottom};
  }

  /// Get image size based on fixed base sizes from main branch
  /// Mobile base: 60.0, Tablet base: 110.0
  /// Then animal-specific multipliers applied
  static double getImageSizeForAnimal(
    String animalId,
    bool isMobile, {
    bool isLandscape = false,
  }) {
    // Fixed base sizes from main branch (after multiplication)
    // Mobile: 60.0, Tablet: 110.0
    final double baseSize = isMobile ? 60.0 : 110.0;

    // Animal-specific multipliers (from main branch tap-target)
    double finalSize;
    switch (animalId.toLowerCase()) {
      case 'rabbit':
      case 'cat':
        finalSize = baseSize * 2.0;
        break;
      case 'dog':
        finalSize = baseSize * 3.5;
        break;
      case 'fish':
        finalSize = baseSize * 1.5;
        break;
      case 'bird':
        finalSize = baseSize * 1.75;
        break;
      case 'tortoise':
        finalSize = baseSize * 1.75;
        break;
      default:
        finalSize = baseSize;
    }

    return finalSize;
  }

  /// Get draggable item size (same as target size per animal)
  static double getDraggableSizeForAnimal(
    String animalId,
    bool isMobile, {
    bool isLandscape = false,
  }) {
    // Use same calculation as targets
    return getImageSizeForAnimal(animalId, isMobile, isLandscape: isLandscape);
  }

  /// Get target positions map for all animals
  /// Grid spans full screen: row 0 = screen top (0px), row 9 = screen bottom
  /// Positions calculated for full screen, then adjusted for Stack coordinate system
  /// (Stack is inside SafeArea, so subtract SafeArea offsets)
  static Map<String, Map<String, double>> getTargetPositionsMap(
    double screenWidth,
    double screenHeight,
    double safeAreaTop,
    double safeAreaBottom,
    bool isMobile,
    Map<String, double>? imageSizeMap, {
    double safeAreaLeft = 0.0,
    double safeAreaRight = 0.0,
  }) {
    final deviceType = isMobile ? 'mobile' : 'tablet';
    final positionsMap = <String, Map<String, double>>{};
    final animalOrder = ['rabbit', 'dog', 'cat', 'fish', 'bird', 'tortoise'];

    for (final animalId in animalOrder) {
      final gridPos =
          AnimalGridPositions.tapTargetPositions[animalId]?[deviceType];
      if (gridPos != null && gridPos.length >= 2) {
        final gridX = gridPos[0];
        final gridY = gridPos[1];

        // Calculate position relative to full screen (grid spans full screen)
        // Animals are now outside SafeArea, so positions are already in screen coordinates
        final basePosition = gridToPixelPosition(
          screenWidth,
          screenHeight,
          gridX,
          gridY,
        );

        positionsMap[animalId] = {
          'left': basePosition['left']! - 10.0,
          'bottom': basePosition['bottom']! + 15.0,
        };
      }
    }

    return positionsMap;
  }

  /// Get draggable positions map for all animals (same grid system as targets)
  /// Grid spans full screen: row 0 = screen top (0px), row 9 = screen bottom
  /// Positions calculated for full screen, then adjusted for Stack coordinate system
  /// (Stack is inside SafeArea, so subtract SafeArea offsets)
  /// Negative positions allowed because Stack has clipBehavior: Clip.none
  static Map<String, Map<String, double>> getDraggablePositionsMap(
    double screenWidth,
    double screenHeight,
    double safeAreaTop,
    double safeAreaBottom,
    bool isMobile, {
    double safeAreaLeft = 0.0,
    double safeAreaRight = 0.0,
  }) {
    final deviceType = isMobile ? 'mobile' : 'tablet';
    final positionsMap = <String, Map<String, double>>{};
    final animalOrder = ['rabbit', 'dog', 'cat', 'fish', 'bird', 'tortoise'];

    for (final animalId in animalOrder) {
      final gridPos =
          AnimalGridPositions.dragDraggablePositions[animalId]?[deviceType];
      if (gridPos != null && gridPos.length >= 2) {
        final gridX = gridPos[0];
        final gridY = gridPos[1];

        // Calculate position relative to full screen (grid spans full screen)
        // Animals are now outside SafeArea, so positions are already in screen coordinates
        positionsMap[animalId] = gridToPixelPosition(
          screenWidth,
          screenHeight,
          gridX,
          gridY,
        );
      }
    }

    return positionsMap;
  }
}

/// Grid position coordinates for animals
/// Format: {animalId: {deviceType: [gridX, gridY]}}
class AnimalGridPositions {
  static Map<String, Map<String, List<int>>> tapTargetPositions = {
    'bird': {
      'mobile': [2, 2],
      'tablet': [2, 2],
    },
    'dog': {
      'mobile': [2, 8],
      'tablet': [2, 8],
    },
    'cat': {
      'mobile': [9, 7],
      'tablet': [10, 7],
    },
    'fish': {
      'mobile': [3, 9],
      'tablet': [3, 9],
    },
    'tortoise': {
      'mobile': [7, 9],
      'tablet': [8, 9],
    },
    'rabbit': {
      'mobile': [13, 9],
      'tablet': [13, 9],
    },
  };

  static Map<String, Map<String, List<int>>> dragDraggablePositions = {
    'dog': {
      'mobile': [10, 4],
      'tablet': [10, 4],
    },
    'fish': {
      'mobile': [8, 2],
      'tablet': [8, 2],
    },
    'rabbit': {
      'mobile': [0, 4],
      'tablet': [0, 4],
    },
    'bird': {
      'mobile': [0, 9],
      'tablet': [0, 9],
    },
    'cat': {
      'mobile': [5, 3],
      'tablet': [5, 3],
    },
    'tortoise': {
      'mobile': [13, 5],
      'tablet': [13, 5],
    },
  };
}
