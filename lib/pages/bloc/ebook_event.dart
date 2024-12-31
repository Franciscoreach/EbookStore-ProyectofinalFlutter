part of 'ebook_bloc.dart';

sealed class EbookEvent extends Equatable {
  const EbookEvent();

  @override
  List<Object> get props => [];
}

class LoadTrendingProductsEvent extends EbookEvent {}

class LoadAllProductsEvent extends EbookEvent {}

class LoadFavoriteProductsEvent extends EbookEvent {}

class RemoveFavoriteProductEvent extends EbookEvent {
  final ProductModel product;

  const RemoveFavoriteProductEvent({required this.product});
}

class AddFavoriteProductEvent extends EbookEvent {
  final ProductModel product;

  const AddFavoriteProductEvent({required this.product});
}

class CreateNewProductsEvent extends EbookEvent {
  final String name;
  final String autor;
  final String imageUrl;
  final int price;
  final bool isTrending;
  final bool isFavorite;

  const CreateNewProductsEvent({
    required this.name,
    required this.autor,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
    this.isTrending = false,
  });

}

class UpdateProductEvent extends EbookEvent {
  final String productId; 
  final String name;
  final String autor;
  final String imageUrl;
  final int price;


  const UpdateProductEvent({
    required this.productId,
    required this.name,
    required this.autor,
    required this.imageUrl,
    required this.price,
  });

}

class RemoveProductItemEvent extends EbookEvent {
  final ProductModel product;
  const RemoveProductItemEvent({required this.product});
}

//Carrito

class LoadCartItemsEvent extends EbookEvent {}

class AddToCartEvent extends EbookEvent {
  final ProductModel product;

  const AddToCartEvent({required this.product});
}

class UpdateCartQuantityEvent extends EbookEvent {
  final ProductModel product;
  final int newQty;

  const UpdateCartQuantityEvent({required this.product, required this.newQty});
}

class RemoveCartItemEvent extends EbookEvent {
  final ProductModel product;
  const RemoveCartItemEvent({required this.product});
}


class CheckoutEvent extends EbookEvent {
  final List<ProductModel> cartItems;

  const CheckoutEvent({required this.cartItems});
}


// Reading 

class LoadReadingProductEvent extends EbookEvent {}


class UpdateProductReadingEvent extends EbookEvent {
  final String productId;
  final bool isReading; 
  final String readDate;

  const UpdateProductReadingEvent({
    required this.productId,
    required this.isReading,
    required this.readDate,
  });
}

class LoadMostRecentReadingProductEvent extends EbookEvent {}
