import 'package:flutter/material.dart';
import '../managers/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsManager _settings = SettingsManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _settings.isDarkMode
                ? [
                    const Color(0xFF0a0e27),
                    const Color(0xFF1a1f3a),
                    const Color(0xFF2a1f4a),
                  ]
                : [
                    const Color(0xFFe3f2fd),
                    const Color(0xFFbbdefb),
                    const Color(0xFF90caf9),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: _settings.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _settings.isDarkMode
                            ? const Color(0xFF00ffff)
                            : const Color(0xFF1976d2),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSettingsCard(
                      title: 'Theme',
                      children: [
                        _buildSettingTile(
                          icon: _settings.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          title: 'Dark Mode',
                          subtitle: _settings.isDarkMode
                              ? 'Enabled - Easy on the eyes'
                              : 'Disabled - Bright and clear',
                          trailing: Switch(
                            value: _settings.isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                _settings.setDarkMode(value);
                              });
                            },
                            activeColor: const Color(0xFF00ffff),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSettingsCard(
                      title: 'Audio',
                      children: [
                        _buildSettingTile(
                          icon: _settings.isSoundEnabled
                              ? Icons.volume_up
                              : Icons.volume_off,
                          title: 'Sound Effects',
                          subtitle: _settings.isSoundEnabled
                              ? 'Enabled'
                              : 'Disabled',
                          trailing: Switch(
                            value: _settings.isSoundEnabled,
                            onChanged: (value) {
                              setState(() {
                                _settings.setSoundEnabled(value);
                              });
                            },
                            activeColor: const Color(0xFF00ffff),
                          ),
                        ),
                        _buildSettingTile(
                          icon: _settings.isMusicEnabled
                              ? Icons.music_note
                              : Icons.music_off,
                          title: 'Background Music',
                          subtitle: _settings.isMusicEnabled
                              ? 'Enabled'
                              : 'Disabled',
                          trailing: Switch(
                            value: _settings.isMusicEnabled,
                            onChanged: (value) {
                              setState(() {
                                _settings.setMusicEnabled(value);
                              });
                            },
                            activeColor: const Color(0xFF00ffff),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSettingsCard(
                      title: 'Controls',
                      children: [
                        _buildSettingTile(
                          icon: Icons.touch_app,
                          title: 'Touch Controls',
                          subtitle: 'Tap left/right to move',
                          trailing: const Icon(Icons.check_circle,
                              color: Color(0xFF26de81)),
                        ),
                        _buildSettingTile(
                          icon: Icons.keyboard,
                          title: 'Keyboard Controls',
                          subtitle: 'Arrow keys to move',
                          trailing: const Icon(Icons.check_circle,
                              color: Color(0xFF26de81)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSettingsCard(
                      title: 'About',
                      children: [
                        _buildSettingTile(
                          icon: Icons.info_outline,
                          title: 'Version',
                          subtitle: '1.0.0',
                        ),
                        _buildSettingTile(
                          icon: Icons.code,
                          title: 'Built with',
                          subtitle: 'Flutter Flame Engine',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (_settings.isDarkMode
                ? const Color(0xFF1a1f3a)
                : Colors.white)
            .withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _settings.isDarkMode
              ? const Color(0xFF00ffff).withOpacity(0.3)
              : const Color(0xFF1976d2).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (_settings.isDarkMode
                    ? const Color(0xFF00ffff)
                    : const Color(0xFF1976d2))
                .withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _settings.isDarkMode
                    ? const Color(0xFFffd93d)
                    : const Color(0xFF1976d2),
                letterSpacing: 1,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (_settings.isDarkMode
                  ? const Color(0xFF00ffff)
                  : const Color(0xFF1976d2))
              .withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: _settings.isDarkMode
              ? const Color(0xFF00ffff)
              : const Color(0xFF1976d2),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:
              _settings.isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color:
              _settings.isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
      trailing: trailing,
    );
  }
}
