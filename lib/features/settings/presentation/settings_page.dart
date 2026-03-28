import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../injection_container.dart';
import '../domain/entities/settings.dart';
import '../presentation/bloc/settings_bloc.dart';
import '../presentation/bloc/settings_event.dart';
import '../presentation/bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings saved')),
            );
          }
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header card ──────────────────────────────────────────────
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
                        const Text(
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
                          child: const Text(
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

              // ── Tabbed settings ──────────────────────────────────────────
              const _SettingsTabView(),

              const SizedBox(height: 24),

              // ── Save button ──────────────────────────────────────────────
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  final isLoading = state is SettingsLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final bloc = context.read<SettingsBloc>();
                            final current = bloc.state;
                            if (current is SettingsLoaded) {
                              bloc.add(SaveSettingsEvent(current.settings));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : const Text(
                            'Save Preferences',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ── Account management ───────────────────────────────────────
              const Text(
                'Account Management',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your account and security',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Download My Data
              _AccountButton(
                label: 'Download My Data',
                onPressed: () {
                  // TODO: implement data export
                },
              ),
              const SizedBox(height: 16),

              // Change Password
              _AccountButton(
                label: 'Change Password',
                onPressed: () {
                  // TODO: wire up Firebase password change
                },
              ),
              const SizedBox(height: 16),

              // Delete Account
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: wire up Firebase account deletion
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.delete,
                      foregroundColor: AppColors.onDelete,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── More ─────────────────────────────────────────────────────
              const Text(
                'More',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              _SettingsNavButton(
                title: 'Help & Support',
                icon: Icons.help_outline,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                ),
              ),
              const SizedBox(height: 12),
              _SettingsNavButton(
                title: 'Tips',
                icon: Icons.lightbulb_outline,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TipsPage()),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab view ───────────────────────────────────────────────────────────────────

class _SettingsTabView extends StatelessWidget {
  const _SettingsTabView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.all(4),
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
              labelStyle:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: const [
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

// ── Profile tab ───────────────────────────────────────────────────────────────
//
// The text controllers are seeded from BLoC state (settings.userName /
// settings.email).  Right now those will be empty strings because Firebase
// isn't wired yet.  Once the auth teammate exposes user data, just populate
// those two fields on the Settings entity and this tab will display them
// automatically with zero changes here.

class _ProfileTab extends StatefulWidget {
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _initialised = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initControllers(Settings settings) {
    if (_initialised) return;
    _nameController = TextEditingController(text: settings.userName);
    _emailController = TextEditingController(text: settings.email);
    _initialised = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      // Only rebuild when the profile fields actually change, not on every
      // toggle update in another tab.
      buildWhen: (prev, curr) {
        if (curr is! SettingsLoaded) return true;
        if (prev is! SettingsLoaded) return true;
        return prev.settings.userName != curr.settings.userName ||
            prev.settings.email != curr.settings.email;
      },
      listenWhen: (_, curr) => curr is SettingsLoaded,
      listener: (context, state) {
        if (state is SettingsLoaded) {
          // Sync controllers whenever the BLoC pushes fresh data (e.g. after
          // Firebase loads the real profile).
          if (_initialised) {
            _nameController.text = state.settings.userName;
            _emailController.text = state.settings.email;
          }
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading || state is SettingsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SettingsLoaded) {
          _initControllers(state.settings);
        }

        if (state is SettingsError) {
          return Center(child: Text(state.message));
        }

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Update your personal information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Full Name
            const Text(
              'Full Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Keep BLoC in sync as the user types so Save picks it up.
                final bloc = context.read<SettingsBloc>();
                final current = bloc.state;
                if (current is SettingsLoaded) {
                  bloc.add(UpdateSettingsEvent(
                    current.settings.copyWith(userName: value),
                  ));
                }
              },
            ),
            const SizedBox(height: 16),

            // Email
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'user@example.com',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                final bloc = context.read<SettingsBloc>();
                final current = bloc.state;
                if (current is SettingsLoaded) {
                  bloc.add(UpdateSettingsEvent(
                    current.settings.copyWith(email: value),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// ── Notifications tab ─────────────────────────────────────────────────────────

class _NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const Text(
              'Email Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose what updates you want to receive',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 16),

            _NotificationToggleItem(
              title: 'Lean Period Warning',
              subtitle: 'Get notified when balance may run low soon.',
              value: settings.notificationsEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(notificationsEnabled: value),
                      ),
                    );
              },
            ),
            const SizedBox(height: 12),
            _NotificationToggleItem(
              title: 'Auto-save Notifications',
              subtitle: 'Receive alerts for automatic savings actions.',
              value: settings.autoSaveNotifications,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(autoSaveNotifications: value),
                      ),
                    );
              },
            ),
            const SizedBox(height: 12),
            _NotificationToggleItem(
              title: 'Weekly Summary',
              subtitle: 'Get a weekly overview of your finances.',
              value: settings.weeklySummary,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(weeklySummary: value),
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

// ── Privacy tab ───────────────────────────────────────────────────────────────
//
// Previously used local setState — now reads from and writes to the BLoC
// so that Save Preferences captures these values correctly.

class _PrivacyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const Text(
              'Privacy Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Control your privacy preferences',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 16),

            _NotificationToggleItem(
              title: 'Show Balance on Home',
              subtitle: 'Display your balance on the home screen',
              value: settings.showBalance,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(showBalance: value),
                      ),
                    );
              },
            ),
            const SizedBox(height: 12),
            _NotificationToggleItem(
              title: 'Share Anonymous Analytics',
              subtitle: 'Help us improve the app with usage data',
              value: settings.shareAnalytics,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(shareAnalytics: value),
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

// ── Appearance tab ────────────────────────────────────────────────────────────
//
// Previously used local setState — now reads from and writes to the BLoC.

class _AppearanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Customize how the app looks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
            const SizedBox(height: 16),

            _ThemeOption(
              title: 'Light',
              isSelected: settings.theme == 'Light',
              onTap: () {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(theme: 'Light'),
                      ),
                    );
              },
            ),
            const SizedBox(height: 12),
            _ThemeOption(
              title: 'Dark',
              isSelected: settings.theme == 'Dark',
              onTap: () {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(theme: 'Dark'),
                      ),
                    );
              },
            ),
            const SizedBox(height: 12),
            _ThemeOption(
              title: 'System Default',
              isSelected: settings.theme == 'System Default',
              onTap: () {
                context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings.copyWith(theme: 'System Default'),
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────

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
        padding: const EdgeInsets.all(16),
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
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _AccountButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AccountButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.onPrimary,
            foregroundColor: AppColors.onSurface,
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: AppColors.onSurface, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder pages ─────────────────────────────────────────────────────────

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(child: Text('Placeholder Help & Support Page')),
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips')),
      body: const Center(child: Text('Placeholder Tips Page')),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: const Center(child: Text('Placeholder Sign In Page')),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: const Center(child: Text('Placeholder Sign Up Page')),
    );
  }
}
