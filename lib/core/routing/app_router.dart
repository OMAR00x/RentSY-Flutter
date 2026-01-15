// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/transitions/netflix_transition.dart';
import 'package:saved/features/agent_home/screens/add_apartment_screen.dart';
import 'package:saved/features/agent_home/screens/agent_apartment_details_screen.dart';
import 'package:saved/features/agent_home/screens/agent_home_screen.dart';
import 'package:saved/features/agent_home/screens/booking_requests_screen.dart';
import 'package:saved/features/agent_home/screens/search_apartments_screen.dart';
import 'package:saved/features/auth/screens/account_created_screen.dart';
import 'package:saved/features/auth/screens/account_type_screen.dart';
import 'package:saved/features/auth/screens/login_screen.dart';
import 'package:saved/features/profile/screens/edit_profile_screen.dart';
import 'package:saved/features/profile/screens/profile_screen.dart';
import 'package:saved/features/register/screens/register_screen.dart';
import 'package:saved/features/renter_home/screens/booking_request_screen.dart';
import 'package:saved/features/renter_home/screens/credit_card_form_screen.dart';
import 'package:saved/features/renter_home/screens/payment_method_selection_screen.dart';
import 'package:saved/features/renter_home/screens/renter_apartments_details_screen.dart';
import 'package:saved/features/renter_home/screens/renter_main_navigation_screen.dart';
import 'package:saved/features/splash_onboarding/screens/onboarding_screen.dart';
import 'package:saved/features/splash_onboarding/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String accountType = '/account-type';
  static const String login = '/login';
  static const String register = '/register';
  static const String accountCreated = '/account-created';
  static const String agentHome = '/agent-home';
  static const String agentApartmentDetails = '/agent-apartment-details';
  static const String renterApartmentDetails = '/renter-apartment-details';
  static const String addApartment = '/add-apartment';
  static const String bookingRequests = '/booking-requests';
  static const String searchApartments = '/search-apartments';
  static const String renterHome = '/renter-home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String bookingRequest = '/booking-request';
  static const String paymentMethodSelection = '/payment-method-selection';
  static const String creditCardFormScreen = '/credit-card-form-screen';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return NetflixTransition(page: const Splashscreen());
      case onboarding:
        return NetflixTransition(page: const OnboardingScreen());
      case accountType:
        return NetflixTransition(page: const AccountTypePage());
      case login:
        return NetflixTransition(page: const LoginPage());
      case register:
        return NetflixTransition(
          page: const CreateYourAccountPage(),
          settings: settings,
        );
      case accountCreated:
        return NetflixTransition(page: const AccountCreatedSuccessfully());
      case agentHome:
        return NetflixTransition(page: const AgentHomeScreen());
      case addApartment:
        return NetflixTransition(page: const AddApartmentScreen());
      case bookingRequests:
        return NetflixTransition(page: const BookingRequestsScreen());
      case searchApartments:
        return NetflixTransition(page: const SearchApartmentsScreen());
      case agentApartmentDetails:
        final apartment = settings.arguments as ApartmentModel?;
        if (apartment != null) {
          return NetflixTransition(
            page: AgentApartmentDetailsScreen(apartment: apartment),
          );
        }
        return NetflixTransition(
          page: const Scaffold(
            body: Center(child: Text("Error: Missing Apartment Data")),
          ),
        );
      case renterApartmentDetails:
        final apartment = settings.arguments as ApartmentModel?;
        if (apartment != null) {
          return NetflixTransition(
            page: RenterApartmentDetailsScreen(apartment: apartment),
          );
        }
        return NetflixTransition(
          page: const Scaffold(
            body: Center(child: Text("Error: Missing Apartment Data")),
          ),
        );
      case bookingRequest:
        final apartment = settings.arguments as ApartmentModel?;
        if (apartment != null) {
          return NetflixTransition(page: BookingRequestScreen(apartment: apartment));
        }
        return NetflixTransition(
          page: const Scaffold(
            body: Center(child: Text("Error: Missing Apartment Data for Booking")),
          ),
        );
      case paymentMethodSelection:
        final args = settings.arguments as Map<String, dynamic>?;
        final apartmentToBook = args?['apartment'] as ApartmentModel?;
        final totalAmount = args?['totalAmount'] as double?;

        if (apartmentToBook != null && totalAmount != null) {
          return NetflixTransition(page: PaymentMethodSelectionScreen(apartment: apartmentToBook, totalAmount: totalAmount));
        }
        return NetflixTransition(
          page: const Scaffold(
            body: Center(child: Text("Error: Missing Booking details for payment selection")),
          ),
        );
      case creditCardFormScreen:
        return NetflixTransition(page: const CreditCardFormScreen());
      case renterHome:
        return NetflixTransition(page: const RenterMainNavigationScreen());
      case profile:
        return NetflixTransition(page: const ProfileScreen());
      case editProfile:
        if (settings.arguments is UserModel) {
          final user = settings.arguments as UserModel;
          return NetflixTransition(page: EditProfileScreen(user: user));
        }
        return NetflixTransition(
          page: const Scaffold(
            body: Center(child: Text("Error: User data was not provided.")),
          ),
        );
      default:
        return NetflixTransition(
          page: const Scaffold(body: Center(child: Text('Page Not Found'))),
        );
    }
  }
}
