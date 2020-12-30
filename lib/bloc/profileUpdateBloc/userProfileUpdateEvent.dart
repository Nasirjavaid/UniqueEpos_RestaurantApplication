import 'dart:io';

abstract class UserProfileUpdateEvent {
  const UserProfileUpdateEvent();
}

class UserProfileUpdateButtonPressed extends UserProfileUpdateEvent {
  final String userId;
  final String name;
  final String email;
  final String oldPassword;
  final String newPassword;
  final String phone;
  final String address;
  final File profilePicturePath;

  const UserProfileUpdateButtonPressed(this.userId, this.name, this.email,
      this.oldPassword,this.newPassword, this.phone, this.address,this.profilePicturePath);

  @override
  String toString() =>
      'Update ButtonPressed with credentials { username:  password:  }';
}

class UserProfileUpdateGetUserDataFromSharedPrefrences
    extends UserProfileUpdateEvent {}
