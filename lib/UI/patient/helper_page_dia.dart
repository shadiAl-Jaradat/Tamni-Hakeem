import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:google_fonts/google_fonts.dart';

class HelperScreenDia extends StatefulWidget {

  HelperScreenDia({Key? key}) : super(key: key);

  @override
  _HelperScreenDiaState createState() => _HelperScreenDiaState();
}

class _HelperScreenDiaState extends State<HelperScreenDia>
    with SingleTickerProviderStateMixin {
  late double screenHeight;
  late double screenWidth;
  late FlutterGifController controller;
  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);
    controller.repeat(
      min: 0,
      max: 121,
      period: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                "نصائح عامة     ",
                style: GoogleFonts.tajawal(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff0B3C42),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 32,
                color: Color(0xff0B3C42),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 350,
                width: 350,
                color: Colors.white,
                child: GifImage(
                  controller: controller,
                  image: const AssetImage("images/newDiaLogo.gif"),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  "هذه مجموعة نصائح من قبل الاطباء لخذ القراءة بطريقة صحيحة ",
                  style: GoogleFonts.tajawal(
                      color: const Color(0xff0B3C42),
                      fontSize: 40,
                      fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenWidth * 0.35,
                    width: screenWidth * 0.35,
                    child: Image.asset(
                      "images/ad1Dia.png",
                      fit: BoxFit.contain,
                      height: screenWidth * 0.35,
                      width: screenWidth * 0.35,
                    ),
                  ),
                  SizedBox(height: 50,),
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
                        "١ -  إغسل يديك بعناية بالصابون و الماء. وهذا سوف يساعد على منع تلوث عينة الدم",
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
              ),

              SizedBox(
                height: screenHeight * 0.08,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/ad1.png",
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
                        "٢ -  استرخ لمدة 5 دقائق قبل اخذ العينة ",
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
              ),

              SizedBox(
                height: screenHeight * 0.1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.6,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14), // Adjust the radius as needed
                      image: DecorationImage(
                        image: AssetImage("images/ad3Dia.png"),
                        fit: BoxFit.cover, // You can use BoxFit.fill to cover the entire container
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                        "٣ -  استخدم شريط اختبار جديد في كل مرة تقوم فيها بالاختبار. يمكن لشرائط الاختبار القديمة أو التالفة أن تعطي قراءات غير دقيقة",
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
              ),

              SizedBox(
                height: screenHeight * 0.08,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/ad4Dia.png",
                    fit: BoxFit.contain,
                    height: screenWidth * 0.3,
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
                        " ٤ -  اختبر نسبة السكر في الدم في نفس الوقت كل يوم",
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
              ),

              SizedBox(
                height: screenHeight * 0.15,
              ),



            ],
          ),
        ),
      ),
    );
  }
}