import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/passwordRecoveryBloc/passwordRecoveryEvent.dart';
import 'package:retaurant_app/bloc/passwordRecoveryBloc/passwordRecoveryState.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/model/passwordRecovery.dart';
import 'package:retaurant_app/repository/passwordRecoveryRepository.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState>
    with ValidationMixin {
  PasswordRecoveryRepository passwordRecoveryRepository =
      PasswordRecoveryRepository();

  PasswordRecovery passwordRecovery;
  @override
  PasswordRecoveryState get initialState => PasswordRecoveryInitialState();

  @override
  Stream<PasswordRecoveryState> mapEventToState(
      PasswordRecoveryEvent event) async* {
    if (event is PasswordRecoveryButtonPressed) {
      passwordRecovery = PasswordRecovery();
      if (this.isFieldEmpty(event.customerEmail)) {
        yield PasswordRecoveryFailure(
            error: "Please enter your email address.");
        return;
      } else if (!event.customerEmail.contains("@") ||
          !event.customerEmail.contains(".")) {
        yield PasswordRecoveryFailure(
            error: "Please enter valid email address.");
        return;
      } else {
        passwordRecovery = await passwordRecoveryRepository
            .sendPasswordToUserEmail(event.customerEmail);

        if (passwordRecovery.status == ("success")) {
          yield PasswordRecoveryInProgress();
          await Future.delayed(Duration(milliseconds: 500));
          yield PasswordRecoveryInSuccess(message: passwordRecovery.message);
          await Future.delayed(Duration(seconds: 2));
          yield PasswordRecoverySuccessAndGoToLoginScreen();
        } else if (passwordRecovery.status == ("failed")) {
          yield PasswordRecoveryInProgress();
          await Future.delayed(Duration(milliseconds: 500));
          yield PasswordRecoveryFailure(error: passwordRecovery.message);
        } else {
          yield PasswordRecoveryInProgress();
          await Future.delayed(Duration(milliseconds: 500));
          yield PasswordRecoveryFailure(error: "Something went wrong.");
        }
      }
    }
  }
}
