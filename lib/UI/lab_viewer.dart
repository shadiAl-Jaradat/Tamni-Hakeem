// import 'package:flutter/material.dart';
// import 'package:kayan/ui/shared_widgets/cached_image.dart';
// import 'package:kayan/ui/shared_widgets/text_button.dart';
// import 'package:kayan/utils/colors/app_theme_colors.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import '../../data/home_screen/models/app_dictionary_list_model.dart';
// import '../../utils/constants.dart';
// import '../../utils/get_value.dart';
//
// attachmentViewerAlertDialog({
//   required BuildContext context,
//   required String uri,
//   required String extension,
//   required double screenHeight,
//   required double screenWidth,
// }) {
//   Widget okButton = TextButton(
//     child: const Text(
//       "تم",
//       style: TextStyle(color: Colors.black),
//     ),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
//   AlertDialog alert = AlertDialog(
//     content: SizedBox(
//       height: screenHeight * 0.45,
//       width: screenWidth * 0.8,
//       child: extension.isNotEmpty
//           ? extension == ".pdf"
//           ? SfPdfViewer.network(uri)
//           : LoadImage(imagePath: uri).cachedNetworkImage()
//           : Container(
//         color: Constants.isDarkMode ? redColorDark : redColorLight,
//       ),
//     ),
//     actions: [
//       okButton,
//     ],
//   );
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
