import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:user_subscription_management/screens/register_screen.dart";
import "package:user_subscription_management/utils/screen_util.dart";

import "../components/rounded_floating_action_button.dart";
import "../controllers/profile_controller.dart";
import "../utils/colors_util.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  late String email;
  late String password;
  ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  final profileController = ProfileController();

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    print("Email: "+email);
    print("Password: "+password);

    if (_validateInput()) {
      await profileController.login(context, email, password);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
  }

  void _validateEmail(String value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (value.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!emailRegex.hasMatch(value)) {
      setState(() {
        _emailError = 'Enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }


  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else if (value.length < 8 || value.length > 15) {
      setState(() {
        _passwordError = 'Password must be between 8 and 15 digits long';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }


  bool _validateInput() {
    _validateEmail(emailController.text);
    _validatePassword(passwordController.text);

    return _emailError == null && _passwordError == null;
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);
    return Scaffold(
      backgroundColor: ColorConverter.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.13),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.subscriptions, color: ColorConverter.blue,size: 30,),
                  SizedBox(width: screenSize.width * 0.03,),
                  Text("SubscriEase",  style: TextStyle(
                      color: ColorConverter.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 35
                  ),),
                ],
              ),
              SizedBox(height: screenSize.height * 0.03,),
          Padding(
            padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
            child: Container(
              height: (_emailError != null && _passwordError != null) ? screenSize.height * 0.66 : screenSize.height * 0.63,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * (30 / 375)),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.01),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: screenSize.height * 0.03),
                              const Text(
                                "Sign in to your",
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Account",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.03),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.03,
                                    left: screenSize.width * 0.05,
                                    right: screenSize.width * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: emailController,
                                            focusNode: emailNode,
                                            cursorColor: ColorConverter.blue,
                                            cursorErrorColor: Colors.red,
                                            decoration: InputDecoration(
                                              hintText: "Enter your email",
                                              prefixIcon: Icon(Icons.person,
                                                  color: ColorConverter.blue,
                                                  size: 23),
                                              enabledBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            onChanged: _validateEmail,
                                            onFieldSubmitted: (value) {
                                              emailController.text = value;
                                              email = emailController.text;
                                              FocusScope.of(context)
                                                  .requestFocus(passwordNode);
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(25),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_emailError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _emailError!,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.02,
                                    left: screenSize.width * 0.05,
                                    right: screenSize.width * 0.05,
                                    bottom: screenSize.height * 0.006),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: showPassword,
                                      builder: (context, value, child) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: passwordController,
                                                focusNode: passwordNode,
                                                cursorColor: ColorConverter.blue,
                                                cursorErrorColor: Colors.red,
                                                obscureText: showPassword.value,
                                                decoration: InputDecoration(
                                                  hintText: "Enter your password",
                                                  prefixIcon: Icon(Icons.password,
                                                      color: ColorConverter.blue,
                                                      size: 23),
                                                  suffixIcon: InkWell(
                                                    child: Icon(
                                                        showPassword.value
                                                            ? Icons.visibility
                                                            : Icons.visibility_off,
                                                        color: ColorConverter.blue,
                                                        size: 23),
                                                    onTap: () {
                                                      showPassword.value =
                                                      !showPassword.value;
                                                    },
                                                  ),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                onChanged: _validatePassword,
                                                onFieldSubmitted: (value) {
                                                  passwordController.text = value;
                                                  password = passwordController.text;
                                                },
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(15),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    if (_passwordError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _passwordError!,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: screenSize.width * 0.45),
                                child: TextButton(
                                  onPressed: () {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const ForgotPassword(),
                                    //   ),
                                    // );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.009),
                              RoundedFloatingActionButton(
                                function: _handleLogin, // Use the new method,
                                width: screenSize.width * 0.6,
                                height: screenSize.height * 0.05,
                                buttonColor: ColorConverter.blue,
                                child: _isLoading
                                    ? SizedBox(
                                  width: screenSize.width * 0.05, // Adjust width
                                  height: screenSize.height * 0.025, // Adjust height
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2, // Adjust thickness of the spinner
                                  ),
                                )
                                    : const Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.014),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterScreen(), // Replace with your login screen
                                      ),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Don't have an account ? ",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Sign Up",
                                              style: TextStyle(
                                                  color: ColorConverter.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                  )),

                              InkWell(
                                  onTap: () {
                                    // Navigator.of(context).pushAndRemoveUntil(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const ContactUsScreen(), // Replace with your login screen
                                    //   ),
                                    //       (Route<dynamic> route) => false,
                                    // );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Need Help ? ",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Contact Us",
                                              style: TextStyle(
                                                  color: ColorConverter.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                  )),
                              SizedBox(height: screenSize.height * 0.02,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ),
          ]),
        ),
      ),
    );
  }
}
