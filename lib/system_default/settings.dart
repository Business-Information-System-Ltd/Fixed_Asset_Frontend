// import 'package:fixed_asset_frontend/depreciation/asset_depreciaiton_policy.dart';
// import 'package:fixed_asset_frontend/depreciation/book_level_depreciation.dart';
// import 'package:fixed_asset_frontend/depreciation/depreciation_convention.dart';
// import 'package:fixed_asset_frontend/system_default/asset_book.dart';
// import 'package:fixed_asset_frontend/system_default/wrapperPage.dart';
// import 'package:flutter/material.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   int _selectedIndex = 0;
//   String? _selectedBookLevel;

//   final List<MenuItem> _menuItems = [
//     MenuItem(title: 'System default', icon: Icons.settings),
//     MenuItem(title: 'Book asset', icon: Icons.book),
//    // MenuItem(title: 'Book level', icon: Icons.layers),
//     MenuItem(title: 'Asset category depreciation', icon: Icons.category),
//     MenuItem(title: 'Depreciation convention', icon: Icons.calendar_today),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
         
//           Container(
//             width: 280,
//             color: Colors.grey[50],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
              
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   child: const Text(
//                     'Settings',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                 ),

                
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _menuItems.length,
//                     itemBuilder: (context, index) {
//                       return _buildMenuItem(
//                         title: _menuItems[index].title,
//                         icon: _menuItems[index].icon,
//                         isSelected: _selectedIndex == index,
//                         onTap: () {
//                           setState(() {
//                             _selectedIndex = index;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

         
//           Container(width: 1, color: Colors.grey[300]),

          
//           Expanded(child: _buildContentPage(_selectedIndex)),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue[50] : Colors.transparent,
//           border: Border(
//             left: BorderSide(
//               color: isSelected ? Colors.blue : Colors.transparent,
//               width: 4,
//             ),
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.blue : Colors.grey[600],
//               size: 22,
//             ),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? Colors.blue : Colors.grey[800],
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContentPage(int index) {
//     switch (index) {
//       case 0:
//         return const SystemDefaultPage();
//     case 1:
//       return AssetBookScreen(
//         onOpenBookLevel: (bookLevel) {
//           setState(() {
//             _selectedIndex = 2; 
//             _selectedBookLevel = bookLevel;
//           });
//         },
//       );
//     case 2:
//       return BookLevelDepreciation(
//         bookLevel: _selectedBookLevel,
//         readOnly: true,
//       );
//       case 3:
//         return const AssetCategoryPolicyForm();
//       case 4:
//         return const DepreciationConventionForm();
//       default:
//         return const SystemDefaultPage();
//     }
//   }
// }

// class MenuItem {
//   final String title;
//   final IconData icon;

//   MenuItem({required this.title, required this.icon});
// }


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
    MenuItem(title: 'Book asset', icon: Icons.book),
    // Book Level is hidden
    MenuItem(title: 'Asset category depreciation', icon: Icons.category),
    MenuItem(title: 'Depreciation convention', icon: Icons.calendar_today),
  ];

  // Map content index to sidebar index (for highlighting)
  int get _sidebarIndex {
    switch (_selectedIndex) {
      case 0: // System default
        return 0;
      case 1: // Book asset
      case 2: // Book Level Policy, highlight Book asset
        return 1;
      case 3: // Asset category depreciation
        return 2;
      case 4: // Depreciation convention
        return 3;
      default:
        return 0;
    }
  }

  // Map sidebar click index → content index
  int _mapSidebarToContent(int sidebarIdx) {
    switch (sidebarIdx) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 3;
      case 3:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildMenuItem(
                        title: _menuItems[index].title,
                        icon: _menuItems[index].icon,
                        isSelected: _sidebarIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex = _mapSidebarToContent(index);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(width: 1, color: Colors.grey[300]),

          // Content area
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
              _selectedIndex = 2; // navigate to Book Level Policy internally
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
        return const AssetCategoryPolicyForm();
      case 4:
        return const DepreciationConventionForm();
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