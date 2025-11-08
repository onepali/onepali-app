/// Helper class for grid-based positioning system
/// Uses a 16x10 grid (16 columns, 10 rows) for consistent positioning
class GridPositionHelper {
  /// Grid dimensions
  static const int gridColumns = 16;
  static const int gridRows = 10;

  /// Calculate grid cell dimensions based on screen size
  /// Returns a map with 'width' and 'height' keys
  static Map<String, double> getCellDimensions(
    double usableWidth,
    double usableHeight,
  ) {
    return {
      'width': usableWidth / gridColumns,
      'height': usableHeight / gridRows,
    };
  }

  /// Get the top-left X position of a grid cell
  static double getCellTopLeftX(
    int gridX,
    double startX,
    double usableWidth,
  ) {
    gridX = gridX.clamp(0, gridColumns - 1);
    final cellWidth = usableWidth / gridColumns;
    return startX + (gridX * cellWidth);
  }

  /// Get the top-left Y position of a grid cell
  static double getCellTopLeftY(
    int gridY,
    double startY,
    double usableHeight,
  ) {
    gridY = gridY.clamp(0, gridRows - 1);
    final cellHeight = usableHeight / gridRows;
    return startY + (gridY * cellHeight);
  }

  /// Convert grid coordinates to pixel X position
  static double gridToX(
    int gridX,
    double startX,
    double usableWidth,
  ) {
    return getCellTopLeftX(gridX, startX, usableWidth);
  }

  /// Convert grid coordinates to pixel Y position
  static double gridToY(
    int gridY,
    double startY,
    double usableHeight,
  ) {
    return getCellTopLeftY(gridY, startY, usableHeight);
  }

  /// Convert pixel position to grid X coordinate
  static int positionToGridX(
    double left,
    double startX,
    double usableWidth,
  ) {
    final cellWidth = usableWidth / gridColumns;
    double relativeX = left - startX;
    int gridX = (relativeX / cellWidth).round();
    return gridX.clamp(0, gridColumns - 1);
  }

  /// Convert pixel position to grid Y coordinate
  static int positionToGridY(
    double top,
    double startY,
    double usableHeight,
  ) {
    final cellHeight = usableHeight / gridRows;
    double relativeY = top - startY;
    int gridY = (relativeY / cellHeight).round();
    return gridY.clamp(0, gridRows - 1);
  }

  /// Calculate grid cell size (average of width and height for square images)
  static double getCellSize(double usableWidth, double usableHeight) {
    final dimensions = getCellDimensions(usableWidth, usableHeight);
    return (dimensions['width']! + dimensions['height']!) / 2;
  }

  /// Get image size based on grid cell size
  static double getImageSizeForAnimal(
    String animalId,
    bool isMobile,
    double cellSize,
  ) {
    final double baseSize = cellSize * 2.5;

    switch (animalId.toLowerCase()) {
      case 'rabbit':
        return baseSize * 1.0;
      case 'cat':
        return baseSize * 1.0;
      case 'dog':
        return baseSize * 1.7;
      case 'fish':
        return baseSize * 0.9;
      case 'bird':
        return baseSize * 0.9;
      case 'tortoise':
        return baseSize * 1.0;
      default:
        return baseSize;
    }
  }

  /// Get draggable item size (same as target size per animal)
  static double getDraggableSizeForAnimal(
    String animalId,
    bool isMobile,
    double cellSize,
  ) {
    return getImageSizeForAnimal(animalId, isMobile, cellSize);
  }

  /// Get target positions map for all animals
  /// Grid spans full screen: row 0 = screen top (0px), row 9 = screen bottom
  /// Images are positioned so their bottom-left aligns with the bottom-left of the grid cell
  /// Note: imageSizeMap should contain the actual rendered image sizes for each animal
  static Map<String, Map<String, double>> getTargetPositionsMap(
    double screenWidth,
    double screenHeight,
    double safeAreaTop,
    double safeAreaBottom,
    bool isMobile,
    Map<String, double>? imageSizeMap,
  ) {
    final double usableWidth = screenWidth;
    final double usableHeight = screenHeight;
    final double startX = 0.0;
    final double startY = -safeAreaTop;
    
    final cellHeight = usableHeight / gridRows;

    final deviceType = isMobile ? 'mobile' : 'tablet';
    final positionsMap = <String, Map<String, double>>{};
    final animalOrder = ['rabbit', 'dog', 'cat', 'fish', 'bird', 'tortoise'];
    
    for (final animalId in animalOrder) {
      final gridPos = AnimalGridPositions.tapTargetPositions[animalId]?[deviceType];
      if (gridPos != null && gridPos.length >= 2) {
        final gridX = gridPos[0];
        final gridY = gridPos[1];
        
        final bottomOfCell = gridToY(gridY, startY, usableHeight) + cellHeight;
        final bottomOffset = screenHeight - safeAreaBottom - bottomOfCell;
        
        positionsMap[animalId] = {
          'left': gridToX(gridX, startX, usableWidth),
          'bottom': bottomOffset,
        };
      }
    }

    return positionsMap;
  }

  /// Get draggable positions map for all animals (same grid system as targets)
  /// Grid spans full screen: row 0 = screen top (0px), row 9 = screen bottom
  /// Images are positioned so their bottom-left aligns with the bottom-left of the grid cell
  static Map<String, Map<String, double>> getDraggablePositionsMap(
    double screenWidth,
    double screenHeight,
    double safeAreaTop,
    double safeAreaBottom,
    bool isMobile,
  ) {
    final double usableWidth = screenWidth;
    final double usableHeight = screenHeight;
    final double startX = 0.0;
    final double startY = -safeAreaTop;
    
    final cellHeight = usableHeight / gridRows;

    final deviceType = isMobile ? 'mobile' : 'tablet';
    final positionsMap = <String, Map<String, double>>{};
    final animalOrder = ['rabbit', 'dog', 'cat', 'fish', 'bird', 'tortoise'];
    
    for (final animalId in animalOrder) {
      final gridPos = AnimalGridPositions.dragDraggablePositions[animalId]?[deviceType];
      if (gridPos != null && gridPos.length >= 2) {
        final gridX = gridPos[0];
        final gridY = gridPos[1];
        
        final bottomOfCell = gridToY(gridY, startY, usableHeight) + cellHeight;
        final bottomOffset = screenHeight - safeAreaBottom - bottomOfCell;
        
        positionsMap[animalId] = {
          'left': gridToX(gridX, startX, usableWidth),
          'bottom': bottomOffset,
        };
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
      'mobile': [2, 7],
      'tablet': [2, 7],
    },
    'cat': {
      'mobile': [9, 7],
      'tablet': [10, 7],
    },
    'fish': {
      'mobile': [2, 9],
      'tablet': [2, 9],
    },
    'tortoise': {
      'mobile': [9, 9],
      'tablet': [10, 9],
    },
    'rabbit': {
      'mobile': [13, 9],
      'tablet': [13, 9],
    },
  };

  static Map<String, Map<String, List<int>>> dragDraggablePositions = {
    'dog': {
      'mobile': [0, 3],
      'tablet': [0, 6],
    },
    'fish': {
      'mobile': [12, 3],
      'tablet': [11, 3],
    },
    'rabbit': {
      'mobile': [11, 5],
      'tablet': [14, 5],
    },
    'bird': {
      'mobile': [0, 4],
      'tablet': [0, 4],
    },
    'cat': {
      'mobile': [5, 3],
      'tablet': [5, 3],
    },
    'tortoise': {
      'mobile': [13, 3],
      'tablet': [13, 3],
    },
  };
}

