import 'package:diabetes_and_hypertension/UI/patient/main_screens/manual/viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'manual_models.dart';

// ignore: must_be_immutable
class BloodDevices extends StatelessWidget {
  BloodDevices({super.key});
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
                              steps: d3,
                            ))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildFoggyCard(
                      name: "عن طريق المعصم اومرون",
                      image: 'images/bloodD3.png',
                    )),
              ),
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
                    name: "من أعلى الذراع اومرون 4 ",
                    image: 'images/bloodD1.png',
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewManual(
                              steps: d5,
                            ))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildFoggyCard(
                      name: "براون من أعلى الذراع",
                      image: 'images/bloodD5.png',
                    )),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewManual(
                              steps: d6,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFoggyCard(
                    name: "جهاز بيورير BM28",
                    image: 'images/bloodD6.png',
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                      name: " اكتيف كنترول من جيراثيرم",
                      image: 'images/bloodD2.png',
                    )),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewManual(
                              steps: d4,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFoggyCard(
                    name: "تحكم تنسيو من جيراثيرم ",
                    image: 'images/bloodD4.png',
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
    return SizedBox(
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
              borderRadius: BorderRadius.circular(16),
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
                  color: const Color(0xff73ABB2).withOpacity(0.75),
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
      name: "إعداد الجهاز. ومثبت به البطاريات. يجب أن يتم إدخال البطاريات مع أقطاب + و - في الاتجاه الصحيح.",
      image: 'images/d1s1.png'),

  StepManual(name: "حدد حجم الكفة. يجب أن يكون حجم الكفة مناسبًا لمحيط ذراعك العلوي", image: 'images/d1s2.png'),

  StepManual(
      name: "ضع الكفة. لف الكفة حول ذراعك العلوي ، مع التأكد من أن الشريط الأزرق على الداخل من ذراعك ومتوافق مع إصبعك الأوسط. يجب أن يمر أنبوب الهواء أسفل الجزء الداخلي من ذراعك.",
      image: 'images/d1s3.png'),

  StepManual(name: "قم بتشغيل الجهاز", image: 'images/d1s4.png'),

  StepManual(name: "اضغط زر ابدأ", image: 'images/d1s5.png'),

  StepManual(name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.", image: 'images/d1s6.png'),

  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d1s7.png'),
  StepManual(name: "قم بإزالة الكفة. بعد اكتمال القياس", image: 'images/d1s8.png'),
  StepManual(name: "قم باغلاق الجهاز ", image: 'images/d1s9.png'),
];

List<StepManual> d2 = [
  StepManual(
      name: "قم بتحضير جهاز الضغط و ضعه في مزود كهرباء",
      image: 'images/d2s1.png'),
  StepManual(name: "حدد حجم الكفة. يجب أن يكون حجم الكفة مناسبًا لمحيط ذراعك العلوي", image: 'images/d1s2.png'),
  StepManual(
      name: "ضع الكفة على ذراعك العلوية، تقريبًا 2-3 سم فوق مرفقك",
      image: 'images/d2s3.png'),
  StepManual(name: "شغل الجهاز", image: 'images/d2s4.png'),
  StepManual(name: "اضغط زر ابدأ", image: 'images/d2s5.png'),
  StepManual(name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.", image: 'images/d2s6.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d2s7.png'),
  StepManual(name: "اضغط زر الانهاء و قم بازالة الجهاز عن مزود الكهرباء ", image: 'images/d2s8.png'),
];

List<StepManual> d3 = [
  StepManual(
      name: "إعداد الجهاز. ومثبت به البطاريات. يجب أن يتم إدخال البطاريات مع أقطاب + و - في الاتجاه الصحيح.",
      image: 'images/d3s1.png'),
  StepManual(
      name: "حدد حجم الكفة. يجب أن يكون حجم الكفة مناسبًا لمحيط معصمك (يدك) ",
      image: 'images/d3s2.png'),
  StepManual(
      name: "ضع الكفة على معصمك",
      image: 'images/d3s3.png'),
  StepManual(name: "يجب ان تكون شاشة الجهاز مواجهة لراحة يدك", image: 'images/d3s4.png'),
  StepManual(name: "ضع يدك بمستوى قلبك و يجب ان يكون ظهرك مستقيم", image: 'images/d3s5.png'),
  StepManual(name: "شغل الجهاز", image: 'images/d3s6.png'),
  StepManual(name: "اضغط زر ابدأ", image: 'images/d3s7.png'),
  StepManual(
      name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.",
      image: 'images/d3s8.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d3s9.png'),
  StepManual(
      name: "قم باغلاق الجهاز",
      image: 'images/d3s10.png'),
];

List<StepManual> d4 = [
  StepManual(
      name: "إعداد الجهاز. ومثبت به البطاريات. يجب أن يتم إدخال البطاريات مع أقطاب + و - في الاتجاه الصحيح.",
      image: 'images/d4s1.png'),
  StepManual(
      name: "ضع الكفة على معصمك . يجب أن يكون حجم الكفة مناسبًا لمحيط معصمك (يدك) و بالاضافة الى شاشة الجهاز يجب ان تكون مواجهة لراحة يدك",
      image: 'images/d4s2.png'),
  StepManual(
      name: "ضع يدك بمستوى قلبك و يجب ان يكون ظهرك مستقيم",
      image: 'images/d4s3.png'),
  StepManual(name: "شغل الجهاز", image: 'images/d4s4.png'),
  StepManual(name: "اضغط زر ابدأ", image: 'images/d4s5.png'),
  StepManual(
      name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.",
      image: 'images/d4s6.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d4s7.png'),
  StepManual(
      name: "قم باغلاق الجهاز",
      image: 'images/d4s8.png'),
];

List<StepManual> d5 = [
  StepManual(
      name: "إعداد الجهاز. ومثبت به البطاريات. يجب أن يتم إدخال البطاريات مع أقطاب + و - في الاتجاه الصحيح.",
      image: 'images/d5s1.png'),

  StepManual(name: "قم بشبك الكفة بالجهاز", image: 'images/d5s2.png'),

  StepManual(name: " ضع الكفة. يجب أن يكون حجم الكفة مناسبًا لمحيط ذراعك العلوي مع التأكد من أن الشريط الأزرق على الداخل من ذراعك ومتوافق مع إصبعك الأوسط. يجب أن يمر أنبوب الهواء أسفل الجزء الداخلي من ذراعك",
      image: 'images/d5s3.png'),

  StepManual(name: "قم بتشغيل الجهاز", image: 'images/d5s4.png'),

  StepManual(name: "اضغط زر ابدأ", image: 'images/d5s5.png'),

  StepManual(name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.", image: 'images/d1s6.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d5s7.png'),
  StepManual(name: "قم باغلاق الجهاز ", image: 'images/d5s8.png'),
];

List<StepManual> d6 = [
  StepManual(
      name: "إعداد الجهاز. ومثبت به البطاريات. يجب أن يتم إدخال البطاريات مع أقطاب + و - في الاتجاه الصحيح.",
      image: 'images/d6s1.png'),
  StepManual(
      name: "قم بشبك الكفة بالجهاز",
      image: 'images/d6s2.png'),
  StepManual(
      name: "حدد حجم الكفة. يجب أن يكون حجم الكفة مناسبًا لمحيط ذراعك العلوي",
      image: 'images/d6s3.png'),

  StepManual(
      name: "ضع الكفة. لف الكفة حول ذراعك العلوي ، مع التأكد من أن الشريط الأزرق على الداخل من ذراعك ومتوافق مع إصبعك الأوسط. يجب أن يمر أنبوب الهواء أسفل الجزء الداخلي من ذراعك.",
      image: 'images/d6s4.png'),
  StepManual(name: "ضع الكفة بمستوى قلبك و يجب ان يكون ظهرك مستقيم", image: 'images/d6s5.png'),
  StepManual(
      name: "شغل الجهاز",
      image: 'images/d6s6.png'),
  StepManual(
      name: "اضغط زر ابدأ",
      image: 'images/d6s7.png'),
  StepManual(
      name: "خذ القياس. بمجرد تشغيل الشاشة، ستقوم تلقائيًا بنفخ الكفة. سوف تنتفخ الكفة ثم تنكمش عدة مرات. بعد الانكماش النهائي، سيتم عرض نتائج القياس على الشاشة.",
      image: 'images/d6s8.png'),
  StepManual(
      name: "عند توقف الجهاز قم باخذ القراءة و تسجيلها ",
      image: 'images/d6s9.png'),
  StepManual(
      name: "قم باغلاق الجهاز",
      image: 'images/d6s10.png'),
];
