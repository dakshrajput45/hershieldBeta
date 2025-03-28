import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/Router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/helper/log.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late TabController tabController =
      TabController(length: 1, vsync: this, initialIndex: 0);
  final _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  bool isResendButtonEnabled = true;
  String? _errorMessage;
  Timer? _timer;
  int _resendOtpSecondsRemaining = 60;
  bool _isLoading = false;
  String _verificationId = "";

  @override
  void initState() {
    _phoneController.addListener(() {
      if (_phoneController.text.trim().length == 10 ||
          RegExp(r'^[6-9]\d{9}$').hasMatch(_phoneController.text.trim())) {
        setState(() {
          isButtonEnabled = true;
        });
      } else {
        setState(() {
          isButtonEnabled = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _phoneController.dispose();
    _otpController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Tab(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 580),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logoShield.png',
                                height: 200,
                              ),
                              Text(
                                "Welcome to HerShield",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Help is just a moment away!!",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          // Google Sign Up Function Added here (Same function used for Log In)
                                          User? userGoogle = await HSUserAuthSDK
                                              .googleSignUp();

                                          if (userGoogle == null) {
                                            hsLog("Google Login Failed");
                                            return;
                                          }
                                          hsLog(
                                              "####### Google Login Succesfully and Updating userData #####");
                                          context.goNamed(RouteNames.sos);
                                        },
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FaIcon(FontAwesomeIcons.google,
                                                size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              "Sign in with Google",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
          // Tab(
          //   child: Center(
          //     child: Container(
          //       constraints: const BoxConstraints(maxWidth: 600),
          //       padding: const EdgeInsets.all(32),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: SingleChildScrollView(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "OTP has been sent to ${_phoneController.value.text.trim()}!",
          //               style: Theme.of(context).textTheme.titleLarge,
          //               textAlign: TextAlign.left,
          //             ),
          //             const SizedBox(height: 12),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 2, vertical: 10.0),
          //               child: TextField(
          //                 controller: _otpController,
          //                 obscureText: true,
          //                 maxLength: 6,
          //                 inputFormatters: [
          //                   FilteringTextInputFormatter.digitsOnly
          //                 ],
          //                 keyboardType: TextInputType.number,
          //                 decoration: const InputDecoration(
          //                     contentPadding: EdgeInsets.symmetric(
          //                         horizontal: 16.0, vertical: 2)),
          //               ),
          //             ),
          //             const SizedBox(height: 8),
          //             if (_errorMessage != null) ...[
          //               Text(
          //                 _errorMessage!,
          //                 style: TextStyle(
          //                     color: Theme.of(context).colorScheme.error),
          //               ),
          //               const SizedBox(height: 12),
          //             ],
          //             Wrap(
          //               alignment: WrapAlignment.spaceBetween,
          //               runSpacing: 8,
          //               spacing: 8,
          //               children: [
          //                 RichText(
          //                   text: TextSpan(
          //                     children: [
          //                       TextSpan(
          //                         text: "Edit Number",
          //                         recognizer: TapGestureRecognizer()
          //                           ..onTap = () {
          //                             tabController.animateTo(0,
          //                                 duration: const Duration(
          //                                     milliseconds: 200));
          //                           },
          //                         style: TextStyle(
          //                           color:
          //                               Theme.of(context).colorScheme.primary,
          //                           decoration: TextDecoration.underline,
          //                         ),
          //                       ),
          //                     ],
          //                     style: Theme.of(context).textTheme.bodyLarge,
          //                   ),
          //                 ),
          //                 RichText(
          //                   text: TextSpan(
          //                     children: [
          //                       TextSpan(
          //                         text: isResendButtonEnabled
          //                             ? "Resend OTP"
          //                             : "Resend in 0:$_resendOtpSecondsRemaining",
          //                         recognizer: TapGestureRecognizer()
          //                           ..onTap = () {
          //                             setState(() {
          //                               _startResendOtpTimer();
          //                             });
          //                           },
          //                         style: TextStyle(
          //                           color: isResendButtonEnabled
          //                               ? Theme.of(context)
          //                                   .colorScheme
          //                                   .secondary
          //                               : Theme.of(context)
          //                                   .colorScheme
          //                                   .onSurface,
          //                           decoration: TextDecoration.underline,
          //                         ),
          //                       ),
          //                     ],
          //                     style: Theme.of(context).textTheme.bodyLarge,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 10),
          //             Row(
          //               children: [
          //                 Expanded(
          //                   child: ElevatedButton(
          //                     onPressed: () async {
          //                       // Dummy validation
          //                       if (_otpController.value.text == "123456" ||
          //                           _otpController.value.text ==
          //                               _verificationId) {
          //                         _errorMessage = null;

          //                         context.goNamed(RouteNames.sos);
          //                         // Proceed to the next screen or home page
          //                       } else if (_verificationId != "") {
          //                         try {
          //                           PhoneAuthCredential credential =
          //                               PhoneAuthProvider.credential(
          //                             verificationId: _verificationId,
          //                             smsCode: _otpController.value.text,
          //                           );
          //                           await FirebaseAuth.instance
          //                               .signInWithCredential(credential);
          //                           _errorMessage = null;

          //                           context.goNamed(RouteNames.sos);
          //                           hsLog("User signed in successfully");
          //                         } catch (e) {
          //                           hsLog("Failed to sign in: $e");
          //                         }
          //                       } else {
          //                         _errorMessage =
          //                             'Invalid OTP. Please try again.';
          //                       }
          //                     },
          //                     child: const Text("Verify OTP"),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // void _startResendOtpTimer() {
  //   setState(() {
  //     _resendOtpSecondsRemaining = 60;
  //     isResendButtonEnabled = false;
  //   });

  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (!mounted) return;
  //     setState(() {
  //       if (_resendOtpSecondsRemaining > 0) {
  //         _resendOtpSecondsRemaining--;
  //       } else {
  //         isResendButtonEnabled = true;
  //         _timer?.cancel();
  //       }
  //     });
  //   });
  // }
}
