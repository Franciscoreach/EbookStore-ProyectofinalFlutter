import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class DetailBookPage extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String price;
  final ProductModel product;

  const DetailBookPage({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Book'),
        backgroundColor: AppColor.greyBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.greyLight),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
            iconSize: 24,
            color: AppColor.greyLight,
          ),
        ],
      ),
      backgroundColor: AppColor.greyBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: MediaQuery.of(context).size.height * 0.35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                author,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.greyLight,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Rating',
                          style: TextStyle(fontSize: 12, color: AppColor.greyLight),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Pages',
                          style: TextStyle(fontSize: 12, color: AppColor.greyLight),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '120',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Language',
                          style: TextStyle(fontSize: 12, color: AppColor.greyLight),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'English',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Gallery West Residence is an apartment that is part of the ARK Gallery West mixed-use complex that is integrated with office...',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              BlocBuilder<EbookBloc, EbookState>(
                builder: (context, state) {
                  final isInCart = state.cart.any((item) => item.id == product.id);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isInCart) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'QTY',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColor.greyLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              BlocBuilder<EbookBloc, EbookState>(
                                builder: (context, state) {
                                  final productItem = state.cart.firstWhere(
                                    (p) => p.id == product.id,
                                    orElse: () => ProductModel(id: product.id, name: '', imageUrl: '', price: 0, quantity: 1, autor: ''),
                                  );
                                  final productQty = productItem.quantity;

                                  return Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (productQty > 0) {
                                            context.read<EbookBloc>().add(
                                              UpdateCartQuantityEvent(
                                                product: product,
                                                newQty: -1,
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(
                                        '$productQty',
                                        style: TextStyle(
                                          color: AppColor.greenBlack,
                                          fontSize: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (productQty < 5) {
                                            context.read<EbookBloc>().add(
                                              UpdateCartQuantityEvent(
                                                product: product,
                                                newQty: 1,
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isInCart) {
                              context.read<EbookBloc>().add(
                                AddToCartEvent(product: product),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInCart ? Colors.grey : AppColor.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isInCart ? 'Item in Cart' : 'Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
