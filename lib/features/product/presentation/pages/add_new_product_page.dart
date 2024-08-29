import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';
import 'package:product_catalog/layout/home_page.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewProductPage());

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _nameController,
                      label: 'Product Name',
                      hintText: 'Enter product name',
                      icon: Icons.shopping_bag,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _categoryController,
                      label: 'Category',
                      hintText: 'Enter product category',
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Enter product description',
                      maxLines: 3,
                      icon: Icons.description,
                    ),
                    const SizedBox(height: 24),
                    Text('Price',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: _priceController,
                      label: 'Price',
                      hintText: '\$0.00',
                      keyboardType: TextInputType.number,
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 32),
                    BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        if (state is AddingProductSuccessState) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsPage(product: state.product),
                          ));
                        }
                      },
                      builder: (context, state) {
                        return state is AddingProductState
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Add Product',
                                    style: TextStyle(fontSize: 18)),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_imageFile!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      size: 50, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 8),
                  Text('Add Product Image',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final tempDir = await getApplicationDocumentsDirectory();
        final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
        final safeFile = File('${tempDir.path}/$uniqueFileName.jpg');
        await safeFile.writeAsBytes(await pickedFile.readAsBytes());
        setState(() => _imageFile = safeFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to pick image')));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      BlocProvider.of<ProductBloc>(context).add(AddProductEvent(
        imageFile: _imageFile!,
        product: Product(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _categoryController.text,
          id: '',
          imageUrl: '',
          localImageUrl: '',
        ),
      ));
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter $label';
            if (label == 'Price' && double.tryParse(value) == null)
              return 'Please enter a valid number';
            return null;
          },
        ),
      ],
    );
  }
}
