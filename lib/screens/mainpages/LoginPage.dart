import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/mainpages/SignInPage.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return loading ? Loading() : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bio Watch Login'),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 100),
                    Center(child: Text('Biowatch', style: theme.textTheme.headline2)),
                    Center(child: Text('Keep events tracked and safe with Biowatch', style: theme.textTheme.bodyText2)),
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        initialValue: email,
                        decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Enter Email' : null,
                        onChanged: (val) => setState(() => email = val)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        initialValue: password,
                        decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                          onPressed: () => setState(() => showPassword = !showPassword),
                          icon: Icon(Icons.visibility)
                          ),
                          hintText: 'Password'
                        ),
                        validator: (val) => val.isEmpty ? 'Enter Password' : null,
                        onChanged: (val) => setState(() => password = val),
                        obscureText: showPassword,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        child: Text('LOG IN'),
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              String result = await _auth.logIn(email, password);
                              if(result != 'SUCCESS') {
                                setState(() {
                                  error = result;
                                  loading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Log In'),
                                    content: Text(error),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK')
                                      )
                                    ],
                                  )
                                );
                              }
                            } else {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                content: Text('Fill up all the fields'),
                                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                        style: ElevatedButton.styleFrom(primary: theme.accentColor)
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        child: Text('CREATE ACCOUNT'),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage(user: AccountData(
                          fullName: '',
                          accountType: 'USER',
                          address: '',
                          contact: '',
                          birthday: '',
                          sex: 'Male'
                        )))),
                        style: ElevatedButton.styleFrom(primary: theme.accentColor),
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
