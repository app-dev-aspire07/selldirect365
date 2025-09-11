import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final List<String> brands;
  final List<String> models;
  final List<String> colors;
  final Function(Map<String, dynamic>) onApply;

  const FilterScreen({
    super.key,
    required this.brands,
    required this.models,
    required this.colors,
    required this.onApply,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> selectedBrands = [];
  List<String> selectedModels = [];
  List<String> selectedColors = [];
  String? priceSort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedBrands.clear();
                selectedModels.clear();
                selectedColors.clear();
                priceSort = null;
              });
            },
            child: const Text("Clear All"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMultiSection("Brand", widget.brands, selectedBrands),
          const Divider(),
          _buildMultiSection("Model", widget.models, selectedModels),
          const Divider(),
          _buildMultiSection("Color", widget.colors, selectedColors),
          const Divider(),
          _buildSortSection(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            widget.onApply({
              "brands": selectedBrands,
              "models": selectedModels,
              "colors": selectedColors,
              "priceSort": priceSort,
            });
            Navigator.pop(context);
          },
          child: const Text("Apply Filters"),
        ),
      ),
    );
  }

  Widget _buildMultiSection(String title, List<String> options, List<String> selectedList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: -8,
          children: options.map((e) {
            final isSelected = selectedList.contains(e);
            return ChoiceChip(
              label: Text(e),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  if (isSelected) {
                    selectedList.remove(e); // deselect
                  } else {
                    selectedList.add(e); // select
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sort by Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text("Low to High"),
              selected: priceSort == "lowToHigh",
              onSelected: (_) => setState(() => priceSort = "lowToHigh"),
            ),
            ChoiceChip(
              label: const Text("High to Low"),
              selected: priceSort == "highToLow",
              onSelected: (_) => setState(() => priceSort = "highToLow"),
            ),
          ],
        ),
      ],
    );
  }
}
