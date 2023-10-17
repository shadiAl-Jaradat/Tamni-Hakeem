import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/patient/main_screens/diabetes_screens/patient_readings_diabetes.dart';
import 'package:diabetes_and_hypertension/UI/patient/main_screens/hypertension_screens/patient_readings_blood.dart';
import 'package:diabetes_and_hypertension/UI/user_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Service/firebase_service.dart';
import '../../change_doctor_page.dart';
import '../manual/manual_home_screen.dart';
import 'chart_labs_page.dart';


final User? user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;


Future<String> getName() async{
  final User? user = FirebaseAuth.instance.currentUser;
  final uid = UserSimplePreferencesUser.getUserID() ?? user?.uid;
  return (FirebaseFirestore.instance.collection('/doctors').doc(UserSimplePreferencesDoctorID.getDrID()).collection('/patient').doc(uid).get()).toString();
}


class BarHome extends StatefulWidget {
  const BarHome({Key? key}) : super(key: key);

  @override
  _BarHomeState createState() => _BarHomeState();
}

class _BarHomeState extends State<BarHome> {
  final PageController _pageController = PageController();
  late final List<Widget> _screens;

  int _selectedIndex = 0;
  Widget currentScreen = PatientInformationDiabetes();

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }


  late bool hasDiabetes;
  late bool hasBlood;


  @override
  void initState() {
    hasDiabetes = UserSimplePreferencesUser.getPaDiabetes() ?? false;
    hasBlood = UserSimplePreferencesUser.getPaBlood() ?? false;
    _screens = [
      if(hasDiabetes) const PatientInformationDiabetes(),
      //TODO: change it to BloodPressure page
      if(hasBlood) const PatientInformationBlood(),
      ChartLabsPage(),
    ];

    print("sososoooooooo");
    print(hasDiabetes);
    print(hasBlood);
    print(_screens);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/newprofile.svg',
              colorFilter: const ColorFilter.mode(Colors.white,BlendMode.srcIn),
              height: screenHeight * 0.07,
              width:  screenWidth * 0.07,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                "  ${UserSimplePreferencesUser.getPaName() ?? 'name'}",
                //+ name_patient,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        ListTile(
          title: Row(
            children: [
              const ImageIcon(
                AssetImage('images/info.png'),
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'تعديل طبيبي',
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push( context, MaterialPageRoute(builder: (context) => const ChangeMyDoctor()));
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.white.withOpacity(0.5),
          indent: 30,
          endIndent: 50,
        ),
        ListTile(
          title: Row(
            children: [
              const ImageIcon(
                AssetImage('images/tsts.png'),
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'آلية استعمال الاجهزة',
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18,)
              ),
            ],
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualHomeScreen()));
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.white.withOpacity(0.5),
          indent: 30,
          endIndent: 50,
        ),
        ListTile(
          title: Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'تسجيل خروج',
                style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18),),
            ],
          ),
          onTap: () {
            //TODO:  format the shred perf
            _signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AppUser()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.white.withOpacity(0.5),
          indent: 30,
          endIndent: 50,
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
              color: Color(0xff20AEC1).withOpacity(0.85)
            ),
          ),
        )
      ],
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData( size: 40),
        automaticallyImplyLeading: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      endDrawer: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Drawer(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
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
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: const Color(0xff0B3C42),
          child: Container(
            height: screenHeight * 0.06, // Set a fixed height for the BottomAppBar
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding if needed
            child: Row(
              mainAxisAlignment: ( (hasDiabetes && !hasBlood) || (!hasDiabetes && hasBlood) )
              ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceBetween,
              children: [
                if(hasDiabetes)
                  MaterialButton(
                  onPressed: () => _onItemTapped(0),
                  child: SvgPicture.asset(
                      "images/diabetesImage.svg",
                      color: _selectedIndex == 0
                          ? const Color(0xff6CD7E6)
                          : const Color(0xff87B7C1),
                      height: 30,
                      width: 30,
                    )
                ),

                if (hasBlood)
                  MaterialButton(
                  onPressed: () => _onItemTapped(hasDiabetes ?  1 : 0),
                  child: SvgPicture.asset(
                      "images/bloodImage.svg",
                    color: _selectedIndex == (hasDiabetes ?  1 : 0)
                      ? const Color(0xff6CD7E6)
                        : const Color(0xff87B7C1),
                    height: 30,
                    width: 30,
                  )
                ),

                MaterialButton(
                  onPressed: () => _onItemTapped( ( hasDiabetes && hasBlood) ?  2 : 1),
                  child:
                    SvgPicture.asset(
                      "images/chartIconTest.svg",
                      color: _selectedIndex == ( (hasDiabetes && hasBlood) ?  2 : 1)
                          ? const Color(0xff6CD7E6)
                          : const Color(0xff87B7C1),
                      height: 30,
                      width: 30,
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> _signOut() async {

  await FirebaseAuth.instance.signOut();
}