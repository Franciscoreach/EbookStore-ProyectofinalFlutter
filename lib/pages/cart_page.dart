import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Cart",
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            color: AppColor.black,
            focusColor: AppColor.greyBackground,
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state.cart.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'There are no products added to the cart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyLight,
                  ),
                ),
              ),
            );
          }

          // Calcular el precio total del carrito
          final totalPrice = state.cart.fold<double>(
            0.0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    final product = state.cart[index];
                    return _buildCardItem(context, product);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final cartItems = state.cart;  // Obtienes los productos del carrito
                    context.read<EbookBloc>().add(CheckoutEvent(cartItems: cartItems));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, ProductModel product) {
    return Container(
      height: 138,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<EbookBloc>().add(RemoveCartItemEvent(product: product));
            },
            icon: Icon(
              Icons.delete,
              color: AppColor.red,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.greyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(product.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    product.autor,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColor.greyLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<EbookBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product: product,
                                      newQty: -1,
                                    ),
                                  );
                            },
                            icon: Icon(
                              Icons.remove,
                              color: AppColor.black,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: Center(
                              child: Text(product.quantity.toString()),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<EbookBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product: product,
                                      newQty: 1,
                                    ),
                                  );
                            },
                            icon: Icon(
                              Icons.add,
                              color: AppColor.black,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\$${product.price * product.quantity}",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
