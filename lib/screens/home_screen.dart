import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mode_gallery/common/app_constants.dart';
import 'package:mode_gallery/controller/home_screen_controller.dart';
import 'package:mode_gallery/screens/full_screen_image_view_screen.dart';
import 'package:mode_gallery/screens/image_list_screen.dart';
import 'package:mode_gallery/screens/image_slider_viewer.dart';
import 'package:mode_gallery/utils/app_colors.dart';
import 'package:mode_gallery/utils/app_sizes.dart';
import 'package:mode_gallery/utils/custom_widgets/custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  ScrollController? controller;
  
  @override
  void initState() {
    homeScreenController.getHomeData(pageNum: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBarColor,
        body: buildBody(context),
        floatingActionButton: FloatingActionButton.small(
          onPressed: (){
            homeScreenController.getHomeData(pageNum: 0);
          },
          child: Text(
            "Ad",
            style: TextStyle(
              color: AppColors.appBarColor,
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
            ),
          ),
        ),
      ),
    );
  }

 Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        CustomWidget.customAppBar(
          title: AppConstant.homeScreenTitle, actionButtons: [],
        ),
        GetBuilder<HomeScreenController>(
          builder: (context) {
            return Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              margin: EdgeInsets.only(top: 60.h),
              decoration: BoxDecoration(
                color: AppColors.appBackgroundColor,
                // borderRadius: BorderRadius.circular(AppSizes().bodyCurveRadius),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes().bodyCurveRadius),
                  topRight: Radius.circular(AppSizes().bodyCurveRadius),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.whiteColor,
                    AppColors.blackColor,
                  ],
                )
              ),
              child: buildImageDataList(),
            );
          }
        ),
      ],
    );
 }

 Widget buildImageDataList() {
    return Container(
      padding:  EdgeInsets.only(left: 10.w, right: 10.w),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: homeScreenController.homeDataList.length,
        separatorBuilder: (context, index){
          // return Divider(color: AppColors.appBarColor, height: 10.h, thickness: 3.h);
          return SizedBox(height: 0.h);
        },
        itemBuilder: (context, index){
          var data = homeScreenController.homeDataList[index];
          return Container(
            padding: index ==0?EdgeInsets.only(top: 15.h):EdgeInsets.zero,
            width: ScreenUtil().screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(data.categoryTitle!, style: TextStyle(color: AppColors.blackColor, fontSize: 17.sp, fontWeight: FontWeight.w600, fontFamily: "poppins")),
                    const Spacer(),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>ImageSliderViewer(imageData: data)));
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: AppColors.blueColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                        )
                    ),
                  ],
                ),
                SizedBox(
                  height: 170.h,
                  width: ScreenUtil().screenWidth,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.categoryImages!.length,
                    separatorBuilder: (context, index){
                      return SizedBox(width: 10.w);
                      },
                    itemBuilder:  (context, index){
                      var imageData = data.categoryImages?[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>FullScreenImageViewScreen(
                                imageData:  data,
                                index: index,
                              )
                              )
                          );
                        },
                        child: SizedBox(
                          width: 120.h,
                          child: CustomWidget.imageBuilder(
                            url: imageData!,
                            circularImage: true,
                          ),
                        ),
                      );
                      },
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          );
        },
      ),
    );
 }
}
