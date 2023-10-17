import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blood_manual_screen.dart';
import 'dia_manual_screen.dart';

class ManualHomeScreen extends StatefulWidget {
  const ManualHomeScreen({super.key});

  @override
  State<ManualHomeScreen> createState() => _ManualHomeScreenState();
}

class _ManualHomeScreenState extends State<ManualHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tapController;

  @override
  void initState() {
    _tapController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabs(),
                  Expanded(
                    child: _buildTabsContent(),
                  )
                ],
              ),
            ),
            Positioned(
                left: 20,
                top: screenHeight * 0.02,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 32, color: Color(0xff0B3C42)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: screenWidth * 0.35,
                    ),
                    Text(
                      "آلية استعمال جهازي",
                      style: GoogleFonts.tajawal(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff0B3C42)),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
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
        "سكري",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    ));

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
    return list;
  }

  Widget _buildTabsContent() {
    return Container(
      child: TabBarView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _tapController,
        children: _buildTabsContentItems(),
      ),
    );
  }

  List<Widget> _buildTabsContentItems() {
    List<Widget> list = <Widget>[];
    list.add(DiabetesDevices());
    list.add(BloodDevices());
    return list;
  }
}
