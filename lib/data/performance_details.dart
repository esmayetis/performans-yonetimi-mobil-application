import 'package:mobil_app/models/performance_model.dart';

class PerformanceDetails {
  final performanceData = const [
    PerformanceModel(
        icon: "assets/images/burn.png", value: "305", title: "Calories burned"),
    PerformanceModel(
        icon: "assets/images/steps.png", value: "10,983", title: "Steps"),
    PerformanceModel(
        icon: "assets/images/distance.png", value: "7km", title: "Distance"),
    PerformanceModel(
        icon: "assets/images/sleep.png", value: "7km", title: "Sleep"),
  ];
}
