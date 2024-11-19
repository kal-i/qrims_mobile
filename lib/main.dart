import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/routes/app_router.dart';
import 'config/sizing/sizing_config.dart';
import 'config/themes/bloc/theme_bloc.dart';
import 'core/features/issuance/presentation/bloc/issuances_bloc.dart';
import 'core/features/purchase_request/presentation/bloc/bloc/purchase_requests_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/components/custom_auth_password_text_box/bloc/custom_auth_password_text_box_bloc.dart';

import 'features/item/presentation/bloc/item_bloc.dart';
import 'features/notification/presentation/bloc/notifications_bloc.dart';
import 'injection_container.dart';

Future<void> main() async {
  await dotenv.load(); // by default , this loads the .env file
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
            BlocProvider<PurchaseRequestsBloc>(
              create: (_) => serviceLocator<PurchaseRequestsBloc>(),
            ),
            BlocProvider<IssuancesBloc>(
              create: (_) => serviceLocator<IssuancesBloc>(),
            ),
            BlocProvider<ItemBloc>(
              create: (_) => serviceLocator<ItemBloc>(),
            ),
            BlocProvider<NotificationsBloc>(
              create: (_) => serviceLocator<NotificationsBloc>(),
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
