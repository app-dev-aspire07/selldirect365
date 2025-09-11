import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_market_place/Auth/sign_in.dart';
import 'package:truck_market_place/app_utils/constants.dart';
import 'package:truck_market_place/model/Auth_Model/SuccessModel.dart';
import 'package:truck_market_place/model/Auth_Model/profile_model.dart' as user;
import 'package:truck_market_place/model/Auth_Model/send_otp_model.dart';
import 'package:truck_market_place/model/Auth_Model/signin_model.dart';
import 'package:truck_market_place/model/Truck_Model/get_brands_model.dart'
    as brand;
import 'package:truck_market_place/model/Truck_Model/get_cat_model.dart'
    as get_cat;
import 'package:truck_market_place/model/Truck_Model/get_my_truck_model.dart'
    as my_truck;
import 'package:truck_market_place/model/Truck_Model/get_subCat_model.dart'
    as sub_cat;
import 'package:truck_market_place/model/Truck_Model/get_formField_model.dart'
    as form_fields;
import 'package:truck_market_place/model/Truck_Model/get_truck_id_model.dart'
    as get_truck_id;
import 'package:truck_market_place/model/Truck_Model/get_truck_id_model.dart';
import 'package:truck_market_place/model/Truck_Model/get_truck_model.dart'
    as get_truck;
import 'package:truck_market_place/model/Truck_Model/save_truck_model.dart';
import 'package:truck_market_place/model/demo_model.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/logging_interceptor.dart';
import 'package:dio/dio.dart' as diooo;

class ApiRepository {
  static final diooo.Dio _dio = diooo.Dio();
  static final CookieJar _cookieJar = CookieJar();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? _token;

  static void initialize() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            print("Unauthorized! Logging out...");
            await logOut();
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(LoggingInterceptor());
  }

  static Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAll(() => SignIn()); // Bina context ke direct kaam karega
  }

  // 🔹 Send OTP
  static Future<OtpSentModel> sendOTPforRegisteration({
    required String? emailId,
  }) async {
    final body = jsonEncode({"email": emailId});
    try {
      final response = await _dio.post(ApiEndPoints.signUpRequest, data: body);
      log("SEND OTP ➜ ${response.data}");
      return OtpSentModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Send OTP");
      return OtpSentModel();
    }
  }

  // 🔹 Verify OTP
  static Future<SuccessModel> verifyOTP({
    required String? email,
    required String? otp,
  }) async {
    final body = jsonEncode({"email": email, "otp": otp});
    try {
      final response = await _dio.post(
        ApiEndPoints.verifySignupOtp,
        data: body,
      );
      print(ApiEndPoints.verifySignupOtp);
      print(body);
      print(response.data);
      log("VERIFY OTP ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Verify OTP");
      return SuccessModel(status: false, message: "OTP verification failed");
    }
  }

  // static Future<SigninModel> loginUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   final body = {"email": email.trim(), "password": password.trim()};

  //   try {
  //     print("BODY: $body");
  //     final response = await _dio.post(ApiEndPoints.loginRequest, data: body);
  //     print("RESPONSE: ${response.data}");

  //     final data = response.data is String
  //         ? jsonDecode(response.data)
  //         : response.data;

  //     SigninModel loginModel = SigninModel.fromJson(data);

  //     if (loginModel.status == true) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("token", loginModel.token ?? "");
  //       return loginModel;
  //     } else {
  //       return SigninModel(status: false, message: loginModel.message);
  //     }
  //   } catch (e, stacktrace) {
  //     debugPrint("Login Error: $e");
  //     debugPrint("StackTrace: $stacktrace");
  //     _handleError(e, "Login");
  //     return SigninModel(status: false, message: "Something went wrong");
  //   }
  // }
  static Future<SigninModel> loginRequest({
    required BuildContext context,
    Object? data,
  }) async {
    SigninModel successModel;
    var body = jsonEncode(data);
    if (kDebugMode) {
      print(data);
      print(body);
    }

    // try {
    var response = await _dio.post(
      ApiEndPoints.loginRequest,
      data: body,
      options: diooo.Options(
        headers: {"Content-Type": "application/json"},
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        },
      ),
    );
    print("login bodyyyy $body");
    print("login response ${response.data}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> info = response.data;

      successModel = SigninModel.fromJson(info);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", successModel.token.toString());

      return successModel;
    } else {
      final Map<String, dynamic> info = response.data;
      successModel = SigninModel.fromJson(info);

      return successModel;
    }
  }

  static Future<SuccessModel> forgotPassword({String? emailId}) async {
    var body = jsonEncode({"email": emailId});
    try {
      print(ApiEndPoints.passWordRequest);
      print(body);
      final response = await _dio.post(
        ApiEndPoints.passWordRequest,
        data: body,
      );

      log("VERIFY OTP ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Verify OTP");
      return SuccessModel(status: false, message: "OTP verification failed");
    }
  }

  static Future<DemoModel> demoUser() async {
    try {
      print("http://192.168.20.236:5000/api/users/me");

      final response = await _dio.get(
        "http://192.168.20.236:5000/api/users/me",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODk0YTY2M2Y3NGRjNWQ2ZGM1MzM0ZTYiLCJpYXQiOjE3NTQ1NzI1MzksImV4cCI6MTc1NDU3NjEzOX0._iG-Q0nhcMlAlPGOMroTPuzw3_fUlR2Meu_MtMAJlAQ",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      log("VERIFY OTP ➜ ${response.data}");
      return DemoModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Verify OTP");
      return DemoModel();
    }
  }

  static Future<SuccessModel> verifyForgetOTP({
    // required String? email,
    required String? otp,
  }) async {
    final body = jsonEncode({"otp": otp});
    try {
      final response = await _dio.post(ApiEndPoints.verifyPassOtp, data: body);
      print(ApiEndPoints.verifyPassOtp);
      print(body);
      log("VERIFY OTP ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Verify OTP");
      return SuccessModel(status: false, message: "OTP verification failed");
    }
  }

  static Future<SuccessModel> resetPassword({
    required String? password,
    // required String? otp,
  }) async {
    final body = jsonEncode({"password": password});
    try {
      final response = await _dio.post(ApiEndPoints.changePass, data: body);
      print(ApiEndPoints.changePass);
      print(body);
      log("Change Password ➜ ${response.data}");
      print(response.data);
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Change Password");
      return SuccessModel();
    }
  }

  // 🔹 Register User
  static Future<SuccessModel> register({
    required String? name,
    required String? email,
    required String? password,
    required String? mob_no,
  }) async {
    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "mobile_number": "+1${mob_no}",
      "role": "user",
    });
    log("REGISTER Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.finalSignup,
        data: body,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("REGISTER ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      _handleError(e, "Register");
      return SuccessModel(status: false, message: "Registration failed");
    }
  }

  static Future<List<get_cat.Datum>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) return [];

    try {
      var response = await _dio.get(
        ApiEndPoints.getCat,
        options: diooo.Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          followRedirects: false,
          validateStatus: (status) => status! <= 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final getCategoriesModel = get_cat.getCategoriesModelFromJson(
          jsonEncode(response.data),
        );

        return getCategoriesModel.data ?? [];
      } else if (response.statusCode == 401) {
        print('------401------loaduser--data-------${response.data}----------');
        logOut();
        return [];
      } else {
        return [];
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("profile errors ${e.toString()}");
      }
      return [];
    }
  }

  static Future<List<sub_cat.Datum>> getSubCategories({int? id}) async {
    sub_cat.GetSubCategoriesModel getCategoriesModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getSubCat + int.parse(id.toString()).toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      // print("${ApiEndPoints.getSubCat + int.parse(id.toString()).toString()}");
      // print(response.statusCode);
      // print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getCategoriesModel = sub_cat.getSubCategoriesModelFromJson(
          jsonEncode(response.data),
        );

        return getCategoriesModel.data!;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<brand.Datum>> getBrands() async {
    brand.GetBrandsModel getBrandsModel;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getBrands,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      // print(ApiEndPoints.getBrands);
      // print(response.statusCode);
      // print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getBrandsModel = brand.getBrandsModelFromJson(
          jsonEncode(response.data),
        );
        return getBrandsModel.data!;
      }

      return [];
    } catch (e) {
      print("hello0");
      print(e);
      rethrow;
    }
  }

  static Future<List<form_fields.Datum>> getFormFields({int? id}) async {
    form_fields.GetFormFieldModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getFormFields + int.parse(id.toString()).toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ApiEndPoints.getSubCat + int.parse(id.toString()).toString());
      // print(response.statusCode);
      // print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        getFormFieldModel = form_fields.getFormFieldModelFromJson(
          jsonEncode(response.data),
        );

        return getFormFieldModel.data!;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<SaveTruckModel> saveTruck({
    required int? catId,
    required int? subCatId,
    required String? desc,
    required List<int> formId,
    required List<int> fieldId,
    required List<String> formValue,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({
      "cat_id": catId,
      "sub_cat_id": subCatId,
      "desc": desc,
      "form_id": formId,
      "form_value": formValue,
      "field_id": fieldId,
    });
    log("REGISTER Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.saveTruck,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Save Truck ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SaveTruckModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('------401------loaduser--data-------${response.data}----------');
        await logOut();
        return SaveTruckModel();
      } else {
        return SaveTruckModel();
      }
    } catch (e) {
      _handleError(e, "Save Truck");
      return SaveTruckModel();
    }
  }

  static Future<SaveTruckModel> saveDesc({
    required int? truckId,

    required String? desc,
    String? address,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({"id": truckId, "desc": desc, "address": address});
    log("REGISTER Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.saveDesc,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Save Desc ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SaveTruckModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('------401------loaduser--data-------${response.data}----------');
        await logOut();
        return SaveTruckModel();
      } else {
        return SaveTruckModel();
      }
    } catch (e) {
      _handleError(e, "Save Truck");
      return SaveTruckModel();
    }
  }

  static Future<SuccessModel> saveImages({
    required int? id,
    required List<String> img,
    void Function(int sent, int total)? onProgress, // progress callback
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    try {
      diooo.FormData body = diooo.FormData.fromMap({
        "id": id,
        "images[]": [
          for (int i = 0; i < img.length; i++)
            await diooo.MultipartFile.fromFile(
              img[i],
              filename: "image_$i.jpg",
            ),
        ],
      });

      final response = await _dio.post(
        ApiEndPoints.saveTruckImg,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),

        onSendProgress: (int sent, int total) {
          if (onProgress != null) {
            onProgress(sent, total);
          }
          log(
            "Upload Progress: $sent / $total (${(sent / total * 100).toStringAsFixed(0)}%)",
          );
        },
      );

      print("Save Truck ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      // _handleError(e, "Save Truck Images");
      return SuccessModel();
    }
  }

  static Future<SuccessModel> saveDocuments({
    required int? id,
    required List<String> docs,
    required String documentsType,
    void Function(int sent, int total)? onProgress, // progress callback
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    try {
      diooo.FormData body = diooo.FormData.fromMap({
        "id": id,
        "documents_type": documentsType,
        "documents[]": [
          for (int i = 0; i < docs.length; i++)
            await diooo.MultipartFile.fromFile(
              docs[i],
              filename:
                  "document_$i.${docs[i].split('.').last}", // keep original extension
            ),
        ],
      });

      final response = await _dio.post(
        ApiEndPoints.saveDocuments,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),

        onSendProgress: (int sent, int total) {
          if (onProgress != null) {
            onProgress(sent, total);
          }
          log(
            "Upload Progress: $sent / $total (${(sent / total * 100).toStringAsFixed(0)}%)",
          );
        },
      );

      print("Save Documents ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      // _handleError(e, "Save Truck Documents");
      return SuccessModel();
    }
  }

  static Future<List<get_truck.Datum>> getTrucks() async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getTrucks.toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ApiEndPoints.getTrucks.toString());
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<get_truck.Datum>> getTrucksByModel({int? id}) async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        "${ApiEndPoints.getTrucksByModel.toString()}$id",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print("${ApiEndPoints.getTrucksByModel.toString()}$id");
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<get_truck.Datum>> getTrucksByCategories({
    int? id,
    int? subCat,
  }) async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        "${ApiEndPoints.getTruckByCatId.toString()}${id}&sub_cat_id=${subCat}",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(
        "${ApiEndPoints.getTruckByCatId.toString()}${id}&sub_cat_id=${subCat}",
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<get_truck_id.Data> getTrucksByTruckId({int? id}) async {
    get_truck_id.GetTruckByIdModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        "${ApiEndPoints.getTruckByTruckId.toString()}${id}",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print("${ApiEndPoints.getTruckByTruckId.toString()}${id}");
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck_id.GetTruckByIdModel.fromJson(info);
        return getFormFieldModel.data ?? get_truck_id.Data();
      } else {
        return Data();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<SuccessModel> sentQuote({
    required int? truckId,

    required int? isQuote,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({"truck_id": truckId, "quote_id": 1});
    log("Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.sentQuote,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Send Quote ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('------401------loaduser--data-------${response.data}----------');
        await logOut();
        return SuccessModel();
      } else {
        return SuccessModel();
      }
    } catch (e) {
      _handleError(e, "Save Truck");
      return SuccessModel();
    }
  }

  static Future<SuccessModel> saveFavorite({
    required int? truckId,
    required int? isFavorite,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({"truck_id": truckId, "is_favorite": isFavorite});
    log("Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.addFavorites,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Send Quote ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('------401------loaduser--data-------${response.data}----------');
        await logOut();
        return SuccessModel();
      } else {
        return SuccessModel();
      }
    } catch (e) {
      _handleError(e, "Save Truck");
      return SuccessModel();
    }
  }

  static Future<List<get_truck.Datum>> getFavorites() async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getFavorites.toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ApiEndPoints.getFavorites.toString());
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<get_truck.Datum>> getQuotes() async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getQuotes.toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ApiEndPoints.getQuotes.toString());
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<SuccessModel> deleteQuote({required int? truckId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({"truck_id": truckId});
    log("Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.deleteQuote,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Send Quote ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        await logOut();
        return SuccessModel();
      } else {
        return SuccessModel();
      }
    } catch (e) {
      _handleError(e, "Save Truck");
      return SuccessModel();
    }
  }

  static Future<SuccessModel> changePassword({
    required String? oldPassword,
    required String? newPass,
    required String? confirmPass,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    final body = jsonEncode({
      "old_password": oldPassword,
      "new_password": newPass,
      "confirm_password": confirmPass,
    });
    log("Body ➜ $body");
    try {
      final response = await _dio.post(
        ApiEndPoints.changePassword,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      log("Change Password ➜ ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        await logOut();
        return SuccessModel();
      } else {
        return SuccessModel();
      }
    } catch (e) {
      _handleError(e, "Change Password");
      return SuccessModel();
    }
  }

  static Future<List<my_truck.Datum>> getMyEquipment() async {
    my_truck.GetMyTruckModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        ApiEndPoints.getMyEquipment.toString(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(ApiEndPoints.getMyEquipment.toString());
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = my_truck.GetMyTruckModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<user.Data> getUserProfile() async {
    user.UserProfileModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        "${ApiEndPoints.profile.toString()}",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print("${ApiEndPoints.profile}");
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = user.UserProfileModel.fromJson(info);
        return getFormFieldModel.data ?? user.Data();
      } else {
        return user.Data();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<SuccessModel> updateProfile({
    required String name,
    required String mobileNumber,
    String? userImagePath,
  }) async {
    print(userImagePath);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    try {
      diooo.FormData body = diooo.FormData.fromMap({
        "name": name,
        "mobile_number": mobileNumber,
        "user_image": [
          await diooo.MultipartFile.fromFile(userImagePath.toString()),
        ],
      });

      final response = await _dio.post(
        ApiEndPoints.updateProfile.toString(),
        data: body,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) => status != null && status <= 500,
        ),
      );
      print(ApiEndPoints.updateProfile);
      print("Update Profile ➜ ${body.fields}");
      print("Update Profile ➜ ${body.files.first}");
      print("Update Profile Response ➜ ${response.data}");
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      print("❌ Update Profile Error: $e");
      return SuccessModel();
    }
  }

  static Future<List<get_truck.Datum>> searchEquipment({String? keyword}) async {
    get_truck.GetTrucksModel getFormFieldModel;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      var response = await _dio.get(
        "${ApiEndPoints.searchTruck.toString()} $keyword",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print("${ApiEndPoints.searchTruck.toString()} $keyword");
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final Map<String, dynamic> info = data is String
            ? jsonDecode(data)
            : data;

        getFormFieldModel = get_truck.GetTrucksModel.fromJson(info);
        return getFormFieldModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // 🔹 Error Handler
  static void _handleError(Object error, String type) {
    String message = Constants.something_went_wrong;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          message = Constants.cancelRequest;
          break;
        case DioExceptionType.connectionTimeout:
          message = Constants.connectionTimeOut;
          break;
        case DioExceptionType.receiveTimeout:
          message = Constants.ReceiveserverTimeOut;
          break;
        case DioExceptionType.sendTimeout:
          message = Constants.serverTimeOut;
          break;
        case DioExceptionType.badResponse:
          message =
              error.response?.data['message'] ?? Constants.something_went_wrong;
          break;
        case DioExceptionType.badCertificate:
          message = "Bad SSL Certificate";
          break;
        case DioExceptionType.connectionError:
          message = "Connection Error";
          break;
        case DioExceptionType.unknown:
          message = Constants.defaultError;
      }
    }

    log("❌ API Error [$type]: $message");

    if (navigatorKey.currentContext != null) {
      AwesomeDialog(
        context: navigatorKey.currentContext!,
        animType: AnimType.scale,
        title: 'Error',
        desc: message,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
