import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileState.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  @override
  UserProfileState get initialState => InitialUserProfileState();

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is GetUserDataUserProfileEvent) {
      yield InProgresssGettingUserProfileState();
      UserAuthRepository userAuthRepository = UserAuthRepository();
      UserLogin userLogin = UserLogin();
      userLogin = await userAuthRepository.getUserDataFromSharedPrefrences();

      if (userLogin != null) {
        yield UserProfiledetailTakenSuccessfully(userLogin: userLogin);
      } else {
        yield FailedTogetUserProfileData(
            error: "User Profile bloc : unable to get user profile data data");
      }
    } else {
      yield FailedTogetUserProfileData(
          error: "User Profile bloc : unable to get user profile data data");
    }
  }
}
