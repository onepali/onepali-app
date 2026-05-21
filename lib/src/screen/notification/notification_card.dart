import 'package:flutter/material.dart';
import 'package:onepali/src/core/model/pzone/pz_notification/pz_notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationTemplate notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.body),
        trailing: notification.seen
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.circle, color: Colors.grey),
      ),
    );
  }
}
