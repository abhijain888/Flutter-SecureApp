import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecureApplication(
        nativeRemoveDelay: 1000,
        onNeedUnlock: (secure) async {
          print(
              'need unlock maybe use biometric to confirm and then sercure.unlock() or you can use the lockedBuilder');

          bool authenticated = false;

          try {
            authenticated = await auth.authenticate(
              localizedReason: "Scan your finger to authenticate",

              // useErrorDialogs: true,
              // stickyAuth: true,
            );
          } on PlatformException catch (e) {
            print(e);
          }

          return authenticated
              ? SecureApplicationAuthenticationStatus.SUCCESS
              : SecureApplicationAuthenticationStatus.FAILED;

          // setState(() {
          //   authorized =
          //       authenticated ? "Authorized success" : "Failed to authenticate";
          //   print(authorized);
          // });

          // var authResult = authMyUser();
          // if (authResul) {
          //  secure.unlock();
          //  return SecureApplicationAuthenticationStatus.SUCCESS;
          //}
          // else {
          //  return SecureApplicationAuthenticationStatus.FAILED;
          //}
          return null;
        },
        onAuthenticationFailed: () async {
          // clean you data

          print('auth failed');
        },
        onAuthenticationSucceed: () async {
          // clean you data
        },
        child: SecureGate(
          blurr: 40,
          opacity: 0.6,
          lockedBuilder: (context, secureApplicationController) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('UNLOCK'),
                    onPressed: () =>
                        secureApplicationController?.authSuccess(unlock: true),
                  ),
                  ElevatedButton(
                    child: const Text('FAIL AUTHENTICATION'),
                    onPressed: () =>
                        secureApplicationController?.authFailed(unlock: false),
                  ),
                ],
              ),
            );
          },
          child: Builder(
            builder: (context) {
              var secureController = SecureApplicationProvider.of(context);
              secureController?.secure();
              return const MyHomePage();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",

        // useErrorDialogs: true,
        // stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      authorized =
          authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }
}
