import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/routes/app_routing_constants.dart';
import '../../../../config/sizing/sizing_config.dart';
import '../../../../config/themes/app_color.dart';
import '../../../../config/themes/bloc/theme_bloc.dart';
import '../../../../core/common/components/custom_filled_button.dart';
import '../../../../core/common/components/custom_message_box.dart';
import '../../../../core/common/components/custom_outline_button.dart';
import '../../../../core/common/components/profile_container.dart';
import '../../../../core/models/user/mobile_user.dart';
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

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _uploadImage(String userId) async {
    // Request permission before picking an image
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        // get path of selected file
        final file = File(result.files.single.path!);

        // read file as bytes
        final bytes = await file.readAsBytes();

        // Convert bytes to Base64 string
        final base64String = base64Encode(bytes);

        // Print or use the Base64 string as needed
        print('Base64 String: $base64String');

        context.read<AuthBloc>().add(
          UpdateUserInfo(
            id: userId,
            profileImage: base64String,
          ),
        );
        //print('file: $file');
        //print('bytes: $bytes');
      }
    } else {
      print("Storage permission not granted");
    }
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoading) {
          _isLoading.value = true;
          _errorMessage = null;
        }

        if (state is Unauthenticated) {
          _isLoading.value = false;
          await Future.delayed(const Duration(seconds: 3));
          context.go(RoutingConstants.loginViewRoutePath);
        }

        if (state is UserInfoUpdated) {
          _isLoading.value = false;
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
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
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
      }),
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
                '${capitalizeWord(_user!.officerEntity.officeName)} - ${capitalizeWord(_user!.officerEntity.positionName)}',
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
            onTap: () => _uploadImage(_user!.id),
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
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return Row(
          children: [
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('authToken');
                context.read<AuthBloc>().add(AuthLogout(token: token!));
              },
              child: Row(
                children: [
                  if (isLoading)
                    SpinKitFadingCircle(
                      color: AppColor.accent,
                      size: SizingConfig.heightMultiplier * 2.0,
                    ),
                   // const SizedBox(width: 10.0,),
                  Text(
                    'Sign Out',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: SizingConfig.textMultiplier * 2.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
