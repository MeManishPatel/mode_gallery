
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/wallpaper_setting_controller.dart';
import 'package:mode_gallery/model/home_data_model.dart';
import 'package:mode_gallery/screens/full_screen_image_view_screen.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class ImageSliderViewer extends StatefulWidget {
 final ImageData imageData;

  const ImageSliderViewer({super.key, required this.imageData});


  @override
  State<ImageSliderViewer> createState() => _ImageSliderViewerState();
}

class _ImageSliderViewerState extends State<ImageSliderViewer> {

  late PageController pageController;
  WallpaperSettingController wallpaperSettingController = Get.put(WallpaperSettingController());
  int selectedIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }

 //  Widget buildBody(BuildContext context) {
 //    return Stack(
 //      children: [
 //        SizedBox(
 //          height: ScreenUtil().screenHeight,
 //          width: ScreenUtil().screenWidth,
 //          child: CachedNetworkImage(
 //            height: ScreenUtil().screenHeight,
 //            width: ScreenUtil().screenWidth,
 //            imageUrl: "https://cdn.pixabay.com/photo/2023/08/20/08/16/ai-generated-8201916_640.png",
 //            fit: BoxFit.fill,
 //          ),
 //        ),
 //        SizedBox(
 //          height: ScreenUtil().screenHeight,
 //          width: ScreenUtil().screenWidth,
 //          // child: homeBannerSlider(imageData: widget.imageData),
 //          child: Column(
 //            children: [
 //              CarouselWithIndicator(
 //                  imageData: widget.imageData,
 //                  wallpaperSettingController: wallpaperSettingController
 //              ),
 //
 //            ],
 //          ),
 //        ),
 //      ],
 //    );
 // }
 //  Widget homeBannerSlider({required ImageData? imageData}) {
 //    return Container(
 //      padding: EdgeInsets.symmetric(horizontal: 14.w),
 //      child: ClipRRect(
 //          borderRadius: BorderRadius.circular(20.r),
 //          child: CarouselSlider(
 //            options: CarouselOptions(
 //              height: ScreenUtil().screenHeight * 0.7,
 //              autoPlay: true,
 //              viewportFraction: 1,
 //              autoPlayInterval: const Duration(seconds: 5),
 //              autoPlayCurve: Curves.fastOutSlowIn,
 //              onPageChanged: (index, reason) {
 //                setState(() {
 //                  // _current = index;
 //                });
 //              },
 //            ),
 //            items: imageData!.categoryImages!
 //                .map(
 //                  (singleBanner) => Builder(
 //                builder: (BuildContext context) => InkWell(
 //                  child: ClipRRect(
 //                      borderRadius: BorderRadius.circular(00),
 //                      child: Platform.isAndroid
 //                          ? CachedNetworkImage(
 //                        imageUrl: singleBanner!,
 //                        width: ScreenUtil().screenWidth,
 //                        fit: BoxFit.cover,
 //                        placeholder: (context, url) => CustomWidget.loadingWidget(),
 //                        errorWidget: (context, error, stackTrace) => const SizedBox.shrink(),
 //                      )
 //                          : Image.network(
 //                        singleBanner,
 //                        cacheWidth: ScreenUtil().screenWidth.toInt(),
 //                        width: ScreenUtil().screenWidth,
 //                        cacheHeight: 180.h.toInt(),
 //                        fit: BoxFit.fitWidth,
 //                        loadingBuilder: (context, child, loadingProgress) {
 //                          if (loadingProgress == null) {
 //                            return child;
 //                          } else {
 //                            return CustomWidget.loadingWidget();
 //                          }
 //                        },
 //                      )),
 //                ),
 //              ),
 //            )
 //                .toList(),
 //          )),
 //    );
 //  }

 Widget buildBody(){
    return Stack(
      children: [
        Container(
        decoration:  BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.black54]
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              blurRadius: 12.r,
              spreadRadius: 2.r,
              color: AppColors.appBackgroundColor
            )
          ]
        ),
        ),
        buildCarousel(),
        Container(
          height: AppSizes().appBarHeight,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
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
              CustomWidget.appBarMenuButton(
                  onTap: () {
                    openBottomMenu();
                  },
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
        GetBuilder<WallpaperSettingController>(
          builder: (context) {
            return Visibility(
              visible: wallpaperSettingController.isLoading,
              child: Center(
                child: CustomWidget.loadingWidget(loadingText: AppConstant.settingWallpaperText),
              ),
            );
          }
        ),

      ],
    );
  }

  Widget buildCarousel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10.h,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> FullScreenImageViewScreen(
                          imageData: widget.imageData,
                          index: selectedIndex
                      )
                  )
              );
            },
            child: Container(
              width: ScreenUtil().screenWidth*0.7,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black, Colors.black54
                      ]
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(-5, -5),
                        blurRadius: 20.r,
                        spreadRadius: 1.r,
                        color: AppColors.appBackgroundColor
                    )
                  ]
              ),
              child: CustomWidget.imageBuilder(
                  url: widget.imageData.categoryImages![selectedIndex],
                  circularImage: true
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().screenHeight*0.25,
          child: PageView.builder(
            itemCount: widget.imageData.categoryImages?.length,
            controller: PageController(viewportFraction: 0.30),
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
          ),
        )
      ],
    );
  }
  
  Widget buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(
      height: selectedIndex == itemIndex?ScreenUtil().screenHeight*0.3:ScreenUtil().screenHeight*0.1,
      margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
      clipBehavior: Clip.antiAlias,
      decoration:  BoxDecoration(
        border: Border.all(
            width: selectedIndex == itemIndex?4.w:2.w,
            color: selectedIndex == itemIndex?AppColors.appBarColor:AppColors.appBackgroundColor
        ),
        color: selectedIndex == itemIndex?AppColors.appBarColor:AppColors.appBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(4.w)),
      ),
      child: CustomWidget.imageBuilder(
          url: widget.imageData.categoryImages![itemIndex],
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: const Alignment(0.8, 1),
              colors: [
                AppColors.gradientColor3,
                AppColors.gradientColor1,
              ],
            ),
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
                      imageUrl:widget.imageData.categoryImages![selectedIndex],
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
                      imageUrl:widget.imageData.categoryImages![selectedIndex],
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
                      imageUrl:widget.imageData.categoryImages![selectedIndex],
                      wallpaperLocation: AsyncWallpaper.BOTH_SCREENS
                  );
                },
                iconData: Icons.home_work,
              ),
              Divider(color: AppColors.blueColor,height: 10.h,thickness: 1.h),
              buildActionButton(
                title: AppConstant.downloadImage,
                callBack: (){
                  Navigator.pop(context);
                  wallpaperSettingController.downloadImage(
                    imageUrl:widget.imageData.categoryImages![selectedIndex],
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

}
