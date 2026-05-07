import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuProvider with ChangeNotifier {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Snacks',
    'Beverages',
    'Desserts',
  ];

  final List<MenuItem> _allItems = [
    MenuItem(
      id: '1',
      name: 'Masala Dosa',
      description: 'Crispy rice crepe stuffed with spiced potato filling, served with sambar and chutney',
      price: 3500.0,
      category: 'Breakfast',
      imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400',
      isVeg: true,
      rating: 4.5,
      prepTimeMinutes: 12,
      tags: ['popular', 'south indian'],
    ),
    MenuItem(
      id: '2',
      name: 'Veg Sandwich',
      description: 'Grilled sandwich with fresh vegetables, cheese and tangy sauce',
      price: 2500.0,
      category: 'Snacks',
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
      isVeg: true,
      rating: 4.2,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: '3',
      name: 'Chicken Biryani',
      description: 'Aromatic basmati rice cooked with tender chicken and exotic spices',
      price: 8000.0,
      category: 'Lunch',
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400',
      isVeg: false,
      rating: 4.8,
      prepTimeMinutes: 20,
      tags: ['bestseller', 'spicy'],
    ),
    MenuItem(
      id: '4',
      name: 'Cold Coffee',
      description: 'Refreshing iced coffee with creamy froth and chocolate drizzle',
      price: 3000.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
      isVeg: true,
      rating: 4.4,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: '5',
      name: 'Lunch Special',
      description: 'Complete meal with rice, beans, grilled chicken, salad and juice',
      price: 5500.0,
      category: 'Lunch',
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400',
      isVeg: false,
      rating: 4.6,
      prepTimeMinutes: 15,
      tags: ['popular', 'filling'],
    ),
    MenuItem(
      id: '6',
      name: 'Chips (Snack)',
      description: 'Crispy golden fries seasoned with local spices',
      price: 1500.0,
      category: 'Snacks',
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
      isVeg: true,
      rating: 4.3,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: '7',
      name: 'Chocolate Cake',
      description: 'Moist chocolate cake slice with creamy frosting',
      price: 4000.0,
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
      isVeg: true,
      rating: 4.7,
      prepTimeMinutes: 7,
    ),
    MenuItem(
      id: '8',
      name: 'Fresh Juice',
      description: 'Freshly squeezed mango, passion fruit or orange juice',
      price: 2000.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400',
      isVeg: true,
      rating: 4.1,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: '9',
      name: 'Ugali & Beans',
      description: 'Traditional ugali served with stewed beans and greens',
      price: 2500.0,
      category: 'Breakfast',
      imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400',
      isVeg: true,
      rating: 4.4,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: '10',
      name: 'Grilled Chicken',
      description: 'Tender grilled chicken marinated in aromatic spices, served with kachumbari',
      price: 7000.0,
      category: 'Lunch',
      imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400',
      isVeg: false,
      rating: 4.5,
      prepTimeMinutes: 15,
      tags: ['bestseller'],
    ),
    MenuItem(
      id: '11',
      name: 'Mandazi (3 pcs)',
      description: 'Sweet fried dough pastry, a Tanzanian breakfast favourite',
      price: 1500.0,
      category: 'Breakfast',
      imageUrl: 'https://images.unsplash.com/photo-1601303516534-bf4f3303d2ab?w=400',
      isVeg: true,
      rating: 4.6,
      prepTimeMinutes: 3,
    ),
    MenuItem(
      id: '12',
      name: 'Chai (Tea)',
      description: 'Hot spiced milk tea, Tanzanian style',
      price: 1000.0,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400',
      isVeg: true,
      rating: 4.5,
      prepTimeMinutes: 5,
    ),
  ];

  List<MenuItem> get allItems => _allItems;

  List<MenuItem> get filteredItems {
    var items = _allItems;

    if (_selectedCategory != 'All') {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return items;
  }

  List<MenuItem> get popularItems =>
      _allItems.where((item) => item.tags.contains('popular') || item.tags.contains('bestseller')).toList();

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  MenuItem? getItemById(String id) {
    try {
      return _allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}


