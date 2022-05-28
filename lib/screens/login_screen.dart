// ignore: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:baceconomie/database/auth_services.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/screens/forgot_password_screen.dart';
import 'package:baceconomie/screens/register_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:baceconomie/utils/widgets.dart';

import 'package:nb_utils/nb_utils.dart';

import 'dash_board_screen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController =
      TextEditingController(text: kReleaseMode ? '' : '');
  TextEditingController passController =
      TextEditingController(text: kReleaseMode ? '' : '');

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loginWithEmail() async {
    if (formKey.currentState!.validate()) {
      locator.get<AppStore>().setLoading(true);
      locator
          .get<AuthService>()
          .signInWithEmailPassword(
              email: emailController.text, password: passController.text)
          .then((value) {
        locator.get<AppStore>().setLoading(false);

        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        locator.get<AppStore>().setLoading(false);
        // toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(LoginPageImage,
                        height: context.height() * 0.35,
                        width: context.width(),
                        fit: BoxFit.fill),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: Image.asset(LoginPageLogo, width: 80, height: 80),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sign In',
                              style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Do not have account?',
                                  style: primaryTextStyle(color: white)),
                              4.width,
                              Text('Sign Up',
                                      style:
                                          boldTextStyle(color: white, size: 18))
                                  .onTap(
                                () {
                                  RegisterScreen().launch(context);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Email', style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: emailController,
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocus,
                        nextFocus: passFocus,
                        decoration: inputDecoration(hintText: 'Email'),
                      ),
                      16.height,
                      Text('Enter Password', style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: passController,
                        focus: passFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(
                            hintText: 'Password', labelText: 'Password'),
                      ),
                      30.height,
                      gradientButton(
                          text: 'Sign In',
                          onTap: loginWithEmail,
                          context: context,
                          isFullWidth: true),
                      16.height,
                      Container(
                        padding: EdgeInsets.only(
                            top: defaultRadius, bottom: defaultRadius),
                        width: context.width(),
                        child: Text('Sign Up', style: boldTextStyle()).center(),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ).onTap(() {
                        RegisterScreen().launch(context);
                      }),
                      16.height,
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          child: Text('Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.secondary,
                              )),
                          onTap: () => ForgotPasswordScreen().launch(context),
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 16, right: 16),
                ),
                16.height,
              ],
            ),
          ),
          Observer(
              builder: (context) =>
                  Loader().visible(locator.get<AppStore>().isLoading)),
        ],
      ),
    );
  }
}
