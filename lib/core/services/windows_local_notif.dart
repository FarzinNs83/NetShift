import 'package:local_notifier/local_notifier.dart';

class WindowsLocalNotif {
  final String title;
  final String body;
  WindowsLocalNotif({
    required this.body,
    required this.title,
  });
  void showNotification() {
    final notification = LocalNotification(
      title: title,
      identifier:
          """NetShift_instance_checkerid:AJD93lsidOAId9238ASDL3JaedlQWEoiqwNEZLKSADjOIWEUqpoZXCMV0923asdklASDqwe9238KJHn:OP23932:SDjAIOWEQzxcLKJHqwoeiASDLKJASDoiwqZXC9238alskdjQWEoiqweZXCv098234JHKASDlkjweuqpzxc9234JHKqwoeiuASD""",
      body: body,
    );
    notification.show();
  }
}
