import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../managers/settings_manager.dart';
import '../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsManager();
    final isDark = settings.isDarkMode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0a0e27) : const Color(0xFFe3f2fd),
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
        backgroundColor: isDark ? const Color(0xFF1a1f3a) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2))
                    .withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.calculate_rounded,
                size: 60,
                color: isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // App Title
          Text(
            l10n.appTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Version
          Text(
            '${l10n.version} 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Description
          _buildInfoCard(
            context,
            icon: Icons.info_outline,
            title: l10n.description,
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          // Links Section
          Text(
            l10n.support,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Privacy Policy
          _buildLinkCard(
            context,
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            onTap: () => _launchURL('https://your-website.com/privacy-policy'),
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Terms of Use
          _buildLinkCard(
            context,
            icon: Icons.description_outlined,
            title: l10n.termsOfUse,
            onTap: () => _launchURL('https://your-website.com/terms-of-use'),
            isDark: isDark,
          ),

          const SizedBox(height: 12),

          // Rate App (placeholder)
          _buildLinkCard(
            context,
            icon: Icons.star_outline,
            title: l10n.rateApp,
            onTap: () {
              // TODO: Add app store link
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rate app feature coming soon!'),
                  backgroundColor: isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2),
                ),
              );
            },
            isDark: isDark,
          ),

          const SizedBox(height: 30),

          // Footer
          Text(
            '© 2024 Equation Builder Dash\nBuilt with Flutter & Flame',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f3a) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2))
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f3a) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2))
                .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
