import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/widgets/error_retry_view.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cart_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/common/widgets/guest_auth_prompt.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/page/cart/widget/cart_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncGuestAndCart());
  }

  Future<void> _syncGuestAndCart() async {
    final dioClient = di<DioClient>();
    final token = await dioClient.getToken();
    final refreshToken =
        await dioClient.secureStorage.read(key: Keys.REFRESH_TOKEN);

    final isLoggedIn = token != null &&
        token.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    if (!mounted) return;

    setState(() {
      _isGuest = !isLoggedIn;
    });

    if (isLoggedIn && mounted) {
      context.read<CartCubit>().getCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (p, c) => c is LoginSuccess,
          listener: (context, state) => _syncGuestAndCart(),
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (p, c) => c is RegisterSuccess,
          listener: (context, state) => _syncGuestAndCart(),
        ),
      ],
      child: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cartErrorMessage(
                  context,
                  state.reason,
                  maxStock: state.maxStock,
                )),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.cart),
            actions: [
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (!_isGuest &&
                      state is CartLoaded &&
                      state.cartItems.isNotEmpty) {
                    return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                context.l10n.confirm,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                context.l10n.confirmRemoveFromCart,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text(
                                    context.l10n.no,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    context.read<CartCubit>().clearCart();
                                  },
                                  child: Text(
                                    context.l10n.yes,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14.sp,
                                      color: CustomColors.orangeColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: CustomColors.blueColor,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: _isGuest ? const GuestAuthPrompt() : _buildCartBody(context),
        ),
      ),
    );
  }

  Widget _buildCartBody(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      // Ekleme/silme gibi ara durumlarda ve işlem hatalarında listeyi koru;
      // aksi halde sepet bir anlığına boş ekrana dönerdi.
      buildWhen: (_, current) =>
          current is CartInitial ||
          current is CartLoading ||
          current is CartLoaded ||
          current is CartError,
      builder: (context, state) {
        if (state is CartLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: CustomColors.orangeColor,
            ),
          );
        } else if (state is CartError) {
          return ErrorRetryView(
            message: cartErrorMessage(context, state.reason),
            onRetry: () => context.read<CartCubit>().getCartItems(),
          );
        } else if (state is CartLoaded) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 64.sp,
                      color: CustomColors.orangeColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    context.l10n.cartIsEmpty,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      return Dismissible(
                        key: ValueKey(cartItem.cartItemId),
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                CustomColors.orangeColor,
                                Colors.white,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            children: [
                              Spacer(),
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          context
                              .read<CartCubit>()
                              .confirmRemoveFromCart(cartItem.id);
                        },
                        child: CartItem(cartItem: cartItem),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      );
                    },
                    itemCount: state.cartItems.length,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.totalAmount,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${state.totalAmount.toStringAsFixed(2)} m.',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onTap: () async {
                          final currentState = context.read<CartCubit>().state;
                          if (currentState is CartLoaded) {
                            final result = await di<AppRouter>().push<bool>(
                              OrderRoute(
                                cartItems: currentState.cartItems,
                                totalPrice: currentState.totalAmount,
                              ),
                            );

                            // Sipariş başarılı ise sepeti yenile
                            if (result == true && context.mounted) {
                              context.read<CartCubit>().getCartItems();
                            }
                          }
                        },
                        backgroundColor: CustomColors.orangeColor,
                        child: Text(
                          context.l10n.acceptCart,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
