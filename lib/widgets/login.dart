import 'package:flutter/material.dart';
import 'package:delivery/Widgets/home.dart';
import 'package:delivery/utils/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController textControllerEmail;
  FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  TextEditingController textControllerPassword;
  FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;
  String loginStatus;
  Color loginStringColor = Colors.green;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = "meriem@gmail.fr";
    textControllerPassword.text = "12345678";
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  String _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty)
        return 'Password can\'t be empty';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              focusNode: textFocusNodeEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: textControllerEmail,
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  _isEditingEmail = true;
                });
              },
              onSubmitted: (value) {
                textFocusNodeEmail.unfocus();
                FocusScope.of(context).requestFocus(textFocusNodePassword);
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blueGrey[800],
                    width: 3,
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(
                  color: Colors.blueGrey[300],
                ),
                hintText: "Email",
                fillColor: Colors.white,
                errorText: _isEditingEmail
                    ? _validateEmail(textControllerEmail.text)
                    : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
              ),
            ),
            TextField(
              focusNode: textFocusNodePassword,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: textControllerPassword,
              obscureText: true,
              autofocus: false,
              onChanged: (value) {
                setState(() {
                _isEditingPassword = true;
                });
              },
              onSubmitted: (value) {
                textFocusNodePassword.unfocus();
                FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blueGrey[800],
                  width: 3,
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(
                  color: Colors.blueGrey[300],
                  ),
                hintText: "Password",
                fillColor: Colors.white,
                errorText: _isEditingPassword
                    ? _validatePassword(textControllerPassword.text)
                    : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
              ),
            ),
            FlatButton(
              color: Colors.blueGrey[800],
              hoverColor: Colors.blueGrey[900],
              highlightColor: Colors.black,
              onPressed: () async {
                setState(() {
                  _isLoggingIn = true;
                  textFocusNodeEmail.unfocus();
                  textFocusNodePassword.unfocus();
                });
                if (_validateEmail(textControllerEmail.text) == null &&
                    _validatePassword(textControllerPassword.text) == null) {
                      await signInWithEmailPassword(
                        textControllerEmail.text,
                        textControllerPassword.text)
                        .then((result) {
                          if (result != null) {
                            print(result);
                            setState(() {
                              loginStatus = 'You have successfully logged in';
                              loginStringColor = Colors.green;
                            });
                            Future.delayed(Duration(milliseconds: 500),() {
                              Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => HomePage(),
                              ));
                            });
                          }
                        }).catchError((error) {
                          print('Login Error: $error');
                          setState(() {
                            loginStatus = 'Error occured while logging in';
                            loginStringColor = Colors.red;
                          });
                        });
                    } else {
                        setState(() {
                          loginStatus = 'Please enter email & password';
                          loginStringColor = Colors.red;
                        });
                      }
                      setState(() {
                        _isLoggingIn = false;
                        textControllerEmail.text = '';
                        textControllerPassword.text = '';
                        _isEditingEmail = false;
                        _isEditingPassword = false;
                      });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: _isLoggingIn ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:new AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                : Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 14,                    
                    color: Colors.white,
                  ),
                ),
              ),
            ),                         
          ],
        ),
      ),
    );
  }
}