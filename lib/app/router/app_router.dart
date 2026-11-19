import 'package:auto_route/auto_route.dart';

import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: CustomNavBarRoute.page),
        AutoRoute(page: BookDetailRoute.page),
        AutoRoute(page: BooksRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: OtpRoute.page),
        AutoRoute(page: NewPasswordRoute.page),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: SubcategoryRoute.page),
        AutoRoute(page: UserEditRoute.page),
        AutoRoute(page: MyOrdersRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: CouponRoute.page),
        AutoRoute(page: ContactRoute.page),
        AutoRoute(page: AboutUsRoute.page),
        AutoRoute(page: TermsOfUseRoute.page),
        AutoRoute(page: PrivacyPolicyRoute.page),
        AutoRoute(page: OrderRoute.page),
        AutoRoute(page: WelayatRoute.page),
        AutoRoute(page: EtrapRoute.page),
        AutoRoute(page: AddCommentRoute.page),
        AutoRoute(page: AllCommentsRoute.page),
        AutoRoute(page: OnboardingCategoryRoute.page),
      ];
}
