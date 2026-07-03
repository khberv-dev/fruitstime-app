import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/assistant/presentation/ui/chat_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/login_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/otp_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/register_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/onboarding_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/select_locale_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/splash_screen.dart';
import 'package:fruitstime/features/notification/presentation/ui/notifications_screen.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/features/order/presentation/ui/location_picker_screen.dart';
import 'package:fruitstime/features/order/presentation/ui/order_detail_screen.dart';
import 'package:fruitstime/features/order/presentation/ui/orders_screen.dart';
import 'package:fruitstime/features/order/presentation/ui/web_view_screen.dart';
import 'package:fruitstime/features/product/presentation/ui/products_screen.dart';
import 'package:fruitstime/features/product/presentation/ui/search_screen.dart';
import 'package:go_router/go_router.dart';

final _appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: SplashScreen.path, builder: (_, _) => SplashScreen()),
    GoRoute(path: SelectLocaleScreen.path, builder: (_, _) => SelectLocaleScreen()),
    GoRoute(path: OnboardingScreen.path, builder: (_, _) => OnboardingScreen()),
    GoRoute(path: AppScreen.path, builder: (_, _) => AppScreen()),
    GoRoute(path: ProductsScreen.path, builder: (_, _) => ProductsScreen()),
    GoRoute(path: LoginScreen.path, builder: (_, _) => LoginScreen()),
    GoRoute(path: RegisterScreen.path, builder: (_, _) => RegisterScreen()),
    GoRoute(path: OtpScreen.path, builder: (_, _) => OtpScreen()),
    GoRoute(path: ChatScreen.path, builder: (_, _) => ChatScreen()),
    GoRoute(path: SearchScreen.path, builder: (_, _) => SearchScreen()),
    GoRoute(path: OrdersScreen.path, builder: (_, _) => OrdersScreen()),
    GoRoute(path: OrderDetailScreen.path, builder: (_, _) => OrderDetailScreen()),
    GoRoute(path: NotificationsScreen.path, builder: (_, _) => NotificationsScreen()),
    GoRoute(
      path: LocationPickerScreen.path,
      builder: (_, state) => LocationPickerScreen(initial: state.extra as OrderAddressEntity?),
    ),
    GoRoute(
      path: WebViewScreen.path,
      builder: (_, state) => WebViewScreen(url: state.extra as String),
    ),
  ],
);

final appRouterProvider = Provider((ref) => _appRouter);
