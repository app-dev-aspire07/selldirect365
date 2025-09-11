import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_market_place/model/Truck_Model/get_truck_model.dart'
    as get_truck;
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/model/Truck_Model/get_my_truck_model.dart' as my_truck;
import 'package:truck_market_place/model/Auth_Model/profile_model.dart' as user;


class OtherController extends GetxController{
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


RxBool isFavorite = true.obs;
  RxList<get_truck.Datum> getFavoriteTrucks = <get_truck.Datum>[].obs;

  RxBool isQuotes = true.obs;
  RxList<get_truck.Datum> getMyQuoteList = <get_truck.Datum>[].obs;

   RxBool isMyEquioment = true.obs;
  RxList<my_truck.Datum> getMyEquimentList = <my_truck.Datum>[].obs;

RxBool isProfile = true.obs;
  var userProfile = Rxn<user.Data>();
  void onInit() {
    super.onInit();
    fetchFavorites();
    fetchQuotes();
    fetchMyEquiments();
  }


  Future<void> fetchFavorites() async {
    try {
      isFavorite(true);
      getFavoriteTrucks.clear();

      final result = await ApiRepository.getFavorites();
      getFavoriteTrucks.assignAll(result);

      if (result.isEmpty) {
        isFavorite(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isFavorite(false);
    }
  }

  Future<void> fetchQuotes() async {
    try {
      isQuotes(true);
      getMyQuoteList.clear();

      final result = await ApiRepository.getQuotes();
      getMyQuoteList.assignAll(result);

      if (result.isEmpty) {
        isQuotes(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isQuotes(false);
    }
  }

Future<void> fetchMyEquiments() async {
    try {
      isMyEquioment(true);
      getMyEquimentList.clear();

      final result = await ApiRepository.getMyEquipment();
      getMyEquimentList.assignAll(result);

      if (result.isEmpty) {
        isMyEquioment(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isMyEquioment(false);
    }
  }

 var errorMessage = "".obs;
  Future<void> fetchUserProfile() async {
    try {
      isProfile(true);
      errorMessage("");

      final result = await ApiRepository.getUserProfile();

      if (result.id != null) {
        userProfile.value = result;
      } else {
        errorMessage("No data found for this truck");
        isProfile(false);
      }
    } catch (e) {
      errorMessage("Failed to load truck details");
      print("❌ Error in fetchTruckById: $e");
    } finally {
      isProfile(false);
    }
  }

    void handleError(dynamic e) {
    if (e is SocketException) {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        animType: AnimType.scale,
        title: 'Error',
        desc: "Check your internet connection",
        btnOkOnPress: () {},
      ).show();
    } else {
      print(e);
    }
  }
}