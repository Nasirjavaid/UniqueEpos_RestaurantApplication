import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/service/myOrdersService.dart';

class MyOrdersRepository {
  Future<MyOrdersModel> getMyOrders() async {
    //custom delay
    // await Future.delayed(Duration(seconds: 1));

    MyOrdersModel myOrdersModel = MyOrdersModel();
    MyOrdersService myOrdersService = MyOrdersService();

    UserAuthRepository userAuthRepository = new UserAuthRepository();
    UserLogin userLogin =
        await userAuthRepository.getUserDataFromSharedPrefrences();
    myOrdersModel =
        await myOrdersService.getMyOrders(0, 0, userLogin.data.customerId);

    if (myOrdersModel != null) {
      return myOrdersModel;
    }
    return null;
  }

  Future<MyOrdersModel> getMyOrderByOrderId(
      {String orderiD, String guestId}) async {
    //custom delay
    // await Future.delayed(Duration(seconds: 1));

    MyOrdersModel myOrdersModel = MyOrdersModel();
    MyOrdersService myOrdersService = MyOrdersService();

    UserAuthRepository userAuthRepository = new UserAuthRepository();
    UserLogin userLogin =
        await userAuthRepository.getUserDataFromSharedPrefrences();

    if (userLogin != null) {
      myOrdersModel =
          await myOrdersService.getMyOrders(0, 0, userLogin.data.customerId);

      for (int i = 0; i < myOrdersModel.data.orderinfo.length; i++) {
        if (myOrdersModel.data.orderinfo[i].saleinvoice.substring(2) ==
            orderiD) {
          List<Orderinfo> selectedOrderByOrderId = List<Orderinfo>();
          selectedOrderByOrderId.add(myOrdersModel.data.orderinfo[i]);

          myOrdersModel.data.orderinfo.clear();
          myOrdersModel.data.orderinfo = selectedOrderByOrderId;
        }
      }
    } else {
      myOrdersModel = await myOrdersService.getMyOrders(0, 0, guestId);

      for (int i = 0; i < myOrdersModel.data.orderinfo.length; i++) {
        if (myOrdersModel.data.orderinfo[i].saleinvoice.substring(2) ==
            orderiD) {
          List<Orderinfo> selectedOrderByOrderId = List<Orderinfo>();
          selectedOrderByOrderId.add(myOrdersModel.data.orderinfo[i]);

          myOrdersModel.data.orderinfo.clear();
          myOrdersModel.data.orderinfo = selectedOrderByOrderId;
        }
      }
    }

    if (myOrdersModel != null) {
      return myOrdersModel;
    }
    return null;
  }
}
