import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/wallpaper_setting_controller.dart';
import 'package:mode_gallery/model/home_data_model.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class FullScreenImageViewScreen extends StatefulWidget {
 final ImageData imageData;
 final int index;

  const FullScreenImageViewScreen({super.key, required this.imageData, required this.index});

  @override
  State<FullScreenImageViewScreen> createState() => _FullScreenImageViewScreenState();
}

class _FullScreenImageViewScreenState extends State<FullScreenImageViewScreen> {
  WallpaperSettingController wallpaperSettingController = Get.put(WallpaperSettingController());
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.index;
    super.initState();
  }


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
    return SizedBox(
      height: AppSizes().appBarHeight,
      width: ScreenUtil().screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 10.w),
          Container(
            height: AppSizes().appBarButtonSize,
            width: AppSizes().appBarButtonSize,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appBarColor,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(-2, -2),
                      color: AppColors.appBarTitleColor,
                      blurRadius: 12.r,
                      spreadRadius: 1.r
                  )
                ]
            ),
            child: CustomWidget.backButton(
              context: context,
              onTap: ()=> Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Container(
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.appBarColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                widget.imageData.categoryTitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.appBarTitleColor,
                    fontSize: 20.sp
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomWidget.appBarMenuButton(
            onTap: () {
              openBottomMenu();
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );

    return CustomWidget.customAppBar(
      color: AppColors.transparentColor,
      title: '',
      leading: GestureDetector(
        onTap: ()=> Navigator.pop(context),
        child: Container(
          height: AppSizes().appBarButtonSize,
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
              color: AppColors.appBarColor,
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
    return PageView.builder(
      itemCount: widget.imageData.categoryImages?.length,
      controller: PageController(viewportFraction: 1.0),
      itemBuilder: (BuildContext context, int itemIndex) {
        return GestureDetector(
            onTap: (){
              selectedIndex = itemIndex;
              setState(() {});
              },
            child: buildCarouselItem(context, itemIndex)
        );
        },
      onPageChanged: (index){
        selectedIndex = index;
        setState(() {});
        },
    );

    return Container(
      height: ScreenUtil().screenHeight,
      width: ScreenUtil().screenWidth,
      color: AppColors.appBackgroundColor,
      child: CustomWidget.imageBuilder(
          url: widget.imageData.categoryImages![widget.index],
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientColor3,
                AppColors.gradientColor1,
              ]
            )
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:[
              Center(
                child: Text(
                   AppConstant.bottomModelSheetTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19.sp, color: AppColors.appBarColor, fontWeight: FontWeight.w800)
                  ),
              ),
              SizedBox(height: 10.h),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnHomeScreen,
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl: widget.imageData.categoryImages![selectedIndex],
                      wallpaperLocation: AsyncWallpaper.HOME_SCREEN
                  );
                },
                iconData: Icons.home,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnLockScreen,
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl: widget.imageData.categoryImages![selectedIndex],
                      wallpaperLocation: AsyncWallpaper.LOCK_SCREEN
                  );
                },
                iconData: Icons.lock_clock_rounded,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: AppConstant.setOnBothScreen,
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.setAsWallpaper(
                      imageUrl: widget.imageData.categoryImages![selectedIndex],
                      wallpaperLocation: AsyncWallpaper.BOTH_SCREENS
                  );
                },
                iconData: Icons.home_work,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title:AppConstant.downloadImage,
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.downloadImage(
                    imageUrl: widget.imageData.categoryImages![selectedIndex],
                  );
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
     child: Container(
       color: AppColors.transparentColor,
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
                 color: AppColors.bottomBarIconColor,
                 size: 20.h,
               ),
             ),
           ),
           SizedBox(width: 10.w),
           Text(title, style: TextStyle(fontSize: 16.sp, color: AppColors.bottomBarButtonColor)),
           const Spacer(),
           Icon(Icons.arrow_forward_ios_rounded, color: AppColors.bottomBarIconColor,size: 15.h),
         ],
       ),
     ),
   );
 }

  Widget buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(
      child: CustomWidget.imageBuilder(
          url: widget.imageData.categoryImages![itemIndex],
          circularImage: false
      ),
    );
  }

}
