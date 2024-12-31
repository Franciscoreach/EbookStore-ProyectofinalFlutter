import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/pages/detailbook_page.dart';
import 'package:proyectofinal/pages/morebook_page.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class TrendingProducts extends StatelessWidget {
  const TrendingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EbookBloc>().add(LoadTrendingProductsEvent());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Books',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<EbookBloc>().add(LoadAllProductsEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MoreBookPage()),
                  );
                },
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: AppColor.greyLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<EbookBloc, EbookState>(
          builder: (context, state) {
            if (state.homeScreenState == HomeScreenState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.homeScreenState == HomeScreenState.success) {
              final trendingProducts = state.trendingProducts;

              if (trendingProducts.isEmpty) {
                return const Center(child: Text('No hay productos trending'));
              }

              return SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingProducts.length,
                  itemBuilder: (context, index) {
                    final product = trendingProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBookPage(
                              product: product,
                              title: product.name,
                              author: product.autor,
                              imageUrl: product.imageUrl,
                              price: '\$${product.price}',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.autor,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: TextStyle(
                                color: AppColor.greyLight,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            // Caso de error
            if (state.homeScreenState == HomeScreenState.failure) {
              return const Center(child: Text('Error al cargar los productos.'));
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
