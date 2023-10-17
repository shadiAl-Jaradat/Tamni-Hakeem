import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Service/firebase_service.dart';
import 'models.dart';

class ListOfDiabetesPatients extends StatefulWidget {
  final List<Patient> lstPatients;
  const ListOfDiabetesPatients({super.key, required this.lstPatients});

  @override
  State<ListOfDiabetesPatients> createState() => _ListOfDiabetesPatientsState();
}

class _ListOfDiabetesPatientsState extends State<ListOfDiabetesPatients> {
  late double screenHeight;
  late double screenWidth;
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //TODO Change into actual search box
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, top: 50),
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.05,
              child: Container(
                //padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xffE5E5E5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child:  TextField(
                      onChanged: (value) {
                        setState(() {
                        searchString = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'ادخل الرقم الوطني او اسم المريض ',
                        hintStyle: GoogleFonts.tajawal(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search,color: Colors.grey.shade500,),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                  itemCount: widget.lstPatients.length,
                  itemBuilder: (context,index){
                    return( widget.lstPatients[index].namePatient.contains(searchString)
                        || widget.lstPatients[index].nationalNumberPatient.contains(searchString))
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PatientCard(patient: widget.lstPatients[index],),
                          )
                        : Container();
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}


class PatientCard extends StatelessWidget {
  final Patient patient;
  const PatientCard({
    required this.patient,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        //TODO:  make PatientHasNewRead = False
        FirebaseFirestore.instance
            .collection('/patient')
            .doc(patient.patientID)
            .set({
          'isHaveNewDiabetesRead': false,
        }, SetOptions(merge: true));
        // doctor.makePatientHasNewReadFalse(userID: id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Details(patient: patient,isDiabetes: true,)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), // <= No more error here :)
          color: patient.lastDiabetesRead >= 130.0 ? const Color(0xffC2402B)
              : patient.lastDiabetesRead <= 80.0 ? const Color(0xffC28C17)
              : const Color(0xff20AEC1),
        ),
        height: screenHeight * 0.13,
        width: screenWidth * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              patient.isHaveNewDiabetesRead == true ?
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    //color: Colors.amber,
                  ),
                ),
              )
                  :Padding(
                padding: EdgeInsets.only(right: 5),
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:  patient.lastDiabetesRead >= 130.0 ? const Color(0xffC2402B)
                          : patient.lastDiabetesRead <= 80.0 ? const Color(0xffC28C17)
                          : const Color(0xff20AEC1)
                    //color: Colors.amber,
                  ),
                ),
              ),

              Container(
                width: screenWidth * 0.55,
                padding: const EdgeInsets.only(right: 10.0,top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      patient.namePatient,
                      style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      patient.lastDiabetesRead == 0 ? '' :
                      (patient.lastDiabetesRead >= 130.0 ? 'مرتفع'
                          : patient.lastDiabetesRead <= 80.0 ? 'منخفض' : 'طبيعي'),
                      style: GoogleFonts.tajawal(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.account_circle_rounded,
                size: 70,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}