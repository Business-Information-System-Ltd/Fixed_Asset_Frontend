import 'dart:async';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final double? minWidth;
  final double? maxWidth;
  final double? flex;
  final String? initialValue;

  const CustomSearchBar({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search...',
    this.minWidth = 300,
    this.maxWidth,
    this.flex,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text when parent passes new initialValue
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double responsiveWidth = constraints.maxWidth * 0.5;

        if (widget.minWidth != null && responsiveWidth < widget.minWidth!) {
          responsiveWidth = widget.minWidth!;
        }
        if (widget.maxWidth != null && responsiveWidth > widget.maxWidth!) {
          responsiveWidth = widget.maxWidth!;
        }

        return Container(
          constraints: BoxConstraints(
            minWidth: widget.minWidth ?? 0,
            maxWidth: widget.maxWidth ?? double.infinity,
          ),
          width: responsiveWidth,
          child: _buildTextField(),
        );
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        isDense: true,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onSearch('');
                },
              )
            : null,
      ),
      onChanged: _onSearchChanged,
    );
  }
}

class SearchUtils {
  static bool matchesSearchWip(Wip wip, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return wip.wipCode.toLowerCase().contains(lowerQuery) ||
        wip.projectName.toLowerCase().contains(lowerQuery) ||
        wip.description.toLowerCase().contains(lowerQuery) ||
        wip.status.toLowerCase().contains(lowerQuery) ||
        DateFormat('yyyy-MM-dd').format(wip.startDate).contains(lowerQuery) ||
        DateFormat('yyyy-MM-dd').format(wip.endDate).contains(lowerQuery) ||
        wip.totalAmount.toString().contains(lowerQuery) ||
        wip.currency.toLowerCase().contains(lowerQuery);
  }

  static bool matchesSearchWipItem(WipItem item, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return item.itemCode.toLowerCase().contains(lowerQuery) ||
        item.itemName.toLowerCase().contains(lowerQuery) ||
        item.costType.toLowerCase().contains(lowerQuery) ||
        item.description.toLowerCase().contains(lowerQuery) ||
        item.quantity.toString().contains(lowerQuery) ||
        item.unitCost.toString().contains(lowerQuery) ||
        item.totalCost.toString().contains(lowerQuery) ||
        item.currency.toLowerCase().contains(lowerQuery);
  }

  static bool matchesSearchAsset(FixedAssets asset, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return asset.fixedAssetCode.toLowerCase().contains(lowerQuery) ||
        asset.sourceType.toLowerCase().contains(lowerQuery) ||
        asset.assetStatus.toLowerCase().contains(lowerQuery) ||
        asset.assetName.toLowerCase().contains(lowerQuery) ||
        asset.assetModel.toLowerCase().contains(lowerQuery) ||
        asset.assetGroup.toLowerCase().contains(lowerQuery) ||
        asset.usefulLife.toDouble().toString().contains(lowerQuery) ||
        asset.assetType.toLowerCase().contains(lowerQuery) ||
        asset.period.toLowerCase().contains(lowerQuery) ||
        asset.homeCurrency.toLowerCase().contains(lowerQuery) ||
        asset.transactionCurrency.toLowerCase().contains(lowerQuery) ||
        asset.fixedAssetCode.toLowerCase().contains(lowerQuery);
  }
}
