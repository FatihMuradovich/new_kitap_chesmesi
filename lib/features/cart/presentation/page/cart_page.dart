import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/cart/presentation/widget/cart_item.dart';
import 'package:new_kitap_chesmesi/features/cart/presentation/widget/order_button.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cart),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FluentSystemIcons.ic_fluent_delete_filled),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
        child: ListView.separated(
          separatorBuilder:
              (context, index) =>
                  Divider(thickness: 0.5, color: Colors.grey[300]),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CustomColors.orangeColor, Colors.white],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  // color: const Color.fromARGB(255, 186, 26, 26),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Spacer(),
                    Icon(
                      FluentSystemIcons.ic_fluent_delete_filled,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              key: const ValueKey(1),
              child: CartItem(),
            );
          },
        ),
      ),
      bottomNavigationBar: OrderBottom(totalOrderPrice: '100', bookCount: 10),
    );
  }
}
