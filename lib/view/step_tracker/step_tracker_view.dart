import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepCounterView extends StatefulWidget {
  const StepCounterView({super.key});

  @override
  State<StepCounterView> createState() => _StepCounterViewState();
}

class _StepCounterViewState extends State<StepCounterView> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = '?', steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.primaryColor1,
          title: const Text('Pedometer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian Status',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Icon(
                status == 'walking'
                    ? Icons.directions_walk
                    : status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  status,
                  style: status == 'walking' || status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
