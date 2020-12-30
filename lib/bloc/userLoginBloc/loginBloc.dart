import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/bloc/userLoginBloc/loginState.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'loginEvent.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with ValidationMixin {
  //Repositiry to get User inforation
  final UserAuthRepository userAuthRepository;
  //User Auth block refrence to talk Bloc to Bloc
  final UserAuthBloc userAuthBloc;

  LoginBloc({@required this.userAuthRepository, @required this.userAuthBloc})
      : assert(userAuthRepository != null),
        assert(userAuthBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    if (event is LoginButtonPressed) {
      yield LoginInProgress();

      if (this.isFieldEmpty(event.userName)) {
        yield LoginFailure(error: "Please enter email address");
        return;
      } else if (!this.validateEmailAddress(event.userName)) {
        yield LoginFailure(error: "Please enter valid email address");
        return;
      } else if (this.isFieldEmpty(event.password)) {
        yield LoginFailure(error: "Please enter password");
        return;
      } else {
        try {
          UserLogin userLogin = UserLogin();
          userLogin = await userAuthRepository.authenticate(
              username: event.userName, password: event.password);

          if (userLogin.status == "failed" ||
              userLogin.status == "no_registered") {
            yield LoginFailure(error: "Wrong email or password.");
          } else if (userLogin.status == "success") {
            userAuthBloc.add(AuthLoggedIn(userLogin: userLogin));
          }

          yield LoginInitial();
        } catch (error) {
          yield LoginFailure(error: "Wrong email or password.");
        }
      }
    }
  }
}
