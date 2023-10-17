import 'package:diabetes_and_hypertension/UI/OTPScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool selected = false;
late TextEditingController phnum;

class LoginScreen extends StatefulWidget {
  bool isDr;

  LoginScreen({
    required this.isDr,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  final _controllerDrID = TextEditingController();
  bool newAccount = false;

  @override
  void dispose() {
    setState(() {
      selected = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background.png"),
                    fit: BoxFit.cover)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  if (selected == true) selected = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onTapCancel: () {
                  if (selected == true) selected = false;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 330),
                  curve: Curves.linear,
                  width: double.infinity,
                  height: selected ? screenHeight * 0.9 : screenHeight * 0.68,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Divider(
                                  color: Colors.grey,
                                  indent: 15,
                                  endIndent: 15,
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Center(
                                      child: Text(
                                    'رمز التحقق',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 30 * textScale,
                                      color: Color(0xff1D98A8),
                                    ),
                                  ))),
                              const Expanded(
                                flex: 1,
                                child: Divider(
                                  color: Colors.grey,
                                  indent: 15,
                                  endIndent: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text(
                            "ادخل رقم الهاتف",
                            style: GoogleFonts.tajawal(
                                color: Color(0xff752C20),
                                fontSize: 25 * textScale,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8),
                          child: Text(
                            "سيتم ارسال رمز سري يستخدم لمرة واحدة فقط",
                            style: TextStyle(
                              color: Color.fromRGBO(134, 138, 139, 1),
                              fontSize: 15 * textScale,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Column(children: const [
                                    Text(
                                      '+962',
                                      style: TextStyle(
                                        fontSize: 23,
                                        color: Color.fromRGBO(117, 121, 122, 1),
                                      ),
                                    ),
                                  ])),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: TextField(
                                    style: TextStyle(fontSize: 22),
                                    onTap: () => setState(() {
                                      selected = true;
                                    }),
                                    onEditingComplete: () => setState(() {
                                      selected = false;
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      //FocusScope.of(context).requestFocus(new FocusNode());
                                    }),
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      hintText: "7XXXXXXXX",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              117, 121, 122, .27)),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 208, 201, 1)),
                                      ),
                                    ),
                                    maxLength: 9,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        newAccount == false
                            ? Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 20),
                                child: widget.isDr == false
                                    ? Text(
                                        "ادخل رمز طبيبك ",
                                        style: GoogleFonts.tajawal(
                                          color: const Color.fromRGBO(
                                              117, 121, 122, 1),
                                          fontSize: 22,
                                        ),
                                      )
                                    : Text(
                                        "ادخل رمزك ",
                                        style: GoogleFonts.tajawal(
                                          color: const Color.fromRGBO(
                                              117, 121, 122, 1),
                                          fontSize: 22,
                                        ),
                                      ),
                              )
                            : Container(),
                        newAccount == false
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 150.0),
                                child: TextField(
                                  style: const TextStyle(fontSize: 22),
                                  onTap: () => setState(() {
                                    selected = true;
                                  }),
                                  onEditingComplete: () => setState(() {
                                    selected = false;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    //FocusScope.of(context).requestFocus(new FocusNode());
                                  }),
                                  controller: _controllerDrID,
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    hintText: "ABC00",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(117, 121, 122, .27)),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(189, 208, 201, 1)),
                                    ),
                                  ),
                                  maxLength: 5,
                                  keyboardType: TextInputType.text,
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      newAccount = true;
                                    });
                                  },
                                  child: Text(
                                    "انشاء حساب جديد ",
                                    style: GoogleFonts.tajawal(
                                      color: newAccount == false
                                          ? Color(0xff752C20)
                                          : Colors.grey,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      newAccount = false;
                                    });
                                  },
                                  child: Text(
                                    "لدي حساب قديم ",
                                    style: GoogleFonts.tajawal(
                                      color: newAccount == true
                                          ? Color(0xff752C20)
                                          : Colors.grey,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff1D98A8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                minimumSize: const Size(274, 41),
                              ),
                              // onPressed: () {},
                              onPressed: () {
                                String ss = _controller.text.toString();
                                if (ss.length == 9) {
                                  if(newAccount == true)
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTPScreen(phone: _controller.text, isDr: widget.isDr,)));
                                  else
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTPScreen(phone: _controller.text , drID: _controllerDrID.text,isDr: widget.isDr,)));
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('ERROR'),
                                      content: Text(
                                        'الرقم قصير , الرجاء اعادة ادخال الرقم ',
                                        style: GoogleFonts.tajawal(),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'ارسل الرمز',
                                style: GoogleFonts.tajawal(fontSize: 25),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 20,
              top: screenHeight * 0.04,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 32,
                  color: Color(0xFFB7D2CC),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }
//
//   @override
// void initState() {
//   hi=0.92;
// }
}
