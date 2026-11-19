import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/order_status_ui.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<MyOrdersCubit>()..loadMyOrders(),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatefulWidget {
  const _MyOrdersView();

  @override
  State<_MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<_MyOrdersView> {
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
      final state = context.read<MyOrdersCubit>().state;
      if (state is MyOrdersLoaded && state.hasMore) {
        _isLoadingMore = true;
        context.read<MyOrdersCubit>().loadMore().whenComplete(() {
          if (mounted) _isLoadingMore = false;
        });
      }
    }
  }

  /// Detayda iptal edilmiş olabilir — dönüşte listeyi tazele.
  Future<void> _openDetail(OrderData order) async {
    await di<AppRouter>().push(OrderDetailRoute(orderId: order.id));
    if (!mounted) return;
    await context.read<MyOrdersCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          context.l10n.myOrders,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<MyOrdersCubit, MyOrdersState>(
        builder: (context, state) {
          if (state is MyOrdersLoading || state is MyOrdersInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          }

          if (state is MyOrdersError) {
            return _OrdersError(
              statusCode: state.statusCode,
              onRetry: () => context.read<MyOrdersCubit>().loadMyOrders(),
            );
          }

          final orders = state is MyOrdersLoaded
              ? state.orders
              : (state as MyOrdersLoadingMore).currentOrders;
          final isLoadingMore = state is MyOrdersLoadingMore;

          if (orders.isEmpty) {
            return RefreshIndicator(
              color: CustomColors.orangeColor,
              onRefresh: () => context.read<MyOrdersCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  const _EmptyOrders(),
                ],
              ),
            );
          }

          final activeOrder = _findActiveOrder(orders);
          final historyOrders =
              orders.where((order) => order != activeOrder).toList();

          return RefreshIndicator(
            color: CustomColors.orangeColor,
            onRefresh: () => context.read<MyOrdersCubit>().refresh(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeOrder != null) ...[
                    GestureDetector(
                      onTap: () => _openDetail(activeOrder),
                      child: _ActiveOrderCard(order: activeOrder),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  if (historyOrders.isNotEmpty) ...[
                    Text(
                      context.l10n.orderHistory,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...historyOrders.map(
                      (order) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: GestureDetector(
                          onTap: () => _openDetail(order),
                          child: _OrderHistoryCard(order: order),
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

/// Devam eden ilk sipariş — son duruma ulaşmamış (pending/confirmed/shipped) olan.
OrderData? _findActiveOrder(List<OrderData> orders) {
  for (final order in orders) {
    if (!order.status.isFinal && order.status != OrderStatus.unknown) {
      return order;
    }
  }
  return null;
}

class _OrdersError extends StatelessWidget {
  const _OrdersError({required this.statusCode, required this.onRetry});

  final int? statusCode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 40.sp,
              color: Colors.grey[400],
            ),
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

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
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
              Icons.receipt_long_outlined,
              size: 48.sp,
              color: CustomColors.orangeColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.noOrdersYet,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 16.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final OrderData order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(
        //   colors: [
        //     CustomColors.orangeColor.withValues(alpha: 0.12),
        //     Colors.white,
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.orangeColor.withValues(alpha: 0.25),
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
                  Icons.local_shipping_outlined,
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
                      context.l10n.activeOrder,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '#${order.id}',
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
                formatOrderDate(order.createdAt),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 11.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          if (order.status == OrderStatus.cancelled)
            const OrderCancelledBanner()
          else
            OrderStepper(status: order.status),
          SizedBox(height: 18.h),
          Divider(height: 1, color: Colors.grey[200]),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16.sp, color: Colors.grey[500]),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  order.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.orderItemsCount(order.orderItems.length),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${order.total} m.',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});

  final OrderData order;

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
                '#${order.id}',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            order.address,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatOrderDate(order.createdAt),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${order.total} m.',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
            ],
          ),
          if (order.orderItems.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              context.l10n.orderItemsCount(order.orderItems.length),
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
