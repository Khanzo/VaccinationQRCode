import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'resources.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget child;
  final bool withCloseButton;

  const CustomAlertDialog({
    Key key,
    this.child,
    this.withCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      content: Stack(
        children: <Widget>[
          withCloseButton
              ? const Positioned(child: CloseButton(), right: 0, top: 0)
              : const SizedBox.shrink(),
          SizedBox(
            width: double.infinity,
            child: child,
          ),
        ],
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String text;
  InfoDialog({@required this.text});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: CustomAlertDialog(
        child: _InfoDialog(
          text: text,
        ),
        withCloseButton: false,
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  final String text;
  _InfoDialog({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF292c36),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 247,
            child: Theme(
              data: ThemeData(
                accentColor: Colors.white,
                buttonTheme: ButtonThemeData(
                  buttonColor: Color(0xFF4d66ba),
                  height: 48,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                  splashColor: Colors.white24,
                  highlightColor: Colors.white10,
                  textTheme: ButtonTextTheme.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                ),
                textTheme: const TextTheme(
                  button: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              child: RaisedButton(
                child: const Text(
                  Strings.ok,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}