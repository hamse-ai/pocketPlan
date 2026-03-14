import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
        ],
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
            height: 38,
            padding: EdgeInsets.all(4), // Padding around the indicator
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
              labelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline, size: 16),
                      SizedBox(width: 4),
                      Text('Profile'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_outlined, size: 16),
                      SizedBox(width: 4),
                      Text('Notify'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, size: 16),
                      SizedBox(width: 4),
                      Text('Privacy'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.palette_outlined, size: 16),
                      SizedBox(width: 4),
                      Text('Theme'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // TabBarView content
          SizedBox(
            height: 400, // Adjust based on your content
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

// Placeholder tabs
class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile content'));
  }
}

class _NotificationsTab extends StatefulWidget {
  @override
  State<_NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<_NotificationsTab> {
  // Temporary state for toggles
  bool toggle1 = true;
  bool toggle2 = false;
  bool toggle3 = true;
  bool toggle4 = false;

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
          title: 'Notification Title 1',
          subtitle: 'Description for notification 1',
          value: toggle1,
          onChanged: (value) {
            setState(() {
              toggle1 = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Notification Title 2',
          subtitle: 'Description for notification 2',
          value: toggle2,
          onChanged: (value) {
            setState(() {
              toggle2 = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Notification Title 3',
          subtitle: 'Description for notification 3',
          value: toggle3,
          onChanged: (value) {
            setState(() {
              toggle3 = value;
            });
          },
        ),
        SizedBox(height: 12),
        _NotificationToggleItem(
          title: 'Notification Title 4',
          subtitle: 'Description for notification 4',
          value: toggle4,
          onChanged: (value) {
            setState(() {
              toggle4 = value;
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
                  fontSize: 16,
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

class _PrivacyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Privacy content'));
  }
}

class _AppearanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Appearance content'));
  }
}