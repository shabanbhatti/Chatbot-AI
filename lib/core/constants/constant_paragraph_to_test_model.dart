String modelReply =
    '''Clean Architecture ke according Bottom Navigation Bar ki implementation ka professional approach:

✅ Best Solution: App Layer (Presentation Layer) mai "Root" ya "Shell" Screen banaen

📍 Location in Clean Architecture:

```
lib/
├── core/           # Shared utilities, constants, themes
├── features/       # Individual features (login, home, profile, etc.)
├── app/           # App-level components
│   ├── pages/
│   │   └── root_page/      # <-- Yeh aap ka main page hoga
│   │       ├── root_page.dart
│   │       ├── root_controller.dart
│   │       └── root_state.dart
│   └── widgets/    # App-wide reusable widgets
└── main.dart
```

📁 Structure Example:

1. Root Page (lib/app/pages/root_page/)

```dart
// root_page.dart
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),      // Feature se import
    const SearchPage(),    // Feature se import  
    const CartPage(),      // Feature se import
    const ProfilePage(),   // Feature se import
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

2. Main.dart mai RootPage ko set karen

```dart
// main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      home: const RootPage(),  // <-- RootPage as initial route
    );
  }
}
```

🎯 Alternative Professional Approaches:

Option A: Shell Architecture (State Management ke sath)

```dart
// lib/app/shell/
├── shell_controller.dart
├── shell_page.dart
└── shell_state.dart
```

Option B: Using Navigation Packages (GoRouter, AutoRoute)

```dart
// With GoRouter
MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const AppBottomNav(),
          );
        },
        routes: [
          GoRoute(path: '/home', pageBuilder: (_, state) => ...),
          GoRoute(path: '/search', pageBuilder: (_, state) => ...),
        ],
      ),
    ],
  ),
)
```

⚡ Key Recommendations:

1. Root Page ko "app" folder mai rakhen - Ye app-level layout hai, kisi specific feature ka part nahi
2. Features ko separate rakhen - Har feature apne folder mai independent ho
3. Dependency Injection use karen - RootPage ko directly features ke pages se inject karen
4. State Management consider karen - Agar complex navigation hai to Provider/Riverpod/Bloc use karen

❌ Avoid:

· Features ke andar root page banana ❌
· Direct MaterialApp ke home mai complex UI dalna ❌
· Bottom navigation logic ko kisi feature ke sath mix karna ❌

Summary: Aap ka main navigation shell/root page app layer mai banana chahiye jo different features ke screens ko host kare, aur har feature apni independence maintain kare.''';
