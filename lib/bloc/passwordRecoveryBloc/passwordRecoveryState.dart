
import 'package:meta/meta.dart';

abstract class PasswordRecoveryState {
  const PasswordRecoveryState();

  // @override
  // List<Object> get props => [];
}

//login nitial state
class PasswordRecoveryInitialState extends PasswordRecoveryState {}

//login in progress
class PasswordRecoveryInProgress extends PasswordRecoveryState {}

class PasswordRecoverySuccessAndGoToLoginScreen extends PasswordRecoveryState {}

class PasswordRecoveryInSuccess extends PasswordRecoveryState {
  final String message;
  PasswordRecoveryInSuccess({this.message});
}

//on any type of log in error
class PasswordRecoveryFailure extends PasswordRecoveryState {
  final String error;

  const PasswordRecoveryFailure({@required this.error});

  @override
  String toString() => 'Password Recovery {error": $error}';
}
