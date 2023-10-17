import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckBoxCommitment extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final Color fillColor;

  const CheckBoxCommitment({required this.onChanged,required this.fillColor, Key? key}) : super(key: key);

  @override
  State<CheckBoxCommitment> createState() => _CheckBoxCommitmentState();
}

class _CheckBoxCommitmentState extends State<CheckBoxCommitment> {
  bool isCommitment = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: 500,
        child: Center(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
            title: Text(
              "هل انت ملتزم بجرعات ادويتك ؟ ",
              style: GoogleFonts.tajawal(fontSize: 20, color: Colors.black),
            ),
            trailing: Transform.scale(
              scale: 1.4,
              child: Checkbox(
                fillColor: MaterialStateProperty.all(widget.fillColor),
                value: isCommitment,
                onChanged: (bool? value) {
                  setState(() {
                    isCommitment = value!;
                    // Notify the callback function of the change
                    widget.onChanged(isCommitment);
                  });
                },
              ),
            ),
            onTap: () {
              setState(() {
                isCommitment = !isCommitment;
                // Notify the callback function of the change
                widget.onChanged(isCommitment);
              });
            },
          ),
        ),
      ),
    );
  }
}