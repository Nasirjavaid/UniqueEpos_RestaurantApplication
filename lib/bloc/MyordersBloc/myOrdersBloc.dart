import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/MyordersBloc/myOrdersEvent.dart';
import 'package:retaurant_app/bloc/MyordersBloc/myOrdersState.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/repository/myOrdersRepository.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersRepository myOrdersRepository = new MyOrdersRepository();

  @override
  MyOrdersState get initialState => MyOrdersStateInitialState();

  @override
  Stream<MyOrdersState> mapEventToState(MyOrdersEvent event) async* {
    try {
      if (event is MyOrdersEventFetched) {
        MyOrdersModel myOrdersModel = MyOrdersModel();
        myOrdersModel = await myOrdersRepository.getMyOrders();

        yield MyOrdersStateInProgressState();
        await Future.delayed(Duration(milliseconds: 500));

        if (myOrdersModel.data.orderinfo.length != 0) {
          yield MyOrdersStateSuccessState(myOrdersModel: myOrdersModel);
        } else {
          yield MyOrdersStateFailureState();
        }
      }
    } catch (ex) {
      print("Exception in My Orders Bloc $ex");
      yield MyOrdersStateFailureState();
    }
  }
}
