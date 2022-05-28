import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class LeaderboardComponent extends StatefulWidget {
  final UserModel? userModel;
  final int? index;
  const LeaderboardComponent({Key? key, this.userModel, this.index})
      : super(key: key);

  @override
  _LeaderboardComponentState createState() => _LeaderboardComponentState();
}

class _LeaderboardComponentState extends State<LeaderboardComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(bottom: 15, left: 5, right: 5),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(50),
          backgroundColor: Theme.of(context).cardColor),
      padding: EdgeInsets.all(16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.width,
          Text(
            widget.index.toString(),
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          16.width,
          CircleAvatar(
            radius: 25,
            child: widget.userModel!.image!.isNotEmpty
                ? cachedImage(widget.userModel!.image.validate(),
                        usePlaceholderIfUrlEmpty: true,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(60)
                : Icon(
                    Feather.user,
                    size: 30,
                  ),
          ),
          1.width,
          Container(
            width: 150,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: widget.userModel!.name!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
          ),
          Spacer(),
          Text(
            widget.userModel!.totalPoints.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          10.width,
        ],
      ),
    );
  }
}
