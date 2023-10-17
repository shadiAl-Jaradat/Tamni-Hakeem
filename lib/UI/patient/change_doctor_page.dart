import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Service/firebase_service.dart';

class ChangeMyDoctor extends StatefulWidget {
  const ChangeMyDoctor({super.key});

  @override
  State<ChangeMyDoctor> createState() => _ChangeMyDoctorState();
}

class _ChangeMyDoctorState extends State<ChangeMyDoctor> {
  late double screenHeight;
  late double screenWidth;
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            shadowColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  "تعديل طبيبي     ",
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
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.12,
                ),
                Center(
                  child: SizedBox(
                    height: screenWidth * 0.35,
                    width: screenWidth * 0.35,
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        "images/changeDoctor.png",
                        fit: BoxFit.contain,
                        height: screenWidth * 0.35,
                        width: screenWidth * 0.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.06,
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: const Color(0xffE5E5E5),
                    ),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'رمز الطبيب',
                        hintStyle: GoogleFonts.tajawal(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      controller: controller,
                      onSaved: (value){

                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.06,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1D98A8),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      minimumSize: Size(screenWidth * 0.7, 45),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if(controller.text != ""){
                        await FirebaseFirestore.instance
                            .collection('/patient')
                            .doc(UserSimplePreferencesUser.getUserID())
                            .set({
                          'Doctor code': controller.text,
                          'DoctorID': controller.text,
                        }, SetOptions(merge: true));
                        await UserSimplePreferencesDoctorID.setDrID(
                            controller.text);
                        print("new Doctor in shared pref : ${UserSimplePreferencesDoctorID.getDrID()}");
                        setState(() {
                          isLoading = false;
                        });
                        closePage();
                      }

                      setState(() {
                        isLoading = false;
                      });

                    },
                    child: Text(
                      'تعديل',
                      style: GoogleFonts.tajawal(fontSize: 22),
                    )),
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.grey.shade400.withOpacity(0.5),
          child: const Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 50.0,
              duration : Duration(milliseconds: 500),
            ),
          ),
        )
            : Container(),
      ],
    );
  }

  void closePage(){
    Navigator.of(context).pop();
  }
}
