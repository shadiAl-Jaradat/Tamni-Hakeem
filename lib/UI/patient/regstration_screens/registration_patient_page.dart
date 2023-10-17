import 'package:diabetes_and_hypertension/UI/patient/main_screens/diabetes_screens/bottom_bar_home.dart';
import 'package:diabetes_and_hypertension/UI/patient/regstration_screens/diabetes_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../Service/firebase_service.dart';



final intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');

bool selected = false;
String time = 'اليوم - الشهر - السنة';
final _time = TextEditingController();

class RegistrationPatientPage extends StatefulWidget {
  String phone;
  RegistrationPatientPage({required this.phone});
  @override
  _RegistrationPatientPageState createState() => _RegistrationPatientPageState();
}

class _RegistrationPatientPageState extends State<RegistrationPatientPage> {
  final _formKey = GlobalKey<FormState>();
  late String namePatient;
  late String heightPatient;
  late String weightPatient;
  late String doctorId;
  late String DateOfPatient;
  late String nationalNumberPatient;
  late int highSystolicTarget;
  late int lowSystolicTarget;
  late int highDiastolicTarget;
  late int lowDiastolicTarget;
  late int sickType;
  bool bloodPressure = false;
  bool diabetes = false;
  bool both = false;
  bool isSmoker = false;
  bool isAlcoholic = false;



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
                        decoration: const BoxDecoration(
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
                                  margin: const EdgeInsets.fromLTRB(25, 25, 25, 10),
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
                                              namePatient = value;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            labelText: 'الاسم',
                                            hintText:
                                            'الرجاء ادخال الاسم الثلاثي',
                                            labelStyle: GoogleFonts.tajawal(
                                              fontSize: 25,
                                              color: Color(0xff752C20),
                                            ),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 15,
                                                color: const Color.fromRGBO(178, 178, 178, 1)),
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty &&
                                                    value.length < 10) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              nationalNumberPatient = value;
                                            }
                                          },
                                          //TODO:GG
                                          maxLength: 10,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            counter: const SizedBox.shrink(),
                                            labelText: 'الرقم الوطني',
                                            hintText: 'xxxxxxxxxx',
                                            labelStyle: GoogleFonts.tajawal(
                                              fontSize: 25,
                                              color: Color(0xff752C20),
                                            ),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 15,
                                                color: const Color.fromRGBO(178, 178, 178, 1)),
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              DateOfPatient = value;
                                            }
                                          },
                                          controller: _time,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            focusColor: const Color.fromRGBO(178, 178, 178, 1),
                                            labelText: 'تاريخ الميلاد',
                                            hintText: 'اليوم - الشهر - السنة',
                                            labelStyle: GoogleFonts.tajawal(
                                              fontSize: 25,
                                              color: Color(0xff752C20),
                                            ),
                                            hintStyle: GoogleFonts.tajawal(
                                                fontSize: 15,
                                                color: const Color.fromRGBO(178, 178, 178, 1)),
                                            suffixIconColor: const Color.fromRGBO(178, 178, 178, 1),
                                            suffixIcon: IconButton(
                                                onPressed: () async {
                                                  final myDateTime =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1920),
                                                      lastDate: DateTime(2025));
                                                  setState(() {
                                                    time = intl.DateFormat('dd-MM-yyyy').format(myDateTime!);
                                                    _time.text = time;
                                                  });
                                                },
                                                icon: const Icon(Icons.calendar_today)),
                                          ),
                                          onTap: () async {
                                            final myDateTime =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1920),
                                                lastDate: DateTime(2025));
                                            setState(() {
                                              time = intl.DateFormat('dd-MM-yyyy').format(myDateTime!);
                                              _time.text = time;
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 140,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'هذه الخانة مطلوبه';
                                                  } else {
                                                    heightPatient = value;
                                                  }
                                                },
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  labelText: 'الطول',
                                                  labelStyle: GoogleFonts.tajawal(
                                                    fontSize: 25,
                                                    color: Color(0xff752C20),
                                                  ),
                                                  hintStyle:  GoogleFonts.tajawal(
                                                      fontSize: 15,
                                                      color: const Color.fromRGBO(
                                                          178, 178, 178, 1)),
                                                  hintText: 'م',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 140,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'هذه الخانة مطلوبه';
                                                  } else {
                                                    weightPatient = value;
                                                  }
                                                },
                                                keyboardType:
                                                TextInputType.number,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  labelText: 'الوزن',
                                                  labelStyle: GoogleFonts.tajawal(
                                                    fontSize: 25,
                                                    color: Color(0xff752C20),
                                                  ),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromRGBO(
                                                          178, 178, 178, 1)),
                                                  hintText: 'كج',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'هذه الخانة مطلوبه';
                                            } else {
                                              doctorId = value;
                                            }
                                          },
                                          maxLength: 5,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            counter: const SizedBox.shrink(),
                                            labelText: 'رمز الدكتور',
                                            hintText: 'xxxxx',
                                            labelStyle: GoogleFonts.tajawal(
                                              fontSize: 25,
                                              color: Color(0xff752C20),
                                            ),
                                            hintStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isAlcoholic,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isAlcoholic = value!;
                                                        });
                                                      },
                                                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                                                              (Set<MaterialState> states) {
                                                            if (states.contains(MaterialState.selected)) {
                                                              return const Color(0xff752C20);
                                                            }
                                                            return null; // Use default value
                                                          }),
                                                      side: const BorderSide(
                                                        color: Color.fromRGBO(178, 178, 178, 1),
                                                      ),
                                                    ),
                                                    Text("تشرب الكحول ",
                                                    style: GoogleFonts.tajawal(
                                                      fontSize: 18,
                                                      color: const Color(0xff752C20),
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:const  EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isSmoker,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isSmoker = value!;
                                                        });
                                                      },
                                                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                                                              (Set<MaterialState> states) {
                                                            if (states.contains(MaterialState.selected)) {
                                                              return const Color(0xff752C20);
                                                            }
                                                            return null; // Use default value
                                                          }),
                                                      side: const BorderSide(
                                                        color: Color.fromRGBO(178, 178, 178, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                        "مدخن",
                                                      style: GoogleFonts.tajawal(
                                                        fontSize: 18,
                                                        color: Color(0xff752C20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.all(13.0),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      shape: const CircleBorder(),
                                                      value: diabetes,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          //ُTODO
                                                          bloodPressure = false;
                                                          diabetes = value!;
                                                          both = false;
                                                        });
                                                      },
                                                      checkColor: Colors.transparent,
                                                      activeColor: const Color(0xff752C20),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      visualDensity: VisualDensity.compact,
                                                      side: const BorderSide(
                                                        color: Color.fromRGBO(178, 178, 178, 1),
                                                      ),
                                                    ),
                                                    Text("سكري",
                                                      style: GoogleFonts.tajawal(
                                                        fontSize: 18,
                                                        color: const Color(0xff752C20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:const  EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      shape: const CircleBorder(),
                                                      value: bloodPressure,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          bloodPressure = value!;
                                                          diabetes = false;
                                                          both = false;
                                                        });
                                                      },
                                                      checkColor: Colors.transparent,
                                                      activeColor: const Color(0xff752C20),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      visualDensity: VisualDensity.compact,
                                                      side: const BorderSide(
                                                        color: Color.fromRGBO(178, 178, 178, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      "ضغط",
                                                      style: GoogleFonts.tajawal(
                                                        fontSize: 18,
                                                        color: Color(0xff752C20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:const  EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      shape: const CircleBorder(),
                                                      value: both,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          bloodPressure = false;
                                                          diabetes = false;
                                                          both = value!;
                                                        });
                                                      },
                                                      checkColor: Colors.transparent,
                                                      activeColor: const Color(0xff752C20),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      visualDensity: VisualDensity.compact,
                                                      side: const BorderSide(
                                                        color: Color.fromRGBO(178, 178, 178, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      "معا",
                                                      style: GoogleFonts.tajawal(
                                                        fontSize: 18,
                                                        color: Color(0xff752C20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        diabetes || both
                                            ? Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 25.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text('نوع السكري',
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.tajawal(
                                                      fontSize: 18,
                                                      color: Color(0xff752C20),
                                                    ),
                                                  ),
                                                  DiabetesType(),
                                                ],
                                              ),
                                            )
                                            : Container(),

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff1D98A8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(14.0),
                                              ),
                                              minimumSize: const Size(308, 35),
                                            ),
                                            onPressed: () async{

                                              // if (doctorId != null &&
                                              //     DateOfPatient != null &&
                                              //     namePatient != null &&
                                              //     heightPatient != null &&
                                              //     weightPatient != null &&
                                              //     nationalNumberPatient != null)


                                             if(_formKey.currentState!.validate()){

                                                await UserSimplePreferencesUser.setPaName(namePatient);
                                                await UserSimplePreferencesUser.setPaDiabetes(both == true ? both : diabetes);
                                                await UserSimplePreferencesUser.setPaBlood(both == true ? both :bloodPressure );
                                                await UserSimplePreferencesUser.setLastOpen(DateTime.now().toString());
                                                await UserSimplePreferencesUser.setCtOfWeek('0');
                                                await UserSimplePreferencesDoctorID.setDrID(doctorId);


                                                // FirebaseServiceDoctor(
                                                //   dateOfPatient: DateOfPatient,
                                                //   doctorId: doctorId,
                                                //   heightPatient: heightPatient,
                                                //   namePatient: namePatient,
                                                //   nationalNumberPatient: nationalNumberPatient,
                                                //   weightPatient: weightPatient,
                                                //   patentPhone: widget.phone,
                                                //
                                                //   highDiastolicTarget: 120,
                                                //   lowDiastolicTarget: 80,
                                                //
                                                //   highSystolicTarget: 120,
                                                //   lowSystolicTarget: 80,
                                                //
                                                //   hasBloodPressure: both == true ? both : bloodPressure,
                                                //   hasDiabetes: both == true ? both : diabetes ,
                                                //
                                                //   isSmoker: isSmoker,
                                                //   isAlcoholic: isAlcoholic,
                                                // ).insertDataCollection();

                                                createNewPatient(
                                                  dateOfPatient: DateOfPatient,
                                                  doctorId: doctorId,
                                                  heightPatient: heightPatient,
                                                  namePatient: namePatient,
                                                  nationalNumberPatient: nationalNumberPatient,
                                                  weightPatient: weightPatient,
                                                  patentPhone: widget.phone,

                                                  highDiastolicTarget: 120,
                                                  lowDiastolicTarget: 80,

                                                  highSystolicTarget: 120,
                                                  lowSystolicTarget: 80,

                                                  hasBloodPressure: both == true ? both : bloodPressure,
                                                  hasDiabetes: both == true ? both : diabetes ,

                                                  isSmoker: isSmoker,
                                                  isAlcoholic: isAlcoholic,
                                                );

                                                _navigateToPage();

                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: Text('ERROR'),
                                                    content: Text('no '),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              };
                                            },
                                            child: Text(
                                              'التالي',
                                              style: GoogleFonts.tajawal(fontSize: 22),
                                            )),


                                        SizedBox(
                                          height: screenHeight * 0.04,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ])),
                  ]),
                )))
    );
  }

  void _navigateToPage(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BarHome(),
      ),
          (Route<dynamic> route) => false,
    );
  }
}
