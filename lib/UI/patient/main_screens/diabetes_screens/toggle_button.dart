import 'package:flutter/material.dart';

class ToggleButtonDemo extends StatefulWidget {
  const ToggleButtonDemo({super.key});

  @override
  _ToggleButtonDemoState createState() => _ToggleButtonDemoState();
}

class _ToggleButtonDemoState extends State<ToggleButtonDemo> {
  final ValueNotifier<int> selectedNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.32),
      child: Container(
        height: 40,
        decoration: ShapeDecoration(
          color: const Color(0xFF20AEC1).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: selectedNotifier,
          builder: (context, selectedValue, child) {
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectedNotifier.value = 0;
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(selectedValue == 0 ? 14 : 0),
                          right: Radius.circular(selectedValue == 1 ? 14 : 0),
                        ),
                        color: selectedValue == 0
                            ? const Color(0xFF167582)
                            : const Color(0xFF20AEC1),
                      ),
                      child: Text(
                        'سكري',
                        style: TextStyle(
                          color: selectedValue == 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontSize: 15,
                          fontFamily: 'Markazi Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectedNotifier.value = 1;
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(selectedValue == 0 ? 14 : 0),
                          right: Radius.circular(selectedValue == 1 ? 14 : 0),
                        ),
                        color: selectedValue == 1
                            ? const Color(0xFF167582)
                            : const Color(0xFF20AEC1),
                      ),
                      child: Text(
                        'ضغط',
                        style: TextStyle(
                          color: selectedValue == 1
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontSize: 15,
                          fontFamily: 'Markazi Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    selectedNotifier.dispose();
    super.dispose();
  }
}
