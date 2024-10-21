import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../config/themes/bloc/theme_bloc.dart';
import '../../../../core/common/components/custom_filled_button.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/custom_outline_button.dart';
import '../../../../core/common/components/profile_container.dart';
import '../../../../core/models/mobile_user.dart';
import '../../../../core/utils/capitalizer.dart';
import '../../../../core/utils/delightful_toast_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  MobileUserModel? _user;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _errorMessage = null;
        }

        if (state is UserInfoUpdated) {
          _errorMessage = null;
          _user = MobileUserModel.fromEntity(state.updatedUser);
          DelightfulToastUtils.showDelightfulToast(
            context: context,
            title: 'Success',
            subtitle: 'Updated',
          );
        }

        if (state is AuthFailure) {
          _errorMessage = state.message;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            _user = MobileUserModel.fromEntity(state.data);
          }

          if (state is UserInfoUpdated) {
            _user = MobileUserModel.fromEntity(state.updatedUser);
          }

          return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizingConfig.widthMultiplier * 5.0,
                    vertical: SizingConfig.heightMultiplier * 3.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileSection(),
                      SizedBox(
                        height: SizingConfig.heightMultiplier * 2.0,
                      ),
                      _buildProfileActionsRow(),
                      SizedBox(
                        height: SizingConfig.heightMultiplier * 2.0,
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                        thickness: 1.5,
                      ),
                      _buildThemePreference(),
                      _buildSignOut(),
                      if (_errorMessage != null)
                        Center(
                          child: CustomMessageBox.error(
                            message: _errorMessage!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
        }
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const ProfileContainer(
          size: 80.0,
        ),
        SizedBox(
          width: SizingConfig.widthMultiplier * 5.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                capitalizeWord(_user!.name),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: SizingConfig.heightMultiplier * 1.0,
              ),
              Text(
                '${_user.} - Supply Officer I',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomOutlineButton(
            text: 'Change Profile',
            height: SizingConfig.heightMultiplier * 6.0,
          ),
        ),
        SizedBox(
          width: SizingConfig.widthMultiplier * 3.0,
        ),
        Expanded(
          child: CustomFilledButton(
            text: 'Edit Information',
            height: SizingConfig.heightMultiplier * 6.0,
          ),
        ),
      ],
    );
  }

  final ValueNotifier<bool> _isDarkMode = ValueNotifier(false);

  Widget _buildThemePreference() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text(
            'Theme',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: SizingConfig.textMultiplier * 2.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          SizedBox(
            width: SizingConfig.widthMultiplier * 5.0,
          ),
          CupertinoSwitch(
            value: _isDarkMode.value,
            onChanged: (value) {
              _isDarkMode.value = value;
              context.read<ThemeBloc>().add(ToggleTheme());
            },
            activeColor: AppColor.darkSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOut() {
    return Row(
      children: [
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('authToken');
            context.read<AuthBloc>().add(AuthLogout(token: token!));
          },
          child: Text(
            'Sign Out',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: SizingConfig.textMultiplier * 2.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
