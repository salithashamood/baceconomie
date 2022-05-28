import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:baceconomie/database/auth_services.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../locator.dart';
import '../store/appstore.dart';
import 'dash_board_screen.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/RegisterScreen';

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      locator.get<AppStore>().setLoading(true);
      await locator
          .get<AuthService>()
          .signUpWithEmailPassword(
            name: nameController.text,
            email: emailController.text,
            password: passController.text.validate(),
          )
          .then(
        (value) {
          locator.get<AppStore>().setLoading(false);
          DashboardScreen().launch(context, isNewTask: true);
          finish(context);
        },
      ).catchError(
        (e) {
          // toast(e.toString());
          locator.get<AppStore>().setLoading(false);
        },
      );
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
                          Text('Sign Up',
                              style: boldTextStyle(color: white, size: 30)),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?',
                                  style: primaryTextStyle(color: white)),
                              4.width,
                              Text('Sign In',
                                      style: boldTextStyle(color: white))
                                  .onTap(
                                () {
                                  finish(context);
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
                      Text('Enter Username', style: primaryTextStyle()),
                      8.height,
                      AppTextField(
                        controller: nameController,
                        textFieldType: TextFieldType.NAME,
                        focus: nameFocus,
                        decoration: inputDecoration(hintText: 'Username'),
                      ),
                      16.height,
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
                        nextFocus: nameFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(
                          labelText: 'Password',
                          hintText: 'Password',
                        ),
                      ),
                      30.height,
                      gradientButton(
                        text: 'Sign Up',
                        onTap: signUp,
                        isFullWidth: true,
                        context: context,
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
