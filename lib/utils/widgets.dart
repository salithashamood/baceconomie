import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'constants.dart';

InputDecoration inputDecoration({String? hintText, String? labelText}) {
  return InputDecoration(
    labelText: labelText,
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
    filled: true,
    hintText: hintText != null ? hintText : '',
    hintStyle: secondaryTextStyle(),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none, color: Colors.white60),
        borderRadius: BorderRadius.circular(defaultRadius)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(defaultRadius)),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(defaultRadius)),
  );
}

Widget gradientButton(
    {required String text,
    Function? onTap,
    bool isFullWidth = false,
    required BuildContext context,
    Color? color}) {
  return Container(
    width: isFullWidth ? context.width() : null,
    padding: EdgeInsets.only(left: 30, right: 30),
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [colorPrimary, colorSecondary],
        begin: FractionalOffset.centerLeft,
        end: FractionalOffset.centerRight,
      ),
      borderRadius: BorderRadius.circular(defaultRadius),
      //color: color
    ),
    child: TextButton(
      style: TextButton.styleFrom(backgroundColor: color),
      child: Text(
        text,
        style: boldTextStyle(color: white, size: 12),
      ),
      onPressed: onTap as void Function()?,
    ),
  );
}

Widget cachedImage(String url,
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(
      url,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

String getLevel({required int points}) {
  if (points < 100) {
    return Level0;
  } else if (points >= 100 && points < 200) {
    return Level1;
  } else if (points >= 200 && points < 300) {
    return Level2;
  } else if (points >= 300 && points < 400) {
    return Level3;
  } else if (points >= 400 && points < 500) {
    return Level4;
  } else if (points >= 500 && points < 600) {
    return Level5;
  } else if (points >= 600 && points < 700) {
    return Level6;
  } else if (points >= 700 && points < 800) {
    return Level7;
  } else if (points >= 800 && points < 900) {
    return Level8;
  } else if (points >= 900 && points < 1000) {
    return Level9;
  } else if (points >= 1000) {
    return Level10;
  } else {
    return '';
  }
}

Widget itemWidget(Color bgColor, Color textColor, String title, String desc) {
  return Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
        border: Border.all(color: gray),
        borderRadius: radius(8),
        color: bgColor),
    padding: EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: primaryTextStyle(color: textColor, size: 30)),
        8.height,
        Expanded(
            child: Text(desc,
                style: primaryTextStyle(size: 24, color: textColor))),
      ],
    ),
  );
}

Future<bool> sendPushNotifications(String title, String content,
    {String? id, String? image}) async {
  Map req = {
    'headings': {
      'en': title,
    },
    'contents': {
      'en': content,
    },
    //  'big_picture': image.validate().isNotEmpty ? image.validate() : '',
    // 'large_icon': image.validate().isNotEmpty ? image.validate() : '',
    // 'small_icon': 'assets/splash_app_logo.png',
    'data': {
      'id': id,
    },
    'app_id': mOneSignalAppId,
    // 'android_channel_id': mOneSignalChannelId,
    'included_segments': ['All'],
  };
  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode);
  log(res.body);

  if (res.statusCode.isSuccessful()) {
    return true;
  } else {
    throw errorSomethingWentWrong;
  }
}

// String parseHtmlString(String? htmlString) {
//   return parse(parse(htmlString).body!.text).documentElement!.text;
// }

// Widget cachedImage(String url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
//   if (url.validate().isEmpty) {
//     return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
//   } else if (url.validate().startsWith('http')) {
//     return CachedNetworkImage(
//       imageUrl: url,
//       height: height,
//       width: width,
//       fit: fit,
//       alignment: alignment as Alignment? ?? Alignment.center,
//       errorWidget: (_, s, d) {
//         return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
//       },
//       placeholder: (_, s) {
//         if (!usePlaceholderIfUrlEmpty) return SizedBox();
//         return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
//       },
//     );
//   } else {
//     return Image.asset(
//       url,
//       height: height,
//       width: width,
//       fit: fit,
//       alignment: alignment ?? Alignment.center,
//     ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
//   }
// }

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset(
    'images/placeholder.jpg',
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
  ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

// Future<void> launchUrl(String url, {bool forceWebView = false}) async {
//   log(url);
//   await launch(url, forceWebView: forceWebView, enableJavaScript: true).catchError((e) {
//     log(e);
//     toast(" ${appStore.translate('lbl_invalid_url')}:$url");
//   });
// }

// bool isLoggedInWithGoogle() {
//   return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeGoogle;
// }

// String getLevel({required int points}) {
//   if (points < 100) {
//     return Level0;
//   } else if (points >= 100 && points < 200) {
//     return Level1;
//   } else if (points >= 200 && points < 300) {
//     return Level2;
//   } else if (points >= 300 && points < 400) {
//     return Level3;
//   } else if (points >= 400 && points < 500) {
//     return Level4;
//   } else if (points >= 500 && points < 600) {
//     return Level5;
//   } else if (points >= 600 && points < 700) {
//     return Level6;
//   } else if (points >= 700 && points < 800) {
//     return Level7;
//   } else if (points >= 800 && points < 900) {
//     return Level8;
//   } else if (points >= 900 && points < 1000) {
//     return Level9;
//   } else if (points >= 1000) {
//     return Level10;
//   } else {
//     return '';
//   }
// }

Widget emptyWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(EmptyImage, height: 150, fit: BoxFit.cover),
      Text('No data found', style: boldTextStyle(size: 20)),
    ],
  ).center();
}

InputDecoration addAnswerInputDecoration({String? hintText, Color? fillColor}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
    //fillColor: fillColor,
    filled: true,

    hintText: hintText != null ? hintText : '',
    hintStyle: secondaryTextStyle(),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none, color: Colors.white60),
        borderRadius: BorderRadius.circular(defaultRadius)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(defaultRadius)),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(defaultRadius)),
  );
}

/*class CorrectAnswerSwitch extends StatefulWidget {
  @override
  CorrectAnswerSwitchState createState() => CorrectAnswerSwitchState();
}

class CorrectAnswerSwitchState extends State<CorrectAnswerSwitch> {
  bool correctAnswer = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: white),
      child: SwitchListTile(
        value: correctAnswer,
        title: Text('Correct answer', style: secondaryTextStyle()),
        onChanged: (bool val) {
          setState(
            () {
              correctAnswer = val;
            },
          );
        },
      ),
    );
  }
}*/
