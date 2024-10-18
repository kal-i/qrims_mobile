import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/app_router.dart';
import 'config/sizing/sizing_config.dart';
import 'config/themes/bloc/theme_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/components/custom_auth_password_text_box/bloc/custom_auth_password_text_box_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizingConfig().init(constraints);

        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>(
              create: (_) => ThemeBloc()..add(SetInitialTheme()),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => serviceLocator<AuthBloc>(),
            ),
            BlocProvider<CustomAuthPasswordTextBoxBloc>(
              create: (_) => CustomAuthPasswordTextBoxBloc(),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, state) {
              return MaterialApp.router(
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                theme: state,
                routerConfig: AppRoutingConfig.router,
              );
            },
          ),
        );
      },
    );
  }
}
