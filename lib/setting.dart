import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAccountExpanded = true;
  bool isGeneralExpanded = true;
  bool isRemindersExpanded = false;
  bool isNotificationsExpanded = false;
  bool isCalendarsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Settings List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Account Section
                    _buildExpandableSection(
                      title: 'Account',
                      isExpanded: isAccountExpanded,
                      onTap: () {
                        setState(() {
                          isAccountExpanded = !isAccountExpanded;
                        });
                      },
                      children: [
                        _buildSettingItem('Photo'),
                        _buildSettingItem('Name'),
                        _buildSettingItem('Email'),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // General Section
                    _buildExpandableSection(
                      title: 'General',
                      isExpanded: isGeneralExpanded,
                      onTap: () {
                        setState(() {
                          isGeneralExpanded = !isGeneralExpanded;
                        });
                      },
                      children: [
                        _buildSettingItem('Theme'),
                        _buildSettingItem('Language'),
                        _buildSettingItem('Time Zone'),
                        _buildSettingItem('Time Format'),
                        _buildSettingItem('Data Format'),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Reminders Section
                    _buildExpandableSection(
                      title: 'Reminders',
                      isExpanded: isRemindersExpanded,
                      onTap: () {
                        setState(() {
                          isRemindersExpanded = !isRemindersExpanded;
                        });
                      },
                      children: [],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Notifications Section
                    _buildExpandableSection(
                      title: 'Notifications',
                      isExpanded: isNotificationsExpanded,
                      onTap: () {
                        setState(() {
                          isNotificationsExpanded = !isNotificationsExpanded;
                        });
                      },
                      children: [],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Calendars Section
                    _buildExpandableSection(
                      title: 'Calendars',
                      isExpanded: isCalendarsExpanded,
                      onTap: () {
                        setState(() {
                          isCalendarsExpanded = !isCalendarsExpanded;
                        });
                      },
                      children: [],
                    ),
                    
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && children.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildSettingItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }
}
