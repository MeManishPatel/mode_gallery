import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:mode_gallery/controller/wallpaper_setting_controller.dart';
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
  WallpaperSettingController wallpaperSettingController = Get.put(WallpaperSettingController());

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
        GetBuilder<WallpaperSettingController>(
          builder: (context) {
            return Visibility(
              visible: wallpaperSettingController.isLoading,
              child: Container(
                color: AppColors.transparentColor,
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                child: Center(
                  child: CustomWidget.loadingWidget(loadingText: wallpaperSettingController.loadingText),
                ),
              ),
            );
          }
        ),
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
          onTap:()  {
            openBottomMenu();
          },
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
  void openBottomMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric( vertical: 30.h),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:[
              Center(
                child: Text(
                  "Select to proceed".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19.sp, color: AppColors.appBarColor, fontWeight: FontWeight.w800)
                  ),
              ),
              SizedBox(height: 10.h),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: 'Set On Home Screen',
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl:widget.imageUrl,
                      wallpaperLocation: AsyncWallpaper.HOME_SCREEN
                  );
                },
                iconData: Icons.home,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: 'Set On Lock Screen',
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl:widget.imageUrl,
                      wallpaperLocation: AsyncWallpaper.LOCK_SCREEN
                  );
                },
                iconData: Icons.lock_clock_rounded,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: 'Set On Both Screen',
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl:widget.imageUrl,
                      wallpaperLocation: AsyncWallpaper.BOTH_SCREENS
                  );
                },
                iconData: Icons.home_work,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title:'Download Image',
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.downloadImage(imageUrl: widget.imageUrl);
                },
                iconData:Icons.save_alt_rounded,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
            ],
          ),
        );
      },
    );
  }
  Widget buildActionButton({required String title, required Callback callBack, required IconData iconData}) {
  return GestureDetector(
     onTap: (){
       callBack();
     },
     child: Padding(
       padding: EdgeInsets.symmetric(horizontal: 20.w,),
       child: Row(
         children: [
           Container(
             padding: EdgeInsets.all(10.h),
             decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: AppColors.appBarColor.withOpacity(0.4)
             ),
             child: Center(
               child: Icon(
                 iconData,
                 color: AppColors.appBarColor,
                 size: 20.h,
               ),
             ),
           ),
           SizedBox(width: 10.w),
           Text(title, style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor)),
           const Spacer(),
           Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appBarColor,size: 15.h),
         ],
       ),
     ),
   );
 }
}
