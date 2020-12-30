class APIConstants {
  static final String baseUrl =
      "https://unique-itsolutions.co.uk/restaurant-demo/sizzler_box/";
  static final String foodProductListEndpoint = baseUrl + "android/foodlist";
  static final String foodProductListByCategoryIdEndpoint =
      baseUrl + "android/Categorywisefoodlist";
  static final String foodCategoryListEndpoint =
      baseUrl + "android/categorylist";
  static final String userLoginEndpoint = baseUrl + "android/sign_in";
  static final String userAuthTokenEndpoint = baseUrl + "android/customerinfo";
  static final String orderPlaceEndpoint = baseUrl + "android/placeorder";
  static final String myOrdersEndpoint = baseUrl + "android/customerorderlist";
  static final String userSignUpEndpoint = baseUrl + "android/sign_up";
  static final String passwordRecoveryEndpoint =
      baseUrl + "android/forgot_password";
  static final String userProfileUpdateEndpoint =
      baseUrl + "android/updateprofile";

  static final String myReservationEndpoint = baseUrl + "android/myreservation";
  static final String tableInfoEndpoint = baseUrl + "android/reservation";
  static final String tableBookingEndpoint = baseUrl + "android/booking";

  static final String foodProductItemOfferListEndpoint =
      baseUrl + "android/offeritem";
}
