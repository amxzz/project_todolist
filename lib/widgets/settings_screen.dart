import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'side_bar.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final String userName;
  final void Function(String route) onMenuTap;
  const SettingsScreen({
    Key? key,
    required this.onLogout,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.userName,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        userName: widget.userName,
        selectedRoute: 'settings',
        onMenuTap: widget.onMenuTap,
        onLogout: widget.onLogout,
      ),
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.white,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF0A3576),
            ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versi Aplikasi'),
            trailing: Text(_version.isEmpty ? '-' : _version),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text('Mode Gelap/Terang'),
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}
