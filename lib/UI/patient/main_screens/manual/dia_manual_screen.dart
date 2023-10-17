import 'package:diabetes_and_hypertension/UI/patient/main_screens/manual/manual_models.dart';
import 'package:diabetes_and_hypertension/UI/patient/main_screens/manual/viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DiabetesDevices extends StatelessWidget {
  DiabetesDevices({super.key});
  late double? screenHeight;
  late double? screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight! * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewManual(
                              steps: d1,
                            ))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildFoggyCard(
                      name: "جهاز بايونيم",
                      image: 'images/diaD1.png',
                    )),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewManual(
                              steps: d2,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFoggyCard(
                    name: "جهاز ون تاتش",
                    image: 'images/diaD2.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFoggyCard({required String name, required String image}) {
    return Container(
      // decoration: BoxDecoration(boxShadow: [
      //   BoxShadow(
      //       blurRadius: 14,
      //       color: Colors.grey.withOpacity(0.4),
      //       spreadRadius: 7,
      //       offset: const Offset(0, 10)),
      // ]),
      padding: EdgeInsets.all(5),
      height: screenHeight! * 0.27,
      width: screenWidth! * 0.4,
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xff73ABB2).withOpacity(0.65), width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(7)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          // Card content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff73ABB2).withOpacity(0.65),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7))),
              height: screenHeight! * 0.06,
              padding: const EdgeInsets.only(top: 17, right: 7, left: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<StepManual> d1 = [
  StepManual(
      name: "قم بتحضير جهاز الضغط و ضع البطاريات فيه",
      image: 'images/diaD1.png'),
  StepManual(name: "اجلس براحة ", image: 'images/diaD1.png'),
  StepManual(
      name: "ضع الكفة على ذراعك العلوية، تقريبًا 2-3 سم فوق مرفقك",
      image: 'images/diaD1.png'),
  StepManual(name: "شغل الجهاز", image: 'images/diaD1.png'),
  StepManual(name: "اضغط زر ابدأ", image: 'images/diaD1.png'),
  StepManual(name: "انتظر القراءة", image: 'images/diaD1.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ الفراءة و تسجيلها ",
      image: 'images/diaD1.png'),
  StepManual(name: "ازل الكفة عن ذراعك العلوية", image: 'images/diaD1.png'),
  StepManual(name: "انتظر القراءة", image: 'images/diaD1.png'),
  StepManual(name: "قم باغلاق الجهاز ", image: 'images/diaD1.png'),
];

List<StepManual> d2 = [
  StepManual(
      name: "قم بتحضير جهاز الضغط و ضع البطاريات فيه",
      image: 'images/diaD2.png'),
  StepManual(name: "اجلس براحة ", image: 'images/diaD2.png'),
  StepManual(
      name: "ضع الكفة على ذراعك العلوية، تقريبًا 2-3 سم فوق مرفقك",
      image: 'images/diaD2.png'),
  StepManual(name: "شغل الجهاز", image: 'images/diaD2.png'),
  StepManual(name: "اضغط زر ابدأ", image: 'images/diaD2.png'),
  StepManual(name: "انتظر القراءة", image: 'images/diaD2.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ الفراءة و تسجيلها ",
      image: 'images/diaD2.png'),
  StepManual(name: "ازل الكفة عن ذراعك العلوية", image: 'images/diaD2.png'),
  StepManual(name: "انتظر القراءة", image: 'images/diaD2.png'),
  StepManual(name: "قم باغلاق الجهاز ", image: 'images/diaD2.png'),
];
