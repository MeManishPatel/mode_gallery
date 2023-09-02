import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class FullScreenImageViewScreen extends StatefulWidget {
 final String imageUrl;

  const FullScreenImageViewScreen({super.key, required this.imageUrl});

  @override
  State<FullScreenImageViewScreen> createState() => _FullScreenImageViewScreenState();
}

class _FullScreenImageViewScreenState extends State<FullScreenImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: buildBody(context),
        )
    );
  }

 Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        buildImageWidget(),
        customAppBar(),
      ],
    );
 }
Widget customAppBar(){
    return CustomWidget.customAppBar(
      color: AppColors.transparentColor,
      title: '',
      leading: GestureDetector(
        onTap: ()=> Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(7.r),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 16.r,
                  color: AppColors.appBarColor,
                ),
              ]
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.appBarTitleColor,
            size: AppSizes().appBarIconSize,
          ),
        ),
      ),
      actionButtons: [
        GestureDetector(
          onTap:(){},
          child: Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16.r,
                    color: AppColors.appBarColor,
                  ),
                ]
            ),
            child: Icon(
              Icons.more_vert,
              size: AppSizes().appBarIconSize,
              color: AppColors.appBarTitleColor,
            ),
          ),
        ),
      ]
    );
}
 Widget buildImageWidget() {
    return Container(
      height: ScreenUtil().screenHeight,
      width: ScreenUtil().screenWidth,
      color: AppColors.appBackgroundColor,
      child: CustomWidget.imageBuilder(
          url: widget.imageUrl,
          circularImage: false
      ),
    );
 }
}
