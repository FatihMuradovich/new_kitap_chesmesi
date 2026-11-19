import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/guest_auth_prompt.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncGuestAndFavorites());
  }

  Future<void> _syncGuestAndFavorites() async {
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
      context.read<FavoriteCubit>().getFavoriteBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (p, c) => c is LoginSuccess,
          listener: (context, state) => _syncGuestAndFavorites(),
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (p, c) => c is RegisterSuccess,
          listener: (context, state) => _syncGuestAndFavorites(),
        ),
      ],
      child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.favorites),
      ),
      body: _isGuest
          ? const GuestAuthPrompt()
          : BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          } else if (state is FavoriteLoaded) {
            final favoriteBooks = state.favorites;
            if (favoriteBooks.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 235.w,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: favoriteBooks.length,
                    itemBuilder: (context, index) {
                      final favorite = favoriteBooks[index];
                      return BookItem(margin: false, book: favorite);
                    }),
              );
            } else {
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
                        Icons.favorite_border_outlined,
                        size: 64.sp,
                        color: CustomColors.orangeColor,
                      ),
                    ),
                         SizedBox(height: 10.h),
                    Text(
                      context.l10n.favoriteIsEmpty,
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
          } else if (state is FavoriteError) {
            return Center(
              child: Text(context.l10n.errorMessage),
            );
          }
          return SizedBox.shrink();
        },
      ),
    ),
    );
  }

}
