import 'login_page.dart';
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
import '../../data/dto/register_dto.dart';
import '../bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = 'register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  bool isPasswordVisible = false;

  @override
  dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  _clear() {
    _emailCtrl.clear();
    _nameCtrl.clear();
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
              context.goNamed(LoginPage.routeName);
              return CustomSnackbar.success(context, AppString.registerSuccess);
            }

            if (state is AuthErrorState) {
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
                  key: _registerFormKey,
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
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        hintText: AppString.name,
                        validator: (val) => Validation.isEmpty(val),
                      ),

                      VSpace(15),

                      CustomTextfieldWidget(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        hintText: AppString.email,
                        validator: (val) => Validation.email(val),
                      ),

                      VSpace(15),

                      CustomTextfieldWidget(
                        controller: _passwordCtrl,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppString.password,
                        validator: (val) => Validation.password(val),
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
                            if (_registerFormKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthRegisterEvent(
                                  req: RegisterDTO(
                                    name: _nameCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    password: _passwordCtrl.text.trim(),
                                  ),
                                ),
                              );
                            }
                          },
                          text: AppString.register,
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
