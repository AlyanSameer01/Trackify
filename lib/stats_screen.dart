import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math; 
import 'package:trackify_app/main.dart'; // Import custom gradient
import 'package:trackify_app/providers/expense_provider.dart'; // Logic for transactions

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // Helper function to get bar groups for the chart
  List<BarChartGroupData> _getBarGroups(List<Transaction> transactions) {
    Map<String, double> expenseTotals = {};

    for (var tx in transactions) {
      // Only chart expenses (negative amounts)
      if (tx.amount < 0) {
        // Use the absolute value of the expense
        expenseTotals.update(
          tx.name, 
          (value) => value + tx.amount.abs(), 
          ifAbsent: () => tx.amount.abs(),
        );
      }
    }

    // Convert map to BarChartGroupData
    final categories = expenseTotals.keys.toList();
    
    return List.generate(categories.length, (index) {
      double total = expenseTotals[categories[index]] ?? 0.0;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            // Use the custom gradient defined in main.dart
            gradient: mainGradient,
            width: 15,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              // Set the maximum height based on the largest expense group for better scaling
              toY: expenseTotals.values.isNotEmpty 
                  ? expenseTotals.values.reduce((a, b) => a > b ? a : b) * 1.2 
                  : 100, 
              color: Colors.grey.withAlpha((0.1 * 255).round()),
            ),
          ),
        ],
      );
    });
  }

  // Helper function to show category labels at the bottom of the chart (X-axis)
  Widget _getBottomTitles(BuildContext context, double value, TitleMeta meta, List<String> categories) {
    final style = TextStyle(
      color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12, 
    );
    
    if (value.toInt() >= 0 && value.toInt() < categories.length) {
      String text = categories[value.toInt()];
      
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        // FIX: Rotate the text by -45 degrees (M_PI / 4) to prevent overlap
        child: Transform.rotate(
          angle: -math.pi / 4, // Rotate by -45 degrees
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0), // Add padding after rotation
            child: Text(
              text, 
              style: style, 
              textAlign: TextAlign.right,
              maxLines: 1, 
              overflow: TextOverflow.ellipsis, 
            ),
          ),
        ),
      );
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 10, child: const Text(''));
  }

  // Helper function to format amount labels on the Y-axis
  Widget _getLeftTitles(BuildContext context, double value, TitleMeta meta) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final style = TextStyle(
      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    String text;
    if (value >= 1000000) {
      // Millions format (e.g., 1.5M)
      text = '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      // Thousands format (e.g., 10.5K)
      text = '\$${(value / 1000).toStringAsFixed(1)}K';
    } else if (value > 0 && value < 1000) {
      // Small numbers (e.g., 200)
      text = '\$${value.toStringAsFixed(0)}';
    } else {
      // Zero or other cases
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10, // Space between the label and the chart grid line
      child: Text(text, style: style, textAlign: TextAlign.right),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final barGroups = _getBarGroups(expenseProvider.transactions);
    
    // Safely extract the base color for grid lines and subtitle
    final bodyColor = Theme.of(context).textTheme.bodyMedium?.color;
    final gridLineColor = bodyColor ?? Colors.grey;

    // Calculate category names (same logic as before)
    final categories = barGroups
        .map((group) {
          int index = group.x;
          Map<String, double> expenseTotals = {};
          for (var tx in expenseProvider.transactions) {
            if (tx.amount < 0) {
              expenseTotals.update(tx.name, (value) => value + tx.amount.abs(), ifAbsent: () => tx.amount.abs());
            }
          }
          final sortedCategories = expenseTotals.keys.toList();
          return index < sortedCategories.length ? sortedCategories[index] : '';
        })
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Spending Analysis", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          
          // FIX: Subtitle color is now set safely
          Text(
            "Overview of your expenses by category.", 
            style: TextStyle(
              color: bodyColor != null 
                ? bodyColor.withAlpha((0.6 * 255).round()) 
                : Colors.grey.shade600,
            )
          ),
          const SizedBox(height: 30),

          // --- Bar Chart ---
          SizedBox(
            height: 350, // Increased height slightly to accommodate the rotated labels
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0), 
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: barGroups.isNotEmpty 
                        ? (barGroups.map((e) => e.barRods.first.toY).reduce((a, b) => a > b ? a : b)) * 1.2
                        : 100,
                    
                    // Show titles on the X-axis (categories) and Y-axis (amount)
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 70, // X-axis space for rotated text
                          getTitlesWidget: (value, meta) => _getBottomTitles(context, value, meta, categories),
                        ),
                      ),
                      leftTitles: AxisTitles( 
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50, 
                          // Interval dynamically set to 1/4th of the max Y value for clean ticks
                          interval: barGroups.isNotEmpty 
                            ? (barGroups.map((e) => e.barRods.first.toY).reduce((a, b) => a > b ? a : b) * 1.2) / 4 
                            : 20, 
                          getTitlesWidget: (value, meta) => _getLeftTitles(context, value, meta), // Formatted K/M labels
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          // FIX: Using the guaranteed non-null gridLineColor
                          color: gridLineColor.withAlpha((0.1 * 255).round()),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    
                    borderData: FlBorderData(show: false),
                    barGroups: barGroups.isEmpty ? [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0)])
                    ] : barGroups,
                    
                    // Add interactivity placeholder
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String categoryName = categories[groupIndex];
                          String amount = '\$${rod.toY.toStringAsFixed(2)}';
                          return BarTooltipItem(
                            '$categoryName\n',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: amount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // --- Top Categories List ---
          const Text(
            'Top Expense Categories', 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          
          // Reusing the transaction list style for a clean look
          ...expenseProvider.transactions
              .where((tx) => tx.amount < 0)
              .take(3) // Only show the top 3 categories (or recent 3 expenses)
              .map((transaction) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.color.withAlpha((0.2 * 255).round()),
                    child: Icon(transaction.icon, color: transaction.color),
                  ),
                  title: Text(transaction.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(
                    '-\$${transaction.amount.abs().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}