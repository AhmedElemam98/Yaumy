import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart';
import '../providers/user.dart';
import '../utilities/constants.dart';
class UserNameScreen extends StatefulWidget {


  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {


  String _username;


  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0XFFaa076b), Color(0XFF61045f)],
        ),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    _username = value;
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
              _buildSignUpBtn(this.context)
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSignUpBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _submit(context),
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

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
       Provider.of<User>(context,listen: false).updateUserName(_username);
    });
  }
}
