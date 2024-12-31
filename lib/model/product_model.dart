import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String autor;
  final double price;
  final String imageUrl;
  final int quantity;
  final bool isTrending;
  final bool isFavorite;
  final bool isReading; 
  final DateTime? readDate;

  const ProductModel({
    required this.id,
    required this.name,
    required this.autor,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isTrending = false,
    this.isFavorite = false,
    this.isReading = false,
    this.readDate,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? autor,
    double? price,
    String? imageUrl,
    int? quantity,
    bool? isTrending,
    bool? isFavorite,
    bool? isReading,
    DateTime? readDate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      autor: autor ?? this.autor,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      isTrending: isTrending ?? this.isTrending,
      isFavorite: isFavorite ?? this.isFavorite,
      isReading: isReading ?? this.isReading,
      readDate: readDate ?? this.readDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        autor,
        price,
        imageUrl,
        quantity,
        isTrending,
        isFavorite,
        isReading,
        readDate,
      ];
}
