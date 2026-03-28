import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify_app/main.dart'; // For mainGradient, primaryBlue, primaryPink
import 'package:trackify_app/providers/expense_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the ExpenseProvider for real-time data updates
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // Calculate balances
    double income = expenseProvider.transactions
        .where((tx) => tx.amount > 0)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    
    double expenses = expenseProvider.transactions
        .where((tx) => tx.amount < 0)
        .fold(0.0, (sum, tx) => sum + tx.amount.abs());
        
    double netBalance = income - expenses;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. Balance Overview Card ---
          _buildBalanceCard(context, netBalance, income, expenses),

          const SizedBox(height: 30),
          
          // --- 2. Recent Transactions Header ---
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // --- 3. Transaction List (Uses Dismissible cards for swipe-to-delete) ---
          expenseProvider.transactions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      'No transactions yet. Add your first expense!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              : Column(
                  children: expenseProvider.transactions
                      // Use the new builder function to wrap each card in Dismissible
                      .map((tx) => _buildDismissibleTransactionCard(context, tx, expenseProvider))
                      .toList(),
                ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- NEW: Dismissible Wrapper for Swipe-to-Delete ---
  Widget _buildDismissibleTransactionCard(
      BuildContext context, Transaction tx, ExpenseProvider provider) {
    return Dismissible(
      key: ValueKey(tx.id), // Unique key is mandatory
      direction: DismissDirection.endToStart, // Only swipe left to dismiss
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // You can add a confirmation dialog here if you wish
        return true; 
      },
      onDismissed: (direction) {
        // Call the delete method on the provider
        provider.deleteTransaction(tx.id);

        // Show a snackbar confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tx.name} deleted.', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: _buildTransactionCard(context, tx),
    );
  }

  // --- Existing Widget Builders ---

  Widget _buildBalanceCard(
      BuildContext context, double balance, double income, double expenses) {
    
    // Determine balance color
    Color balanceColor = balance >= 0 ? Colors.white : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: mainGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryPink.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: balanceColor, 
              fontSize: 36,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(1, 1),
                ),
              ]
            ),
          ),
          const Divider(color: Colors.white30, height: 30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income Column
              _buildMetricColumn(
                icon: Icons.arrow_upward,
                label: 'Income',
                amount: income,
                color: Colors.greenAccent.shade400,
              ),
              
              // Expenses Column
              _buildMetricColumn(
                icon: Icons.arrow_downward,
                label: 'Expenses',
                amount: expenses,
                color: Colors.redAccent.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(
      {required IconData icon,
      required String label,
      required double amount,
      required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction tx) {
    final isExpense = tx.amount < 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // Uses the correct color from the Transaction object
            color: tx.color.withOpacity(0.1), 
            borderRadius: BorderRadius.circular(12),
          ),
          // Uses the correct icon from the Transaction object
          child: Icon(tx.icon, color: tx.color, size: 24), 
        ),
        title: Text(
          tx.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          tx.category,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}\$${tx.amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isExpense ? Colors.redAccent : Colors.green,
          ),
        ),
      ),
    );
  }
}