import 'package:flutter/material.dart';
import 'package:onepali/src/core/constants/assets.dart';
import 'package:onepali/src/core/widget/gaps.dart';

class PSettingCard extends StatelessWidget {
  final String title;
  final String? avatarUrl;
  final bool isAdd;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  const PSettingCard({
    super.key,
    required this.title,
    this.avatarUrl,
    this.isAdd = false,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAdd ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
        child: Row(
          children: [
            isAdd
                ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 28),
                )
                : CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      avatarUrl != null && avatarUrl!.isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : AssetImage(Assets.userAvatar) as ImageProvider,
                ),
            Gaps.horizontalGapOf(12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (!isAdd)
              IconButton(
                icon: const Icon(Icons.edit, size: 22),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
