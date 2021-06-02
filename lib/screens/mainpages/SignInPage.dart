import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String fullName = '';
  String email = '';
  String password = '';
  String accountType = '';
  String address = '';
  String contact = '';
  String birthday = '';
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Placeholder(),
                ),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: fullName,
                  decoration: textFieldDecoration.copyWith(hintText: 'Full Name'),
                  validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                  onChanged: (val) => setState(() => fullName = val)
                ),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: email,
                  decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter Email' : null,
                  onChanged: (val) => setState(() => email = val)
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: accountType,
                        decoration: textFieldDecoration.copyWith(hintText: 'Account Type'),
                        validator: (val) => val.isEmpty ? 'Enter AccountType' : null,
                        onChanged: (val) => setState(() => accountType = val),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
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
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: address,
                  decoration: textFieldDecoration.copyWith(hintText: 'Permanent Address'),
                  validator: (val) => val.isEmpty ? 'Enter Permanent Address' : null,
                  onChanged: (val) => setState(() => address = val)
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: contact,
                        decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                        validator: (val) => val.isEmpty ? 'Enter Contact No.' : null,
                        onChanged: (val) => setState(() => contact = val)
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: birthday,
                        decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                        validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                        onChanged: (val) => setState(() => birthday = val)
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  child: Text('CREATE ACCOUNT'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: theme.accentColor),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
