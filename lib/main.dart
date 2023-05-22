import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecureApplication(
        nativeRemoveDelay: 1000,
        onNeedUnlock: (secure) async {
          print(
              'need unlock maybe use biometric to confirm and then sercure.unlock() or you can use the lockedBuilder');
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
          child: Builder(builder: (context) {
            var secureController = SecureApplicationProvider.of(context);
            secureController?.secure();

            return const MyHomePage();
          }),
        ),
      ),
    );
  }
}
