import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 8)
      return DateFormat("dd-MM-yyyy HH:mm:ss").format(notificationDate);
    else if ((diff.inDays / 7).floor() >= 1)
      return 'Last Week';
    else if (diff.inDays >= 2)
      return '${diff.inDays} days ago';
    else if (diff.inDays >= 1)
      return '1 day ago';
    else if (diff.inHours >= 2)
      return '${diff.inHours} hours ago';
    else if (diff.inHours >= 1)
      return '1 hours ago';
    else if (diff.inMinutes >= 2)
      return '${diff.inMinutes} Minutes ago';
    else if (diff.inMinutes >= 1)
      return '1 minutes ago';
    else if (diff.inSeconds >= 3)
      return '${diff.inSeconds} Seconds ago';
    else
      return 'just now';
  }

  static bool isSameDay(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);
    if (diff.inDays > 0)
      return false;
    else
      return true;
  }
}
