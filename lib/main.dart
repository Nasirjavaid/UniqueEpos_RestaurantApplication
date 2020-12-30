import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:retaurant_app/ui/Containers/MainHomeContainer/mainHomeContainer.dart';

import 'package:retaurant_app/ui/Screen/LoginScreen/loginScreen.dart';
import 'package:retaurant_app/ui/Screen/NetworkFailureScreen/networkFailureScreen.dart';
import 'package:retaurant_app/ui/Screen/SplashScreen/spalshScreen.dart';



class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserAuthRepository();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MultiBlocProvider(
          providers: [
            BlocProvider<CartBloc>(
              create: (context) => CartBloc(),
            ),
            BlocProvider<UserAuthBloc>(
              create: (context) {
                return UserAuthBloc(userAuthRepository: userRepository)
                  ..add(AuthStarted());
              },
            ),
          ],
          child: App(
            userRepository: userRepository,
          ))));
}

class App extends StatefulWidget {
  final UserAuthRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool networkCheck = false;

  @override
  void initState() {
    NetworkConnectivity.check().then((internet) {
      if (internet) {
        setState(() {
          networkCheck = true;
        });
      } else {
        //show network erro

        setState(() {
          networkCheck = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: networkCheck
          ? BlocBuilder<UserAuthBloc, UserAuthState>(
              builder: (context, state) {
                if (state is AuthInitial) {
                  return SplashScreen();
                }

                if (state is AuthInProgress) {
                  return LoadingIndicator();
                }

                if (state is AuthSuccess) {
                  return HomeCintainer();
                }

                if (state is AuthFailure) {
                  return LoginPage(userAuthRepository: widget.userRepository);
                }

                return Container();
              },
            )
          : NetworkFauilureScreen(
              contextA: context,
            ),
    );
  }
}
