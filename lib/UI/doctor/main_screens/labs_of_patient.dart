import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';





class LabsOfPatient extends StatefulWidget {
  final String patientID;
  final List<String> labsPaths;
  const LabsOfPatient({
    required this.patientID,
    required this.labsPaths,
    Key? key
  }) : super(key: key);

  @override
  State<LabsOfPatient> createState() => _LabsOfPatientState();
}

class _LabsOfPatientState extends State<LabsOfPatient> {


  // @override
  // void initState() {
  //   super.initState();
  // }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(
      //     color: Color(0xff0B3C42), // <-- SEE HERE
      //   ),
      //   title: Center(child: Text("المختبرات         " ,  style: GoogleFonts.tajawal(color: Color(0xff0B3C42),fontWeight: FontWeight.bold, fontSize: 25))),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30, 30.0, 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios,  size: 32,
                      color: Color(0xff0B3C42), ),
                    color: const Color(0xff0B3C42),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 10),
                    child: Text(
                      'التحاليل المختبرية ',
                      style: GoogleFonts.tajawal(
                        fontSize: 40,
                        color: Color(0xff0B3C42),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 120),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.custom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  primary: false,
                  childrenDelegate: SliverChildListDelegate( List.generate(widget.labsPaths.length, (index) {
                    return createCardFile(widget.labsPaths[index], index , screenHeight , screenWidth);
                  })),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget createCardFile(String path , index,double screenHeight , double screenWidth) {

    return InkWell(
      onTap: () async {
        final Dio _dio = Dio();
        late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
        path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        final isPermissionStatusGranted = await _getPermission();
        Map<String, dynamic> result = {
          'isSuccess': false,
          'filePath': null,
          'error': null,
        };
        if (isPermissionStatusGranted) {
          final response = await _dio.get(
            path,
            options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (received, total) {
              if (total != -1) {
                // Calculate the download percentage
                int progress = (received * 100 / total).floor();
                final String progressString = '$progress%';
                  final AndroidNotificationDetails androidPlatformChannelSpecifics =
                  AndroidNotificationDetails(
                    'channel id',
                    'channel name',
                    icon: 'launch_background',
                    importance: Importance.high,
                    priority: Priority.high,
                    onlyAlertOnce: true,
                    showProgress: true,
                    maxProgress: 100,
                    progress: progress,
                  );
                  final NotificationDetails platformChannelSpecifics =
                  NotificationDetails(
                      android: androidPlatformChannelSpecifics,
                      iOS: const DarwinNotificationDetails());
                  flutterLocalNotificationsPlugin.show(
                    0,
                    // 'Downloading...',
                    "Downloading...",
                    'Download in progress $progressString',
                    platformChannelSpecifics,
                  );

              }
            },
          );
          String header = response.headers['content-disposition']![0];
          String extension =
          header.substring(header.lastIndexOf('.') + 1, header.length);
          String savePath = path;

          int counter = 1;
          while (await File(savePath).exists()) {
            savePath =
            '$path($counter)';
            counter++;
          }
          final File file = File(savePath);
          try {
            await file.create();
            final response = await _dio.download(
              path,
              savePath,
              options: Options(responseType: ResponseType.bytes),
            );
            result['isSuccess'] = response.statusCode == 200;
            result['filePath'] = savePath;
          } catch (ex) {
            result['error'] = ex.toString();
            print('Error creating file: $ex');
          } finally {
            flutterLocalNotificationsPlugin.cancel(0);
            await showNotification(downloadStatus: result, flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
            print(result);
          }
        } else {
          print('not granted');
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
        child: Container(
          height: 141,
          width: 20,
          decoration: BoxDecoration(
            color: Color(0xff167582),
            borderRadius: BorderRadius.all(Radius.circular(14)),
            //border: Colors.black,
            border: Border.all(
              color: Color(0xff167582),
              width: 2,
            ),
          ),
          child: Card(
            elevation: 0,
            color: const Color(0xff167582),
            //shape: RoundedRectangleBorder( Radius.circular(14)),
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'images/newlabicon.svg',
                      color: const Color(0xffFFFFFF),
                      height: screenHeight * 0.09,
                      width: screenWidth * 0.09,
                    )
                ),

                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      ' نتيجة المختبر  ' + '${index+1}',
                      style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFFFFFF), fontSize: 25),
                      textAlign: TextAlign.center,
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

  Future<bool> _getPermission() async {
    PermissionStatus permissionStatus;
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = double.tryParse(androidInfo.version.release);
      if (release != null && release >= 13) {
        return true;
      } else {
        permissionStatus = await Permission.storage.request();
      }

    if (permissionStatus.isGranted) {
      return true;
    } else {
      print('not granted');
      return false;
    }
  }
  Future<void> showNotification(
      {required Map<String, dynamic> downloadStatus,required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin}) async {
    final android = AndroidNotificationDetails('channel id', 'channel name',
        priority: Priority.high, importance: Importance.max);
    final iOS = DarwinNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess
            ? "تم تحميل الملف "
            : "لم يتم تحميل الملف",
        // 'There was an error while downloading the file.'
        "قيد التحميل ",
        platform,
        payload: json);
  }
}
