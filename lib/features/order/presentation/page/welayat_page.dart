import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class WelayatPage extends StatefulWidget {
  const WelayatPage({super.key});

  @override
  State<WelayatPage> createState() => _WelayatPageState();
}

class _WelayatPageState extends State<WelayatPage> {
  @override
  void initState() {
    super.initState();
    context.read<WelayatAndEtrapCubit>().getWelayats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.chooseProvince,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<WelayatAndEtrapCubit, WelayatAndEtrapState>(
        builder: (context, state) {
          if (state is WelayatAndEtrapLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          } else if (state is WelayatAndEtrapLoaded) {
            final welayats = state.welayats;

            if (welayats.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.noProvinceFound,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: welayats.length,
              itemBuilder: (context, index) {
                final welayat = welayats[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      'id': welayat.id,
                      'name': welayat.name,
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    color: const Color(0xFFFAFAFA),
                    elevation: 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            welayat.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins-regular',
                            ),
                          ),
                          // CustomIcons.rightChevron,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is WelayatAndEtrapError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.errorMessage,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<WelayatAndEtrapCubit>().getWelayats();
                    },
                    child: Text(
                      context.l10n.tryAgain,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14.sp,
                        color: CustomColors.orangeColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
