import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  ReadingPageState createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<EbookBloc>().add(LoadReadingProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ebookBloc = context.read<EbookBloc>();

    return BlocProvider.value(
      value: ebookBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Reading Collection",
            style: TextStyle(
              color: AppColor.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              color: AppColor.black,
              focusColor: AppColor.greyBackground,
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: BlocBuilder<EbookBloc, EbookState>(
          builder: (context, state) {
            if (state.homeScreenState == HomeScreenState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.homeScreenState == HomeScreenState.failure) {
              return const Center(child: Text('Failure to load products'));
            }

            if (state.readingProducts.isEmpty) {
              return const Center(child: Text('There are no products to read'));
            }

            return ListView.builder(
              itemCount: state.readingProducts.length,
              itemBuilder: (context, index) {
                final product = state.readingProducts[index];
                return _buildProductCard(product, state);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, EbookState state) {
    final isReading = state.readingProducts.any(
      (p) => p.id == product.id && p.isReading == true,
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        key: ValueKey(product.id),
        contentPadding: const EdgeInsets.all(12),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.autor),
            const SizedBox(height: 8),
            _buildRatingStars(4),
          ],
        ),
        leading: Image.network(product.imageUrl, width: 50, height: 50),
        trailing: ElevatedButton(
          onPressed: () {
            final readDate = DateTime.now().toIso8601String();
            context.read<EbookBloc>().add(UpdateProductReadingEvent(
              productId: product.id,
              isReading: !isReading,
              readDate: readDate,
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isReading ? Colors.grey : AppColor.orange,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isReading ? "Reading..." : "Start reading",
            style: TextStyle(
              color: AppColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(
        Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: AppColor.orange,
          size: 20,
        ),
      );
    }

    return Row(
      children: stars,
    );
  }
}
