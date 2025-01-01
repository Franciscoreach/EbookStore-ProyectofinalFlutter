import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/pages/detailbook_page.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class MoreBookPage extends StatelessWidget {
  const MoreBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<EbookBloc>().state.products.isEmpty) {
      context.read<EbookBloc>().add(LoadAllProductsEvent());
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More Books'),
        backgroundColor: AppColor.greyBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.greyLight),
      ),
      backgroundColor: AppColor.greyBackground,
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state.homeScreenState == HomeScreenState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.homeScreenState == HomeScreenState.failure) {
            return const Center(child: Text('Failed to load books.'));
          } else if (state.products.isEmpty) {
            return const Center(child: Text('No books available.'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView.builder(
                itemCount: (state.products.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final book1 = state.products[index * 2];
                  final book2 = index * 2 + 1 < state.products.length
                      ? state.products[index * 2 + 1]
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BookItem(
                          imageUrl: book1.imageUrl,
                          title: book1.name,
                          author: book1.autor,
                          screenWidth: screenWidth,
                          product: book1,
                        ),
                        if (book2 != null)
                          BookItem(
                            imageUrl: book2.imageUrl,
                            title: book2.name,
                            author: book2.autor,
                            screenWidth: screenWidth,
                            product: book2,
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double screenWidth;
  final ProductModel product;

  const BookItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.screenWidth,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    double imageWidth = screenWidth * 0.4;
    double imageHeight = imageWidth * 1.5;

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
            SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.greyLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              author,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.black,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
