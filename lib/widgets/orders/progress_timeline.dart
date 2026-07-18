import 'package:flutter/material.dart';
import '../../models/order_item.dart';

class ProgressTimeline extends StatelessWidget {
  final OrderStatus status;

  const ProgressTimeline({super.key, required this.status});

  int get currentStep {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.completed:
        return 3;
    }
  }

  Color _stepColor(int step) {
    switch (step) {
      case 0:
        return Colors.orange;
      case 1:
        return const Color(0xffB39DDB);
      case 2:
        return const Color(0xff54C7C3);
      case 3:
        return const Color(0xff4CD778);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        if (index.isOdd) {
          int lineStep = index ~/ 2;

          return Expanded(
            child: Container(
              height: 2,
              color: currentStep > lineStep
                  ? _stepColor(lineStep)
                  : Colors.grey.shade300,
            ),
          );
        }

        int dotStep = index ~/ 2;

        bool completed = dotStep <= currentStep;
        bool current = dotStep == currentStep;

        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? _stepColor(dotStep) : Colors.grey.shade300,
            border: current
                ? Border.all(color: _stepColor(dotStep), width: 3)
                : null,
            boxShadow: current
                ? [
                    BoxShadow(
                      color: _stepColor(dotStep).withOpacity(0.35),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
