import 'package:saralyatra/pages/login-page.dart';
import 'package:saralyatra/payments/khalti-pay.dart';

class AppRoute {
  AppRoute._();

  static const String homeRoute = '/';
  static const String cartRoute = '/cart';
  static const String khaltiRoute = '/khalti-pay';

  static getAppRoutes() {
    return {
      homeRoute: (context) => const Login_page(),
      khaltiRoute: (context) => const PaymentKhalti()
    };
  }
}
