import 'package:retaurant_app/model/tableBookingModel.dart';
import 'package:retaurant_app/model/tableInfoModel.dart';
import 'package:retaurant_app/service/tableInfoService.dart';

class TableInfoRepository {
  TableInfoService tableInfoService = TableInfoService();
  Future<TableInfoModel> getTableInfo(
    String person,
    String reserveDate,
    String reserveTime,
  ) async {
    TableInfoModel tableInfoModel = await tableInfoService.getTableInfo(
      person,
      reserveDate,
      reserveTime,
    );

    return tableInfoModel;
  }

  Future<TableBookingModel> bookNewTable(
    String customerId,
  String person,
  String reserveDate,
  String reserveTime,
  String endTime,
 String name,
  String phone,
   String tableId,
  String email,
  String customerNote
  ) async {
    TableBookingModel tableBookingModel = await tableInfoService.bookNewTable(
      customerId,
      person,
      reserveDate,
      reserveTime,
      endTime,
      name,
      phone,
      tableId,email,
       customerNote
    );

    return tableBookingModel;
  }
}
