import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/widgets/app_colors.dart';
import 'package:proyectofinal/pages/add_product_page.dart';

class MaintainerPage extends StatelessWidget {
  const MaintainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EbookBloc>()..add(LoadAllProductsEvent()),
      child: const MaintainerBody(),
    );
  }
}

class MaintainerBody extends StatelessWidget {
  const MaintainerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Maintainer",
          style: TextStyle(
            color: AppColor.greyLight,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColor.greenBlack,
              size: 30,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              );
              if (result != null && result) {
                // ignore: use_build_context_synchronously
                context.read<EbookBloc>().add(LoadAllProductsEvent());
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state.homeScreenState == HomeScreenState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.homeScreenState == HomeScreenState.failure) {
            return const Center(child: Text('Failed to load products'));
          } else if (state.products.isNotEmpty) {
            final products = state.products;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildListItem(context, product);
              },
            );
          } else {
            return const Center(child: Text('No products available.'));
          }
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, ProductModel product) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 180,
            decoration: BoxDecoration(
              color: AppColor.greyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.autor,
                    style: TextStyle(
                      color: AppColor.greyLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      color: AppColor.greenBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColor.orange,
                  size: 24,
                ),
                onPressed: () async {
                  // Edit
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductPage(
                        isEdit: true,
                        productId: product.id,
                        productName: product.name,
                        productAutor: product.autor,
                        productPrice: product.price.toDouble(),
                        productImageUrl: product.imageUrl,
                      ),
                    ),
                  );

                  if (result != null && result) {
                    // ignore: use_build_context_synchronously
                    context.read<EbookBloc>().add(LoadAllProductsEvent());
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 24,
                ),
                onPressed: () {
                  context.read<EbookBloc>().add(RemoveProductItemEvent(product: product));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
