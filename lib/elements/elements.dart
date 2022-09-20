// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/providers/wsstate.dart';
import 'package:provider/provider.dart';

class StylePage extends StatelessWidget {
  StylePage(
      {super.key,
      required this.child,
      required this.title,
      this.backArrow = false});
  final Widget child;
  final String title;
  bool backArrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, backArrow: backArrow),
      body: Container(
          decoration: BoxDecoration(color: Color(0xFFF9F9FF)),
          child: Padding(padding: const EdgeInsets.all(20), child: child)),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({super.key, required this.title, this.backArrow = false});
  final String title;
  bool backArrow;

  @override
  Widget build(BuildContext context) {
    return Consumer<WSState>(builder: (context, value, child) {
      return AppBar(
        backgroundColor: Color(0xFFF9F9FF),
        elevation: 6,
        centerTitle: true,
        title: Text(title.toUpperCase(),
            style: GoogleFonts.robotoCondensed(
                textStyle: const TextStyle(color: Color(0xFF3F4053)),
                fontWeight: FontWeight.w900,
                fontSize: 20.0)),
        leading: value.getStatus() == "error"
            ? IconButton(
                onPressed: () {
                  Provider.of<WSState>(context, listen: false)
                      .setStatus("loading");

                  Provider.of<Store>(context, listen: false).socket.connect();
                },
                icon: Icon(Icons.replay, color: Colors.black87))
            : backArrow
                ? BackButton(
                    onPressed: () => {Navigator.pop(context)},
                    color: Colors.black87,
                  )
                : Container(),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key, required this.placeholder, required this.controller});
  final String placeholder;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 3,
              blurRadius: 20,
              color: Color(0xFFA9ABC3),
            )
          ]),
          child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  fillColor: Color(0xFFEFF0FF),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  // border: OutlineInputBorder(),
                  label: Text(placeholder,
                      style: GoogleFonts.robotoCondensed(
                          textStyle: const TextStyle(color: Color(0xFF3F4053)),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0))
                  // hintText: 'Enter valid username'),
                  ))),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed});
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF2638DC),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: 3,
                    blurRadius: 10,
                    color: Color(0xFFA9ABC3),
                  )
                ]),
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Center(
                    child: Text(text.toUpperCase(),
                        style: GoogleFonts.robotoCondensed(
                            textStyle:
                                const TextStyle(color: Color(0xFFEFF0FF)),
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0))))),
      ),
    );
  }
}

class Secondarybutton extends StatelessWidget {
  const Secondarybutton(
      {super.key, required this.text, required this.onPressed});
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF2638DC), width: 5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: 3,
                    blurRadius: 10,
                    color: Color(0xFFA9ABC3),
                  )
                ]),
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Center(
                    child: Text(text.toUpperCase(),
                        style: GoogleFonts.robotoCondensed(
                            textStyle:
                                const TextStyle(color: Color(0xFF2638DC)),
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0))))),
      ),
    );
  }
}

class TextError extends StatelessWidget {
  const TextError({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text.toUpperCase(),
          style: GoogleFonts.robotoCondensed(
              textStyle:
                  const TextStyle(color: Color.fromARGB(255, 209, 21, 21)),
              fontWeight: FontWeight.w700,
              fontSize: 15.0)),
    );
  }
}

class PlayerContainer extends StatelessWidget {
  const PlayerContainer({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF2EFF0FF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 3,
                  blurRadius: 10,
                  color: Color(0xFFA9ABC3),
                )
              ]),
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(player.name,
                      style: GoogleFonts.robotoCondensed(
                          textStyle: const TextStyle(color: Color(0xFF3F4053)),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0))))),
    );
  }
}

class MiniGamePayload {
  MiniGamePayload(
      {required this.name,
      required this.code,
      required this.players,
      required this.minPlayers});
  final String name;
  final String code;
  final int players;
  final int minPlayers;
}

class MiniGameContainer extends StatelessWidget {
  const MiniGameContainer(
      {super.key, required this.payload, required this.onTap});
  final MiniGamePayload payload;
  final Function onTap;

  optimalPlayers() {
    return payload.players >= payload.minPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: GestureDetector(
        onTap: () => {optimalPlayers() ? onTap() : () {}},
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: optimalPlayers()
                      ? Color(0xFF2EFF0FF)
                      : Color.fromARGB(255, 224, 84, 84),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 3,
                      blurRadius: 10,
                      color: Color(0xFFA9ABC3),
                    )
                  ]),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(payload.name,
                          style: GoogleFonts.robotoCondensed(
                              textStyle:
                                  const TextStyle(color: Color(0xFF3F4053)),
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0))))),
          optimalPlayers()
              ? Container()
              : Text("Pas assez de joueurs",
                  style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 209, 21, 21)),
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0))
        ]),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF2EFF0FF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 3,
                  blurRadius: 10,
                  color: Color(0xFFA9ABC3),
                )
              ]),
          // width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Align(alignment: Alignment.centerLeft, child: child))),
    );
  }
}

class CustomContainerText extends StatelessWidget {
  const CustomContainerText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF2EFF0FF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 3,
                  blurRadius: 10,
                  color: Color(0xFFA9ABC3),
                )
              ]),
          // width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(text,
                      style: GoogleFonts.robotoCondensed(
                          textStyle: const TextStyle(color: Color(0xFF3F4053)),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0))))),
    );
  }
}

class PrettyText extends StatefulWidget {
  const PrettyText({super.key, required this.text});
  final String text;

  @override
  State<PrettyText> createState() => _PrettyTextState();
}

class _PrettyTextState extends State<PrettyText> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(widget.text,
            style: GoogleFonts.robotoCondensed(
                textStyle: const TextStyle(color: Color(0xFF3F4053)),
                fontWeight: FontWeight.w700,
                fontSize: 20.0)));
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.icon,
      required this.color,
      required this.onTap});
  final Icon icon;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: 3,
                    blurRadius: 10,
                    color: Color(0xFFA9ABC3),
                  )
                ]),
            //width: MediaQuery.of(context).size.width,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Align(alignment: Alignment.centerLeft, child: icon))),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({super.key, required this.active, required this.onTap});
  bool active;
  Function onTap;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          SystemSound.play(SystemSoundType.click);
          widget.onTap();
          setState(() {
            widget.active = !widget.active;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10)),
          height: 30,
          width: 30,
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: widget.active ? Color(0xFF2638DC) : Colors.transparent,
                borderRadius: BorderRadius.circular(8)),
          ),
        ));
  }
}
