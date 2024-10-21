import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../core/common/components/custom_filled_button.dart';
import '../../../../core/common/components/custom_loading_filled_button.dart';
import '../../../../core/common/components/custom_outline_button.dart';
import '../../../../core/utils/delightful_toast_utils.dart';
import '../bloc/auth_bloc.dart';
import '../components/custom_auth_password_text_box/custom_auth_password_text_box.dart';
import '../../../../config/routes/app_routing_constants.dart';

class SetNewPasswordView extends StatefulWidget {
  const SetNewPasswordView({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<SetNewPasswordView> createState() => _SetNewPasswordViewState();
}

class _SetNewPasswordViewState extends State<SetNewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      /// need to trigger this first
      if (_passwordController.text != _confirmPasswordController.text) {
        DelightfulToastUtils.showDelightfulToast(
          context: context,
          icon: Icons.error_outline,
          title: 'Error',
          subtitle: 'Password and Confirm Password did not match.',
        );
      } else {
        context.read<AuthBloc>().add(
          AuthResetPassword(
              email: widget.email, password: _passwordController.text),
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isLoading.dispose();
    super.dispose();
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
            subtitle: 'Password updated successfully.',
          );
          await Future.delayed(const Duration(seconds: 3));
          context.go(RoutingConstants.loginViewRoutePath);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: _buildForm(),
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
          'Set up New Password.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: SizingConfig.heightMultiplier * 1.0,
        ),
        Text(
          'Please create a secure password.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
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
          CustomAuthPasswordTextBox(
            placeHolderText: 'password',
            controller: _passwordController,
          ),
          SizedBox(
            height: SizingConfig.heightMultiplier * 2.0,
          ),
          CustomAuthPasswordTextBox(
            placeHolderText: 'confirm password',
            controller: _confirmPasswordController,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActionRow() {
    return Row(
      children: [
        Expanded(
          child: CustomOutlineButton(
            onTap: () => context.go(RoutingConstants.loginViewRoutePath),
            text: 'Cancel',
            height: SizingConfig.heightMultiplier * 6,
          ),
        ),
        SizedBox(
          width: SizingConfig.heightMultiplier * 2.0,
        ),
        Expanded(
          child: CustomLoadingFilledButton(
            onTap: () => _changePassword(),
            text: 'Change Password',
            isLoadingNotifier: _isLoading,
            height: SizingConfig.heightMultiplier * 6,
          ),
        ),
      ],
    );
  }
}
