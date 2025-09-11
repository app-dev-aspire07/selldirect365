import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_market_place/model/Truck_Model/get_cat_model.dart'
    as get_cat;
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/model/Truck_Model/get_subCat_model.dart'
    as sub_cat;
import 'package:truck_market_place/model/Truck_Model/get_brands_model.dart'
    as brand;
import 'package:truck_market_place/model/Truck_Model/get_formField_model.dart'
    as form_fields;
import 'package:truck_market_place/model/Truck_Model/get_truck_model.dart'
    as get_truck;
    import 'package:truck_market_place/model/Truck_Model/get_truck_id_model.dart' as get_truck_id;

class HomeController extends GetxController {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Category States
  RxBool isLoading = true.obs;
  RxList<get_cat.Datum> categoriesList = <get_cat.Datum>[].obs;

  /// SubCategory States
  RxBool isSubCat = true.obs;
  RxList<sub_cat.Datum> subCatList = <sub_cat.Datum>[].obs;

  /// Brand States
  RxBool isBrands = true.obs;
  RxList<brand.Datum> branList = <brand.Datum>[].obs;

  /// Form Fields States
  RxBool isForm = true.obs;
  RxList<form_fields.Datum> formFieldList = <form_fields.Datum>[].obs;

  /// Split Lists for Different Screens
  RxList<form_fields.Datum> brandList = <form_fields.Datum>[].obs;
  RxList<form_fields.Datum> modelList = <form_fields.Datum>[].obs;
  RxList<form_fields.Datum> transmissionList = <form_fields.Datum>[].obs;
  RxList<form_fields.Datum> yearColorList = <form_fields.Datum>[].obs;
  RxList<form_fields.Datum> theList = <form_fields.Datum>[].obs;
  RxList<form_fields.Datum> remainingFieldsList = <form_fields.Datum>[].obs;

  RxBool isTrucks = true.obs;
  RxList<get_truck.Datum> getTruckList = <get_truck.Datum>[].obs;

  RxBool isModelTruck = true.obs;
  RxList<get_truck.Datum> getTruckModelList = <get_truck.Datum>[].obs;

  RxBool isCat = true.obs;
  RxList<get_truck.Datum> getTruckCatList = <get_truck.Datum>[].obs;

    RxBool isSearch = true.obs;
  RxList<get_truck.Datum> getSearchResult = <get_truck.Datum>[].obs;

  /// Final grouped data for screens
  List<List<form_fields.Datum>> screensData = [];

  /// Selection States
  RxInt selectedCatId = 0.obs;
  var selectedModelIndex = (-1).obs;
  var selectedModelIndex1 = (-1).obs;
  var selectedBrandIndex = (-1).obs;
  var selectedTransmissionIndex = (-1).obs;

  /// Manual Field States
  var manualFieldValues = <int, String>{}.obs; // fieldId → text value

  /// Old states (still used in some places)
  var enteredPrice = ''.obs;
  var showEnteredPrice = false.obs;

  RxInt selectedSubCatId = 0.obs;
  RxInt selectedSubCat = 0.obs;
  var selectedValues = <int, String>{}.obs; // fieldId : selectedOptionValue
  var enteredValues = <int, String>{}.obs; // fieldId : enteredText
  var showPriceFields = <int, bool>{}.obs; // fieldId : show/hide

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesList();
    fetchTrucks();
    fetchBrandsList();
    
  }

  @override
  void onReady() {
    super.onReady();
    fetchCategoriesList();
    fetchTrucks();
    fetchBrandsList();
  }

  /// ✅ Global validation
  bool get isNextEnabled {
    // Manual fields validation
    for (var field in theList) {
      final fieldId = field.fieldId ?? -1;
      if (fieldId == -1) continue;

      final isOptional = field.isOptional == 1;
      if (isOptional) continue;
    }

    // Model & Transmission selection validation
    if (selectedModelIndex.value == -1 ||
        selectedTransmissionIndex.value == -1) {
      return false;
    }

    return true;
  }

  /// Fetch Categories
  Future<void> fetchCategoriesList() async {
    try {
      isLoading(true);
      categoriesList.clear();

      final result = await ApiRepository.getCategories();
      categoriesList.assignAll(result);

      if (result.isEmpty) {
        isLoading(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading(false);
    }
  }

  /// Fetch Sub Categories
  Future<void> fetchSubCategoriesList(int? catId) async {
    try {
      isSubCat(true);
      subCatList.clear();

      final result = await ApiRepository.getSubCategories(id: catId);
      subCatList.assignAll(result);

      if (result.isEmpty) {
        isSubCat(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isSubCat(false);
    }
  }

  /// Fetch Form Fields & Split Data
  Future<void> fetchFormFields(int? catId) async {
    print("Fetching form fields for category: $catId");
    try {
      isForm(true);
      formFieldList.clear();

      final result = await ApiRepository.getFormFields(id: catId);

      if (result.isNotEmpty) {
        formFieldList.assignAll(result);

        brandList.clear();
        modelList.clear();
        transmissionList.clear();
        yearColorList.clear();
        theList.clear();
        remainingFieldsList.clear();
        screensData.clear();
        manualFieldValues.clear();

        for (int i = 0; i < formFieldList.length; i++) {
          final field = formFieldList[i];

          if (i == 0) {
            brandList.add(field);
          } else if (i == 1) {
            modelList.add(field);
          } else if (i == 3 || i == 2) {
            yearColorList.add(field);
          } else if (i == 4 || i == 18 || i == 19) {
            theList.add(field);
          } else {
            remainingFieldsList.add(field);
          }

          /// ✅ Initialize manual fields with empty string
          if (field.isManual == 1) {
            manualFieldValues[field.fieldId ?? 0] = "";
          }
        }

        screensData.add(brandList);
        screensData.add(modelList);
        screensData.add(transmissionList);
        screensData.add(yearColorList);
        screensData.add(theList);
        screensData.add(remainingFieldsList);
      } else {
        isForm(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isForm(false);
    }
  }

  /// Fetch Brands
  Future<void> fetchBrandsList() async {
    try {
      isBrands(true);
      branList.clear();

      final result = await ApiRepository.getBrands();
      branList.assignAll(result);

      if (result.isEmpty) {
        isBrands(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isBrands(false);
    }
  }

  Future<void> fetchTrucks() async {
    try {
      isTrucks(true);
      getTruckList.clear();

      final result = await ApiRepository.getTrucks();
      getTruckList.assignAll(result);

      if (result.isEmpty) {
        isTrucks(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isTrucks(false);
    }
  }
  Future<void> fetchTrucksByModel({int? id}) async {
    try {
      isModelTruck(true);
      getTruckModelList.clear();

      final result = await ApiRepository.getTrucksByModel(id: id);
      getTruckModelList.assignAll(result);

      if (result.isEmpty) {
        isModelTruck(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isModelTruck(false);
    }
  }
  Future<void> fetchTrucksByCategories({int? id, int? subCatId}) async {
  try {
    isCat(true);
    getTruckCatList.clear();

    // ✅ Agar "All" option select hai
    if (subCatId == 0) {
      List<get_truck.Datum> allResults = [];

      // 1. SubCatId = 0 ka data
      final result0 = await ApiRepository.getTrucksByCategories(
        id: id,
        subCat: 0,
      );
      allResults.addAll(result0);

      // 2. Baaki subcategories ka data
      for (var sub in subCatList) {
        final res = await ApiRepository.getTrucksByCategories(
          id: id,
          subCat: sub.id ?? 0,
        );
        allResults.addAll(res);
      }

      // 3. Sabko ek hi list me store karo
      getTruckCatList.assignAll(allResults);
    } else {
      // ✅ Normal case (specific subcategory)
      final result = await ApiRepository.getTrucksByCategories(
        id: id,
        subCat: subCatId,
      );
      getTruckCatList.assignAll(result);
    }
  } catch (e) {
    handleError(e);
  } finally {
    isCat(false);
  }
}

var truckDetail = Rxn<get_truck_id.Data>();

RxBool isTruckDetailLoading = true.obs;
 var errorMessage = "".obs;
Future<void> fetchTruckById(int? id) async {
    try {
      isTruckDetailLoading(true);
      errorMessage("");

      final result = await ApiRepository.getTrucksByTruckId(id: id);

      if (result.truckFormId != null) {
        truckDetail.value = result;
      } else {
        errorMessage("No data found for this truck");
        isTruckDetailLoading(false);
      }
    } catch (e) {
      errorMessage("Failed to load truck details");
      print("❌ Error in fetchTruckById: $e");
    } finally {
      isTruckDetailLoading(false);
    }
  }

Future<void> fetchSearchResult({String? keyword}) async {
    try {
      isSearch(true);
      getSearchResult.clear();

      final result = await ApiRepository.searchEquipment(keyword: keyword);
      getSearchResult.assignAll(result);

      if (result.isEmpty) {
        isSearch(false);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isSearch(false);
    }
  }

  /// Error Handler
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
