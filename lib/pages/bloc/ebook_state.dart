part of 'ebook_bloc.dart';

enum HomeScreenState {
  none,
  loading,
  success,
  failure,
}


class EbookState extends Equatable {
  final List<ProductModel> cart;
  final List<ProductModel> products;
  final List<ProductModel> trendingProducts;
  final List<ProductModel> favoriteProducts; 
  final HomeScreenState homeScreenState;
  final List<ProductModel> readingProducts;
  final List<ProductModel> mostRecentReadingProduct;  // Esto debería ser una lista, no un solo producto.

  const EbookState({
    required this.cart,
    required this.products,
    required this.homeScreenState,
    required this.trendingProducts,
    required this.favoriteProducts,
    required this.readingProducts,
    required this.mostRecentReadingProduct,
  });

  factory EbookState.initial() {
    return const EbookState(
      cart: [],
      products: [],
      homeScreenState: HomeScreenState.none,
      trendingProducts: [],
      favoriteProducts: [],
      readingProducts: [],
      mostRecentReadingProduct: [],  // Iniciar como lista vacía
    );
  }

  EbookState copyWith({
    List<ProductModel>? cart,
    List<ProductModel>? products,
    HomeScreenState? homeScreenState,
    List<ProductModel>? trendingProducts,
    List<ProductModel>? favoriteProducts, 
    Map<String, int>? cartQuantities,
    List<ProductModel>? readingProducts, 
    List<ProductModel>? mostRecentReadingProduct,  // Asegúrate de que sea una lista.
  }) {
    return EbookState(
      cart: cart ?? this.cart,
      products: products ?? this.products,
      homeScreenState: homeScreenState ?? this.homeScreenState,
      trendingProducts: trendingProducts ?? this.trendingProducts,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      readingProducts: readingProducts ?? this.readingProducts,
      mostRecentReadingProduct: mostRecentReadingProduct ?? this.mostRecentReadingProduct,
    );
  }

  @override
  List<Object?> get props => [
        cart,
        products,
        homeScreenState,
        trendingProducts,
        favoriteProducts,
        readingProducts,
        mostRecentReadingProduct,  // Asegúrate de que esté correctamente en la lista.
      ];
}
