import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/src/extensions/context_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: colorPrimary,
        elevation: 0,
        title: Text('Reset Password', style: TextStyle(color: scaffoldColor)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receive an email to\nreset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 25,
              ),
              AppTextField(
                validator: (value) =>
                    value != null ? 'Enter a valid email' : null,
                controller: emailController,
                textFieldType: TextFieldType.EMAIL,
                decoration: inputDecoration(hintText: 'Email'),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding:
                    EdgeInsets.only(top: defaultRadius, bottom: defaultRadius),
                width: context.width(),
                child: Text('Reset Password', style: boldTextStyle()).center(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ).onTap(() {
                if (emailController.text.isNotEmpty)
                  resetPassword();
                else {
                  final snackBar =
                      SnackBar(content: Text('Please Enter Email'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      final snackBar = SnackBar(content: Text('Password Reset Email Sent'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }
}
