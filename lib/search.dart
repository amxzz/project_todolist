import 'package:flutter/material.dart';

void main() {
  runApp(const SearchScreenApp());
}

class SearchScreenApp extends StatelessWidget {
  const SearchScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Screen',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F8),
        primaryColor: Colors.deepOrange,
        textTheme: const TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  titleMedium: TextStyle(fontWeight: FontWeight.w600),
  bodyMedium: TextStyle(color: Colors.black87),
),
      ),
      home: const SearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1440) {
      return const EdgeInsets.symmetric(horizontal: 120, vertical: 20);
    } else if (width >= 767) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F8),
        centerTitle: false,
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black87,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.deepOrange),
            onPressed: () {
            },
            tooltip: 'Menu',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    offset: Offset(0, 3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B3D),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.orangeAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.orangeAccent),
                            cursorColor: Colors.orangeAccent,
                            decoration: const InputDecoration(
                              hintText: 'Search or type a command.....',
                              hintStyle: TextStyle(color: Colors.orangeAccent),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recently Viewed',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _RecentlyViewedItem(
                          icon: Icons.calendar_today_rounded,
                          label: 'Upcoming',
                        ),
                        _RecentlyViewedItem(
                          icon: Icons.calendar_today_rounded,
                          label: 'Today',
                        ),
                        _RecentlyViewedItem(
                          icon: Icons.inbox_rounded,
                          label: 'Inbox',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _AddItem(
                          icon: Icons.add,
                          label: 'Add task',
                        ),
                        _AddItem(
                          icon: Icons.tag,
                          label: 'Add label',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentlyViewedItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RecentlyViewedItem({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        // Handle tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AddItem({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}