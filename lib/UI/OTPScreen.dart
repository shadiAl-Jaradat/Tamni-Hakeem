import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/patient/main_screens/diabetes_screens/bottom_bar_home.dart';
import 'package:diabetes_and_hypertension/UI/patient/regstration_screens/registration_patient_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Service/firebase_service.dart';
import 'doctor/main_screens/lstOfMyPatient.dart';
import 'doctor/regstration_screens/doctor_regstration.dart';


double hi = 0.65;
bool check = false;
bool selected = false;
class OTPScreen extends StatefulWidget {
  late final String phone;
  String? drID;
  bool isDr;
  OTPScreen({required this.phone , this.drID, required this.isDr});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  //get pinPutDecoration => null;
  BoxDecoration get pinPutDecoration {
    return BoxDecoration(
      color: const Color.fromRGBO(196, 196, 196, 0.26),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
  //bool get cho => cho;



  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  _verifyPhone() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    //
    // await auth.verifyPhoneNumber(
    //   phoneNumber: '+962${widget.phone}',
    //   timeout: const Duration(seconds: 200),
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     print("Verified");
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     print(e.message);
    //   },
    //   codeSent: (String verificationID, [int? resendToken]) {
    //     setState(() {
    //       _verificationCode = verificationID; // Store the verification ID here
    //     });
    //   },
    //   codeAutoRetrievalTimeout: (String verificationID) {
    //     setState(() {
    //       _verificationCode = verificationID; // Store the verification ID here
    //     });
    //   },
    // );
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background.png"), fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  if (selected == true ) selected=false;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onTapCancel:() {
                  if (selected == true ) selected=false;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 330),
                  curve: Curves.linear,
                  width: double.infinity,
                  height: selected ? screenHeight * 0.9 : screenHeight * 0.68,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                  ),
                  child: Column(
                    children: [
                      ///1
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Divider(
                                color: Colors.grey,
                                indent: 30,
                                endIndent: 15,
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text(
                                      'رمز التحقق',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 30 * textScale,
                                        color: Color(0xff1D98A8),),
                                    ))),
                            Expanded(
                              flex: 1,
                              child: Divider(
                                color: Colors.grey,
                                indent: 15,
                                endIndent: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///2
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: Text(
                            //+962-${widget.phone}
                            "لقد تم ارسال رمز التحقق الى ",
                            style: GoogleFonts.tajawal(
                                color: Color(0xff752C20),
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: Text(
                            '+962 ${widget.phone}',
                            style: TextStyle(
                                color: Color.fromRGBO(134, 138, 139, 1),
                                fontSize: 20),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: 20,
                      ),


                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: PinCodeTextField(
                          keyboardType: TextInputType.number,
                          controller: _pinPutController,
                          length: 6,
                          onTap: () => setState(() {
                            selected = true;
                          }),
                          onCompleted: (pin){
                            setState(() {
                              selected = false;
                              FocusScope.of(context).requestFocus(new FocusNode());
                            });
                          },
                          autoDisposeControllers: false,
                          cursorColor: const Color(0xff752C20),
                          textStyle: TextStyle(color: Colors.black),
                          appContext: context,
                          pinTheme: PinTheme(
                              selectedColor:  const Color(0xff752C20),
                              activeColor: const Color(0xff752C20),
                              inactiveColor: Colors.grey,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 75,
                              fieldWidth: 50,
                              activeFillColor:  Colors.white,
                              disabledColor: Colors.black),
                          validator: (value) {
                            // if(value!.length < 6){
                            //   return "length less than 6";
                            // }
                            return null;
                          },
                          focusNode: _pinPutFocusNode,
                          onSubmitted: (pin) async {
                            selected=false;
                          },
                          animationType: AnimationType.fade,
                        ),
                        // child: Pinput(
                        //     onTap: () => setState(() {
                        //       selected = true;
                        //     }),
                        //
                        //     onCompleted: (pin){
                        //       setState(() {
                        //         selected = false;
                        //         FocusScope.of(context).requestFocus(new FocusNode());
                        //       });
                        //     },
                        //
                        //   defaultPinTheme : PinTheme(
                        //     width: 56,
                        //     height: 70,
                        //     textStyle: TextStyle(fontSize: 25, color: Color.fromRGBO(52, 91, 99, 1), fontWeight: FontWeight.w600),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //   ),
                        //
                        //   // onEditingComplete: () => setState(() {
                        //   //   selected = false;
                        //   //   FocusScope.of(context).requestFocus(new FocusNode());
                        //   // }),
                        //
                        //   useNativeKeyboard: true,
                        //   validator: (value) {
                        //     if(value!.length < 6){
                        //       return "length less than 6";
                        //     }
                        //     return null;
                        //   },
                        //
                        //   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        //   //autovalidateMode: AutovalidateMode.always,
                        //
                        //   //withCursor: true,
                        //
                        //   //fieldsCount: 6,
                        //   length: 6,
                        //
                        //   //textStyle: TextStyle(fontSize: 25.0, color: Color.fromRGBO(52, 91, 99, 1)),
                        //
                        //   // eachFieldWidth: 50.0,
                        //   // eachFieldHeight: 70.0,
                        //   focusNode: _pinPutFocusNode,
                        //   controller: _pinPutController,
                        //
                        //   submittedPinTheme: PinTheme(
                        //     decoration: BoxDecoration(
                        //       color: Color.fromRGBO(196, 196, 196, 0.26),
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //   ),
                        //
                        //   followingPinTheme: PinTheme(
                        //     decoration: BoxDecoration(
                        //       color: Color.fromRGBO(196, 196, 196, 0.26),
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //   ),
                        //
                        //   //selectedFieldDecoration: pinPutDecoration,
                        //   pinAnimationType: PinAnimationType.fade,
                        //
                        //   onSubmitted: (pin) async {
                        //     selected=false;
                        //   },
                        //
                        //   // onSubmit: (pin) async {
                        //   //   selected=false;
                        //   // },
                        // ),
                        // child: Pinput(
                        //   controller: _pinPutController,
                        //   length: 6,
                        //   onCompleted: (pin) {
                        //     print(pin);
                        //     selected=false;
                        //     FocusScope.of(context).requestFocus(new FocusNode());
                        //   },
                        //
                        // ),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff1D98A8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              minimumSize: const Size(140, 40),
                            ),
                            onPressed: () async{

                              try {
                                //here we check if the code enterd by the user the same one that was sent from firebase

                                print("------${_pinPutController.text}");
                                // print("------${_verificationCode}");

                                FirebaseAuth auth = FirebaseAuth.instance;
                                await auth.verifyPhoneNumber(
                                  phoneNumber: '+962${widget.phone}',
                                  codeSent: (String verificationId, int? resendToken) async {
                                    // Update the UI - wait for the user to enter the SMS code
                                    String smsCode = _pinPutController.text;

                                    // Create a PhoneAuthCredential with the code
                                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

                                    // Sign the user in (or link) with the credential
                                    await auth.signInWithCredential(credential).then((value) async {
                                      print("Arrivced");
                                      print(value.user?.uid);
                                      print(check);
                                      // patient login
                                      if(widget.drID != null && widget.isDr == false){
                                        await UserSimplePreferencesUser.setUserID(value.user!.uid);
                                        await UserSimplePreferencesDoctorID.setDrID(widget.drID!);
                                        await UserSimplePreferencesDoctorID.setUserType('Pa');
                                        await UserSimplePreferencesUser.setLastOpen(DateTime.now().toString());

                                        DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
                                            .collection('/patient')
                                            .doc(value.user!.uid)
                                            .get();

                                        Map<String, dynamic> data = dd.data() as Map<String, dynamic>;

                                        print("&&&&&&& name : ${data['Name']}");

                                        bool hasDi = data['hasDiabetes'];
                                        bool hasBl = data['hasBloodPressure'];
                                        await UserSimplePreferencesUser.setPaName(data['Name']);
                                        await UserSimplePreferencesUser.setPaDiabetes(hasDi);
                                        await UserSimplePreferencesUser.setPaBlood(hasBl);
                                        await UserSimplePreferencesUser.setCtOfWeek(data['counterOfWeeks'].toString());
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BarHome()),
                                                (route) => false
                                        );
                                      }
                                      // dr login
                                      else if(widget.drID != null && widget.isDr == true){
                                        //TODO : make setup for login Dr.

                                        await UserSimplePreferencesDoctorID.setDrID(widget.drID.toString());
                                        await UserSimplePreferencesDoctorID.setUserType('Dr');



                                        DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
                                            .collection('/doctors')
                                            .doc(widget.drID)
                                            .get();

                                        Map<String, dynamic> data = dd.data() as Map<String, dynamic>;

                                        print("&&&&&&& name : ${data['first-name']}");

                                        await UserSimplePreferencesDoctorID.setDrName(data['first-name'].toString());
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ListOfPatient()),
                                                (route) => false
                                        );
                                      }
                                      else {
                                        if (value.user?.uid != null  && widget.isDr == true) {
                                          print("ana hone dr jded ");
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DoctorReg()), (route) => false);
                                        }
                                        else if(value.user?.uid != null  && widget.isDr  == false){
                                          await UserSimplePreferencesUser.setUserID(value.user!.uid);
                                          await UserSimplePreferencesDoctorID.setUserType('Pa');
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => RegistrationPatientPage(phone: widget.phone)),
                                                  (route) => false);
                                        }
                                      }
                                    });
                                  },
                                  verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
                                  verificationFailed: (FirebaseAuthException error) {  },
                                  codeAutoRetrievalTimeout: (String verificationId) {  },
                                );


                                // await FirebaseAuth.instance
                                //     .signInWithCredential(
                                //     PhoneAuthProvider.credential(
                                //         verificationId: _verificationCode,
                                //         smsCode: _pinPutController.text))
                                //     .then((value) async {
                                //   print("Arrivced");
                                //   print(value.user?.uid);
                                //   print(check);
                                //   // patient login
                                //   if(widget.drID != null && widget.isDr == false){
                                //     await UserSimplePreferencesUser.setUserID(value.user!.uid);
                                //     await UserSimplePreferencesDoctorID.setDrID(widget.drID!);
                                //     await UserSimplePreferencesDoctorID.setUserType('Pa');
                                //     await UserSimplePreferencesUser.setCtOfWeek('0');
                                //     await UserSimplePreferencesUser.setLastOpen(DateTime.now().toString());
                                //
                                //     DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
                                //         .collection('/doctors')
                                //         .doc(widget.drID)
                                //         .collection('/patient')
                                //         .doc(value.user!.uid)
                                //         .get();
                                //
                                //     Map<String, dynamic> data = dd.data() as Map<String, dynamic>;
                                //
                                //     print("&&&&&&& name : ${data['Name']}");
                                //
                                //     bool hasDi = data['hasDiabetes'];
                                //     bool hasBl = data['hasBloodPressure'];
                                //     await UserSimplePreferencesUser.setPaName(data['Name']);
                                //     await UserSimplePreferencesUser.setPaDiabetes(hasDi);
                                //     await UserSimplePreferencesUser.setPaBlood(hasBl);
                                //     Navigator.pushAndRemoveUntil(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => BarHome()),
                                //             (route) => false
                                //     );
                                //   }
                                //   // dr login
                                //   else if(widget.drID != null && widget.isDr == true){
                                //     //TODO : make setup for login Dr.
                                //
                                //     await UserSimplePreferencesDoctorID.setDrID(widget.drID.toString());
                                //     await UserSimplePreferencesDoctorID.setUserType('Dr');
                                //
                                //
                                //
                                //     DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
                                //         .collection('/doctors')
                                //         .doc(widget.drID)
                                //         .get();
                                //
                                //     Map<String, dynamic> data = dd.data() as Map<String, dynamic>;
                                //
                                //     print("&&&&&&& name : ${data['first-name']}");
                                //
                                //     await UserSimplePreferencesDoctorID.setDrName(data['first-name'].toString());
                                //     // ignore: use_build_context_synchronously
                                //     Navigator.pushAndRemoveUntil(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => listOfPatient()),
                                //             (route) => false
                                //     );
                                //   }
                                //   else {
                                //     if (value.user?.uid != null  && widget.isDr == true) {
                                //       print("ana hone dr jded ");
                                //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DoctorReg()), (route) => false);
                                //     }
                                //     else if(value.user?.uid != null  && widget.isDr  == false){
                                //       await UserSimplePreferencesUser.setUserID(value.user!.uid);
                                //       await UserSimplePreferencesDoctorID.setUserType('Pa');
                                //       Navigator.pushAndRemoveUntil(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => RegistrationPatientPage(phone: widget.phone)),
                                //               (route) => false);
                                //     }
                                //   }
                                // });
                              } catch (e) {
                                showDialog<String>(context: context, builder: (BuildContextcontext) =>
                                    AlertDialog(
                                      title:
                                      const Text(
                                          'ERROR'),
                                      content: const Text(
                                          'الرقم الذي ادخلته خاطئ  , الرجاء اعادة ادخال الرقم '),
                                      actions: <
                                          Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context,
                                                  'OK'),
                                          child:
                                          const Text(
                                              'OK'),
                                        ),
                                      ],
                                    ),
                                );
                              }
                            },
                            child: const Text(
                              'التالي',
                              style: TextStyle(fontSize: 22),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 20,
              top: screenHeight * 0.04,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 32,
                  color: Color(0xFFB7D2CC),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }




}
