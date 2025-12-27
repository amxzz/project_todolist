import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String userName;
  final String selectedRoute;
  final void Function(String route) onMenuTap;
  final VoidCallback onLogout;

  const SideBar({
    Key? key,
    required this.userName,
    required this.selectedRoute,
    required this.onMenuTap,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF00F5A0), const Color(0xFF00D2A0)]
                        : [const Color(0xFF3ED2FC), const Color(0xFF406AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'THRIVE',
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.black87 : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _MenuSectionHeader(title: 'MENU UTAMA'),
                _MenuListItem(
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  isSelected: selectedRoute == 'dashboard',
                  onTap: () => onMenuTap('dashboard'),
                ),
                _MenuListItem(
                  title: 'Hari Ini',
                  icon: Icons.today_outlined,
                  isSelected: selectedRoute == 'today',
                  onTap: () => onMenuTap('today'),
                ),
                _MenuListItem(
                  title: 'Mendatang',
                  icon: Icons.calendar_today_outlined,
                  isSelected: selectedRoute == 'upcoming',
                  onTap: () => onMenuTap('upcoming'),
                ),
                _MenuListItem(
                  title: 'Selesai',
                  icon: Icons.check_circle_outline,
                  isSelected: selectedRoute == 'done',
                  onTap: () => onMenuTap('done'),
                ),
                const SizedBox(height: 20),
                _MenuSectionHeader(title: 'FITUR TAMBAHAN'),
                _MenuListItem(
                  title: 'Journal',
                  icon: Icons.book_outlined,
                  isSelected: selectedRoute == 'journal',
                  onTap: () => onMenuTap('journal'),
                ),
                _MenuListItem(
                  title: 'Habit Tracker',
                  icon: Icons.track_changes_outlined,
                  isSelected: selectedRoute == 'habit_tracker',
                  onTap: () => onMenuTap('habit_tracker'),
                ),
                _MenuListItem(
                  title: 'Filter & Label',
                  icon: Icons.filter_alt_outlined,
                  isSelected: selectedRoute == 'filter_label',
                  onTap: () => onMenuTap('filter_label'),
                ),
                const SizedBox(height: 20),
                _MenuSectionHeader(title: 'LAINNYA'),
                _MenuListItem(
                  title: 'Pengaturan',
                  icon: Icons.settings_outlined,
                  isSelected: selectedRoute == 'settings',
                  onTap: () => onMenuTap('settings'),
                ),
                _MenuListItem(
                  title: 'Keluar',
                  icon: Icons.logout,
                  isSelected: false,
                  onTap: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSectionHeader extends StatelessWidget {
  final String title;
  const _MenuSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuListItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = isDark ? theme.colorScheme.primary : theme.primaryColor;
    final textColor = isSelected
        ? selectedColor
        : (isDark ? Colors.white : Colors.black87);
    final iconColor = isSelected
        ? selectedColor
        : (isDark ? Colors.white70 : Colors.black54);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(icon, size: 22, color: iconColor),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
