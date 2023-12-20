import 'dart:async';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivityRecognitionView extends StatefulWidget {
  const ActivityRecognitionView({super.key});

  @override
  State<ActivityRecognitionView> createState() =>
      _ActivityRecognitionViewState();
}

class _ActivityRecognitionViewState extends State<ActivityRecognitionView> {
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  void _onActivityReceive(Activity activity) {
    _activityStreamController.sink.add(activity);
  }

  void _handleError(dynamic error) {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;

      // Check if the user has granted permission. If not, request permission.
      PermissionRequestResult reqResult;
      reqResult = await activityRecognition.checkPermission();
      if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        return;
      } else if (reqResult == PermissionRequestResult.DENIED) {
        reqResult = await activityRecognition.requestPermission();
        if (reqResult != PermissionRequestResult.GRANTED) {
          return;
        }
      }

      // Subscribe to the activity stream.
      final _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Activity Recognition'),
            centerTitle: true,
          ),
          body: _buildContentView()),
    );
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContentView() {
    return StreamBuilder<Activity>(
        stream: _activityStreamController.stream,
        builder: (context, snapshot) {
          final updatedDateTime = DateTime.now();
          final content = snapshot.data?.toJson().toString() ?? '';

          return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                FilledButton(child: Text('Your Activity is updated on: ${updatedDateTime.day}/${updatedDateTime.month}/${updatedDateTime.year} ${updatedDateTime.hour}:${updatedDateTime.minute}:${updatedDateTime.second}',
                style: TextStyle(fontSize: 14, color: TColor.white),),
                onPressed: () {
                  
                },
                ),
                const SizedBox(height: 10.0),
                Text(content)
              ]);
        });
  }
}
