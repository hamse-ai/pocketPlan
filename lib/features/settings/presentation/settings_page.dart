import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/colors.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_plan/features/auth/presentation/bloc/auth_event.dart';
import 'package:pocket_plan/features/education/presentation/pages/tips_screen.dart';
import 'package:pocket_plan/features/help_support/presentation/pages/help_support_screen.dart';
import '../presentation/bloc/settings_bloc.dart';
import '../presentation/bloc/settings_event.dart';
import '../presentation/bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings saved successfully')),
            );
          }
          if (state is PasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
          }
          if (state is AccountDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account deleted successfully')),
            );
            context.read<AuthBloc>().add(CheckAuthStatusEvent());
          }
          if (state is DataDownloaded) {
            _handleDataDownload(context, state.data);
          }
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
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
                  color: cs.primary,
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
                            color: cs.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Manage your account and preferences',
                            style: TextStyle(
                              fontSize: 16,
                              color: cs.onPrimary,
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
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onPrimary,
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
              Text(
                'Account Management',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your account and security',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 16),

              // Download My Data
              _AccountButton(
                label: 'Download My Data',
                onPressed: () {
                  context.read<SettingsBloc>().add(DownloadUserDataEvent());
                },
              ),
              const SizedBox(height: 16),

              // Change Password
              _AccountButton(
                label: 'Change Password',
                onPressed: () {
                  _showChangePasswordDialog(context);
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
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteAccountDialog(context);
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
              Text(
                'More',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              _SettingsNavButton(
                title: 'Help & Support',
                icon: Icons.help_outline,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _SettingsNavButton(
                title: 'Tips',
                icon: Icons.lightbulb_outline,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TipsScreen()),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
    );
  }

  void _handleDataDownload(BuildContext context, Map<String, dynamic> data) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    
    Share.share(
      jsonString,
      subject: 'My Pocket Plan Data',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data ready to share or save')),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              context.read<SettingsBloc>().add(
                    ChangePasswordEvent(
                      currentPassword: currentPasswordController.text,
                      newPassword: newPasswordController.text,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.delete,
            ),
            onPressed: () {
              context.read<SettingsBloc>().add(
                    DeleteAccountEvent(password: passwordController.text),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

// ── Tab view ───────────────────────────────────────────────────────────────────

class _SettingsTabView extends StatelessWidget {
  const _SettingsTabView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: cs.onPrimary,
              unselectedLabelColor: cs.onSurface,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'General'),
                Tab(text: 'Notifications'),
                Tab(text: 'Privacy'),
                Tab(text: 'Appearance'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                const _GeneralTab(),
                const _NotificationsTab(),
                const _PrivacyTab(),
                const _AppearanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual Tab Implementations ────────────────────────────────────────────

class _GeneralTab extends StatelessWidget {
  const _GeneralTab();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              
              // User Name Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: cs.onSurface),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          Text(
                            settings.userName.isEmpty ? 'Not set' : settings.userName,
                            style: TextStyle(
                              fontSize: 16,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Email Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: cs.onSurface),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          Text(
                            settings.email.isEmpty ? 'Not set' : settings.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _NotificationToggleItem(
                title: 'Show Balance',
                subtitle: 'Display balance on home screen',
                value: settings.showBalance,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings.copyWith(showBalance: value),
                        ),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationToggleItem(
                title: 'Enable Notifications',
                subtitle: 'Receive app notifications',
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings.copyWith(notificationsEnabled: value),
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              _NotificationToggleItem(
                title: 'Auto-Save Notifications',
                subtitle: 'Get notified when transactions are saved',
                value: settings.autoSaveNotifications,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings.copyWith(autoSaveNotifications: value),
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              _NotificationToggleItem(
                title: 'Weekly Summary',
                subtitle: 'Receive weekly spending summary',
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
          ),
        );
      },
    );
  }
}

class _PrivacyTab extends StatelessWidget {
  const _PrivacyTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;
        final cs = Theme.of(context).colorScheme;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data & Privacy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _NotificationToggleItem(
                title: 'Share Analytics',
                subtitle: 'Help improve the app by sharing anonymous usage data',
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
          ),
        );
      },
    );
  }
}

class _AppearanceTab extends StatelessWidget {
  const _AppearanceTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = state.settings;
        final cs = Theme.of(context).colorScheme;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),
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
          ),
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
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
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
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
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
    final cs = Theme.of(context).colorScheme;
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
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: cs.primary),
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
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: cs.onSurface.withValues(alpha: 0.35), width: 2),
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
