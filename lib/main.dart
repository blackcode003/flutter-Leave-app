import 'package:flutter/material.dart';
import 'owner_panel.dart';
import 'leave_application.dart';

void main() {
  runApp(const LeaveApp());
}

class LeaveApp extends StatelessWidget {
  const LeaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4ECDC4),
          secondary: Color(0xFF45B7D1),
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF0D0D0D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // cardTheme: CardTheme(
        //   color: const Color(0xFF1A1A2E),
        //   elevation: 4,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(16),
        //     side: const BorderSide(color: Color(0xFF2A2A4A), width: 1),
        //   ),
        // ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF16213E),
          labelStyle: const TextStyle(color: Color(0xFF8892B0)),
          hintStyle: const TextStyle(color: Color(0xFF4A5568)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ECDC4),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFCCD6F6)),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  String role = 'Worker';
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final Map<String, String> credentials = {
    'Worker': '1234',
    'Owner': 'admin123',
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (_passwordController.text == credentials[role]) {
      if (role == 'Owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OwnerPanelScreen(requests: demoRequests),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerLeavePage(
              requests: demoRequests,
              employeeId: 'EMP-2024-085',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Wrong password. Please try again.'),
            ],
          ),
          backgroundColor: const Color(0xFFFF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = role == 'Owner';
    final accentColor =
    isOwner ? const Color(0xFF45B7D1) : const Color(0xFF4ECDC4);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // Background design
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.05),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isOwner
                                ? [
                              const Color(0xFF1A3A5C),
                              const Color(0xFF45B7D1)
                            ]
                                : [
                              const Color(0xFF0F3460),
                              const Color(0xFF4ECDC4)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isOwner
                              ? Icons.admin_panel_settings
                              : Icons.badge_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        isOwner ? 'Owner Portal' : 'Worker Portal',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Leave Management System',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white38,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: accentColor.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Role selector
                            Text(
                              'Select Role',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D0D0D),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF2A2A4A)),
                              ),
                              child: Row(
                                children: ['Worker', 'Owner'].map((r) {
                                  final selected = role == r;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => role = r),
                                      child: AnimatedContainer(
                                        duration:
                                        const Duration(milliseconds: 250),
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? accentColor.withOpacity(0.15)
                                              : Colors.transparent,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          border: selected
                                              ? Border.all(
                                              color: accentColor
                                                  .withOpacity(0.5))
                                              : null,
                                        ),
                                        child: Text(
                                          r,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: selected
                                                ? accentColor
                                                : Colors.white38,
                                            fontWeight: selected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              onSubmitted: (_) => login(),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle:
                                const TextStyle(color: Color(0xFF4A5568)),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: accentColor.withOpacity(0.7),
                                    size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white38,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Login as $role',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                  accentColor.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: accentColor.withOpacity(0.15)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: accentColor.withOpacity(0.7),
                                        size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Demo: ${role == 'Owner' ? 'admin123' : '1234'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: accentColor.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}