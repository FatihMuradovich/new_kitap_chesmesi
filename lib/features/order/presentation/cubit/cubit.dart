import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/order_data_source.dart';
import '../../domain/model/order.dart';
import 'state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderDataSource dataSource;
  OrderCubit(this.dataSource)
      : super(const OrderLoaded([])); // Start with an empty list of orders

  // Adds a book to the order or increases its quantity if already present.
  void addOrder(BookModel book) {
    if (state is OrderLoaded) {
      final currentOrders =
          List<OrderModel>.from((state as OrderLoaded).orders);
      final existingOrderIndex =
          currentOrders.indexWhere((order) => order.book.code == book.code);

      if (existingOrderIndex != -1) {
        // Book already exists, increase quantity
        final updatedOrder = currentOrders[existingOrderIndex].copyWith(
          quantity: currentOrders[existingOrderIndex].quantity + 1,
        );
        currentOrders[existingOrderIndex] = updatedOrder;
      } else {
        // Book does not exist, add new order with quantity 1
        currentOrders.add(OrderModel(book: book, quantity: 1));
      }
      emit(OrderLoaded(currentOrders));
    }
  }

  // Increases the quantity of a specific book in the order.
  void increaseQuantity(BookModel book) {
    if (state is OrderLoaded) {
      final currentOrders =
          List<OrderModel>.from((state as OrderLoaded).orders);
      final existingOrderIndex =
          currentOrders.indexWhere((order) => order.book.code == book.code);

      if (existingOrderIndex != -1) {
        final updatedOrder = currentOrders[existingOrderIndex].copyWith(
          quantity: currentOrders[existingOrderIndex].quantity + 1,
        );
        currentOrders[existingOrderIndex] = updatedOrder;
        emit(OrderLoaded(currentOrders));
      }
    }
  }

  // Decreases the quantity of a specific book in the order.
  // Removes the order if quantity drops to 0 or less.
  void decreaseQuantity(BookModel book) {
    if (state is OrderLoaded) {
      final currentOrders =
          List<OrderModel>.from((state as OrderLoaded).orders);
      final existingOrderIndex =
          currentOrders.indexWhere((order) => order.book.code == book.code);

      if (existingOrderIndex != -1) {
        final currentQuantity = currentOrders[existingOrderIndex].quantity;
        if (currentQuantity > 1) {
          final updatedOrder = currentOrders[existingOrderIndex].copyWith(
            quantity: currentQuantity - 1,
          );
          currentOrders[existingOrderIndex] = updatedOrder;
        } else {
          // If quantity is 1, remove the item
          currentOrders.removeAt(existingOrderIndex);
        }
        emit(OrderLoaded(currentOrders));
      }
    }
  }

  // Removes a specific book from the order.
  void removeOrder(BookModel book) {
    if (state is OrderLoaded) {
      final currentOrders =
          List<OrderModel>.from((state as OrderLoaded).orders);
      currentOrders.removeWhere((order) => order.book.code == book.code);
      emit(OrderLoaded(currentOrders));
    }
  }

  void makeOrder({required String name,required String adress,required String phone,required int userId}) {
    if (state is OrderLoaded) {
      final currentOrders =
          List<OrderModel>.from((state as OrderLoaded).orders);
      dataSource.makeOrder(orders:  currentOrders,name:  name,phone:  phone,adress:  adress,userId: userId);
      emit(OrderLoaded([]));
    }
  }

  // Clears all orders.
  void clearOrders() {
    emit(const OrderLoaded([]));
  }
}
