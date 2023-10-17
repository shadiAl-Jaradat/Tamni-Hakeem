import 'package:diabetes_and_hypertension/UI/loginscreen.dart';
import 'package:diabetes_and_hypertension/UI/statistics/statistics_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

late bool choice;

class AppUser extends StatefulWidget {
  @override
  _AppUserState createState() => _AppUserState();
}

class _AppUserState extends State<AppUser> {
  late double screenHeight;
  late double screenWidth;
  late double textScale;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    textScale = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
          child: Scaffold(
            body: SizedBox(
              //background
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/backTest.png"),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, left: 30.0, right: 30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.35,
                                              height: screenHeight * 0.25,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  choice = false;
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen(isDr: true,)
                                                      )
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xff63816D),
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                          padding: const  EdgeInsets.only(top: 30.0 , bottom:15),
                                                          child: SvgPicture.asset(
                                                            "images/doctorLogo.svg",
                                                            height: 80,
                                                            width: 50,
                                                            color: Colors.white,
                                                          )
                                                        // Image(
                                                        //     image: AssetImage('images/doctorLogo.png'),
                                                        //     height: 0,
                                                        //     width: 15,
                                                        //   ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 15.0),
                                                        child: Text(
                                                          'طبيب',
                                                          style: GoogleFonts.tajawal(
                                                            fontSize: 0.075* screenWidth,
                                                            fontWeight:FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.35,
                                              height: screenHeight * 0.25,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  choice = false;
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen(isDr: false,)));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xffBECC23),
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 25.0,bottom:15),
                                                        child: SvgPicture.asset(
                                                          "images/patientLogo.svg",
                                                          height: 80,
                                                          width: 50,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 20.0),
                                                        child: Text(
                                                          'مريض',
                                                          style: GoogleFonts.tajawal(
                                                            fontSize: 0.075* screenWidth,
                                                            fontWeight:FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.1,
                                        width: screenWidth * 0.85,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xff1D98A8),
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(16))),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StatisticsHome()));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "ابحاث و احصائيات ",
                                                  style: GoogleFonts.tajawal(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    //Color.fromRGBO(91, 122, 128, 100),
                                                    fontSize: 0.058* screenWidth,),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

  }
}
