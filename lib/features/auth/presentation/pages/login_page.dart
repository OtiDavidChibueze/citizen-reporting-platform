import '../../data/dto/login_dto.dart';
import 'register_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/theme/app_colors.dart';
import '../../../../core/common/widgets/custom_button_widget.dart';
import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../core/constants/app_image_urls.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/utils/custom_dialog_loader.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/utils/validations/validation.dart';
import '../bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool isPasswordVisible = false;

  @override
  dispose() {
    _emailCtrl.dispose();

    _passwordCtrl.dispose();
    super.dispose();
  }

  _clear() {
    _emailCtrl.clear();
    _passwordCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoadingState) {
              return CustomDialogLoader.show(context);
            }

            if (state is AuthSuccessState) {
              _clear();
              CustomDialogLoader.cancel(context);
              return CustomSnackbar.info(context, AppString.loginSuccess);
            }

            if (state is AuthErrorState) {
              _clear();
              CustomDialogLoader.cancel(context);
              return CustomSnackbar.error(context, state.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(16)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      VSpace(30),

                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.white, blurRadius: 30),
                              BoxShadow(color: AppColors.white, blurRadius: 15),
                            ],
                          ),
                          child: Image.asset(
                            AppImageUrls.logo,
                            fit: BoxFit.cover,
                            height: h(200),
                          ),
                        ),
                      ),

                      VSpace(50),

                      CustomTextfieldWidget(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        hintText: AppString.email,
                        validator: (val) => Validation.isEmpty(val),
                      ),

                      VSpace(15),

                      CustomTextfieldWidget(
                        controller: _passwordCtrl,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppString.password,
                        validator: (val) => Validation.isEmpty(val),
                        obscureText: !isPasswordVisible,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isPasswordVisible
                                ? AppColors.borderColor
                                : AppColors.white,
                          ),
                        ),
                      ),

                      VSpace(20),

                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              context.pushNamed(RegisterPage.routeName),

                          child: RichText(
                            text: TextSpan(
                              text: AppString.dontHaveAccount,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: sp(13),
                              ),
                              children: [
                                TextSpan(
                                  text: AppString.register,
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: sp(15),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      VSpace(50),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sr(20)),
                          boxShadow: [
                            BoxShadow(color: AppColors.white, blurRadius: 20),
                            BoxShadow(color: AppColors.white, blurRadius: 10),
                          ],
                        ),
                        child: CustomButtonWidget(
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthLoginEvent(
                                  req: LoginDto(
                                    email: _emailCtrl.text,
                                    password: _passwordCtrl.text,
                                  ),
                                ),
                              );
                            }
                          },
                          text: AppString.login,
                          horizontal: w(100),
                          vertical: h(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
