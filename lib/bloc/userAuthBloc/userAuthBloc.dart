import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthState.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/repository/foodProductRepository.dart';

import 'package:retaurant_app/repository/userAuthRepository.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  @override
  //Starting with initial state of Auththentication
  UserAuthState get initialState => AuthInitial();

  //Refrence to UserAuthRepository
  final UserAuthRepository userAuthRepository;

  //Check for the  UserAuthRepository if null or not /// assert key word used for this purpose
  UserAuthBloc({@required this.userAuthRepository});
  FoodProductRepository foodProductRepository = new FoodProductRepository();
  FoodProduct settings = new FoodProduct();
  // Mapping Events with state
  @override
  Stream<UserAuthState> mapEventToState(UserAuthEvent event) async* {
    //check if Authentication is confirmed from repostory
    if (event is AuthStarted) {

//get Settings on Authentication
      settings = await foodProductRepository.getFoodProduct();
      Methods.storeSettingsTosharedPrefrences(settings);

      final bool hassToken = await userAuthRepository.hasToken();

      // if token exists then return Login in success
      if (hassToken) {
        await Future.delayed(Duration(milliseconds: 500));
        yield AuthSuccess();
      } else {
        // if token doens not exist then return Login in  failure
        await Future.delayed(Duration(milliseconds: 500));
        yield AuthFailure();
      }
    }

    //Check if user token already exists then move to Dashboard
    if (event is AuthLoggedIn) {
      yield AuthInProgress();
      await Future.delayed(Duration(milliseconds: 500));

      await userAuthRepository.persistToken(event.userLogin);

      yield AuthSuccess();
    }
    //Check if user token does not exist then move to Login Screen
    if (event is AuthLoggedOut) {
      yield AuthInProgress();
      await Future.delayed(Duration(milliseconds: 500));
      await userAuthRepository.deleteToken();

      yield AuthFailure();
    }
  }
}
