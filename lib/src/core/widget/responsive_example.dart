import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

/// Example widget demonstrating ResponsiveConfig enum-based API
class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive Example',
          style: TextStyle(
            fontSize: ResponsiveConfig.getAdaptiveFontSize(
              small: 16.0,
              normal: 18.0,
              large: 24.0,
              extraLarge: 28.0,
            ),
          ),
        ),
        // Smaller toolbar in mobile landscape
        toolbarHeight: ResponsiveConfig.isMobileInLandscape ? 50.0 : 60.0,
      ),
      body: Padding(
        padding: ResponsiveConfig.getAdaptivePadding(
          small: const EdgeInsets.all(8.0),
          normal: const EdgeInsets.all(16.0),
          large: const EdgeInsets.all(24.0),
          extraLarge: const EdgeInsets.all(32.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Information Card
            _buildDeviceInfoCard(),

            SizedBox(
              height: ResponsiveConfig.getAdaptiveSpacing(
                small: 12.0,
                normal: 16.0,
                large: 20.0,
                extraLarge: 24.0,
              ),
            ),

            // Layout based on device type
            _buildLayoutByDeviceType(),

            SizedBox(
              height: ResponsiveConfig.getAdaptiveSpacing(
                small: 12.0,
                normal: 16.0,
                large: 20.0,
                extraLarge: 24.0,
              ),
            ),

            // Conditional content based on size
            if (ResponsiveConfig.isLargeDevice ||
                ResponsiveConfig.isExtraLargeDevice)
              _buildDetailedContent(),

            // Hide in mobile landscape to save space
            if (!ResponsiveConfig.isMobileInLandscape) _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    return Card(
      child: Padding(
        padding: ResponsiveConfig.getAdaptivePadding(
          small: const EdgeInsets.all(8.0),
          normal: const EdgeInsets.all(12.0),
          large: const EdgeInsets.all(16.0),
          extraLarge: const EdgeInsets.all(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: TextStyle(
                fontSize: ResponsiveConfig.getAdaptiveFontSize(
                  small: 14.0,
                  normal: 16.0,
                  large: 20.0,
                  extraLarge: 24.0,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Type', ResponsiveConfig.deviceType.name),
            _buildInfoRow('Size', ResponsiveConfig.refinedSize.name),
            _buildInfoRow('Orientation', ResponsiveConfig.orientation.name),
            _buildInfoRow(
              'Screen',
              '${ResponsiveConfig.screenWidth.toInt()}x${ResponsiveConfig.screenHeight.toInt()}',
            ),
            _buildInfoRow(
              'Device Dimensions',
              '${ResponsiveConfig.deviceShortestSide.toInt()}x${ResponsiveConfig.deviceLongestSide.toInt()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildLayoutByDeviceType() {
    // Use enum for clean switch statements
    switch (ResponsiveConfig.deviceType) {
      case DeviceType.mobile:
        return _buildMobileLayout();
      case DeviceType.tablet:
        return _buildTabletLayout();
      case DeviceType.desktop:
        return _buildDesktopLayout();
      case DeviceType.watch:
        return _buildWatchLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue.shade100,
      child: Column(
        children: [
          const Icon(Icons.phone_android, size: 48),
          const SizedBox(height: 8),
          Text(
            'Mobile Layout',
            style: TextStyle(
              fontSize: ResponsiveConfig.getAdaptiveFontSize(
                small: 12.0,
                normal: 14.0,
                large: 18.0,
                extraLarge: 22.0,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (ResponsiveConfig.isLandscapeOrientation)
            const Text('(Landscape Mode)'),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.green.shade100,
      child: Row(
        children: [
          const Icon(Icons.tablet, size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tablet Layout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (ResponsiveConfig.isTabletInLandscape)
                  const Text('Wide layout for landscape')
                else
                  const Text('Compact layout for portrait'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      color: Colors.purple.shade100,
      child: Row(
        children: [
          const Icon(Icons.desktop_windows, size: 72),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desktop Layout',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Full-featured layout with all details'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchLayout() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.orange.shade100,
      child: const Column(
        children: [
          Icon(Icons.watch, size: 32),
          SizedBox(height: 4),
          Text('Watch Layout', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDetailedContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Content',
              style: TextStyle(
                fontSize: ResponsiveConfig.getAdaptiveFontSize(
                  small: 14.0,
                  normal: 16.0,
                  large: 18.0,
                  extraLarge: 20.0,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This content only appears on large and extra large devices. '
              'Perfect for additional information that might clutter smaller screens.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12.0),
      color: Colors.grey.shade200,
      child: const Text(
        'Footer (hidden in mobile landscape to save vertical space)',
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Example: Grid with adaptive column count
class ResponsiveGridExample extends StatelessWidget {
  const ResponsiveGridExample({super.key});

  int _getCrossAxisCount() {
    switch (ResponsiveConfig.refinedSize) {
      case RefinedSize.small:
        return 2; // 2 columns for small devices
      case RefinedSize.normal:
        return 3; // 3 columns for normal phones
      case RefinedSize.large:
        return 4; // 4 columns for tablets
      case RefinedSize.extraLarge:
        return 6; // 6 columns for large tablets/desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        mainAxisSpacing: ResponsiveConfig.getAdaptiveSpacing(
          small: 4.0,
          normal: 8.0,
          large: 12.0,
          extraLarge: 16.0,
        ),
        crossAxisSpacing: ResponsiveConfig.getAdaptiveSpacing(
          small: 4.0,
          normal: 8.0,
          large: 12.0,
          extraLarge: 16.0,
        ),
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(
                fontSize: ResponsiveConfig.getAdaptiveFontSize(
                  small: 10.0,
                  normal: 12.0,
                  large: 14.0,
                  extraLarge: 16.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
