import 'package:diabetes_and_hypertension/UI/statistics/models/ringsModels.dart';
import 'package:diabetes_and_hypertension/UI/statistics/models/year.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'charts/bar_chart.dart';
import 'charts/ring_chart.dart';

class BloodStatistics extends StatefulWidget {
  const BloodStatistics({super.key});
  @override
  State<BloodStatistics> createState() =>
      _BloodStatisticsStatisticsPageState();
}

class _BloodStatisticsStatisticsPageState
    extends State<BloodStatistics> {
  List<String> years = [
    "٢٠١٦",
    "٢٠١٧",
    "٢٠١٨",
    "٢٠١٩",
    "٢٠٢٠",
    "٢٠٢١",
    "٢٠٢٢",
    "٢٠٢٣"
  ];

  int yearIndex = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassmorphicContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.44,
                borderRadius: 30,
                blur: 100,
                alignment: Alignment.bottomCenter,
                border: 1.5,
                linearGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade200.withOpacity(0.65),
                      Colors.grey.shade200.withOpacity(0.65),
                    ],
                    stops: const [
                      0.1,
                      1,
                    ]),
                borderGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade200.withOpacity(0.1),
                    Colors.grey.shade200.withOpacity(0.65),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(
                            bottom: 50, right: 20, top: 20),
                        child: Text(
                          " مرضى الضغط خلال ٢٠٢٣ - ٢٠١٦",
                          style: GoogleFonts.tajawal(
                              color: const Color(0xff0B3C42),
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                      RoundedBarChart(
                        onBarTouched: (int? touchedIndex) {
                          setState(() {
                            yearIndex = touchedIndex ?? 7;
                          });
                          print("Touched bar index: $touchedIndex");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                const EdgeInsets.only(top: 40.0, bottom: 15, right: 20),
                child: Text(
                  " : احصائيات سنة ${years[yearIndex]}",
                  style: GoogleFonts.tajawal(
                      color: const Color(0xff0B3C42),
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticsCard(
                    color: Color(0xffBECC23),
                    current: 150,
                    goal: 250,
                    title: "الذكور"),
                _buildStatisticsCard(
                    color: Color(0xff63816D),
                    current: 100,
                    goal: 250,
                    title: "الاناث"),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticsCard(
                    color: Color(0xff20AEC1),
                    current: 30,
                    goal: 100,
                    title: "يشربون الكحول"),
                _buildStatisticsCard(
                    color:Color(0xff167582),
                    current: 65,
                    goal: 100,
                    title: "المدخنين"),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ]),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildStatisticsCard(
      {required Color color,
        required String title,
        required double current,
        required double goal}) {
    return GlassmorphicContainer(
      width: 220,
      height: 290,
      borderRadius: 30,
      blur: 100,
      alignment: Alignment.bottomCenter,
      border: 1.5,
      linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade200.withOpacity(0.65),
            Colors.grey.shade200.withOpacity(0.65),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade200.withOpacity(0.1),
          Colors.grey.shade200.withOpacity(0.65),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
            child: Text(
              title,
              style: GoogleFonts.tajawal(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0B3C42)),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              child: CircularChart(
                current: current,
                goal: goal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<DiabetesYear> listDiabetesYears = [
  DiabetesYear(
      numberOfPatient: 1000,
      diabetesTypeOne: DiabetesTypeOne(
          numberOfPatient: 100,
          alcohol: 100,
          feMail: 100,
          mail: 100,
          smokers: 190),
      diabetesTypeTwo: DiabetesTypeTwo(
          numberOfPatient: 299,
          alcohol: 100,
          feMail: 100,
          mail: 200,
          smokers: 130),
      diabetesTypePre: DiabetesTypePre(
          numberOfPatient: 200,
          alcohol: 12,
          feMail: 22,
          mail: 123,
          smokers: 14),
      diabetesTypeBaby: DiabetesTypeBaby(
          numberOfPatient: 120,
          feMail: 123,
          alcohol: 12,
          mail: 12,
          smokers: 12),
      mail: DiabetesMail(
          numberOfPatient: 150,
          alcohol: 21,
          diabetesTypeBaby: 12,
          diabetesTypeOne: 23,
          diabetesTypePre: 21,
          diabetesTypeTwo: 21,
          smokers: 23),
      feMail: DiabetesFeMail(
          numberOfPatient: 200,
          alcohol: 12,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      alcohol: DiabetesAlcohol(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      smokers: DiabetesSmoker(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          alcohol: 32)),
  DiabetesYear(
      numberOfPatient: 1000,
      diabetesTypeOne: DiabetesTypeOne(
          numberOfPatient: 100,
          alcohol: 100,
          feMail: 100,
          mail: 100,
          smokers: 190),
      diabetesTypeTwo: DiabetesTypeTwo(
          numberOfPatient: 299,
          alcohol: 100,
          feMail: 100,
          mail: 200,
          smokers: 130),
      diabetesTypePre: DiabetesTypePre(
          numberOfPatient: 200,
          alcohol: 12,
          feMail: 22,
          mail: 123,
          smokers: 14),
      diabetesTypeBaby: DiabetesTypeBaby(
          numberOfPatient: 120,
          feMail: 123,
          alcohol: 12,
          mail: 12,
          smokers: 12),
      mail: DiabetesMail(
          numberOfPatient: 150,
          alcohol: 21,
          diabetesTypeBaby: 12,
          diabetesTypeOne: 23,
          diabetesTypePre: 21,
          diabetesTypeTwo: 21,
          smokers: 23),
      feMail: DiabetesFeMail(
          numberOfPatient: 200,
          alcohol: 12,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      alcohol: DiabetesAlcohol(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      smokers: DiabetesSmoker(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          alcohol: 32)),
  DiabetesYear(
      numberOfPatient: 1000,
      diabetesTypeOne: DiabetesTypeOne(
          numberOfPatient: 100,
          alcohol: 100,
          feMail: 100,
          mail: 100,
          smokers: 190),
      diabetesTypeTwo: DiabetesTypeTwo(
          numberOfPatient: 299,
          alcohol: 100,
          feMail: 100,
          mail: 200,
          smokers: 130),
      diabetesTypePre: DiabetesTypePre(
          numberOfPatient: 200,
          alcohol: 12,
          feMail: 22,
          mail: 123,
          smokers: 14),
      diabetesTypeBaby: DiabetesTypeBaby(
          numberOfPatient: 120,
          feMail: 123,
          alcohol: 12,
          mail: 12,
          smokers: 12),
      mail: DiabetesMail(
          numberOfPatient: 150,
          alcohol: 21,
          diabetesTypeBaby: 12,
          diabetesTypeOne: 23,
          diabetesTypePre: 21,
          diabetesTypeTwo: 21,
          smokers: 23),
      feMail: DiabetesFeMail(
          numberOfPatient: 200,
          alcohol: 12,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      alcohol: DiabetesAlcohol(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      smokers: DiabetesSmoker(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          alcohol: 32)),
  DiabetesYear(
      numberOfPatient: 1000,
      diabetesTypeOne: DiabetesTypeOne(
          numberOfPatient: 100,
          alcohol: 100,
          feMail: 100,
          mail: 100,
          smokers: 190),
      diabetesTypeTwo: DiabetesTypeTwo(
          numberOfPatient: 299,
          alcohol: 100,
          feMail: 100,
          mail: 200,
          smokers: 130),
      diabetesTypePre: DiabetesTypePre(
          numberOfPatient: 200,
          alcohol: 12,
          feMail: 22,
          mail: 123,
          smokers: 14),
      diabetesTypeBaby: DiabetesTypeBaby(
          numberOfPatient: 120,
          feMail: 123,
          alcohol: 12,
          mail: 12,
          smokers: 12),
      mail: DiabetesMail(
          numberOfPatient: 150,
          alcohol: 21,
          diabetesTypeBaby: 12,
          diabetesTypeOne: 23,
          diabetesTypePre: 21,
          diabetesTypeTwo: 21,
          smokers: 23),
      feMail: DiabetesFeMail(
          numberOfPatient: 200,
          alcohol: 12,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      alcohol: DiabetesAlcohol(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          smokers: 32),
      smokers: DiabetesSmoker(
          numberOfPatient: 200,
          feMail: 12,
          mail: 33,
          diabetesTypeBaby: 14,
          diabetesTypeOne: 54,
          diabetesTypePre: 54,
          diabetesTypeTwo: 54,
          alcohol: 32)),
];

