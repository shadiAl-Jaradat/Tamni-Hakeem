import 'package:diabetes_and_hypertension/UI/statistics/models/ringsModels.dart';

class DiabetesYear {
  final int numberOfPatient;
  final DiabetesTypeOne diabetesTypeOne;
  final DiabetesTypeTwo diabetesTypeTwo;
  final DiabetesTypePre diabetesTypePre;
  final DiabetesTypeBaby diabetesTypeBaby;
  final DiabetesMail mail;
  final DiabetesFeMail feMail;
  final DiabetesSmoker smokers;
  final DiabetesAlcohol alcohol;

  DiabetesYear({
    required this.numberOfPatient,
    required this.diabetesTypeOne,
    required this.diabetesTypeTwo,
    required this.diabetesTypePre,
    required this.diabetesTypeBaby,
    required this.mail,
    required this.feMail,
    required this.smokers,
    required this.alcohol
});
}

