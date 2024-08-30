import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

enum Category {
  electronics,
  jewelry,
  menClothing,
  womenClothing,
  books,
  homeAndGarden,
  sportsAndOutdoors,
  toysAndGames,
}

Future<void> addExampleProducts() async {
  final firestore = FirebaseFirestore.instance;
  final random = Random();
  final imageUrls = [
    'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
    'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
    'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
    'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg',
    'https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg',
    'https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg',
    'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
    'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
    'https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_.jpg',
    'https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_.jpg',
    'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
    'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg',
    'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg',
    'https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_.jpg',
  ];

  final productNames = [
    'Wireless Earbuds',
    'Smartphone Stand',
    'Leather Belt',
    'Yoga Mat',
    'Cooking Utensils Set',
    'Bluetooth Speaker',
    'Running Shoes',
    'Sunglasses',
    'Backpack',
    'Smartwatch',
    'Digital Camera',
    'Coffee Maker',
    'Electric Kettle',
    'Laptop Sleeve',
    'Gaming Mouse',
    'Travel Pillow',
    'Portable Charger',
    'Fitness Band',
    'Bluetooth Headset',
    'Book Light'
  ];

  final productDescriptions = [
    'High-quality product with modern design.',
    'Lightweight and durable for everyday use.',
    'Crafted with precision for long-lasting performance.',
    'Designed for comfort and style.',
    'Perfect for daily activities and special occasions.',
    'Made with premium materials for durability.',
    'Ideal for home, office, or on the go.',
    'Enhances your experience with cutting-edge technology.',
    'A must-have accessory for modern living.',
    'Combines functionality with sleek design.',
  ];

  for (int i = 0; i < 500; i++) {
    final id = const Uuid().v4();
    final name = productNames[random.nextInt(productNames.length)];
    final description =
        productDescriptions[random.nextInt(productDescriptions.length)];
    final price = (random.nextDouble() * 200 + 10).toStringAsFixed(2);
    final category = Category.values[random.nextInt(Category.values.length)]
        .toString()
        .split('.')
        .last;
    final imageUrl = imageUrls[random.nextInt(imageUrls.length)];

    await firestore.collection('products').doc(id).set({
      'id': id,
      'name': name,
      'description': description,
      'price': double.parse(price),
      'category': category,
      'imageUrl': imageUrl,
    });
  }

  print('Added 100 example products to Firestore.');
}
