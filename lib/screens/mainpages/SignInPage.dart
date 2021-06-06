import 'package:bio_watch/models/User.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  final User user;

  SignInPage({this.user});

  @override
  _SignInPageState createState() => _SignInPageState(user);
}

class _SignInPageState extends State<SignInPage> {
  bool hidePassword = true;
  User user;
  _SignInPageState(this.user);

  @override
  Widget build(BuildContext context) {
    Function signIn = Provider.of<DataProvider>(context, listen: true).signIn;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
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
                      initialValue: user.fullName,
                      decoration: textFieldDecoration.copyWith(hintText: 'Full Name'),
                      validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                      onChanged: (val) => setState(() => user.fullName = val)
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: user.email,
                      decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val) => setState(() => user.email = val)
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: user.accountType,
                            decoration: textFieldDecoration.copyWith(hintText: 'Account Type'),
                            validator: (val) => val.isEmpty ? 'Enter AccountType' : null,
                            onChanged: (val) => setState(() => user.accountType = val),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: user.password,
                            decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                                onPressed: () => setState(() => hidePassword = !hidePassword),
                                icon: Icon(Icons.visibility)
                              ),
                              hintText: 'Password'
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Password' : null,
                            onChanged: (val) => setState(() => user.password = val),
                            obscureText: hidePassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: user.address,
                      decoration: textFieldDecoration.copyWith(hintText: 'Permanent Address'),
                      validator: (val) => val.isEmpty ? 'Enter Permanent Address' : null,
                      onChanged: (val) => setState(() => user.address = val)
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
                            initialValue: user.contact,
                            decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                            validator: (val) => val.isEmpty ? 'Enter Contact No.' : null,
                            onChanged: (val) => setState(() => user.contact = val)
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: user.birthday,
                            decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                            validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                            onChanged: (val) => setState(() => user.birthday = val)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      child: Text('CREATE ACCOUNT'),
                      onPressed: () {
                        signIn(user);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(primary: theme.accentColor),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
