import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/home.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:national_lawyer_assistant/utils/create_route.dart';
import 'package:national_lawyer_assistant/Screens/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../signup/ui/verify_email.dart';
import '../../Login/ui/login.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc splashScreenBloc = SplashScreenBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreenBloc
        .add(SplashScreenInitalEvent(splashScreenBloc: splashScreenBloc));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      bloc: splashScreenBloc,
      listenWhen: (previous, current) => current is SplashScreenActionState,
      buildWhen: (previous, current) => current is! SplashScreenActionState,
      listener: (context, state) {
        if (state is SplashScreenToHome) {
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => const HomePage()));
          Navigator.of(context)
              .pushReplacement(createPopupRoute(redirectedPage: HomeScreen()));
        } else if (state is SplashScreenToLogin) {
          Navigator.of(context).pushReplacement(
              createPopupRoute(redirectedPage: LoginPage(), duration: 1000));
        } else if (state is SplashScreenToVerifyEmail) {
          Navigator.of(context).pushReplacement(
              createPopupRoute(redirectedPage: VerifyEmailPage()));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case SplashScreenLoading:
            return Scaffold(
              backgroundColor: primary,
              body: Column(
                children: [
                  Spacer(), // Pushes the content below to the center of the screen
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/ChatBotLogo.png',
                              fit: BoxFit
                                  .cover, // Ensures the image fits inside the container
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Shimmer.fromColors(
                            direction: ShimmerDirection.ltr,
                            baseColor: onSecondary,
                            highlightColor: purple200,
                            child: Text(
                              'National Lawyer Assistant',
                              style: TextStyle(
                                color: onSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(), // Pushes the content above to the center of the screen
                  Center(
                    child: IntrinsicWidth(
                      child: ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.circular(10), // Rounded edges
                            color: onSecondary,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/LogixosLogo.png',
                              fit: BoxFit
                                  .cover, // Ensures the image fits inside the container
                            ),
                          ),
                        ),
                        title: Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: onSecondary,
                          highlightColor: purple400,
                          child: Text(
                            'Powered by',
                            style: TextStyle(
                              color: onSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        subtitle: Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: onSecondary,
                          highlightColor: purple400,
                          child: Text(
                            'LOGIXOS TECH',
                            style: TextStyle(
                              color: onSecondary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          20), // Adds some space at the bottom of the screen
                ],
              ),
            );

          default:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: purple500,
                  strokeWidth: 5,
                ),
              ),
            );
        }
      },
    );
  }
}
