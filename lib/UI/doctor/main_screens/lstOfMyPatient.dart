import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lst_blood_tap.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lst_diabetes_tap.dart';
import 'package:diabetes_and_hypertension/UI/user_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Service/firebase_service.dart';
import '../../loading.dart';
import 'models.dart';
String doctorFullName = "";
String doctorCode = "";
List<Patient> diabetesPatients = [];
List<Patient> bloodPressurePatients = [];
Future<DocumentSnapshot<Object?>>? getInitData() async {
  DocumentSnapshot doctorData = await FirebaseFirestore.instance
      .collection('/doctors')
      .doc(UserSimplePreferencesDoctorID.getDrID())
      .get();
  Map<String, dynamic> parsedDoctorData = doctorData.data() as Map<String, dynamic>;
  doctorFullName = parsedDoctorData['first-name'] + " "+ parsedDoctorData['second-name'] ;
  await UserSimplePreferencesDoctorID.setDrName(doctorFullName);
  doctorCode = parsedDoctorData['DrID'];
  QuerySnapshot<Map<String, dynamic>> allPatients = await FirebaseFirestore.instance.collection('/patient').get();
  List<Patient> listOfPatients = allPatients.docs.map((document) {
    final user = document.data();
    return Patient(
      namePatient: user['Name'],
      patientHieght: user['Hieght'],
      patientWeight: user['weight'],
      diabetesType: user['Diabetes Type'],
      dateOfBirth: user['Date of birth'],
      patientID: user['User'],
      nationalNumberPatient: user['National ID'],
      doctorID: user['DoctorID'],
      patentPhone: user['phone'],
      hasDiabetes: user['hasDiabetes'],
      hasBloodPressure: user['hasBloodPressure'],
      isSmoker: user['isSmoker'],
      isAlcoholic: user['isAlcoholic'],
      isHaveNewDiabetesRead: user['isHaveNewDiabetesRead'],
      isBeforeBloodRead: user['isBeforeBloodRead'],
      lastDiabetesRead: double.parse(user['lastDiabetesRead'].toString()),
      isHaveNewBloodRead: user['isHaveNewBloodRead'],
      isMorningBloodRead: user['isMorningBloodRead'],
      lastDiastolicBloodRead: double.parse(user['lastDiastolicBloodRead'].toString()),
      lastSystolicBloodRead: double.parse(user['lastSystolicBloodRead'].toString()),
      lastHartRateRead: double.parse(user['lastHartRateRead'].toString()),
      commitmentCounter: user['commitmentCounter'],
      readingsCounter: user['readingsCounter'],
      counterOfWeeks: user['counterOfWeeks'],
      history: user['history'],
    );
  }).toList();
  bloodPressurePatients.clear();
  diabetesPatients.clear();
  for (int i = 0; i < listOfPatients.length; i++) {
    final patient = listOfPatients[i];
    if (patient.doctorID == doctorCode) {
      if (patient.hasBloodPressure) {
        bloodPressurePatients.add(patient);
      }
      if (patient.hasDiabetes) {
        diabetesPatients.add(patient);
      }
    }
  }
  theDataFetchedLstPa =true ;
  return doctorData;
}
bool theDataFetchedLstPa = false;

class ListOfPatient extends StatefulWidget {
  const ListOfPatient({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListOfPatientState createState() => _ListOfPatientState();
}

class _ListOfPatientState extends State<ListOfPatient> with SingleTickerProviderStateMixin{

  TabController? _tapController;

  @override
  void initState() {
    _tapController = TabController(
      length: 2,
      initialIndex: 1,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final drawerItems = ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'images/newprofile.svg',
              colorFilter: const ColorFilter. mode (  Colors.white , BlendMode. srcIn,),
              height: 60,
              width: 60,
            ),
            Text('د. ${UserSimplePreferencesDoctorID.getDrName()}',
              //+ name_patient,
              style: GoogleFonts.tajawal(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        ListTile(
          title: Row(
            children: [
              const Icon(
                Icons.numbers,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'رمز الطبيب :  ${UserSimplePreferencesDoctorID.getDrID()}',
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () {},
        ),
         Divider(
          thickness: 1,
          color: Colors.white.withOpacity(0.5),
          indent: 30,
          endIndent: 30,
        ),
        ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 15,
              ),
               Text(
                'تسجيل خروج',
                style: TextStyle(color: Colors.white, fontSize: 20),),
            ],
          ),
          onTap: () {
            //TODO:  format the shred perf
            _signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AppUser()
                ),
                    (route) => false
            );
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.white.withOpacity(0.5),
          indent: 30,
          endIndent: 30,
        ),
        SizedBox(height: screenHeight * 0.32,),
        Container(
          padding: const EdgeInsets.only(left: 42, right: 42,),
          height: screenHeight * 0.23,
          width:  screenWidth * 0.2,
          child: Text(
            "طَمّني حَكِيمٌ",
            style: GoogleFonts.notoNastaliqUrdu(
                fontSize: 50,
                color: const Color(0xff20AEC1).withOpacity(0.85)
            ),
          ),
        )
      ],
    );
    return FutureBuilder<DocumentSnapshot>(
      future: theDataFetchedLstPa ? null : getInitData(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ERROR");
          }
          if (snapshot.connectionState == ConnectionState.done || theDataFetchedLstPa) {
            return Scaffold(
              // key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                elevation: 0,
                iconTheme: const IconThemeData(color: Color(0xff0B3C42), size: 40),
              ),
              endDrawer: Directionality(
                textDirection: TextDirection.rtl,
                child: Drawer(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                  ),
                  //shape: Icon(Icons.menu),
                  child: Container(
                      padding: const EdgeInsets.only(left: 15, top: 61, right: 15, bottom: 61,),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF23BBCF), Color(0xFF0B3C42)],
                            stops: [0.0, 1.0],
                          ),
                          borderRadius:BorderRadius.only(
                            topLeft: Radius.circular(40.00,),
                            bottomLeft: Radius.circular(40.00,),
                          )
                      ),
                      child: drawerItems
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مرحبا',
                              style: GoogleFonts.tajawal(
                                  fontSize: 20, color: const Color(0xff0B3C42)),
                            ),
                            Text('د. ${UserSimplePreferencesDoctorID.getDrName()}',
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25, color: const Color(0xff0B3C42)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset(
                            'images/profile.png',
                            color: const Color(0xff75797A),
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      child: _buildTabs(),
                      // child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     _buildTabs(),
                      //     Expanded(
                      //       child: _buildTabsContent(),
                      //     )
                      //   ],
                      // ),
                    ),
                    Expanded(
                      child: _buildTabsContent(),
                    )

                  ],
                ),
              ),
            );
          }
          return const Loading();
      }
    );
  }
  Widget _buildTabsContent() {
    return TabBarView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _tapController,
      children: _buildTabsContentItems(),
    );
  }
  List<Widget> _buildTabsContentItems() {
    List<Widget> list = <Widget>[];
    list.add(ListOfBloodPatients(lstPatients: bloodPressurePatients,));
    list.add(ListOfDiabetesPatients(lstPatients: diabetesPatients,));
    return list;
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14091e42),
              offset: Offset(0, 2),
              blurRadius: 1,
              spreadRadius: -1),
          BoxShadow(
              color: Color(0x19091e42),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TabBar(
          isScrollable: false,
          indicatorColor: const Color(0xff0B3C42),
          labelColor: const Color(0xff0B3C42),
          indicatorWeight: 2.0,
          controller: _tapController,
          unselectedLabelColor: const Color(0xFF8993a4),
          tabs: _buildTabsItems(),
        ),
      ),
    );
  }
  List<Widget> _buildTabsItems() {
    List<Widget> list = <Widget>[];
    list.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "ضغط",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    ));

    list.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "سكري",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    ));
    return list;
  }
}

Future<void> _signOut() async {
  UserSimplePreferencesDoctorID.setDrID("");
  UserSimplePreferencesDoctorID.setDrName("");
  UserSimplePreferencesDoctorID.setUserType("");
  await FirebaseAuth.instance.signOut();
}