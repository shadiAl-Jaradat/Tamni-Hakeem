import 'package:diabetes_and_hypertension/UI/statistics/blood_statistics.dart';
import 'package:diabetes_and_hypertension/UI/statistics/diabetes_statistics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Service/firebase_service.dart';




class StatisticsHome extends StatefulWidget {
  const StatisticsHome({Key? key}) : super(key: key);
  @override
  _StatisticsHomeHomeState createState() => _StatisticsHomeHomeState();
}

class _StatisticsHomeHomeState extends State<StatisticsHome> {
  final PageController _pageController = PageController();
  late final List<Widget> _screens;

  int _selectedIndex = 0;
  Widget currentScreen = const DiabetesStatisticsPage();

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
    _screens = const [
      DiabetesStatisticsPage(),
      BloodStatistics()
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
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
          ),
          Positioned(
              left: 18,
              top: screenHeight * 0.035,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 32,
                  color: Color(0xff0B3C42),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BottomAppBar(
          color: const Color(0xff0B3C42),
          child: Container(
            height: screenHeight * 0.065,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                  MaterialButton(
                      onPressed: () => _onItemTapped(0),
                      child: Text(
                        "سكري",
                        style: GoogleFonts.tajawal(
                          fontSize: 20,
                          color: _selectedIndex == 0
                              ? const Color(0xff6CD7E6)
                              : const Color(0xff87B7C1),
                          fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                MaterialButton(
                    onPressed: () => _onItemTapped(1),
                    child: Text(
                      "ضغط",
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        color: _selectedIndex == 1
                            ? const Color(0xff6CD7E6)
                            : const Color(0xff87B7C1),
                        fontWeight: FontWeight.bold
                      ),
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