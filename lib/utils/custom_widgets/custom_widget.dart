import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';

class CustomWidget{
  static customAppBar({
   required String title,
  }){
    return  Container(
      height: 100.h,
      width: ScreenUtil().screenWidth,
      color: AppColors.appBarColor,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.whiteColor, size: AppSizes.appBarIconSize),
          Text(title, style: TextStyle(color: AppColors.appBarTitleColor, fontSize: 18.sp, fontWeight: FontWeight.w600)),
          SizedBox(width: 25.w),
        ],
      ),
    );
  }
}