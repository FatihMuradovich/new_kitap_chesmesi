import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/order_status_ui.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_orders/special_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_orders/special_orders_state.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/widget/special_order_status_ui.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// "Taleplerim" — SPECIAL-ORDER-API.md §7.
/// `MyOrdersPage` ile aynı yapı: aktif talep üstte, gerisi geçmiş listesinde.
@RoutePage()
class SpecialOrdersPage extends StatelessWidget {
  const SpecialOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<SpecialOrdersCubit>()..loadMyRequests(),
      child: const _SpecialOrdersView(),
    );
  }
}

class _SpecialOrdersView extends StatefulWidget {
  const _SpecialOrdersView();

  @override
  State<_SpecialOrdersView> createState() => _SpecialOrdersViewState();
}

class _SpecialOrdersViewState extends State<_SpecialOrdersView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200 && !_isLoadingMore) {
      final state = context.read<SpecialOrdersCubit>().state;
      if (state is SpecialOrdersLoaded && state.hasMore) {
        _isLoadingMore = true;
        context.read<SpecialOrdersCubit>().loadMore().whenComplete(() {
          if (mounted) _isLoadingMore = false;
        });
      }
    }
  }

  /// Detayda onaylanmış/reddedilmiş olabilir — dönüşte listeyi tazele.
  Future<void> _openDetail(SpecialOrderRequestData request) async {
    await di<AppRouter>().push(
      SpecialOrderDetailRoute(requestId: request.id),
    );
    if (!mounted) return;
    await context.read<SpecialOrdersCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          context.l10n.myRequests,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SpecialOrdersCubit, SpecialOrdersState>(
        builder: (context, state) {
          if (state is SpecialOrdersLoading || state is SpecialOrdersInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          }

          if (state is SpecialOrdersError) {
            return _RequestsError(
              onRetry: () =>
                  context.read<SpecialOrdersCubit>().loadMyRequests(),
            );
          }

          final requests = state is SpecialOrdersLoaded
              ? state.requests
              : (state as SpecialOrdersLoadingMore).currentRequests;
          final isLoadingMore = state is SpecialOrdersLoadingMore;

          if (requests.isEmpty) {
            return RefreshIndicator(
              color: CustomColors.orangeColor,
              onRefresh: () => context.read<SpecialOrdersCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  const _EmptyRequests(),
                ],
              ),
            );
          }

          final activeRequest = _findActiveRequest(requests);
          final historyRequests =
              requests.where((request) => request != activeRequest).toList();

          return RefreshIndicator(
            color: CustomColors.orangeColor,
            onRefresh: () => context.read<SpecialOrdersCubit>().refresh(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeRequest != null) ...[
                    GestureDetector(
                      onTap: () => _openDetail(activeRequest),
                      child: _ActiveRequestCard(request: activeRequest),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  if (historyRequests.isNotEmpty) ...[
                    Text(
                      context.l10n.requestHistory,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...historyRequests.map(
                      (request) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: GestureDetector(
                          onTap: () => _openDetail(request),
                          child: _RequestHistoryCard(request: request),
                        ),
                      ),
                    ),
                  ],
                  if (isLoadingMore)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.orangeColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Devam eden ilk talep — son duruma ulaşmamış (`Pending` / `Quoted`) olan.
SpecialOrderRequestData? _findActiveRequest(
  List<SpecialOrderRequestData> requests,
) {
  for (final request in requests) {
    if (!request.status.isFinal &&
        request.status != SpecialOrderStatus.unknown) {
      return request;
    }
  }
  return null;
}

class _RequestsError extends StatelessWidget {
  const _RequestsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              context.l10n.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                context.l10n.tryAgain,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.orangeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
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
                Icons.flight_takeoff_outlined,
                size: 48.sp,
                color: CustomColors.orangeColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.l10n.emptyRequests,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              context.l10n.emptyRequestsHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({required this.request});

  final SpecialOrderRequestData request;

  @override
  Widget build(BuildContext context) {
    // Teklif hazır olan talep aksiyon bekliyor — kartı marka rengiyle vurgula.
    final awaitingAction = request.isActionable;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.orangeColor
              .withValues(alpha: awaitingAction ? 0.55 : 0.25),
          width: awaitingAction ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: CustomColors.orangeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flight_takeoff_outlined,
                  color: CustomColors.orangeColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.activeRequest,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '#${request.id}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatOrderDate(request.createdAt),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 11.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SpecialOrderStatusChip(status: request.status),
          if (request.quoteExpiresAt != null && awaitingAction) ...[
            SizedBox(height: 10.h),
            Text(
              context.l10n
                  .quoteExpiresAt(formatOrderDateTime(request.quoteExpiresAt!)),
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
          if (request.items.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 12.h),
            Text(
              context.l10n.orderItemsCount(request.items.length),
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestHistoryCard extends StatelessWidget {
  const _RequestHistoryCard({required this.request});

  final SpecialOrderRequestData request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                '#${request.id}',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
              SpecialOrderStatusChip(status: request.status),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatOrderDate(request.createdAt),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              if (request.items.isNotEmpty)
                Text(
                  context.l10n.orderItemsCount(request.items.length),
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
