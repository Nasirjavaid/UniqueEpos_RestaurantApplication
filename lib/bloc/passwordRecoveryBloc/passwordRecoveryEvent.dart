
abstract class PasswordRecoveryEvent  {
  const PasswordRecoveryEvent();
}

class PasswordRecoveryButtonPressed extends PasswordRecoveryEvent {
  
  final String customerEmail;


  const PasswordRecoveryButtonPressed(
     this.customerEmail);

  // @override
  // List<Object> get props => [];

  @override
  String toString() =>
      'PasswordRecoveryButtonPressed with credentials { username:$customerEmail  password:  }';
}
