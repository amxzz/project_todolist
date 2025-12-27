import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/auth_service.dart';
import 'tasks/task_list_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'widgets/side_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'tasks/add_task_dialog.dart';
import 'tasks/today_task_screen.dart';
import 'tasks/upcoming_task_screen.dart';
import 'tasks/done_task_screen.dart';
import 'journal_habit_filter/journal_screen.dart';
import 'journal_habit_filter/habit_tracker_screen.dart';
import 'journal_habit_filter/filter_label_screen.dart';
import 'widgets/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:
        'https://iozsepnfybvpbpadxlkh.supabase.co', // TODO: Replace with your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlvenNlcG5meWJ2cGJwYWR4bGtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE3NjI4MDYsImV4cCI6MjA2NzMzODgwNn0.TfqWmWMaeVnqKYpRCNhXERxPpIWGYD_c1HWwmMVU4FM', // TODO: Replace with your Supabase anon/public key
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF00F5A0),
          brightness: Brightness.dark,
          background: Color(0xFF181A20),
          surface: Color(0xFF23262F),
          primary: Color(0xFF00F5A0),
          secondary: Color(0xFF00F5A0),
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFF181A20),
        cardColor: Color(0xFF23262F),
        dialogBackgroundColor: Color(0xFF23262F),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF181A20),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00F5A0),
          foregroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Color(0xFF00F5A0)),
        ),
        dividerColor: Colors.white12,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF23262F),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5A0)),
            borderRadius: BorderRadius.circular(8),
          ),
          hintStyle: TextStyle(color: Colors.white38),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Color(0xFF00F5A0)),
          checkColor: MaterialStateProperty.all(Colors.black),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Color(0xFF00F5A0)),
          trackColor: MaterialStateProperty.all(
            Color(0xFF00F5A0).withOpacity(0.5),
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthGate(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme),
    );
  }
}

class AuthGate extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const AuthGate({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Navigation state for auth screens
  bool _showLogin = true;
  bool _showRegister = false;
  bool _showForgot = false;
  User? _user;
  late final Stream<AuthState> _authStream;
  // Add navigation state for dashboard
  final GlobalKey<DashboardScreenState> _dashboardKey =
      GlobalKey<DashboardScreenState>();
  final GlobalKey<TodayTaskScreenState> _todayTaskKey =
      GlobalKey<TodayTaskScreenState>();
  final GlobalKey<UpcomingTaskScreenState> _upcomingTaskKey =
      GlobalKey<UpcomingTaskScreenState>();
  final GlobalKey<HabitTrackerScreenState> _habitTrackerKey =
      GlobalKey<HabitTrackerScreenState>();
  String _selectedScreen = 'dashboard';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _user = Supabase.instance.client.auth.currentUser;
    _authStream = Supabase.instance.client.auth.onAuthStateChange;
    _authStream.listen((data) {
      setState(() {
        _user = Supabase.instance.client.auth.currentUser;
      });
    });
  }

  void _goToLogin() {
    setState(() {
      _showLogin = true;
      _showRegister = false;
      _showForgot = false;
    });
  }

  void _goToRegister() {
    setState(() {
      _showLogin = false;
      _showRegister = true;
      _showForgot = false;
    });
  }

  void _goToForgot() {
    setState(() {
      _showLogin = false;
      _showRegister = false;
      _showForgot = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      final isDashboard = _selectedScreen == 'dashboard';
      final isToday = _selectedScreen == 'today';
      final isUpcoming = _selectedScreen == 'upcoming';
      final isDone = _selectedScreen == 'done';
      final isJournal = _selectedScreen == 'journal';
      final isHabitTracker = _selectedScreen == 'habit_tracker';
      final isFilterLabel = _selectedScreen == 'filter_label';

      if (_selectedScreen == 'settings') {
        return SettingsScreen(
          onLogout: () async {
            await AuthService().signOut();
            setState(() {
              _selectedScreen = 'dashboard';
            });
          },
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          userName: _user?.email ?? 'User',
          onMenuTap: (route) {
            setState(() {
              _selectedScreen = route;
            });
            Navigator.of(context).pop();
          },
        );
      }

      return Scaffold(
        drawer: SideBar(
          userName: _user?.email ?? 'User',
          selectedRoute: _selectedScreen,
          onMenuTap: (route) {
            setState(() {
              _selectedScreen = route;
            });
            Navigator.of(context).pop();
          },
          onLogout: () async {
            await AuthService().signOut();
            Navigator.of(context).pop();
          },
        ),
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton:
            isToday || isUpcoming || isHabitTracker
                ? FloatingActionButton(
                  onPressed: () {
                    if (isToday) {
                      _todayTaskKey.currentState?.showAddTaskDialog();
                    } else if (isUpcoming) {
                      _upcomingTaskKey.currentState?.showAddTaskDialog();
                    } else if (isHabitTracker) {
                      _habitTrackerKey.currentState?.showAddHabitDialog();
                    }
                  },
                  child: const Icon(Icons.add),
                  tooltip: 'Tambah',
                )
                : (isDashboard
                    ? FloatingActionButton(
                      onPressed:
                          () => _dashboardKey.currentState?.showAddTaskDialog(),
                      child: const Icon(Icons.add),
                      tooltip: 'Tambah Tugas',
                    )
                    : null),
      );
    }
    if (_showLogin) {
      return LoginScreen(
        onRegisterTap: _goToRegister,
        onForgotPasswordTap: _goToForgot,
      );
    } else if (_showRegister) {
      return RegisterScreen(onLoginTap: _goToLogin);
    } else if (_showForgot) {
      return ForgotPasswordScreen(onLoginTap: _goToLogin);
    }
    return const SizedBox.shrink();
  }

  String _getScreenTitle(String screen) {
    switch (screen) {
      case 'dashboard':
        return 'Dashboard';
      case 'today':
        return 'Tugas Hari Ini';
      case 'upcoming':
        return 'Tugas Mendatang';
      case 'done':
        return 'Tugas Selesai';
      case 'journal':
        return 'Journal';
      case 'habit_tracker':
        return 'Habit Tracker';
      case 'filter_label':
        return 'Filter & Label';
      case 'settings':
        return 'Settings';
      default:
        return 'My Tasks';
    }
  }

  AppBar? _buildAppBar() {
    final isDashboard = _selectedScreen == 'dashboard';
    final isToday = _selectedScreen == 'today';
    final isUpcoming = _selectedScreen == 'upcoming';
    final isDone = _selectedScreen == 'done';
    final isJournal = _selectedScreen == 'journal';
    final isHabitTracker = _selectedScreen == 'habit_tracker';
    final isFilterLabel = _selectedScreen == 'filter_label';

    if (isDashboard) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text:
                    '\nSelamat datang kembali! Ini adalah ringkasan aktivitas Anda',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _dashboardKey.currentState?.fetchTasks(),
            tooltip: 'Refresh',
          ),
        ],
      );
    } else if (isToday) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hari Ini',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\n${DateFormat.yMMMMd().format(DateTime.now())}',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    } else if (isUpcoming) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Mendatang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\nTugas yang akan datang',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    } else if (isDone) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Selesai',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\nTugas yang telah diselesaikan',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    } else if (isJournal) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Journal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\nCatat pemikiran dan refleksi harian Anda',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    } else if (isHabitTracker) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Habit Tracker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\Pantau kebiasaan harian Anda',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    } else if (isFilterLabel) {
      return AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Filter & Label',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00F5A0)
                          : const Color(0xFF0A3576),
                ),
              ),
              TextSpan(
                text: '\nKelola kategori dan label untuk tugas Anda',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        toolbarHeight: 72,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      );
    }
    return AppBar(title: Text(_getScreenTitle(_selectedScreen)));
  }

  Widget _buildBody() {
    switch (_selectedScreen) {
      case 'dashboard':
        return DashboardScreen(key: _dashboardKey);
      case 'today':
        return TodayTaskScreen(key: _todayTaskKey);
      case 'upcoming':
        return UpcomingTaskScreen(key: _upcomingTaskKey);
      case 'done':
        return DoneTaskScreen();
      case 'journal':
        return JournalScreen();
      case 'habit_tracker':
        return HabitTrackerScreen(key: _habitTrackerKey);
      case 'filter_label':
        return FilterLabelScreen();
      case 'settings':
        return SettingsScreen(
          onLogout: () async {
            await AuthService().signOut();
            setState(() {
              _selectedScreen = 'dashboard';
            });
          },
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          userName: _user?.email ?? 'User',
          onMenuTap: (route) {
            setState(() {
              _selectedScreen = route;
            });
            Navigator.of(context).pop();
          },
        );
      default:
        return TaskListScreen();
    }
  }
}
