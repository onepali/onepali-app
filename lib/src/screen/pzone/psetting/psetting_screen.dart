import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:onepali/src/src.dart';

class ParentSettingScreen extends StatefulWidget {
  const ParentSettingScreen({super.key});

  @override
  State<ParentSettingScreen> createState() => _ParentSettingScreenState();
}

class _ParentSettingScreenState extends State<ParentSettingScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<UserProvider>().fetchOwnProfile();
      context.read<ChildUserProvider>().fetchChildUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final childProvider = context.watch<ChildUserProvider>();
    final parent = userProvider.user;
    final children = childProvider.childUser;
    final canAddChild = children.length < 3;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Parent card
          if (parent != null)
            PSettingCard(
              title: parent.fullName,
              avatarUrl: null,
              onEdit: () {},
            ),
          Gaps.verticalGapOf(18),
          const Text(
            'Your Children',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Gaps.verticalGapOf(8),
          // Children cards
          ...children.map(
            (child) => PSettingCard(
              title: child.fullName,
              avatarUrl: child.avatarUrl,
              onEdit: () {},
            ),
          ),
          if (canAddChild)
            PSettingCard(title: 'Add child', isAdd: true, onTap: () {}),
          Gaps.verticalGapOf(18),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Spread the word! Invite a friend.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Icon(Icons.favorite, color: Colors.orange[300]),
                Gaps.horizontalGapOf(8),
                Icon(Icons.send, color: Colors.orange[300]),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('My plan'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Cancel Subscription'),
            onTap: () {},
          ),
          Gaps.verticalGapOf(24),
          // Footer
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('About us'),
                const Text('Contact us'),
                const Text('FAQ'),
                // Image.asset('assets/images/kidsafe.png', height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
