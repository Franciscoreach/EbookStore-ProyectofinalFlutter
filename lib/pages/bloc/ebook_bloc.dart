import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyectofinal/model/product_model.dart';
import 'package:uuid/uuid.dart';

part 'ebook_event.dart';
part 'ebook_state.dart';

const homeUrl = "https://ebookstore-4b98b-default-rtdb.firebaseio.com/ebookstore";
const cartUrl = "https://ebookstore-4b98b-default-rtdb.firebaseio.com/ebookstore_cart";
const checkoutUrl = "https://ebookstore-4b98b-default-rtdb.firebaseio.com/ebookstore_checkout";

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  var uuid = const Uuid();
  var dio = Dio();

  EbookBloc() : super(EbookState.initial()) {
    on<LoadTrendingProductsEvent>(_onLoadTrendingProductsEvent);
    on<LoadAllProductsEvent>(_onLoadAllProductsEvent);
    on<LoadFavoriteProductsEvent>(_onLoadFavoriteProductsEvent);
    on<RemoveFavoriteProductEvent>(_onRemoveFavoriteProductEvent);
    on<AddFavoriteProductEvent>(_onAddFavoriteProductEvent);
    on<CreateNewProductsEvent>(_onCreateNewProductsEvent);
    on<UpdateProductEvent>(_onUpdateProductEvent);
    on<RemoveProductItemEvent>(_onRemoveProductItemEvent);
    on<LoadCartItemsEvent>(_onLoadCartItemsEvent);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantityEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
    on<CheckoutEvent>(_onCheckoutEvent);
    on<LoadReadingProductEvent>(_onLoadReadingProductEvent);
    on<UpdateProductReadingEvent>(_onUpdateProductReadingEvent);
    on<LoadMostRecentReadingProductEvent>(_onLoadMostRecentReadingProductEvent);
  }
  

void _onLoadTrendingProductsEvent(LoadTrendingProductsEvent event, Emitter<EbookState> emit) async {

  if (state.homeScreenState == HomeScreenState.loading) {
    return;
  }

  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    final response = await dio.get('$homeUrl.json');
    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(
        state.copyWith(
          homeScreenState: HomeScreenState.success,
          trendingProducts: [],
        ),
      );
      return;
    }

    final trendingProducts = data.entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["name"],
        autor: prod.value["autor"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
        isTrending: prod.value["isTrending"] ?? false,
        isFavorite: prod.value["isFavorite"] ?? false,
      );
    }).where((prod) => prod.isTrending).toList();

    emit(
      state.copyWith(
        homeScreenState: HomeScreenState.success,
        trendingProducts: trendingProducts,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(homeScreenState: HomeScreenState.failure),
    );
  }
}

void _onLoadAllProductsEvent(LoadAllProductsEvent event, Emitter<EbookState> emit) async {
  if (state.homeScreenState == HomeScreenState.loading) {
    return;
  }

  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    final response = await dio.get('$homeUrl.json');
    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(
        state.copyWith(
          homeScreenState: HomeScreenState.success,
          products: [],
        ),
      );
      return;
    }

    final allProducts = data.entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["name"],
        autor: prod.value["autor"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
        isTrending: prod.value["isTrending"] ?? false,
        isFavorite: prod.value["isFavorite"] ?? false,
      );
    }).toList();

    emit(
      state.copyWith(
        homeScreenState: HomeScreenState.success,
        products: allProducts,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(homeScreenState: HomeScreenState.failure),
    );
  }
}

void _onLoadFavoriteProductsEvent(LoadFavoriteProductsEvent event, Emitter<EbookState> emit) async {
  if (state.homeScreenState == HomeScreenState.loading) {
    return;
  }

  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    final response = await dio.get('$homeUrl.json');
    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(
        state.copyWith(
          homeScreenState: HomeScreenState.success,
          favoriteProducts: [],
        ),
      );
      return;
    }

    final favoriteProducts = data.entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["name"],
        autor: prod.value["autor"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
        isFavorite: prod.value["isFavorite"] ?? false,
      );
    }).where((prod) => prod.isFavorite).toList();

    emit(
      state.copyWith(
        homeScreenState: HomeScreenState.success,
        favoriteProducts: favoriteProducts,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(homeScreenState: HomeScreenState.failure),
    );
  }
}

void _onAddFavoriteProductEvent(AddFavoriteProductEvent event, Emitter<EbookState> emit) async {
  final updatedProduct = ProductModel(
    id: event.product.id,
    name: event.product.name,
    autor: event.product.autor,
    price: event.product.price,
    imageUrl: event.product.imageUrl,
    isFavorite: true,
    isTrending: event.product.isTrending,
  );

  final updatedFavorites = List<ProductModel>.from(state.favoriteProducts)..add(updatedProduct);

  emit(state.copyWith(
    favoriteProducts: updatedFavorites,
  ));

  try {
    await dio.patch(
      "$homeUrl/${event.product.id}.json",
      data: {
        "isFavorite": true,
      },
    );
  } catch (e) {
    print('Error updating favorite status: $e');
  }
}

void _onRemoveFavoriteProductEvent(RemoveFavoriteProductEvent event, Emitter<EbookState> emit) async {
  final productIndex = state.favoriteProducts.indexWhere((product) => product.id == event.product.id);

  if (productIndex >= 0) {
    // ignore: unused_local_variable
    final updatedProduct = ProductModel(
      id: event.product.id,
      name: event.product.name,
      autor: event.product.autor,
      price: event.product.price,
      imageUrl: event.product.imageUrl,
      isFavorite: false,
      isTrending: event.product.isTrending,
    );

    final updatedFavorites = List<ProductModel>.from(state.favoriteProducts);
    updatedFavorites.removeAt(productIndex);

    emit(state.copyWith(
      favoriteProducts: updatedFavorites,
    ));

    try {
      await dio.patch(
        "$homeUrl/${event.product.id}.json",
        data: {
          "isFavorite": false,
        },
      );
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }
}

void _onCreateNewProductsEvent(CreateNewProductsEvent event, Emitter<EbookState> emit) async {
  final String prodUID = uuid.v1();

  final data = {
    "id": prodUID,
    "name": event.name,
    "autor": event.autor,
    "image_url": event.imageUrl,
    "price": event.price,
    "is_trending": event.isTrending,
    "is_favorite": event.isFavorite,
  };

  await dio.put("$homeUrl/$prodUID.json", data: data);

  final newProduct = ProductModel(
    id: prodUID,
    name: event.name,
    autor: event.autor,
    price: double.parse(event.price.toString()),
    imageUrl: event.imageUrl,
    isTrending: event.isTrending,
    isFavorite: event.isFavorite,  
  );

  final updateProducts = [...state.products, newProduct];
  emit(state.copyWith(products: updateProducts));
}

void _onUpdateProductEvent(UpdateProductEvent event, Emitter<EbookState> emit) async {
  final productIndex = state.products.indexWhere((product) => product.id == event.productId);

  if (productIndex >= 0) {
    final updatedProduct = ProductModel(
      id: event.productId,
      name: event.name,
      autor: event.autor,
      price: event.price.toDouble(),
      imageUrl: event.imageUrl,
    );

    final updatedMaintainer = List<ProductModel>.from(state.products);
    updatedMaintainer[productIndex] = updatedProduct;

    emit(state.copyWith(products: updatedMaintainer));

    await dio.patch(
      "$homeUrl/${event.productId}.json",
      data: {
        "name": event.name,
        "autor": event.autor,
        "image_url": event.imageUrl,
        "price": event.price,
      },
    );

    add(LoadAllProductsEvent());
  }
}

void _onRemoveProductItemEvent(RemoveProductItemEvent event, Emitter<EbookState> emit) async {
  final productId = event.product.id;
  
  final productIndex = state.products.indexWhere((product) => product.id == productId);

  if (productIndex >= 0) {
    final updatedProducts = state.products.where((product) => product.id != productId).toList();
    
    emit(state.copyWith(products: updatedProducts));

    try {
      await dio.delete("$homeUrl/$productId.json");
    } catch (e) {
      //print("Error occurred while deleting product from Firebase: $e");
    }
  }
}

void _onLoadCartItemsEvent(LoadCartItemsEvent event, Emitter<EbookState> emit) async {
  if (state.cart.isEmpty) {
    try {
      final response = await dio.get('$cartUrl.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null || data.isEmpty) {
        emit(state.copyWith(cart: []));
        return;
      }

      final cartItems = data.entries.map((prod) {
        final product = prod.value;

        final id = product["id"] ?? '';
        final autor = product["autor"] ?? '';
        final name = product["name"] ?? '';
        final price = product["price"] ?? 0.0;
        final imageUrl = product["image_url"] ?? '';
        final quantity = product["quantity"] ?? 1;

        return ProductModel(
          id: id,
          autor: autor,
          name: name,
          price: price,
          imageUrl: imageUrl,
          quantity: quantity,
        );
      }).toList();

      emit(state.copyWith(cart: cartItems));

    } catch (e) {
      //print("Error cargando productos del carrito: $e");
      emit(state.copyWith(cart: []));
    }
  }
}

void _onAddToCartEvent(AddToCartEvent event, Emitter<EbookState> emit) async {
  final ProductModel product = event.product;

  final existItemIndex = state.cart.indexWhere((p) => p.id == product.id);

  if (existItemIndex >= 0) {
    final productItem = state.cart[existItemIndex];
    final newQuantity = productItem.quantity + 1; 

    await dio.patch(
      "$cartUrl/${product.id}.json",
      data: {
        "quantity": newQuantity,
      },
    );

    final updatedCart = [...state.cart];
    updatedCart[existItemIndex] = productItem.copyWith(quantity: newQuantity);

    emit(state.copyWith(cart: updatedCart));
  } else {
    await dio.put(
      "$cartUrl/${product.id}.json",
      data: {
        "id": product.id,
        "name": product.name,
        "autor": product.autor,
        "image_url": product.imageUrl,
        "price": product.price,
        "quantity": 1,
      },
    );

    final updatedCart = [...state.cart, product.copyWith(quantity: 1)];
    emit(state.copyWith(cart: updatedCart));
  }
}

void _onUpdateCartQuantityEvent(UpdateCartQuantityEvent event, Emitter<EbookState> emit) async {
  final ProductModel product = event.product;

  final existItemIndex = state.cart.indexWhere((p) => p.id == product.id);

  if (existItemIndex >= 0) {
    final productItem = state.cart[existItemIndex];
    final newQuantity = productItem.quantity + event.newQty;

    if (newQuantity >= 1) {
      await dio.patch(
        "$cartUrl/${product.id}.json",
        data: {"quantity": newQuantity},
      );

      final updatedCart = [...state.cart];
      updatedCart[existItemIndex] = productItem.copyWith(quantity: newQuantity);

      emit(state.copyWith(cart: updatedCart));
    }
  }
}

void _onRemoveCartItemEvent(RemoveCartItemEvent event, Emitter<EbookState> emit) async {
  final ProductModel product = event.product;

  try {
    final response = await dio.delete("$cartUrl/${product.id}.json");

    if (response.statusCode == 200) {
      final updatedCart = state.cart.where((p) => p.id != event.product.id).toList();
      
      emit(state.copyWith(cart: updatedCart));
    } else {
      print('Error al eliminar el producto del carrito: ${response.statusCode}');
    }
  } catch (e) {
    print('Error en la solicitud: $e');
  }
}

void _onCheckoutEvent(CheckoutEvent event, Emitter<EbookState> emit) async {
  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    for (var product in event.cartItems) {
      final data = {
        "id": product.id,
        "name": product.name,
        "autor": product.autor,
        "price": product.price,
        "image_url": product.imageUrl,
        "quantity": product.quantity,
        "isReading": false,
        "readDate": DateTime.now().toIso8601String(),
      };

      await dio.post('$checkoutUrl.json', data: data);
    }

    for (var product in event.cartItems) {
      await dio.delete("$cartUrl/${product.id}.json");
    }

    emit(state.copyWith(cart: []));

    emit(state.copyWith(homeScreenState: HomeScreenState.success));
  } catch (e) {
    print("Error during checkout: $e");
    emit(state.copyWith(homeScreenState: HomeScreenState.failure));
  }
}

void _onLoadReadingProductEvent(LoadReadingProductEvent event, Emitter<EbookState> emit) async {
  if (state.homeScreenState == HomeScreenState.loading) {
    return;
  }

  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    final response = await dio.get('$checkoutUrl.json');
    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(
        state.copyWith(
          homeScreenState: HomeScreenState.success,
          readingProducts: [],
        ),
      );
      return;
    }

    final readProducts = data.entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["name"],
        autor: prod.value["autor"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
        isTrending: prod.value["isTrending"] ?? false,
        isFavorite: prod.value["isFavorite"] ?? false,
        isReading: prod.value["isReading"] ?? false, // Aseguramos que este valor sea tomado de la API
        readDate: prod.value["readDate"] != null ? DateTime.parse(prod.value["readDate"]) : null,
      );
    }).toList();

    emit(
      state.copyWith(
        homeScreenState: HomeScreenState.success,
        readingProducts: readProducts,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(homeScreenState: HomeScreenState.failure),
    );
  }
}



void _onUpdateProductReadingEvent(UpdateProductReadingEvent event, Emitter<EbookState> emit) async {
  final readDate = DateTime.parse(event.readDate);

  // Buscar y actualizar en `products`
  final productIndex = state.products.indexWhere((product) => product.id == event.productId);
  if (productIndex >= 0) {
    final updatedProducts = [...state.products];
    updatedProducts[productIndex] = updatedProducts[productIndex].copyWith(
      isReading: event.isReading,
      readDate: readDate,
    );
    emit(state.copyWith(products: updatedProducts));
  }

  // Buscar y actualizar en `readingProducts`
  final readingProductIndex = state.readingProducts.indexWhere((product) => product.id == event.productId);
  if (readingProductIndex >= 0) {
    final updatedReadingProducts = [...state.readingProducts];
    updatedReadingProducts[readingProductIndex] = updatedReadingProducts[readingProductIndex].copyWith(
      isReading: event.isReading,
      readDate: readDate,
    );
    emit(state.copyWith(readingProducts: updatedReadingProducts));
  }

  // Enviar actualización al backend
  await dio.patch(
    "$checkoutUrl/${event.productId}.json",
    data: {
      "isReading": event.isReading,
      "readDate": readDate.toIso8601String(),
    },
  );
}



void _onLoadMostRecentReadingProductEvent(
  LoadMostRecentReadingProductEvent event, 
  Emitter<EbookState> emit,
) async {
  if (state.homeScreenState == HomeScreenState.loading) {
    return;
  }

  emit(state.copyWith(homeScreenState: HomeScreenState.loading));

  try {
    // Realizamos la solicitud HTTP para obtener los productos desde Firebase (suponiendo que usas Firebase Realtime Database)
    final response = await dio.get('$checkoutUrl.json');

    final data = response.data as Map<String, dynamic>?;

    if (data == null) {
      emit(
        state.copyWith(
          homeScreenState: HomeScreenState.success,
          mostRecentReadingProduct: [],  // Si no hay datos, retornamos una lista vacía
        ),
      );
      return;
    }

    // Filtramos los productos que están siendo leídos
    final mostRecentReadingProduct = data.entries
        .map((prod) {
          return ProductModel(
            id: prod.key,
            name: prod.value["name"],
            autor: prod.value["autor"],
            price: double.parse(prod.value["price"].toString()),
            imageUrl: prod.value["image_url"],
            isReading: prod.value["isReading"] ?? false,
            readDate: DateTime.parse(prod.value["readDate"]), // Asegúrate que readDate sea un string válido
          );
        })
        .where((prod) => prod.isReading) // Filtramos solo los productos que están siendo leídos
        .toList();

    // Ordenamos los productos por la fecha de lectura más reciente
    mostRecentReadingProduct.sort((a, b) => b.readDate!.compareTo(a.readDate!));

    emit(
      state.copyWith(
        homeScreenState: HomeScreenState.success,
        mostRecentReadingProduct: mostRecentReadingProduct, // Actualizamos el estado con los productos filtrados y ordenados
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(homeScreenState: HomeScreenState.failure),
    );
  }
}


}

  