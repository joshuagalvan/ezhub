import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/components/stepper_page_view.dart';
import 'package:simone/src/utils/colorpalette.dart';

class StepperContainerForm extends HookWidget {
  const StepperContainerForm({
    super.key,
    required this.steps,
    this.counter = 0,
    this.next,
    this.previous,
    this.isLoading,
  });

  final List<StepperPageView> steps;
  final int counter;
  final Future<int> Function()? next;
  final Future<int> Function()? previous;
  final bool Function()? isLoading;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> currentPage = useState(0);

    return PopScope(
      canPop: (currentPage.value <= 0),
      onPopInvokedWithResult: (canPop, _) {
        if (!canPop) currentPage.value--;
      },
      child: Stack(
        children: [
          isLoading!()
              ? Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: ((currentPage.value + 1) /
                                        steps.length),
                                    backgroundColor: Colors.grey[300],
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  "${currentPage.value + 1} of ${steps.length}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  steps[currentPage.value].title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                currentPage.value + 1 < steps.length
                                    ? Text(
                                        "Next: ${steps[currentPage.value + 1].title}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ))
                                    : const Text(
                                        "Almost Done!",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: steps[currentPage.value].content,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor,
                            ),
                            onPressed: () async {
                              if (previous != null) {
                                currentPage.value = await previous!();
                              }
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (next != null)
                            ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ColorPalette.primaryColor,
                              ),
                              onPressed: () async {
                                if (next != null) {
                                  currentPage.value = await next!();
                                }
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
