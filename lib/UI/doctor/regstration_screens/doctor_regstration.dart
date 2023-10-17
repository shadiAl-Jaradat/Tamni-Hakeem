import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lstOfMyPatient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Service/firebase_service.dart';
import 'package:intl/intl.dart' as intl;

final intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');

bool selected = false;
String time = 'اليوم - الشهر - السنة';
final _time = TextEditingController();

class DoctorReg extends StatefulWidget {
  @override
  _DoctorRegState createState() => _DoctorRegState();
}

class _DoctorRegState extends State<DoctorReg> {
  late String firstnameDoctor = "";
  late String lastnameDoctor = "";
  late String doctorID = "";
  late String DateBirthDoctor = "";
  final _formKey = GlobalKey<FormState>();



  Future<void> insertDrData() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorID)
          .set({
        'first-name': firstnameDoctor,
        'second-name': lastnameDoctor,
        'DrID': doctorID,
      });
    } catch (e) {
      print(e);
    }
  }

  void navigateToPage(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ListOfPatient(),
      ),
          (Route<dynamic> route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background.png"),
                    fit: BoxFit.cover)),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Scrollbar(
                  child: ListView(shrinkWrap: true, children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.linear,
                        width: double.infinity,
                        //height: selected ? screenHeight * 0.9 : screenHeight * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.fromLTRB(25, 25, 25, 10),
                                  height: selected
                                      ? screenHeight * 0.9
                                      : screenHeight * 0.75,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              setState(() {
                                                firstnameDoctor = value;
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'الاسم الأول',
                                            hintText:
                                                'الرجاء ادخال الاسم الأول',
                                            labelStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color(0xff752C20)),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                          ),
                                        ),

                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              setState(() {
                                                lastnameDoctor = value;
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'اسم العائلة',
                                            hintText:
                                                'الرجاء ادخال اسم العائلة',
                                            labelStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color(0xff752C20)),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                          ),
                                        ),

                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              setState(() {
                                                doctorID = value;
                                              });
                                            }
                                          },
                                          maxLength: 5,
                                          decoration: InputDecoration(
                                            counter: SizedBox.shrink(),
                                            labelText: 'رمز الدكتور',
                                            hintText: 'xxxxx',
                                            labelStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color(0xff752C20)),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 18,
                                                color: const Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff1D98A8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              ),
                                              minimumSize: Size(308, 35),
                                            ),
                                            onPressed: () async {
                                              if ( _formKey.currentState!.validate()) {

                                                await UserSimplePreferencesDoctorID.setDrID(doctorID);
                                                await UserSimplePreferencesDoctorID.setDrName(firstnameDoctor);
                                                await UserSimplePreferencesDoctorID.setUserType('Dr');

                                                await insertDrData();

                                                navigateToPage();

                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text('ERROR'),
                                                            content: const Text('no '),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context, 'OK'),
                                                                child: const  Text('OK'),
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
                                        // SizedBox(
                                        //   height: 30,
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ])),
                  ]),
                ))));
  }
}
