import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/features/product/presentation/pages/product_details_page.dart';
import 'package:product_catalog/layout/home_page.dart';
import 'package:uuid/uuid.dart';
import 'package:product_catalog/features/product/domain/entities/categories.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? productToEdit;
  const AddEditProductPage({super.key, this.productToEdit});

  static route({Product? productToEdit}) => MaterialPageRoute(
      builder: (context) => AddEditProductPage(productToEdit: productToEdit));

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late Category _selectedCategory;
  File? _imageFile;
  bool get _isEditing => widget.productToEdit != null;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.productToEdit?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.productToEdit?.description ?? '');
    _priceController = TextEditingController(
        text: widget.productToEdit?.price.toString() ?? '');
    _selectedCategory = widget.productToEdit?.category != null
        ? Category.values.firstWhere(
            (e) =>
                e.toString().split('.').last == widget.productToEdit!.category,
            orElse: () => Category.electronics)
        : Category.electronics;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add New Product',
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImagePicker()
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 100.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 24),
                            _buildInputField(
                              controller: _nameController,
                              label: 'Product Name',
                              hintText: 'Enter product name',
                              icon: Icons.shopping_bag,
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 16),
                            _buildCategoryDropdown()
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 300.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _descriptionController,
                              label: 'Description',
                              hintText: 'Enter product description',
                              maxLines: 3,
                              icon: Icons.description,
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 400.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 24),
                            Text('Price',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold))
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 500.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _priceController,
                              label: 'Price',
                              hintText: 'NGN 0.00',
                              keyboardType: TextInputType.number,
                              icon: Icons.currency_exchange,
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 32),
                            BlocConsumer<ProductBloc, ProductState>(
                              listener: (context, state) {
                                if (state is AddingProductSuccess) {
                                  Navigator.of(context).push(
                                      ProductDetailsPage.route(state.product));
                                }

                                if (state is UpdatingProductSuccess) {
                                  Navigator.of(context).push(
                                      ProductDetailsPage.route(state.product));
                                }
                                if (state is ErrorState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)));
                                }
                              },
                              builder: (context, state) {
                                return state is AddingProduct ||
                                        state is UpdatingProduct
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Text(
                                            _isEditing
                                                ? 'Update Product'
                                                : 'Add Product',
                                            style:
                                                const TextStyle(fontSize: 18)),
                                      )
                                        .animate()
                                        .fadeIn(duration: 600.ms, delay: 700.ms)
                                        .slideY(begin: 0.2, end: 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
                child: Image.file(_imageFile!, fit: BoxFit.cover)
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .shimmer(
                        duration: 1500.ms,
                        color: Colors.white.withOpacity(0.3)),
              )
            : widget.productToEdit?.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(widget.productToEdit!.imageUrl,
                            fit: BoxFit.cover)
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .shimmer(
                            duration: 1500.ms,
                            color: Colors.white.withOpacity(0.3)),
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
                  )
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .shimmer(
                        duration: 1500.ms,
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to pick image')));
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.productToEdit?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        category: _selectedCategory.toString().split('.').last,
        imageUrl: widget.productToEdit?.imageUrl ?? '',
        localImageUrl: '',
      );

      if (_isEditing) {
        BlocProvider.of<ProductBloc>(context)
            .add(UpdateProductEvent(product: product));
      } else if (_imageFile != null) {
        BlocProvider.of<ProductBloc>(context).add(AddProductEvent(
          imageFile: _imageFile!,
          product: product,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image')));
        return;
      }

      // Clear controllers after successful submission
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _imageFile = null;
      });
    }
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Category>(
          value: _selectedCategory,
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.category, color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
          items: Category.values.map((Category category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(category.toString().split('.').last),
            );
          }).toList(),
          onChanged: (Category? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ],
    );
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
            if (label == 'Price' && double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }

            return null;
          },
        ),
      ],
    );
  }
}
