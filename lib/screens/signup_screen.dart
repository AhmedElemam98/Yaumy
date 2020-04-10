import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/constants.dart';
import '../providers/auth.dart';
import '../utilities/dialog_error.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  bool _rememberMe = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };
  final _passwordController = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            cursorColor: Colors.red,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (!isValidPattern(value, emailPattern)) {
                return 'Invalid email!';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              _authData['email'] = value;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'User name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            cursorColor: Colors.red,
            keyboardType: TextInputType.text,
            onSaved: (value) {
              _authData['username'] = value;
            },
            validator: (value) {
              if (!isValidPattern(value, usernamePattern)) {
                return 'Invalid username';
              } else {
                return null;
              }
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person_pin,
                color: Colors.white,
              ),
              hintText: 'Enter your name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF({bool password = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          password ? 'Password' : 'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            cursorColor: Colors.red,
            obscureText: true,
            controller: password ? _passwordController : null,
            validator: password
                ? (value) {
                    if (!isValidPattern(value, passwordPattern)) {
                      return 'Password must contains at least 8 characters length,at least one lowercase and one uppercase letter';
                    } else {
                      return null;
                    }
                  }
                : (value) {
                    if (value != _passwordController.text) {
                      return '  Passwords do not match!';
                    }
                    return null;
                  },
            onSaved: (value) {
              _authData['password'] = value;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorMaxLines: 3,
              //errorStyle: TextStyle(fontSize: 14, color: Colors.red[200],),
              border: InputBorder.none,
              //contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText:
                  password ? 'Enter your Password' : 'Confirm your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSignUpBtn(auth) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _submit(auth),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'sign up',
          style: TextStyle(
            color: Color(0XFFaa076b),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void _submit(auth) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await auth
          .signUpUsingPassword(
        email: _authData['email'],
        password: _authData['password'],
        username: _authData['username'],
      );
      Navigator.of(context).pop();
    }
    catch(error)
    {
      showErrorDialog(
          context: context,
          errorMessage: error.toString().replaceFirst("Exception:", ""));
    }
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: kBackgroundDecoration,
      child:_isLoading
          ? Center(
        child: SpinKitFadingGrid(color: Colors.white, shape: BoxShape.rectangle)
        ,
      )
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 80.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'Yaumy',
                    style: GoogleFonts.permanentMarker(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              _buildEmailTF(),
              SizedBox(
                height: 30.0,
              ),
              _buildUserNameTF(),
              SizedBox(
                height: 30.0,
              ),
              _buildPasswordTF(),
              SizedBox(
                height: 30.0,
              ),
              _buildPasswordTF(password: false),
              SizedBox(
                height: 30.0,
              ),
              _buildSignUpBtn(_auth),
            ],
          ),
        ),
      ),
    ));
  }
}
