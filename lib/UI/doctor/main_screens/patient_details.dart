import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/labs_of_patient.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lstOfMyPatient.dart' as lstOfMyPatientPage;
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/models.dart';
import 'package:diabetes_and_hypertension/UI/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Service/firebase_service.dart';

int maxWeek = 0;
int minWeek = 0;
int currentWeek = 0;
bool weekHasNotData = true;
bool isPlus = false;
bool theDataFetched = false;
class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class ReadingDataAfter {
  final String day;
  final DateTime time;
  final double value;

  ReadingDataAfter({required this.day, required this.time,required this.value});
  int get dayIndex => customWeekdayIndex(time);

}

class ReadingDataBefore {
  final String day;
  final DateTime time;
  final double value;

  ReadingDataBefore({required this.day, required this.time,required this.value});
  int get dayIndex => customWeekdayIndex(time);
}

List<String> listOfLabs = [];

Future<void> getLabs(Patient patient) async {
  listOfLabs = await getFilesList(patient);
}

Future<List<String>> getFilesList(Patient patient) async {

  List<String> filePaths = [];
  Reference storageRef = FirebaseStorage.instance.ref()
      .child('Patients_labs')
      .child('/${UserSimplePreferencesUser.getUserID()}');

  dynamic listOfFiles = await storageRef.listAll();

  for (var file in listOfFiles.items) {
    String downloadURL = await file.getDownloadURL();
    filePaths.add(downloadURL);
    // _cardListFiles.add(createCardFile(downloadURL));
  }


  if (kDebugMode) {
    print(filePaths);
  }
  return filePaths;
}

Future<DocumentSnapshot<Object?>>? fetchData(bool isDiabetes, Patient patient) async{
  maxWeek =  patient.counterOfWeeks;
  await getLabs(patient);
  CollectionReference users = FirebaseFirestore.instance
      .collection('/patient');
  dynamic data;
  // do{
  data = isDiabetes
      ? await users
      .doc(patient.patientID)
      .collection('/diabetesWeeks')
      .doc(currentWeek.toString())
      .get()
      : await users
      .doc(patient.patientID)
      .collection('/bloodWeeks')
      .doc(currentWeek.toString())
      .get();
  Map<String, dynamic> parseData = data!.data() as Map<String, dynamic>;
  //
  if(isDiabetes ==true ){
    weekHasNotData = parseData['AfterReadings'].length == 0 && parseData['BeforeReadings'].length == 0;
  }
  else {
    weekHasNotData = parseData['EveningDiastolicReadings'].length == 0 && parseData['MorningDiastolicReadings'].length == 0;
  }
  // theDataFetched = true;
  return data;
}



class Details extends StatefulWidget {
  final Patient patient;
  final bool isDiabetes;
  const Details({
    super.key,
    required this.isDiabetes,
    required this.patient,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  // final TextEditingController _historyController = TextEditingController();
  DateTime firstDayOfWeek = DateTime.now();
  DateTime lastDayOfWeek = DateTime.now();
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }


  @override
  void dispose() {
    theDataFetched = false;
    maxWeek = 0;
    minWeek = 0;
    currentWeek = 0;
    weekHasNotData = true;
    isPlus = false;
    super.dispose();
  }
  List<ReadingDataBefore> beforeReadings = [];
  List<ReadingDataAfter> afterReadings = [];
  List<ReadingDataBefore> dummyReadings = [];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    makingPhoneCall(String phoneNum) async {
      var url = Uri.parse("tel:+926$phoneNum");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    return FutureBuilder<DocumentSnapshot>(
        future: theDataFetched ? null : fetchData(widget.isDiabetes, widget.patient),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ERROR");
          }

          if ( theDataFetched || snapshot.connectionState == ConnectionState.done){
            if(theDataFetched == false){
              afterReadings.clear();
              beforeReadings.clear();
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              for (int i = 0;
                  i <
                      (widget.isDiabetes
                          ? data['AfterReadings'].length
                          : data['EveningDiastolicReadings'].length);
                  i++) {
                afterReadings.add(ReadingDataAfter(
                    day: widget.isDiabetes
                        ? data['Days_English_after'][i]
                        : data['Days_English_evening'][i],
                    time: widget.isDiabetes
                        ? data['AfterDateTime'][i].toDate()
                        : data['EveningDateTime'][i].toDate(),
                    value: widget.isDiabetes
                        ? double.parse(data['AfterReadings'][i].toString())
                        : double.parse(data['EveningDiastolicReadings'][i]
                                .toString()) +
                            0.3 *
                                (double.parse(data['EveningSystolicReadings'][i]
                                        .toString()) -
                                    double.parse(
                                        data['EveningDiastolicReadings'][i]
                                            .toString()))));
              }


              if (widget.isDiabetes) {
                for (int i = 0; i < (data['BeforeReadings'].length); i++) {
                  beforeReadings.add(ReadingDataBefore(
                      day: data['Days_English_before'][i],
                      time: data['BeforeDateTime'][i].toDate(),
                      value:
                          double.parse(data['BeforeReadings'][i].toString())));
                }
              } else {
                for (int i = 0;
                    i < (data['MorningDiastolicReadings'].length);
                    i++) {
                  beforeReadings.add(ReadingDataBefore(
                      day: data['Days_English_morning'][i],
                      time: data['MorningDateTime'][i].toDate(),
                      value: double.parse(
                              data['MorningDiastolicReadings'][i].toString()) +
                          0.3 *
                              (double.parse(data['MorningSystolicReadings'][i]
                                      .toString()) -
                                  double.parse(data['MorningDiastolicReadings']
                                          [i]
                                      .toString()))));
                }
              }
              dummyReadings.clear();

              if(beforeReadings.isNotEmpty) {
                DateTime anyDayOfThisWeek = beforeReadings[0].time;
                int indexOfCurrentDay = customWeekdayIndex(anyDayOfThisWeek);
                firstDayOfWeek = getFirstDayOfWeek(
                    indexOfCurrentDay, anyDayOfThisWeek);
                lastDayOfWeek = getLastDayOfWeek(
                    indexOfCurrentDay, anyDayOfThisWeek);
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 1)), day: "sat"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 2)), day: "sun"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 3)), day: "mon"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 4)), day: "tues"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 5)), day: "wed"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 6)), day: "thurs"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 7)), day: "fri"));
              }
              else if(afterReadings.isNotEmpty){
                DateTime anyDayOfThisWeek = afterReadings[0].time;
                int indexOfCurrentDay = customWeekdayIndex(anyDayOfThisWeek);
                firstDayOfWeek = getFirstDayOfWeek(
                    indexOfCurrentDay, anyDayOfThisWeek);
                lastDayOfWeek = getLastDayOfWeek(
                    indexOfCurrentDay, anyDayOfThisWeek);
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 1)), day: "sat"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 2)), day: "sun"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 3)), day: "mon"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 4)), day: "tues"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 5)), day: "wed"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 6)), day: "thurs"));
                dummyReadings.add(ReadingDataBefore(value: 0,time: firstDayOfWeek.add(const Duration(days: 7)), day: "fri"));
              }

              theDataFetched = true;
            }


            return Scaffold(
              backgroundColor: Colors.white,
              body: ListView(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          //TODO:  must be push and remove
                          lstOfMyPatientPage.theDataFetchedLstPa = false;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const lstOfMyPatientPage.ListOfPatient(),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios,  size: 32,
                          color: Color(0xff0B3C42), ),
                        color: const Color(0xff0B3C42),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LabsOfPatient(patientID: widget.patient.patientID,labsPaths: listOfLabs,)));
                        },
                        child: const Padding(
                          padding:  EdgeInsets.only(top:10.0),
                          child: Text(
                            'التحاليل المختبرية',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0B3C42),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //TODO chart

                weekHasNotData
                    ? Image.asset(
                      "images/noRedingsTwo.png",
                      width: screenWidth,
                      height: screenHeight * 0.4,
                    )
                    : Stack(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: SfCartesianChart(
                                  primaryXAxis: DateTimeAxis(
                                    interval: 1, // Set the interval to 1 day
                                    dateFormat: intl.DateFormat.E(), // Display day names (e.g., Mon, Tue, etc.)
                                    majorGridLines: const MajorGridLines(width: 0),
                                    majorTickLines: const MajorTickLines(size: 0),
                                    minorGridLines: const MinorGridLines(width: 0),
                                    minorTickLines: const MinorTickLines(size: 0),
                                    rangePadding: ChartRangePadding.none,
                                    intervalType: DateTimeIntervalType.days,
                                    visibleMinimum: firstDayOfWeek.subtract(const Duration(days: 1)),
                                    visibleMaximum: lastDayOfWeek.subtract(const Duration(days: 1)),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: const MajorGridLines(width: 1),
                                  ),
                                  legend: const Legend(
                                    isVisible: true,
                                    position: LegendPosition.top,
                                  ),
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <SplineSeries>[

                                    SplineSeries<ChartData, DateTime>(
                                        name: widget.isDiabetes? "صائم" : "صباح",
                                        color: const Color(0xff20AEC1),
                                        dataSource: <ChartData>[

                                          for ( int i = 0; i < beforeReadings.length ; i++)
                                            ChartData(
                                                beforeReadings[i].time,
                                                beforeReadings[i].value
                                            ),

                                        ],
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        // Enable data label
                                        enableTooltip: true,
                                        markerSettings: const MarkerSettings(isVisible: true),
                                        dataLabelSettings: const DataLabelSettings(isVisible: true)),


                                    SplineSeries<ChartData, DateTime>(
                                      name: widget.isDiabetes ? "غير صائم" : "مساء",
                                      color: const Color(0xff167582),
                                      dataSource:  <ChartData>[
                                        for ( int i = 0; i < afterReadings.length ; i++)
                                          ChartData(
                                              afterReadings[i].time,
                                              afterReadings[i].value
                                          ),
                                      ],
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      // Enable data label
                                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                                      enableTooltip: true,
                                      markerSettings: const MarkerSettings(isVisible: true),
                                    ),



                                    SplineSeries<ChartData, DateTime>(
                                      name: "",
                                      color: Colors.white,
                                      isVisibleInLegend: false,
                                      dataSource:  <ChartData>[
                                        for(int i=0;i< dummyReadings.length ; i++)
                                          ChartData(
                                              dummyReadings[i].time,
                                              dummyReadings[i].value
                                          ),
                                      ],
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      // Enable data label
                                      dataLabelSettings: const DataLabelSettings(isVisible: false),

                                    )

                                  ]
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                            width: screenWidth,
                            right: -20,
                            bottom: screenHeight*0.004,
                            child: Container(
                              height: 20,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text("سبت", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 45),
                                  Text("احد", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 45),
                                  Text("اثنين", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 45),
                                  Text("ثلاثاء", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 45),
                                  Text("اربعاء", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 30),
                                  Text("خميس", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                  const SizedBox(width: 30),
                                  Text("جمعة", style: GoogleFonts.tajawal(color: const Color(0xFF0B3C42).withOpacity(0.7),),),
                                ],
                              ),
                            )
                        )
                      ],
                    ),

                //TODO: back - next
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          theDataFetched = false;
                          if(currentWeek > minWeek){
                            setState(() {
                              currentWeek--;
                            });
                          }
                        },
                        icon:const  Icon(Icons.arrow_back_ios),
                        color: const Color.fromRGBO(52, 91, 99, 1),
                        iconSize: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                        child: Text(
                          '${(currentWeek+1).toString()} اسبوع ',
                          style: const TextStyle(
                            color: Color.fromRGBO(52, 91, 99, 1),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          theDataFetched = false;
                          if(currentWeek < maxWeek ){
                            setState(() {
                              currentWeek++;
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: const Color.fromRGBO(52, 91, 99, 1),
                        iconSize: 18,
                      ),
                    ],
                  ),
                ),

                //TODO: details
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0B3C42),Color(0xFF23BBCF)],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius:BorderRadius.only(
                        topRight: Radius.circular(60.00,),
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Image.asset('images/newtest.png'),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder:  (BuildContext context) => BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 15, sigmaY: 15),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.only(
                                                  topLeft: Radius
                                                      .circular(30),
                                                  topRight:
                                                  Radius.circular(
                                                      30))),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Text(
                                                'معلومات المريض',
                                                style: GoogleFonts.tajawal(
                                                  fontSize: 35,
                                                  color: const Color(0xff0B3C42),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 35,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.namePatient ,
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " الاسم",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                          fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 7,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        "${calculateAge(widget.patient.dateOfBirth).toString()} عام " ,
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " العمر",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        "%${((widget.patient.commitmentCounter / widget.patient.readingsCounter) * 100).floor().toString()}",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " الالتزام بالادوية ",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.isSmoker ? "نعم" : "لا",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " مدخن",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.isSmoker ? "نعم" : "لا",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " يشرب الكحول",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              widget.isDiabetes ?
                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.diabetesType,
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " نوع السكري ",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) : Container(),

                                              widget.isDiabetes ? const SizedBox(
                                                height: 10,
                                              ) : Container(),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.patientHieght ,
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " الطول",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 50.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        widget.patient.patientWeight ,
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            color: const Color(0xff6B6B6B),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth*0.4,
                                                      child: Text(
                                                        " الوزن",
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.tajawal(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color(0xff0B3C42),
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.white54,
                                    size: 28,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.62,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.patient.namePatient,
                                      style: GoogleFonts.tajawal(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      " العمر ${calculateAge(widget.patient.dateOfBirth).toString()} عام ",
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      "% الالتزام بالادوية ${((widget.patient.commitmentCounter / widget.patient.readingsCounter) * 100).floor().toString()}",
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.account_circle_sharp,
                                size: 80,
                                color: Colors.white,

                              ),
                            ],
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10,right: 18),
                            child: GestureDetector(
                              onTap: ()async{
                                makingPhoneCall(widget.patient.patentPhone);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'اتصل بالمريض ',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: Text(
                              'سجل',
                              style: GoogleFonts.tajawal(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Center(
                              child: Container(
                                width: screenWidth * 0.85,
                                height: screenHeight * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                                  border: Border.all(
                                      color: Colors.white
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    initialValue: widget.patient.history.isEmpty ? "" : widget.patient.history,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(border: InputBorder.none),
                                    onChanged: (value) async {
                                      //TODO: change the history
                                      await FirebaseFirestore.instance
                                          .collection('/patient')
                                          .doc(widget.patient.patientID)
                                          .set({
                                        'history': value,
                                      }, SetOptions(merge: true));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight*0.1,)
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            );
          }

          return const Loading();
        }
    );
  }
}


class LabCard extends StatelessWidget {
  const LabCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      //color: Color.fromRGBO(218, 228, 229, 1),
      height: 141,
      width: 114,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(218, 228, 229, 1),
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        //border: Colors.black,
        border: Border.all(
          color:const  Color.fromRGBO(218, 228, 229, 1),
          width: 2,
        ),
      ),
      child: const Card(
        elevation: 0,
        color: Color.fromRGBO(218, 228, 229, 1),
        //shape: RoundedRectangleBorder( Radius.circular(14)),
        child: Column(
          children:<Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage('images/lab.png'),
                  width: 42.5,
                  height: 53,
                )),

            //TODO: change الاول to a number based on number of labs entered
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  'نتيحة المختبر \n الاول',
                  style: TextStyle(
                      color: Color.fromRGBO(91, 122, 129, 1), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // PDFViewer(document: widget.document));
          ],
        ),
      ),
    );
  }




}


class ToggleButtonDoc extends StatefulWidget {
  const ToggleButtonDoc({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToggleButtonDocState createState() => _ToggleButtonDocState();
}

const double width = 220.0;
const double height = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Color.fromRGBO(139, 170, 177, 1);
const Color normalColor = Color.fromRGBO(218, 228, 229, 1);

class _ToggleButtonDocState extends State<ToggleButtonDoc> {
  double? xAlign;
  Color? loginColor;
  Color? signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      decoration:  const BoxDecoration(
        color: Color.fromRGBO(139, 170, 177, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign!, 0),
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(218, 228, 229, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(14.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = loginAlign;
                loginColor = selectedColor;
                signInColor = normalColor;
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'شهري',
                  style: TextStyle(
                    color: loginColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = signInAlign;
                signInColor = selectedColor;
                loginColor = normalColor;
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'اسبوعي',
                  style: TextStyle(
                    color: signInColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int calculateAge(String dateOfBirthString) {
  DateTime dateOfBirth = intl.DateFormat("dd-MM-yyyy").parse(dateOfBirthString);
  DateTime currentDate = DateTime.now();

  int age = currentDate.year - dateOfBirth.year;

  if (currentDate.month < dateOfBirth.month ||
      (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
    age--;
  }

  return age;
}


DateTime getFirstDayOfWeek(int indexOfCurrentDay, DateTime currentDay){
  DateTime firstDayOfWeek = indexOfCurrentDay == 1
      ? currentDay
      : indexOfCurrentDay == 2
      ? currentDay.subtract(const Duration(days: 1))
      : indexOfCurrentDay == 3
      ? currentDay.subtract(const Duration(days: 2))
      : indexOfCurrentDay == 4
      ? currentDay.subtract(const Duration(days: 3))
      : indexOfCurrentDay == 5
      ? currentDay.subtract(const Duration(days: 4))
      : indexOfCurrentDay == 6
      ? currentDay.subtract(const Duration(days: 5))
      : currentDay.subtract(const Duration(days: 6));

  return firstDayOfWeek;
}


DateTime getLastDayOfWeek(int indexOfCurrentDay, DateTime currentDay){

  DateTime lastDayOfWeek =
  indexOfCurrentDay == 1
      ? currentDay.add(const Duration(days: 6))
      : indexOfCurrentDay == 2
      ? currentDay.add(const Duration(days: 5))
      : indexOfCurrentDay == 3
      ? currentDay.add(const Duration(days: 4))
      : indexOfCurrentDay == 4
      ? currentDay.add(const Duration(days: 3))
      : indexOfCurrentDay == 5
      ? currentDay.add(const Duration(days: 2))
      : indexOfCurrentDay == 6
      ? currentDay.add(const Duration(days: 1))
      : currentDay;

  return lastDayOfWeek;
}


int customWeekdayIndex(DateTime dateTime) {
  int weekday = dateTime.weekday;

  if (weekday == 6) {
    return 1; // Saturday becomes 1
  } else if (weekday == 7) {
    return 2; // Sunday becomes 2
  } else {
    return weekday + 2; // Shift the other days by two
  }
}