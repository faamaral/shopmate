import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text("Ocorreu um erro!"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (context, index) =>
                      OrderWidget(order: orders.items[index]),
                ),
              ),
            );
          }
        },
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
      ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }
}
