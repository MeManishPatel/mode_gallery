import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        body: buildBody(context),
      ),
    );
  }

 Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        CustomWidget.customAppBar(title: "Home Screen"),
        Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            color: AppColors.appBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.bodyCurveRadius),
          ),
        ),
      ],
    );
 }
}
