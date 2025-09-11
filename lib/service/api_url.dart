// ignore_for_file: unused_field

class ApiEndPoints {

static const String baseUrl = 'https://baltejb24.sg-host.com/api/endpoints';
  static const String _baseUrl = 'https://baltejb24.sg-host.com/api/endpoints';
  static const String imgBaseUrl = "https://baltejb24.sg-host.com/admin-frontend/uploads/";
  static const String imgUrl = "https://baltejb24.sg-host.com/api/";
  static const String imgMUrl ="https://baltejb24.sg-host.com/admin-frontend/Uploads/";

  // Auth EndPoints

  static const String signUpRequest = '$baseUrl/register-send-otp.php';
  static const String verifySignupOtp = "$baseUrl/register-verify-otp.php";
  static const String finalSignup = "$baseUrl/register-final.php";
  static const String loginRequest = "$baseUrl/login.php";
 
  static const String passWordRequest = "$baseUrl/forgot-password.php";
  static const String verifyPassOtp = "$baseUrl/verify-reset-otp.php";
  static const String changePass = "$baseUrl/reset-password.php";


  static const String getCat = "$baseUrl/get-main-categories.php";
  static const String getSubCat = "$baseUrl/get-sub-categories.php?main_category_id=";
  static const String getBrands = "$baseUrl/get-brands.php";
  static const String getFormFields = "$baseUrl/form-field-p1.php?main_category_id=";
  static const String saveTruck = "$baseUrl/save_truck_form.php"; //post
  static const String saveDesc = "$baseUrl/save_truck_desc.php";
  static const String saveTruckImg = "$baseUrl/save_truck_images.php";
  static const String saveDocuments = "$baseUrl/save_truck_doc.php";

  // Get Trucks API's
  static const String getTrucks = "$baseUrl/get_truck.php";
  static const String getTrucksByModel = "$baseUrl/get_truck_model_by_id.php?model_id="; 
  static const String getTruckByCatId =   "$baseUrl/get-truck-by-cat-id.php?cat_id=";//40&sub_cat_id=0
  static const String getTruckByTruckId = "$baseUrl/get_truck_by_id.php?id=";

static const String sentQuote = "$baseUrl/sent_quote.php";
static const String addFavorites = "$baseUrl/add_favorite.php";
static const String getFavorites = "$baseUrl/get_favorite.php";

static const String getQuotes = "$baseUrl/get_quote.php";
static const String getMyEquipment = "$baseUrl/get_sell_truck.php";
static const String deleteQuote = "$baseUrl/delete_quote.php";

// profile
static const String profile = "$baseUrl/get_profile.php";
static const String updateProfile = "$baseUrl/update_profile.php";
static const String changePassword = "$baseUrl/change_password.php";
static const String deleteAccount = "$baseUrl/delete_account.php"; 
static const String searchTruck = "$baseUrl/search_truck.php?q=";


}