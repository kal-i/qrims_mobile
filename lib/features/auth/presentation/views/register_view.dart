import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../core/common/components/custom_loading_filled_button.dart';
import '../../../../core/utils/delightful_toast_utils.dart';
import '../components/custom_auth_password_text_box/custom_auth_password_text_box.dart';
import '../../../../core/common/components/custom_text_box.dart';
import '../components/custom_email_text_box.dart';
import '../../../../config/themes/app_color.dart';
import '../bloc/auth_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegister(
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoading) {
          _isLoading.value = true;
        }

        if (state is AuthFailure) {
          _isLoading.value = false;
          DelightfulToastUtils.showDelightfulToast(
            context: context,
            icon: Icons.error_outline,
            title: 'Error',
            subtitle: state.message,
          );
        }

        if (state is AuthSuccess) {
          _isLoading.value = false;
          DelightfulToastUtils.showDelightfulToast(
            context: context,
            icon: Icons.check_circle_outline,
            title: 'Success',
            subtitle:
                'You have registered successfully. Please verify your email.',
          );
          await Future.delayed(const Duration(seconds: 3));
          context.go(RoutingConstants.loginViewRoutePath);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildForm(),
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * 2.0,
          ),
          CustomLoadingFilledButton(
            onTap: () => _register(),
            text: 'Sign up',
            isLoadingNotifier: _isLoading,
            height: SizingConfig.heightMultiplier * 6,
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * 2.0,
          ),
          _buildNavigationActionRow(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sign up.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormHeader(),
          SizedBox(
            height: SizingConfig.heightMultiplier * 1.0,
          ),
          CustomTextBox(
            height: SizingConfig.heightMultiplier * 12,
            controller: _nameController,
            placeHolderText: 'name',
            prefixIcon: HugeIcons.strokeRoundedUser,
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * 1.0,
          ),
          CustomEmailTextBox(
            controller: _emailController,
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * 1.0,
          ),
          CustomAuthPasswordTextBox(
            placeHolderText: 'password',
            controller: _passwordController,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => context.go(RoutingConstants.loginViewRoutePath),
          child: Text(
            'Sign in',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColor.darkHighlightedText,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
