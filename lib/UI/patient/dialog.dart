import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialogBox extends StatelessWidget {

  const CustomDialogBox();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          margin: const EdgeInsets.only(top: 64.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "تحذير",
                  style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                Text(
                  'القراءة الذي ادخلتها مرتفعة , اذا اردت الاتصال بالدفاع المدني اضغط على اتصال ',
                  style: GoogleFonts.tajawal(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "الغاء",
                          style: GoogleFonts.tajawal(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: (){
                          _makePhoneCall('tel:911');
                        },
                        child: Text(
                          "اتصال",
                          style: GoogleFonts.tajawal(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xffE00000), // Set the color of the border here
                width: 4.0, // Set the width of the border here
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 48.0,
             child: SvgPicture.asset(
               "images/sos.svg",
               height: 40,
               width: 40,
             ),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
