import 'package:fixed_asset_frontend/depreciation/asset_depreciaiton_policy.dart';
import 'package:fixed_asset_frontend/depreciation/book_level_depreciation.dart';
import 'package:fixed_asset_frontend/depreciation/depreciation_convention.dart';
import 'package:fixed_asset_frontend/system_default/asset_book.dart';
import 'package:fixed_asset_frontend/system_default/wrapperPage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  String? _selectedBookLevel;

  final List<MenuItem> _menuItems = [
    MenuItem(title: 'System default', icon: Icons.settings),
    MenuItem(title: 'Book Setting', icon: Icons.book),
    // MenuItem(title: 'Book level', icon: Icons.layers),
    MenuItem(title: 'Depreciation Setting', icon: Icons.category),
  ];
  final DepreciationNavigation depreciationNav = DepreciationNavigation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Menu Bar
          Container(
            width: 280,
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildMenuItem(
                        title: _menuItems[index].title,
                        icon: _menuItems[index].icon,
                        isSelected: _selectedIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(width: 1, color: Colors.grey[300]),

          // Main Content Area
          Expanded(child: _buildContentPage(_selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPage(int index) {
    switch (index) {
      case 0:
        return const SystemDefaultPage();
      case 1:
        return AssetBookScreen(
          onOpenBookLevel: (bookLevel) {
            setState(() {
              _selectedIndex = 2;
              _selectedBookLevel = bookLevel;
            });
          },
        );
      case 2:
        return BookLevelDepreciation(
          bookLevel: _selectedBookLevel,
          readOnly: true,
        );

      case 3:
        return DepreciationSettingPage(nav: depreciationNav);
      default:
        return const SystemDefaultPage();
    }
  }
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({required this.title, required this.icon});
}
