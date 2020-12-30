import 'package:retaurant_app/model/foodProduct.dart';

abstract class DashboardSate {
  const DashboardSate();
}

class InitialDashboardState extends DashboardSate {}

class FetchingDashboadDataInProgressDashboardState extends DashboardSate {}

class FetchedDashboadDataSuccessfulyDashboardState extends DashboardSate {
  final FoodProduct foodProduct;
  FetchedDashboadDataSuccessfulyDashboardState({this.foodProduct});
}

class FailedToFetchDashboadDataDashboardState extends DashboardSate {}
