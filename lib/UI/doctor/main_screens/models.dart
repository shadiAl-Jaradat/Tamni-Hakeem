class Patient {
  final String namePatient;
  final String patientID;
  final String patientHieght;
  final String patientWeight;
  final String diabetesType;
  final String dateOfBirth;
  final String nationalNumberPatient;
  final String doctorID;
  final String patentPhone;
  final bool hasDiabetes;
  final bool hasBloodPressure;
  final bool isSmoker;
  final bool isAlcoholic;

  final bool isHaveNewDiabetesRead;
  final bool isBeforeBloodRead;
  final double lastDiabetesRead;


  final bool isHaveNewBloodRead;
  final bool isMorningBloodRead;
  final double lastDiastolicBloodRead;
  final double lastSystolicBloodRead;
  final double lastHartRateRead;

  final int commitmentCounter;
  final int readingsCounter;
  final int counterOfWeeks;

  final String history;

  Patient({
    required this.namePatient,
    required this.patientID,
    required this.patientHieght,
    required this.patientWeight,
    required this.diabetesType,
    required this.dateOfBirth,
    required this.nationalNumberPatient,
    required this.doctorID,
    required this.patentPhone,
    required this.hasDiabetes,
    required this.hasBloodPressure,
    required this.isSmoker,
    required this.isAlcoholic,

    required this.isHaveNewDiabetesRead,
    required this.isBeforeBloodRead,
    required this.lastDiabetesRead,

    required this.isHaveNewBloodRead,
    required this.isMorningBloodRead,
    required this.lastDiastolicBloodRead,
    required this.lastSystolicBloodRead,
    required this.lastHartRateRead,

    required this.commitmentCounter,
    required this.readingsCounter,

    required this.counterOfWeeks,
    required this.history,

  });
}