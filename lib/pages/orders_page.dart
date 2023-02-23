import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoanding = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(context, listen: false).loadOrders().then((value) {
      setState(() {
        _isLoanding = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
      ),
      drawer: const AppDrawer(),
      body: _isLoanding
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (context, index) =>
                    OrderWidget(order: orders.items[index]),
              ),
            ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }
}
