import 'package:flutter/material.dart';

// --- 1. Category Mapping Definition ---
class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});
}

// Global list of predefined categories
final List<Category> availableCategories = [
  
  // Core Categories (Items 1-9)
      Category(name: 'Shopping', icon: Icons.shopping_cart, color: Colors.purple),
   Category(name: 'Food & Drinks', icon: Icons.restaurant, color: Colors.orange),
   Category(name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
   Category(name: 'Salary', icon: Icons.attach_money, color: Colors.green),
   Category(name: 'Entertainment', icon: Icons.movie, color: Colors.pink),
   Category(name: 'Health', icon: Icons.local_hospital, color: Colors.red),
   Category(name: 'Education', icon: Icons.school, color: Colors.teal), 
   Category(name: 'Utilities', icon: Icons.lightbulb, color: Colors.brown),
   Category(name: 'Investment', icon: Icons.trending_up, color: Colors.indigo),

  // Expanded Categories (Items 10-35)
   Category(name: 'Fitness & Gym', icon: Icons.fitness_center, color: Colors.cyan),
   Category(name: 'Rent & Housing', icon: Icons.home, color: Colors.deepOrange),
   Category(name: 'Travel', icon: Icons.flight, color: Colors.lightBlue),
   Category(name: 'Clothing', icon: Icons.checkroom, color: Colors.deepPurple),
   Category(name: 'Groceries', icon: Icons.local_grocery_store, color: Colors.amber),
   Category(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.yellow),
   Category(name: 'Insurance', icon: Icons.security, color: Colors.green),
   Category(name: 'Taxes', icon: Icons.account_balance, color: Colors.grey),
   Category(name: 'Personal Care', icon: Icons.spa, color: Colors.pinkAccent),
   Category(name: 'Pets', icon: Icons.pets, color: Colors.lime),
   Category(name: 'Hobbies', icon: Icons.extension, color: Colors.brown),
   Category(name: 'Subscriptions', icon: Icons.subscriptions, color: Colors.blueGrey),
   Category(name: 'Technology', icon: Icons.devices_other, color: Colors.black),
   Category(name: 'Home Repair', icon: Icons.construction, color: Colors.blueGrey),
   Category(name: 'Childcare', icon: Icons.child_care, color: Colors.deepOrangeAccent),
   Category(name: 'Books', icon: Icons.menu_book, color: Colors.brown),
   Category(name: 'Bank Fees', icon: Icons.paid, color: Colors.redAccent),
   Category(name: 'Loans', icon: Icons.handshake, color: Colors.indigoAccent),
   Category(name: 'Internet', icon: Icons.wifi, color: Colors.blueAccent),
   Category(name: 'Mobile Bill', icon: Icons.phone_android, color: Colors.tealAccent),
   Category(name: 'Fuel', icon: Icons.local_gas_station, color: Colors.orangeAccent),
   Category(name: 'Parking', icon: Icons.local_parking, color: Colors.blueGrey),
   Category(name: 'Maintenance', icon: Icons.build, color: Colors.grey),
   Category(name: 'Donations', icon: Icons.volunteer_activism, color: Colors.lightGreen),
   Category(name: 'Retirement', icon: Icons.elderly, color: Colors.amber),
   Category(name: 'Miscellaneous', icon: Icons.category, color: Colors.blueGrey),

  // Add more as needed
];
// --- End Category Mapping ---


class Transaction {
  final String id;
  final String name;
  final double amount;
  final String category; 
  final DateTime date;

  // These properties are calculated based on the category string
  final IconData icon; 
  final Color color;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  }) : 
    // Lookup logic: Find the category or default to the first one ('Shopping')
    icon = availableCategories.firstWhere(
      (cat) => cat.name == category, 
      orElse: () => availableCategories.first, 
    ).icon,
    color = availableCategories.firstWhere(
      (cat) => cat.name == category, 
      orElse: () => availableCategories.first,
    ).color;
}

class ExpenseProvider with ChangeNotifier {
  // Initial demo data (updated to use new Category names and test Education)
  final List<Transaction> _transactions = [
    Transaction(
      id: '${DateTime.now().millisecondsSinceEpoch}1',
      name: 'Salary Deposit',
      amount: 4500.00,
      category: 'Salary', 
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: '${DateTime.now().millisecondsSinceEpoch}2',
      name: 'Coffee Shop',
      amount: -4.50,
      category: 'Food & Drinks', 
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Transaction(
      id: '${DateTime.now().millisecondsSinceEpoch}3',
      name: 'New Shoes',
      amount: -75.99,
      category: 'Shopping', 
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: '${DateTime.now().millisecondsSinceEpoch}4',
      name: 'University Fees',
      amount: -850.00,
      category: 'Education', 
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  List<Transaction> get transactions => _transactions;

  void addTransaction({
    required String name,
    required double amount,
    required String category,
    required DateTime date,
  }) {
    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      category: category,
      date: date,
    );
    _transactions.add(newTransaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  // --- NEW: Delete Transaction Method for Swipe-to-Delete ---
  void deleteTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }
}