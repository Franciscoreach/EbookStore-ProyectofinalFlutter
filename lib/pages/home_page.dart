import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/pages/cart_page.dart';
import 'package:proyectofinal/pages/maintainer_page.dart';
import 'package:proyectofinal/pages/detailbook_page.dart';
import 'package:proyectofinal/widgets/app_colors.dart';
import 'package:proyectofinal/widgets/trending_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EbookBloc>(context).add(LoadMostRecentReadingProductEvent());
    BlocProvider.of<EbookBloc>(context).add(LoadCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EbookBloc>(context).add(LoadMostRecentReadingProductEvent());
    BlocProvider.of<EbookBloc>(context).add(LoadTrendingProductsEvent());
    BlocProvider.of<EbookBloc>(context).add(LoadCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MaintainerPage()),
              );
            },
            icon: Icon(
              Icons.settings,
              color: AppColor.black,
              size: 32,
            ),
          ),
        ),
        actions: [
          BlocBuilder<EbookBloc, EbookState>(
            builder: (context, state) {
              final totalItems = state.cart.fold(0, (sum, item) => sum + item.quantity);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColor.greyLight,
                      size: 30,
                    ),
                  ),
                  if (totalItems > 0)
                    Positioned(
                      top: 5,
                      right: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            totalItems.toString(),
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/img/profilePic.jpg'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColor.greyLight),
                hintText: 'Search',
                hintStyle: TextStyle(color: AppColor.greyLight),
                filled: true,
                fillColor: AppColor.greyBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.mic, color: AppColor.black),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Column(
                children: [
                  TrendingProducts(),
                ],
              ),
            ),
          ),
          BlocBuilder<EbookBloc, EbookState>(
            builder: (context, state) {
              final mostRecentProduct = state.mostRecentReadingProduct.isNotEmpty
                  ? state.mostRecentReadingProduct[0]
                  : null;

              if (mostRecentProduct == null || !mostRecentProduct.isReading) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBookPage(
                        product: mostRecentProduct,
                        title: mostRecentProduct.name,
                        author: mostRecentProduct.autor,
                        imageUrl: mostRecentProduct.imageUrl,
                        price: '\$${mostRecentProduct.price}',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColor.greenBlack,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Continue Reading',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.more_horiz,
                                      color: AppColor.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  height: 85,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            mostRecentProduct.imageUrl,
                                            width: 60,
                                            height: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              mostRecentProduct.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            Text(
                                              mostRecentProduct.autor,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.black.withOpacity(0.7),
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(4, (index) {
                                                return Icon(
                                                  Icons.star,
                                                  color: AppColor.yellow,
                                                  size: 16,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColor.orange,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '65%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
