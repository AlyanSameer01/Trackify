// add_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify_app/main.dart'; // For colors
import 'package:trackify_app/providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  // State for category and date
  DateTime _selectedDate = DateTime.now();
  // Initialize with the first available category name
  String _selectedCategory = availableCategories.first.name; 
  
  // By default, assume it's an expense (negative amount). User can change the sign.
  bool _isIncome = false;
  
  

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // --- Date Picker Function ---
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryPink, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // --- Submit Logic ---
  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final enteredAmount = double.tryParse(_amountController.text);
      if (enteredAmount == null || enteredAmount <= 0) {
        // Handle invalid amount input
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive amount.')),
        );
        return;
      }

      // Convert amount to negative if it's an expense
      final amountToSave = _isIncome ? enteredAmount : -enteredAmount;

      Provider.of<ExpenseProvider>(context, listen: false).addTransaction(
        name: _nameController.text.trim(),
        amount: amountToSave,
        category: _selectedCategory,
        date: _selectedDate,
      );

      // Show success message and navigate back to Home/Dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} added successfully!', style: const TextStyle(color: Colors.white)),
          backgroundColor: primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Transaction'),
        backgroundColor: Colors.transparent,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Transaction Type Toggle (Income/Expense)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                    selected: !_isIncome,
                    selectedColor: primaryPink.withOpacity(0.8),
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      setState(() {
                        _isIncome = !selected;
                      });
                    },
                  ),
                  const SizedBox(width: 15),
                  ChoiceChip(
                    label: const Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
                    selected: _isIncome,
                    selectedColor: Colors.green.withOpacity(0.8),
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (selected) {
                      setState(() {
                        _isIncome = selected;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 2. Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Title / Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.receipt_long, color: primaryBlue),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Amount Input
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (\$)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.monetization_on, color: primaryPink),
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid amount.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. Category Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category, color: primaryBlue),
                    contentPadding: EdgeInsets.zero,
                  ),
                  value: _selectedCategory,
                  items: availableCategories.map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Row(
                        children: [
                          Icon(category.icon, color: category.color),
                          const SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 5. Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${
                      _selectedDate.day.toString().padLeft(2, '0')
                    }/${
                      _selectedDate.month.toString().padLeft(2, '0')
                    }/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_today, color: primaryPink),
                    label: const Text('Pick Date', style: TextStyle(color: primaryPink)),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 6. Submit Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: mainGradient,
                  boxShadow: [
                    BoxShadow(
                      color: primaryPink.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Use gradient background
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'ADD TRANSACTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}