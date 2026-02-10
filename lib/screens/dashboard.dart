import 'package:fixed_asset_frontend/leaseScreen/leaseList.dart';
import 'package:fixed_asset_frontend/screens/fixed_asset_list.dart';
import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of screens/pages
  final List<Widget> _screens = [
    WelcomeScreen(),
    const WIPListScreen(),
    const FixedAssetListScreen(),
    const Leaselist(),
  ];

  // List of menu items with icons and colors
  final List<NavigationItem> _menuItems = [
    NavigationItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      color: Colors.grey,
      description: 'Overview and analytics',
    ),
    NavigationItem(
      title: 'Work-in-Progress',
      icon: Icons.build_rounded,
      color: const Color(0xFFFF9800),
      description: 'Manage ongoing projects',
    ),
    NavigationItem(
      title: 'Fixed Assets',
      icon: Icons.business_rounded,
      color: const Color(0xFF4CAF50),
      description: 'Company assets tracking',
    ),
    NavigationItem(
      title: 'Lease List',
      icon: Icons.settings_rounded,
      color: const Color(0xFF9C27B0),
      description: 'App preferences and settings',
    ),
  ];

  // Handle menu item selection
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            const Icon(Icons.inventory_rounded, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _selectedIndex == 0
                  ? 'Asset Management'
                  : _menuItems[_selectedIndex].title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: () {
              // Notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_rounded, color: Colors.white),
            onPressed: () {
              // Help/Support
            },
          ),
        ],
      ),
      drawer: SideNavigationDrawer(
        selectedIndex: _selectedIndex,
        menuItems: _menuItems,
        onItemSelected: _onMenuItemSelected,
      ),
      body: _screens[_selectedIndex],
    );
  }
}

// Side Navigation Drawer Component
class SideNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItem> menuItems;
  final Function(int) onItemSelected;

  const SideNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.menuItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: const Color(0xFF1A237E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            _buildHeader(context),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  ...menuItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildMenuItem(
                      context: context,
                      item: item,
                      index: index,
                      isSelected: selectedIndex == index,
                    );
                  }).toList(),

                  // Spacer
                  const SizedBox(height: 32),

                  // Additional Links
                  _buildAdditionalLinks(),
                ],
              ),
            ),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Title
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Color(0xFF1A237E),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSET MANAGER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Professional Edition',
                      style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // User Profile
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3949AB),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Administrator',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  // Edit profile
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required NavigationItem item,
    required int index,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: item.color.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? item.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: !isSelected
                        ? Border.all(
                            color: item.color.withOpacity(0.5),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Icon(
                    item.icon,
                    color: isSelected ? Colors.white : item.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xEEFFFFFF),
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      if (item.description != null)
                        Text(
                          item.description!,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : const Color(0x99FFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: item.color,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Quick Links',
              style: TextStyle(
                color: Color(0x99FFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          _buildLinkItem(
            icon: Icons.help_rounded,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildLinkItem(
            icon: Icons.document_scanner_rounded,
            title: 'Documentation',
            onTap: () {},
          ),
          _buildLinkItem(
            icon: Icons.bug_report_rounded,
            title: 'Report Issue',
            onTap: () {},
          ),
          _buildLinkItem(
            icon: Icons.star_rounded,
            title: 'Rate App',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0x99FFFFFF), size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xEEFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      minLeadingWidth: 32,
      dense: true,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      child: Column(
        children: [
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Version and Copyright
          const Text(
            'Version 2.1.4',
            style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            '© 2024 Asset Manager Pro',
            style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Navigation Item Model
class NavigationItem {
  final String title;
  final IconData icon;
  final Color color;
  final String? description;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.color,
    this.description,
  });
}

// =============================================
// SCREEN IMPLEMENTATIONS
// =============================================

// 1. WELCOME/SPLASH SCREEN
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'John Smith',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFF1A237E),
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            'Here\'s what\'s happening with your assets today',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 32),

          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                title: 'Total Assets',
                value: '1,284',
                change: '+12%',
                icon: Icons.inventory_2_rounded,
                color: const Color(0xFF1A237E),
                isPositive: true,
              ),
              _buildStatCard(
                title: 'Active WIP',
                value: '47',
                change: '+8%',
                icon: Icons.build_rounded,
                color: const Color(0xFFFF9800),
                isPositive: true,
              ),
              _buildStatCard(
                title: 'Asset Value',
                value: '\$2.4M',
                change: '+4.2%',
                icon: Icons.attach_money_rounded,
                color: const Color(0xFF4CAF50),
                isPositive: true,
              ),
              _buildStatCard(
                title: 'Depreciation',
                value: '\$124K',
                change: '-2.1%',
                icon: Icons.trending_down_rounded,
                color: const Color(0xFFF44336),
                isPositive: false,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add_rounded,
                  label: 'Add Asset',
                  color: const Color(0xFF1A237E),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan QR',
                  color: const Color(0xFF4CAF50),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.report_rounded,
                  label: 'Reports',
                  color: const Color(0xFFFF9800),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Activity
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
                const SizedBox(height: 16),
                ..._recentActivities
                    .map((activity) => _buildActivityItem(activity))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A237E),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(activity['icon'], color: activity['color']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['subtitle'],
                  style: const TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'icon': Icons.add_rounded,
      'color': Colors.green,
      'title': 'New Asset Added',
      'subtitle': 'Laptop MacBook Pro M2',
      'time': '10 min ago',
    },
    {
      'icon': Icons.build_rounded,
      'color': Colors.orange,
      'title': 'WIP Updated',
      'subtitle': 'Office Renovation Project',
      'time': '1 hour ago',
    },
    {
      'icon': Icons.check_circle_rounded,
      'color': Colors.blue,
      'title': 'Maintenance Completed',
      'subtitle': 'HVAC System #245',
      'time': '2 hours ago',
    },
    {
      'icon': Icons.warning_rounded,
      'color': Colors.red,
      'title': 'Depreciation Alert',
      'subtitle': '5 assets require review',
      'time': '5 hours ago',
    },
  ];
}
