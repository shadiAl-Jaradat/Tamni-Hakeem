import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lstOfMyPatient.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Service/firebase_service.dart';
import 'models.dart';
String searchString = "";

class ListOfBloodPatients extends StatefulWidget {
  final List<Patient> lstPatients;
  const ListOfBloodPatients({super.key, required this.lstPatients});
  @override
  State<ListOfBloodPatients> createState() => _ListOfBloodPatientsState();
}

class _ListOfBloodPatientsState extends State<ListOfBloodPatients> {
  late double screenHeight;
  late double screenWidth;

  @override
  void dispose() {
    searchString = "";
    super.dispose();
  }

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
                    child: TextFormField(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.lstPatients.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return( widget.lstPatients[index].namePatient.contains(searchString)
                              || widget.lstPatients[index].nationalNumberPatient.contains(searchString))
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PatientCard(
                              patient: widget.lstPatients[index],
                            ),
                          )
                          : Container();
                    }
                ),
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
          'isHaveNewBloodRead': false,
        }, SetOptions(merge: true));
        // doctor.makePatientHasNewReadFalse(userID: id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Details(patient: patient,isDiabetes: false,)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), // <= No more error here :)
          color: patient.lastSystolicBloodRead <= 120 && patient.lastDiastolicBloodRead <= 80 ? const Color(0xffa3cb3b).withOpacity(0.85)
              : ( ( patient.lastSystolicBloodRead >= 121  &&  patient.lastSystolicBloodRead<= 129 )   &&  patient.lastDiastolicBloodRead <= 80 ) ? const Color(0xffffec01).withOpacity(0.8)
              : (  ( patient.lastSystolicBloodRead >= 130  &&  patient.lastSystolicBloodRead<= 139 )  ||   ( patient.lastDiastolicBloodRead >= 81  &&  patient.lastDiastolicBloodRead<= 89 ) )  ? const Color(0xffffb601).withOpacity(0.8)
              : (  ( patient.lastSystolicBloodRead >= 140  &&  patient.lastSystolicBloodRead<= 179 )  ||   ( patient.lastDiastolicBloodRead >= 90  &&  patient.lastDiastolicBloodRead<= 119 ) )  ? const Color(0xffba3a03).withOpacity(0.85)
              : const Color(0xff990812).withOpacity(0.95),
        ),
        height: screenHeight * 0.13,
        width: screenWidth * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              patient.isHaveNewBloodRead == true
                  ? Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      //color: Colors.amber,
                    ),
                  )
                  : Container(),
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
                    //TODO automate from readings
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      patient.lastSystolicBloodRead <= 120 && patient.lastDiastolicBloodRead <= 80 ? "طبيعي"
                          : ( ( patient.lastSystolicBloodRead >= 121  &&  patient.lastSystolicBloodRead<= 129 )   &&  patient.lastDiastolicBloodRead <= 80 ) ? "مرتفع"
                          : (  ( patient.lastSystolicBloodRead >= 130  &&  patient.lastSystolicBloodRead<= 139 )  ||   ( patient.lastDiastolicBloodRead >= 81  &&  patient.lastDiastolicBloodRead<= 89 ) )  ? " ارتفاع ضغط الدم مرحلة ١"
                          : (  ( patient.lastSystolicBloodRead >= 140  &&  patient.lastSystolicBloodRead<= 179 )  ||   ( patient.lastDiastolicBloodRead >= 90  &&  patient.lastDiastolicBloodRead<= 119 ) )  ? " ارتفاع ضغط الدم المرحلة ٢ "
                          : "أزمة ارتفاع ضغط الدم",
                      style: GoogleFonts.tajawal(
                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.account_circle_rounded,
                size: 63,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
