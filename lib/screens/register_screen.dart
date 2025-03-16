import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:user_subscription_management/screens/login_screen.dart";

import "../components/rounded_floating_action_button.dart";
import "../controllers/profile_controller.dart";
import "../utils/colors_util.dart";
import "../utils/screen_util.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> showConfirmPassword = ValueNotifier<bool>(true);

  late String email;
  late String password;
  late String confirm_password;
  late AnimationController _animationController;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;


  final profileController = ProfileController();


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();


    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
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

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Confirm password is required';
      });
    } else if (value.length < 8 || value.length > 15) {
      setState(() {
        _confirmPasswordError = 'Password must be between 8 and 15 digits long';
      });
    } else if(value != password){
      _confirmPasswordError = "Both password must match";
    }
    else {
      setState(() {
        _confirmPasswordError = null;
      });
    }
  }


  bool _validateInput() {
    _validateEmail(emailController.text);
    _validatePassword(passwordController.text);
    _validateConfirmPassword(confirmPasswordController.text);

    return _emailError == null && _passwordError == null && _confirmPasswordError == null;
  }

  void _handleRegister() async {
    setState(() {
      _isLoading = true;  // Set loading state to true
    });

    print("Email: "+email);
    print("Password: "+password);


    if (_validateInput()) {
      await profileController.register(context, email, password);
    }

    setState(() {
      _isLoading = false;  // Set loading state to false
    });

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
                                        "Create a new",
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
                                                          FocusScope.of(context)
                                                              .requestFocus(confirmPasswordNode);
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
                                        padding: EdgeInsets.only(
                                            top: screenSize.height * 0.02,
                                            left: screenSize.width * 0.05,
                                            right: screenSize.width * 0.05,
                                            bottom: screenSize.height * 0.006),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: showConfirmPassword,
                                              builder: (context, value, child) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller: confirmPasswordController,
                                                        focusNode: confirmPasswordNode,
                                                        cursorColor: ColorConverter.blue,
                                                        cursorErrorColor: Colors.red,
                                                        obscureText: showConfirmPassword.value,
                                                        decoration: InputDecoration(
                                                          hintText: "Enter your confirm password",
                                                          prefixIcon: Icon(Icons.password,
                                                              color: ColorConverter.blue,
                                                              size: 23),
                                                          suffixIcon: InkWell(
                                                            child: Icon(
                                                                showConfirmPassword.value
                                                                    ? Icons.visibility
                                                                    : Icons.visibility_off,
                                                                color: ColorConverter.blue,
                                                                size: 23),
                                                            onTap: () {
                                                              showConfirmPassword.value =
                                                              !showConfirmPassword.value;
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
                                                          confirmPasswordController.text = value;
                                                          confirm_password = confirmPasswordController.text;
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
                                            if (_confirmPasswordError != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  _confirmPasswordError!,
                                                  style: const TextStyle(color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: screenSize.height * 0.05),
                                      RoundedFloatingActionButton(
                                        function: _handleRegister, // Use the new method,
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
                                          "Register",
                                          style: TextStyle(color: Colors.white, fontSize: 17),
                                        ),
                                      ),
                                      SizedBox(height: screenSize.height * 0.014),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) => const LoginScreen(), // Replace with your login screen
                                              ),
                                                  (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                                text: "Already have an account ? ",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: "Log In",
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
