import 'package:retaurant_app/model/myReservationModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/service/myReservationService.dart';

class MyReservationRepository {
  Future<MyReserveListModel> getMyReservationList() async {
    //custom delay
    // await Future.delayed(Duration(seconds: 1));

    MyReserveListModel myReserveListModel = MyReserveListModel();
    MyReservationService myReservationService = MyReservationService();

    UserAuthRepository userAuthRepository = new UserAuthRepository();
    UserLogin userLogin =
        await userAuthRepository.getUserDataFromSharedPrefrences();
    myReserveListModel = await myReservationService.getMyReservationList(
        0, 0, userLogin.data.customerId);
    
    if (myReserveListModel != null) {
      return myReserveListModel;
    }
    return null;
  }
}
