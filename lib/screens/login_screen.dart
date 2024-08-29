import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  var userIdController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ResponsiveRowColumn(
            rowMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                columnFlex: 1,
                child: SizedBox(
                  width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                      ? double.infinity
                      : 400,
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          label: "User ID",
                          controller: userIdController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Password",
                          controller: passwordController,
                          obscureText: true,
                          isPasswordField: true,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                            label: "Login",
                            onPressed: () {
                              if (loginFormKey.currentState!.validate()) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
