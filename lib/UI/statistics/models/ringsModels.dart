class DiabetesTypeOne {
  final int numberOfPatient;
  final int mail;
  final int feMail;
  final int smokers;
  final int alcohol;
  DiabetesTypeOne(
      {required this.numberOfPatient,
      required this.mail,
      required this.feMail,
      required this.smokers,
      required this.alcohol});
}

class DiabetesTypeTwo {
  final int numberOfPatient;
  final int mail;
  final int feMail;
  final int smokers;
  final int alcohol;
  DiabetesTypeTwo(
      {required this.numberOfPatient,
      required this.mail,
      required this.feMail,
      required this.smokers,
      required this.alcohol});
}

class DiabetesTypePre {
  final int numberOfPatient;
  final int mail;
  final int feMail;
  final int smokers;
  final int alcohol;
  DiabetesTypePre(
      {required this.numberOfPatient,
      required this.mail,
      required this.feMail,
      required this.smokers,
      required this.alcohol});
}

class DiabetesTypeBaby {
  final int numberOfPatient;
  final int mail;
  final int feMail;
  final int smokers;
  final int alcohol;
  DiabetesTypeBaby(
      {required this.numberOfPatient,
      required this.mail,
      required this.feMail,
      required this.smokers,
      required this.alcohol});
}

class DiabetesMail {
  final int numberOfPatient;
  final int diabetesTypeOne;
  final int diabetesTypeTwo;
  final int diabetesTypePre;
  final int diabetesTypeBaby;
  final int smokers;
  final int alcohol;
  DiabetesMail(
      {required this.numberOfPatient,
      required this.diabetesTypeOne,
      required this.diabetesTypeTwo,
      required this.diabetesTypePre,
      required this.diabetesTypeBaby,
      required this.smokers,
      required this.alcohol});
}

class DiabetesFeMail {
  final int numberOfPatient;
  final int diabetesTypeOne;
  final int diabetesTypeTwo;
  final int diabetesTypePre;
  final int diabetesTypeBaby;
  final int smokers;
  final int alcohol;
  DiabetesFeMail(
      {required this.numberOfPatient,
      required this.diabetesTypeOne,
      required this.diabetesTypeTwo,
      required this.diabetesTypePre,
      required this.diabetesTypeBaby,
      required this.smokers,
      required this.alcohol});
}

class DiabetesSmoker {
  final int numberOfPatient;
  final int diabetesTypeOne;
  final int diabetesTypeTwo;
  final int diabetesTypePre;
  final int diabetesTypeBaby;
  final int mail;
  final int feMail;
  final int alcohol;
  DiabetesSmoker(
      {required this.numberOfPatient,
      required this.diabetesTypeOne,
      required this.diabetesTypeTwo,
      required this.diabetesTypePre,
      required this.diabetesTypeBaby,
      required this.mail,
      required this.feMail,
      required this.alcohol});
}

class DiabetesAlcohol {
  final int numberOfPatient;
  final int diabetesTypeOne;
  final int diabetesTypeTwo;
  final int diabetesTypePre;
  final int diabetesTypeBaby;
  final int mail;
  final int feMail;
  final int smokers;
  DiabetesAlcohol({
    required this.numberOfPatient,
    required this.diabetesTypeOne,
    required this.diabetesTypeTwo,
    required this.diabetesTypePre,
    required this.diabetesTypeBaby,
    required this.mail,
    required this.feMail,
    required this.smokers,
  });
}
