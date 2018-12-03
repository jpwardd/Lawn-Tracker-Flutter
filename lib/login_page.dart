import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  login, 
  register
}
class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
      return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print('signed in: ${user.uid}');
      }
      catch (error) {
        print('error: $error');
      }
    }
  }

  void goToRegister() {
    setState(() {
      _formType = FormType.register;
    });
  }

  void goToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Lawn Tracker'),
        ),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons()
            ),
          ),
        ),
      );
    }

    List<Widget> buildInputs() {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'email:'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'password'),
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
          obscureText: true,
        ),
      ];
    }

    List<Widget> buildSubmitButtons() {
      if (_formType == FormType.login) {
        return [
          new RaisedButton(
            child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
            onPressed: validateAndSubmit,
          ),
          new FlatButton(
            child: new Text('Create an accont', style: new TextStyle(fontSize: 20.0),),
            onPressed: goToRegister,
          )
        ];
      } else {
        return [
         new RaisedButton(
            child: new Text('Create an account', style: new TextStyle(fontSize: 20.0)),
            onPressed: validateAndSubmit,
          ),
          new FlatButton(
            child: new Text('Have an account? Login', style: new TextStyle(fontSize: 20.0),),
            onPressed: goToLogin,
          ),
        ];
      }
    }
}