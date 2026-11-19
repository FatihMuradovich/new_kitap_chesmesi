import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class EtrapPage extends StatefulWidget {
  final int welayatId;

  const EtrapPage({
    super.key,
    required this.welayatId,
  });

  @override
  State<EtrapPage> createState() => _EtrapPageState();
}

class _EtrapPageState extends State<EtrapPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<WelayatAndEtrapCubit>().getEtrapsByWelayatId(widget.welayatId);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<WelayatAndEtrapCubit>().state;
    if (state is! WelayatAndEtrapLoaded) return;
    if (!state.etrapsHasMore || state.etrapsLoadingMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context
          .read<WelayatAndEtrapCubit>()
          .loadMoreEtrapsByWelayatId(widget.welayatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.chooseDistrict,
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
            final etraps = state.etraps;

            if (etraps.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.noDistrictFound,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                  ),
                ),
              );
            }

            final hasMore = state.etrapsHasMore;
            final loadingMore = state.etrapsLoadingMore;

            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8),
              itemCount: etraps.length + (hasMore && loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= etraps.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: CustomColors.orangeColor,
                        ),
                      ),
                    ),
                  );
                }
                final etrap = etraps[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, {
                          'id': etrap.id,
                          'name': etrap.name,
                          'price': etrap.price,
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                etrap.name,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${etrap.price} m.',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.orangeColor,
                              ),
                            ),
                          ],
                        ),
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
                      context
                          .read<WelayatAndEtrapCubit>()
                          .getEtrapsByWelayatId(widget.welayatId);
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
