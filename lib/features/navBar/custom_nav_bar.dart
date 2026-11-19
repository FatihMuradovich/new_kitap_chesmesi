import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/update_dialog.dart';
import 'package:new_kitap_chesmesi/core/config/update_config.dart';
import 'package:new_kitap_chesmesi/core/service/update_service.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/page/cart/cart_page.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/page/category_page.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/page/favorite_page.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/page/home_page.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/page/profile_page.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/cubit/popup_cubit.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/cubit/popup_state.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/widgets/popup_dialog.dart';

// ignore: must_be_immutable
@RoutePage(name: 'CustomNavBarRoute')
class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  int navBarIndex = 0;

  List<Widget> _navBody() {
    return [
      HomePage(),
      CategoryPage(),
      FavoritePage(),
      CartPage(),
      ProfilePage(),
    ];
  }

  // final _service = FirebaseNotificatioService();
  @override
  void initState() {
    super.initState();
    // _service.conntectNotification();
    
    // Popup ve update kontrolü (popup: await + doğrudan dialog; BlocListener ilk state'i kaçırabilirdi)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      log('📱 NavBar initialized, fetching popup...', name: 'CustomNavBar');
      unawaited(_checkForUpdateOnce());
      unawaited(_fetchPopupAndShowIfNeeded(context));
    });
  }

  Future<void> _fetchPopupAndShowIfNeeded(BuildContext context) async {
    await context.read<PopupCubit>().fetchLatestPopup();
    if (!context.mounted) return;
    final state = context.read<PopupCubit>().state;
    if (state is PopupLoaded) {
      log('✅ PopupLoaded after fetch, opening dialog', name: 'CustomNavBar');
      _showPopupDialog(context, state);
    }
  }

  Future<void> _checkForUpdateOnce() async {
    final updateService = di<UpdateService>();

    if (updateService.hasShownDialogInSession) {
      return;
    }

    final result = await updateService.checkForUpdate(
      enforcement: UpdateConfig.forceUpdateEnabled
          ? UpdateEnforcement.mandatory
          : UpdateEnforcement.optional,
    );

    if (!mounted) return;

    if (result.hasError || !result.isUpdateAvailable) {
      return;
    }

    updateService.markDialogShownInSession();

    final action = await UpdateDialog.show(
      context: context,
      result: result,
    );

    if (!mounted) return;

    if (action == UpdateDialogAction.updateNow) {
      await updateService.openStore(result);
    }
  }

  List<PersistentBottomNavBarItem> navBarItem() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 22,
        activeColorPrimary: CustomColors.blueColor,
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.home),
        title: context.l10n.homeScreen,
        textStyle: const TextStyle(
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        activeColorPrimary: CustomColors.blueColor,
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.grid_view),
        title: context.l10n.categories,
        textStyle: const TextStyle(
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        activeColorPrimary: CustomColors.blueColor,
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.favorite),
        title: context.l10n.favorites,
        textStyle: const TextStyle(
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        activeColorPrimary: CustomColors.blueColor,
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        title: context.l10n.cart,
        textStyle: const TextStyle(
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        iconSize: 22,
        activeColorPrimary: CustomColors.blueColor,
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.person),
        title: context.l10n.profil,
        textStyle: const TextStyle(
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _showPopupDialog(BuildContext context, PopupLoaded state) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (dialogContext) => PopupDialog(
        popup: state.popup,
        onDismiss: () {
          Navigator.of(dialogContext).pop();
          context.read<PopupCubit>().dismissPopup();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, bool>(
        builder: (context, isVisible) {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _navBody(),
            items: navBarItem(),
            isVisible: isVisible,
            confineToSafeArea: isVisible ? true : false,
            backgroundColor: Colors.white,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardAppears: true,
            navBarStyle: NavBarStyle.style10,
            key: navigatorKey,
            onItemSelected: (index) async {
              // Ana sayfaya (index 0) her geçildiğinde verileri sessizce yenile
              if (index == 0) {
                context.read<HomeCubit>().loadHomeData(silentRefresh: true);
              }
              navBarIndex = index;
            },
          );
        },
    );
  }
}












// Scaffold(
//       body: navBody[navBarIndex],
//       bottomNavigationBar: Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: GNav(
//             selectedIndex: navBarIndex,
//             // onTabChange: pageChange(),
//             onTabChange: (index) {
//               setState(() {
//                 navBarIndex = index;
//               });
//             },
//             backgroundColor: Colors.white,
//             activeColor: Colors.white,
//             color: ConstantsColor.customBlueColor,
//             tabBackgroundColor: ConstantsColor.customBlueColor,
//             gap: 5,
//             padding: const EdgeInsets.all(6),
//             tabs: const [
//               GButton(
//                 padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                 icon: FluentSystemIcons.ic_fluent_home_filled,
//                 iconSize: 20,
//                 text: 'Baş sahypa',
//               ),
//               GButton(
//                 padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                 icon: FluentSystemIcons.ic_fluent_glance_filled,
//                 iconSize: 20,
//                 text: 'Kategoriýalar',
//               ),
//               GButton(
//                 padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                 icon: FluentSystemIcons.ic_fluent_heart_filled,
//                 iconSize: 20,
//                 text: 'Halanlarym',
//               ),
//               GButton(
//                 padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                 icon: Icons.shopping_cart,
//                 iconSize: 20,
//                 text: 'Sebet',
//               ),
//               GButton(
//                 padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                 icon: FluentSystemIcons.ic_fluent_person_filled,
//                 iconSize: 20,
//                 text: 'Profil',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );