import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../../injection_container.dart';
import '../presentation/bloc/settings_event.dart';



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Settings Header Card
          SizedBox(
            width: double.infinity,
            child: Card(
              color: AppColors.primary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Manage your account and preference',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tab Bar with rounded ends
          _SettingsTabView(),

          const SizedBox(height: 24),

          // Save Preferences Button (only takes needed width)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 32),

          // Account Management Section (below tabs)
          Text(
            'Account Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Manage your account and security',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          SizedBox(height: 16),

          // Download My Data Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.onPrimary,
                  foregroundColor: AppColors.onSurface,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.onSurface, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Download My Data',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Change Password Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.onPrimary,
                  foregroundColor: AppColors.onSurface,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.onSurface, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Delete Account Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.delete,
                  foregroundColor: AppColors.onDelete,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          Text(
            'More',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),

          SizedBox(height: 16),

          _SettingsNavButton(
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpSupportPage()),
              );
            },
          ),

          SizedBox(height: 12),

          _SettingsNavButton(
            title: 'Tips',
            icon: Icons.lightbulb_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TipsPage()),
              );
            },
          ),

          SizedBox(height: 12),

          _SettingsNavButton(
            title: 'Sign In',
            icon: Icons.login,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignInPage()),
              );
            },
          ),

          SizedBox(height: 12),

          _SettingsNavButton(
            title: 'Sign Up',
            icon: Icons.person_add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpPage()),
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _SettingsTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Custom TabBar with rounded container
          Container(
            height: 48,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: AppColors.onPrimary,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceSecondary,
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline, size: 16),
                        SizedBox(width: 4),
                        Text('Profile'),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_outlined, size: 16),
                        SizedBox(width: 4),
                        Text('Notifs'),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 16),
                        SizedBox(width: 4),
                        Text('Privacy'),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.palette_outlined, size: 16),
                        SizedBox(width: 4),
                        Text('Theme'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TabBarView content
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                _ProfileTab(),
                _NotificationsTab(),
                _PrivacyTab(),
                _AppearanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Tab - Shorter content
class _ProfileTab extends StatefulWidget {
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final TextEditingController fullNameController = TextEditingController(
    text: 'John Doe',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'john@example.com',
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Profile Header
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Update your personal information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 24),

        // Full Name
        Text(
          'Full Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 16),

        // Email
        Text(
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'user@example.com',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

// Notifications Tab
class _NotificationsTab extends StatefulWidget {
  @override
  State<_NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<_NotificationsTab> {
  bool toggle1 = true;
  bool toggle2 = false;
  bool toggle3 = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Email Notifications Header
        Text(
          'Email Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Choose what updates you want to receive',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 16),

        // Notification Toggle Items
        _NotificationToggleItem(
          title: 'Lean Period Warning',
          subtitle: 'Get notified when balance may run low soon.',
          value: toggle1,
          onChanged: (value) {
            setState(() {
              toggle1 = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Auto-Save Success Notifications',
          subtitle: 'Get notified when you auto-save for emergency',
          value: toggle2,
          onChanged: (value) {
            setState(() {
              toggle2 = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Weekly Money Summary',
          subtitle: 'Get provided with weekly summaries',
          value: toggle3,
          onChanged: (value) {
            setState(() {
              toggle3 = value;
            });
          },
        ),
      ],
    );
  }
}

class _NotificationToggleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.onPrimary,
          activeTrackColor: AppColors.primary,
          inactiveThumbColor: AppColors.disabled,
          inactiveTrackColor: AppColors.surface,
        ),
      ],
    );
  }
}

// Privacy Tab - Simpler content
class _PrivacyTab extends StatefulWidget {
  @override
  State<_PrivacyTab> createState() => _PrivacyTabState();
}

class _PrivacyTabState extends State<_PrivacyTab> {
  bool showBalance = true;
  bool shareAnalytics = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Privacy Header
        Text(
          'Privacy Settings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Control your privacy preferences',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 16),

        _NotificationToggleItem(
          title: 'Show Balance on Home',
          subtitle: 'Display your balance on the home screen',
          value: showBalance,
          onChanged: (value) {
            setState(() {
              showBalance = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Share Anonymous Analytics',
          subtitle: 'Help us improve the app with usage data',
          value: shareAnalytics,
          onChanged: (value) {
            setState(() {
              shareAnalytics = value;
            });
          },
        ),
      ],
    );
  }
}

// Appearance Tab
class _AppearanceTab extends StatefulWidget {
  @override
  State<_AppearanceTab> createState() => _AppearanceTabState();
}

class _AppearanceTabState extends State<_AppearanceTab> {
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Appearance Header
        Text(
          'Appearance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Customize how the app looks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 16),

        // Theme Options
        _ThemeOption(
          title: 'Light',
          isSelected: selectedTheme == 'Light',
          onTap: () {
            setState(() {
              selectedTheme = 'Light';
            });
          },
        ),
        SizedBox(height: 12),
        _ThemeOption(
          title: 'Dark',
          isSelected: selectedTheme == 'Dark',
          onTap: () {
            setState(() {
              selectedTheme = 'Dark';
            });
          },
        ),
        SizedBox(height: 12),
        _ThemeOption(
          title: 'System Default',
          isSelected: selectedTheme == 'System Default',
          onTap: () {
            setState(() {
              selectedTheme = 'System Default';
            });
          },
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _SettingsNavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsNavButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ---------------- PLACEHOLDER PAGES ----------------

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(
        child: Text('Placeholder Help & Support Page'),
      ),
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips')),
      body: const Center(
        child: Text('Placeholder Tips Page'),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: const Center(
        child: Text('Placeholder Sign In Page'),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: const Center(
        child: Text('Placeholder Sign Up Page'),
      ),
    );
  }
}