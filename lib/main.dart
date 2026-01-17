import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/services/notidication_service.dart';
import 'package:saved/features/agent_home/cubit/add_apartment_cubit.dart';
import 'package:saved/features/agent_home/cubit/agent_booking_requests_cubit.dart';
import 'package:saved/features/agent_home/cubit/apartment_form_cubit.dart';
import 'package:saved/features/agent_home/cubit/my_apartments_cubit.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';
import 'package:saved/features/auth/cubit/auth_cubit.dart';
import 'package:saved/features/auth/repository/auth_repository.dart';
import 'package:saved/features/profile/cubit/profile_cubit.dart';
import 'package:saved/features/profile/repository/profile_repository.dart';
import 'package:saved/features/register/cubit/register_cubit.dart';
import 'package:saved/features/register/repository/register_repository.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_cubit.dart';
import 'package:saved/features/renter_home/cubit/favorite_cubit.dart';
import 'package:saved/features/renter_home/cubit/my_bookings_cubit.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';
import 'package:saved/features/renter_home/cubit/booking_cubit.dart';
import 'package:saved/features/chat/cubit/chat_cubit.dart';
import 'package:saved/features/chat/repository/chat_repository.dart';
import 'package:saved/features/notifications/cubit/notification_cubit.dart';
import 'package:saved/features/notifications/repository/notification_repository.dart';
import 'package:saved/features/renter_home/cubit/filter_cubit.dart';
import 'package:saved/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessaginhBackgroundHandler,
  );

  await NotificationService.initializeNotification();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => RegisterRepository()),
        RepositoryProvider(create: (context) => AgentRepository()),
        RepositoryProvider(create: (context) => RenterRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => ChatRepository()),
        RepositoryProvider(create: (context) => NotificationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                RegisterCubit(context.read<RegisterRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                MyApartmentsCubit(context.read<AgentRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                AllApartmentsCubit(context.read<RenterRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                AddApartmentCubit(context.read<AgentRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                ApartmentFormCubit(context.read<AgentRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(),
              context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BookingCubit(context.read<RenterRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                AgentBookingRequestsCubit(context.read<AgentRepository>()),
          ),
          BlocProvider(
            // <--- ADD THIS BLOCK
            create: (context) => MyBookingsCubit(context.read()),
          ),
          BlocProvider(
            create: (context) =>
                FavoriteCubit(context.read<RenterRepository>()),
          ),
          BlocProvider(
            create: (context) => ChatCubit(context.read<ChatRepository>()),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(context.read<NotificationRepository>()),
          ),
          BlocProvider(
            create: (context) => FilterCubit(context.read<AgentRepository>()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
