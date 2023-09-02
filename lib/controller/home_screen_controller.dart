import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mode_gallery/model/home_data_model.dart';



class HomeScreenController extends GetxController {

  List<ImageData> homeDataList = [];
  String lastId = "0";
  bool isLoading = false;
  bool isLoadingMore = false;
  // String feedType = ApiConstants().trending;

  @override
  void onInit() {
    getHomeData(pageNum: 0);
    super.onInit();
  }

  getHomeData({required int pageNum}) async {
    updateLoadingState(status: true);
    var jsonData = await rootBundle.loadString("assets/image_list_model.json");
    print("object =>1 ${jsonData}");
    print("object =>11 ${json.decode(jsonData).runtimeType}");
    final data = HomeDataModel.fromJson(json.decode(jsonData));
    print("object =>2 ${data.toJson()}");
      if (data.imageData != null && data.imageData!.isNotEmpty) {
        homeDataList = data.imageData!;
        print("object =>3 ${homeDataList.length}");
      }

    updateLoadingState(status: false);
    update();
  }

  loadMoreData({required int pageNum}) async {
    updateLoadingMoreState(status: true);

    ///TODO logic for pagination
    updateLoadingMoreState(status: false);
    update();
  }

  void updateLoadingState({required bool status}) {
    isLoading = status;
    update();
  }

  void updateLoadingMoreState({required bool status}) {
    isLoadingMore = status;
    update();
  }

  void updateLastId({required String id}) {
    lastId = id;
    update();
  }
}
