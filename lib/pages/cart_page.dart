import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';
import '../models/cart.dart';
import '../models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final itens = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headlineMedium
                              ?.color),
                    ),
                  ),
                  const Spacer(),
                  CartButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) =>
                  CartItemWidget(cartItem: itens[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoanding = false;
  @override
  Widget build(BuildContext context) {
    return _isLoanding
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoanding = true);
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    widget.cart.clear();
                    setState(() => _isLoanding = false);
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            child: const Text("COMPRAR"),
          );
  }
}
