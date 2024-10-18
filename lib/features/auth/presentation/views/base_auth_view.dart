import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../config/sizing/sizing_config.dart';
import '../bloc/auth_bloc.dart';

class BaseAuthView extends StatelessWidget {
  const BaseAuthView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: _BaseAuthViewContent(
        content: child,
      ),
    );
  }
}

class _BaseAuthViewContent extends StatelessWidget {
  const _BaseAuthViewContent({
    super.key,
    required this.content,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizingConfig.widthMultiplier * 4.4,
            vertical: SizingConfig.heightMultiplier * 2.4,
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ModalProgressHUD(
                      inAsyncCall: state is AuthLoading,
                      child: content,
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
