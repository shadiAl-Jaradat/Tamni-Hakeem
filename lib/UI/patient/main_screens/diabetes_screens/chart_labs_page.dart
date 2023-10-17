import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/lab_viewer.dart';
import 'package:diabetes_and_hypertension/UI/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart' as intl;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:io';
import '../../../../Service/firebase_service.dart';

late String fileName;
const String sun = 'ح';
const String mon = 'ن';
const String tues = 'ت';
const String wed = 'ر';
const String thurs = 'خ';
const String fri = 'ج';
const String sat = 'س';
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
  int get dayIndex => customWeekdayIndex(time); // 0 for Saturday, 6 for Friday

}

class ReadingDataBefore {
  final String day;
  final DateTime time;
  final double value;

  ReadingDataBefore({required this.day, required this.time,required this.value});
  int get dayIndex => customWeekdayIndex(time); // 0 for Saturday, 6 for Friday
}

class ChartLabsPage extends StatefulWidget {
  const ChartLabsPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChartLabsPageState createState() => _ChartLabsPageState();
}

bool hasDiabetes = UserSimplePreferencesUser.getPaDiabetes() ?? false;
bool hasBlood = UserSimplePreferencesUser.getPaBlood() ?? false;
List<bool> isSelected = ((hasDiabetes && hasBlood) || hasDiabetes )
                        ?  [true, false] :  [false, true];
class _ChartLabsPageState extends State<ChartLabsPage> {
  late File? file;

  late TooltipBehavior _tooltipBehavior;
  bool isSwitched = false;

  int getNumOfDay(String day) {
    if (day == 'sat') {
      return 0;
    } else if (day == 'sun') {
      return 1;
    } else if (day == 'mon') {
      return 2;
    } else if (day == 'tues') {
      return 3;
    } else if (day == 'wed') {
      return 4;
    } else if (day == 'thurs') {
      return 5;
    } else {
      return 6;
    }
  }

  List<ChartData> chartDataBefore = [];
  List<ChartData> chartDataAfter = [];


  bool hasDiabetes = UserSimplePreferencesUser.getPaDiabetes() ?? false;
  bool hasBlood = UserSimplePreferencesUser.getPaBlood() ?? false;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    //_Call_list_files();
    super.initState();
  }


  Future<void> getLabs() async {
    listOfLabs = await getFilesList();
    print("list OF labs : soso");
    print(listOfLabs.length);
  }

  Future<firebase_storage.UploadTask> uploadFile(File file) async {


    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Patients_labs')
        .child('/${UserSimplePreferencesUser.getUserID()}')
        .child('/${file.path.split('/').last}');


    final metadata = firebase_storage.SettableMetadata(
        contentType: 'patient/pdf',
        customMetadata: {'picked-file-path': file.path}
    );

    if (kDebugMode) {
      print("Uploading..!");
    }

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    if (kDebugMode) {
      print("done..!");
    }
    return Future.value(uploadTask);
  }


  ///***********************************************

  Future<List<String>> getFilesList() async {

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

  String getDayTitle(double value){
    // int dayIndex = (value / 24).floor();
    List<String> dayNames = ['س', 'ح', 'ن', 'ث', 'أ', 'خ', 'ج'];
    return dayNames[value.toInt()];
  }

  late double screenHeight;
  late double screenWidth;
  late double textScale;


  Future<DocumentSnapshot<Object?>>? fetchData() async{
    maxWeek = int.parse(UserSimplePreferencesUser.getCtOfWeek() ?? "0");
    if(theDataFetched == false){
      currentWeek = int.parse(UserSimplePreferencesUser.getCtOfWeek() ?? "0");
    }
    await getLabs();
    CollectionReference users = FirebaseFirestore.instance
        .collection('/patient');
    dynamic data;
    // do{
      data = isSelected[0]
          ? await users
              .doc(UserSimplePreferencesUser.getUserID() ?? uid)
              .collection('/diabetesWeeks')
              .doc(currentWeek.toString())
              .get()
          : await users
              .doc(UserSimplePreferencesUser.getUserID() ?? uid)
              .collection('/bloodWeeks')
              .doc(currentWeek.toString())
              .get();
      Map<String, dynamic> parseData = data!.data() as Map<String, dynamic>;
      //
      if(isSelected[0] ==true ){
        weekHasNotData = parseData['AfterReadings'].length == 0 && parseData['BeforeReadings'].length == 0;
      }
      else {
        weekHasNotData = parseData['EveningDiastolicReadings'].length == 0 && parseData['MorningDiastolicReadings'].length == 0;
      }
      // if(repeat) {
      //   currentWeek = isPlus ? (currentWeek+1) : (currentWeek-1);
      // }
    // } while(repeat);
    theDataFetched = true;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    textScale = MediaQuery.of(context).textScaleFactor;


    return FutureBuilder<DocumentSnapshot>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.data == null) return const Loading();

        if (snapshot.hasError) {
          return const Text("ERROR");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("ERROR");
        }

        if (snapshot.connectionState == ConnectionState.done) {

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          List<ReadingDataAfter> afterReadings = [];
          for(int i =0 ; i< ( isSelected[0] ? data['AfterReadings'].length : data['EveningDiastolicReadings'].length) ; i++){
            afterReadings.add(ReadingDataAfter(
                day:  isSelected[0] ? data['Days_English_after'][i] : data['Days_English_evening'][i],
                time: isSelected[0] ? data['AfterDateTime'][i].toDate() : data['EveningDateTime'][i].toDate(),
                value: isSelected[0]
                    ? double.parse(data['AfterReadings'][i].toString())
                    : double.parse(data['EveningDiastolicReadings'][i].toString()) + 0.3 * ( double.parse(data['EveningSystolicReadings'][i].toString()) - double.parse(data['EveningDiastolicReadings'][i].toString()) )
            ));
          }

          List<ReadingDataBefore> beforeReadings = [];
          if(isSelected[0]) {
            for (int i = 0; i < (data['BeforeReadings'].length); i++) {
              beforeReadings.add(ReadingDataBefore(
                  day: data['Days_English_before'][i],
                  time: data['BeforeDateTime'][i].toDate(),
                  value: double.parse(data['BeforeReadings'][i].toString())));
            }
          } else{
            for(int i =0 ; i< ( data['MorningDiastolicReadings'].length) ; i++){
              print("soso : ${data['MorningDateTime'][i].toDate()}");
              beforeReadings.add(ReadingDataBefore(
                  day: data['Days_English_morning'][i],
                  time: data['MorningDateTime'][i].toDate(),
                  value: double.parse(data['MorningDiastolicReadings'][i].toString()) + 0.3 * ( double.parse(data['MorningSystolicReadings'][i].toString()) - double.parse(data['MorningDiastolicReadings'][i].toString()) )
              ));
            }
          }
          List<ReadingDataBefore> dummyReadings = [];
          DateTime firstDayOfWeek = DateTime.now();
          DateTime lastDayOfWeek = DateTime.now();
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
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Align(
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    weekHasNotData
                    ? Image.asset(
                    "images/noRedingsTwo.png",
                      width: screenWidth,
                      height: screenHeight * 0.4,
                    ):
                    Stack(
                      children: [
                        Container(
                          color: Colors.white,
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
                                        name: hasDiabetes && hasBlood
                                            ? isSelected[0] ? "صائم" : "صباح"
                                            : hasDiabetes ? "صائم"  : hasBlood ? "صباح" : "",
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
                                        markerSettings: MarkerSettings(isVisible: true),
                                        dataLabelSettings: const DataLabelSettings(isVisible: true)),

                                    SplineSeries<ChartData, DateTime>(
                                        name: hasDiabetes && hasBlood
                                            ? isSelected[0] ? "غير صائم" : "مساء"
                                            : hasDiabetes ? "غير صائم"  : hasBlood ? "مساء" : "",
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
                                      markerSettings: MarkerSettings(isVisible: true),
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
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
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
                    const SizedBox(
                      height: 8,
                    ),


                    //TODO toggle Button
                    //TODO:this Container is only for testing we should replace it with the info below the chart such as (what week and monthly,yearly)

                    hasBlood && hasDiabetes
                        ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.32),
                      child: ToggleSwitch(
                        minWidth: 86.0,
                        cornerRadius: 14.0,
                        activeBgColors: const [[Color(0xFF167582)], [Color(0xFF167582)]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color(0xFF167582).withOpacity(0.5),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: isSelected[0] ? 0 : 1,
                        labels: const ['سكري', 'ضغط'],
                        radiusStyle: true,
                        onToggle: (index) {
                          print('switched to: ${index!}');
                          setState(() {
                            isSelected[index] = !isSelected[index];
                            isSelected[1 - index] = !isSelected[1 - index];
                          });
                        },
                      ),
                    )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 30),
                      child: Text(
                        "نتائج المختبر",
                        style: GoogleFonts.tajawal(
                            color: Colors.black,
                            fontSize: 0.065 * screenWidth,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 20, top: 20, left: 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(14)),
                                      border: Border.all(
                                        color: const Color.fromRGBO(218, 228, 229, 1),
                                        width: 2,
                                      ),
                                      //color: Colors.black,
                                    ),

                                    //color: Colors.black,
                                    height: screenHeight * 0.20,
                                    width: screenWidth * 0.30,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 27),
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff20AEC1),
                                              shape: const CircleBorder(),
                                              padding: const EdgeInsets.all(5),
                                            ),
                                            onPressed: () async {
                                              final result = await FilePicker.platform.pickFiles();
                                              if (result == null) return;
                                              final path = result.files.single.path!;
                                              setState(() => file = File(path));
                                              uploadFile(file!);
                                              _cardListFiles.add(createCardFile(path));
                                            },
                                            //icon: Icon(Icons.add),
                                            child: Icon(Icons.add, size: 40 * textScale),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 35.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'اضف',
                                                    style: GoogleFonts.tajawal(
                                                      color: const Color(0xff0B3C42),
                                                      fontSize: 21,

                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'نتيجة جديدة',
                                                    style: GoogleFonts.tajawal(
                                                      color: const Color(0xff0B3C42),
                                                      fontSize: 21,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                children: callListFiles(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Loading();
      },
    );
  }

  final List<Widget> _cardListFiles = [];
  List<String> listOfLabs = [];
  List<Widget> callListFiles() {
    _cardListFiles.clear();
    for(int index =0 ; index< (listOfLabs.length?? 0) ; index++){
      // setState(() {
        _cardListFiles.add(createCardFile(listOfLabs[index]));
      // });
    }
    return _cardListFiles;
  }

  Widget createCardFile(String path) {
    //String? ext = Plt_file.extension;

    return InkWell(
      onTap: () {
        OpenFile.open(path);
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  LabViewer(path: path)));
        // attachmentViewerAlertDialog(
        //   context: context,
        //   uri: path,
        //   screenHeight: screenHeight,
        //   screenWidth: screenWidth,
        // );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
        child: Container(
          //color: Color.fromRGBO(218, 228, 229, 1),
          height: screenHeight * 0.20,
          width: screenWidth * 0.32,
          decoration: BoxDecoration(
            color: const Color(0xff167582),
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            //border: Colors.black,
            border: Border.all(
              color: const Color(0xff167582),
              width: 2,
            ),
          ),
          child: Card(
            elevation: 1,
            color: const Color(0xff167582),
            //shape: RoundedRectangleBorder( Radius.circular(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SvgPicture.asset(
                      'images/newlabicon.svg',
                      color: const Color(0xffFFFFFF),
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.065,
                    )
                ),

                //TODO: change الاول to a number based on number of labs entered
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                      children: [
                        Text(
                          'نتيحة المختبر ',
                          style: GoogleFonts.tajawal(
                            color: const Color(0xffE5E5E5),
                            fontSize: 0.04 * screenWidth,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,

                        ),
                        Text(
                          intl.DateFormat('yyyy/MM/dd').format(DateTime.now()),
                          style: GoogleFonts.tajawal(
                            color: const Color(0xffE5E5E5),
                            fontSize: 0.04 * screenWidth,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // PDFViewer(document: widget.document));
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataAfterReadings {
  DataAfterReadings(List<dynamic> pastA, List<dynamic> pastD) {
    var pastR;
    var pastD;

    if (pastA == null) {
      for (var i = 0; i < (pastR.length?? 0) && pastR[i] != null; i++) {
        After.add(0);
      }
    } else {
      for (var i = 0; i < (pastR.length?? 0) && pastR[i] != null; i++) {
        After.add(pastR[i]);
      }
    }

    if (pastD == null) {
      for (var i = 0; i < (pastD.length?? 0) && pastD[i] != null; i++) {
        day.add(' ');
      }
    } else {
      for (var i = 0; i < (pastD.length ?? 0) && pastD[i] != null; i++) {
        day.add(pastD[i]);
      }
    }
  }
  late List<double> After;
  late List<String> day;
}

class DataBeforeReadings {
  DataBeforeReadings(List<dynamic> pastA, List<dynamic> pastD) {
    var pastR;
    var pastD;
    if (pastA == null) {
      for (var i = 0; i <( pastR.length ?? 0)&& pastR[i] != null; i++) {
        before.add(0);
      }
    } else {
      for (var i = 0; i < (pastR.length ?? 0)&& pastR[i] != null; i++) {
        before.add(pastR[i]);
      }
    }

    if (pastD == null) {
      for (var i = 0; i < (pastD.length ?? 0)&& pastD[i] != null; i++) {
        day.add(' ');
      }
    } else {
      for (var i = 0; i < (pastD.length ?? 0)&& pastD[i] != null; i++) {
        day.add(pastD[i]);
      }
    }
  }
  late List<double> before;
  late List<String> day;
}
//TODO:TO GET THE READINGS

List<double> readingsChartBefore(List<dynamic> pastR) {
  List<double> readDoubleBefore = [];
  for (var i = 0; i < (pastR.length ?? 0)&& pastR[i] != null; i++) {
    readDoubleBefore.add(pastR[i]);
  }
  return readDoubleBefore;
}

List<double> readingsChartAfter(List<dynamic> pastR) {
  List<double> readDoubleAfter = [];
  for (var i = 0; i < (pastR.length ?? 0)&& pastR[i] != null; i++) {
    readDoubleAfter.add(pastR[i]);
  }

  return readDoubleAfter;
}

//TODO:TOO GET THE DAY OF THE READINGS

List<String> readingsDay(List<dynamic> pastR) {
  List<String> readDays = [];
  for (var i = 0; i < (pastR.length ?? 0)&& pastR[i] != null; i++) {
    readDays.add(pastR[i]);
  }
  return readDays;
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