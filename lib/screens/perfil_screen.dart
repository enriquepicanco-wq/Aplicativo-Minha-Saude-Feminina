import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'editar_perfil_screen.dart';
import 'dicas_uteis_screen.dart';
import 'suporte_screen.dart';
import 'login_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('Rayssa', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            Text('rayssa@gmail.com', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _MenuItem(icon: Icons.edit_outlined, label: 'Editar perfil',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilScreen()))),
                  _MenuItem(icon: Icons.notifications_outlined, label: 'Notificações', onTap: () {}),
                  _MenuItem(icon: Icons.emoji_objects_outlined, label: 'Dicas Úteis',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DicasUteisScreen()))),
                  _MenuItem(icon: Icons.support_agent_outlined, label: 'Suporte',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SuporteScreen()))),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Sair',
                    isDestructive: true,
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppColors.textDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.shade50 : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDestructive ? Colors.red.shade100 : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.red : AppColors.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: color))),
            Icon(Icons.arrow_forward_ios, size: 14, color: isDestructive ? Colors.red.shade300 : AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
