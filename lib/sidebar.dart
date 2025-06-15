import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SidebarScreen(),
    );
  }
}

class SidebarScreen extends StatelessWidget {
  const SidebarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          NavigationDrawer(),
          Expanded(
            child: MainContent(), 
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1F1F1F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 10),
                Text('User', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Divider(color: Colors.grey[700]),
          const ListTile(
            leading: Icon(Icons.add, color: Colors.amber),
            title: Text('Add task', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.search, color: Colors.white),
            title: Text('Search', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.inbox, color: Colors.white),
            title: Text('Inbox', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.today, color: Colors.white),
            title: Text('Today', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title: Text('Upcoming', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.filter_list, color: Colors.white),
            title: Text('Filters & Label', style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.white),
            title: Text('Completed', style: TextStyle(color: Colors.white)),
          ),
          const Spacer(),
          const ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Text(
          'Main Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
