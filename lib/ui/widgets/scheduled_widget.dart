import 'package:flutter/material.dart';

import '../../data/schedule_task_data.dart';
import 'custom_card_widget.dart';

class Scheduled extends StatelessWidget {
  const Scheduled({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ScheduleTasksData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Scheduled",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < data.scheduled.length; index++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomCard(
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.scheduled[index].title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.scheduled[index].date,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Icon(Icons.more),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
