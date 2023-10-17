import 'package:diabetes_and_hypertension/UI/patient/main_screens/manual/manual_models.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewManual extends StatefulWidget {
  final List<StepManual> steps;

  ViewManual({Key? key, required this.steps}) : super(key: key);

  @override
  _ViewManualState createState() => _ViewManualState();
}

class _ViewManualState extends State<ViewManual>
    with SingleTickerProviderStateMixin {
  late double screenHeight;
  late double screenWidth;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.steps.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                "الخطوات     ",
                style: GoogleFonts.tajawal(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff167582),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 32,
                color: Color(0xff167582),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: widget.steps.map((step) {
                    return viewStep(step.name, step.image);
                  }).toList(),
                ),
              ),
              Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.only(bottom: 100, right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if (_tabController.index != 0)
                    ElevatedButton(
                      onPressed: () {
                        _tabController.animateTo(_tabController.index - 1);
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          fixedSize: MaterialStateProperty.all(const Size(135, 40)),
                          shape: MaterialStateProperty.resolveWith((states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23.0)
                            );
                          }),
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xff167582))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.keyboard_double_arrow_left,
                            color: Colors.white,
                            size: 32,
                          ),
                          Text(
                            "السابق",
                            style: GoogleFonts.tajawal(
                                color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    // if (_tabController.index != widget.steps.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        _tabController.animateTo(_tabController.index + 1);
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5),
                          fixedSize: MaterialStateProperty.all(const Size(135, 40)),
                          shape: MaterialStateProperty.resolveWith((states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23.0)
                            );
                          }),
                          backgroundColor: MaterialStateProperty.all(const Color(0xff167582))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "التالي",
                            style: GoogleFonts.tajawal(
                                color: Colors.white, fontSize: 24),
                          ),
                          const Icon(
                            Icons.keyboard_double_arrow_right,
                            color: Colors.white,
                            size: 32,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewStep(String name, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          fit: BoxFit.contain,
          height: screenWidth * 0.5,
          width: screenWidth * 0.5,
        ),
        Container(
          width: screenWidth * 0.7,
          // height: screenHeight * 0.2,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade200.withOpacity(0.65),
                Colors.grey.shade200.withOpacity(0.65),
              ],
              stops: const [
                0.1,
                1,
              ],
            ),
          ),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: const Color(0xff0B3C42),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class DynamicHeightContainer extends StatelessWidget {
  final String name;
  final double screenWidth;
  final double screenHeight;

  DynamicHeightContainer({required this.name, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    // Calculate the text height based on the name and its style
    final textSpan = TextSpan(
      text: name,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w500,
        color: const Color(0xff0B3C42),
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate the height of the container
    final containerHeight = textPainter.height + 50.0; // Add padding

    return GlassmorphicContainer(
      width: screenWidth * 0.7,
      height: containerHeight,
      borderRadius: 30,
      blur: 100,
      alignment: Alignment.bottomCenter,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade200.withOpacity(0.65),
          Colors.grey.shade200.withOpacity(0.65),
        ],
        stops: const [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade200.withOpacity(0.1),
          Colors.grey.shade200.withOpacity(0.65),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 50, left: 10),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: const Color(0xff0B3C42),
          ),
        ),
      ),
    );
  }
}

