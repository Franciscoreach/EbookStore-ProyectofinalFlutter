import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectofinal/pages/bloc/ebook_bloc.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class AddProductPage extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? productAutor;
  final double? productPrice;
  final String? productImageUrl;
  final bool isEdit;

  const AddProductPage({
    super.key,
    this.productId,
    this.productName,
    this.productAutor,
    this.productPrice,
    this.productImageUrl,
    this.isEdit = false, 
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _nameController.text = widget.productName ?? '';
      _autorController.text = widget.productAutor ?? '';
      _priceController.text = widget.productPrice?.toString() ?? '';
      _imageUrlController.text = widget.productImageUrl ?? '';
    }
  }

  void _saveProduct(BuildContext context) {
    final name = _nameController.text;
    final autor = _autorController.text;
    final price = _priceController.text;
    final imageUrl = _imageUrlController.text;

    if (name.isEmpty || autor.isEmpty || price.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son requeridos.')),
      );
      return;
    }

    if (widget.isEdit) {
      context.read<EbookBloc>().add(UpdateProductEvent(
        productId: widget.productId!,
        name: name,
        autor: autor,
        price: int.tryParse(price) ?? 0,
        imageUrl: imageUrl,
      ));
    } else {
      context.read<EbookBloc>().add(CreateNewProductsEvent(
        name: name,
        autor: autor,
        price: int.tryParse(price) ?? 0, 
        imageUrl: imageUrl, 
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto guardado exitosamente.')),
    );

    _nameController.clear();
    _autorController.clear();
    _priceController.clear();
    _imageUrlController.clear();

    Navigator.pop(context); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _autorController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Book' : 'New Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name of the Book',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _autorController,
              decoration: const InputDecoration(
                labelText: 'Name of the Author',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL of the image',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _saveProduct(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.orange,
              ),
              child: Text('Save Book', 
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
