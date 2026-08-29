import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'main_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  void _login() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.favorite, color: AppColors.primary, size: 44),
              ),
              const SizedBox(height: 16),
              Text('Minha Saúde Feminina',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('Acesse informações sobre sua saúde e bem-estar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Faça login com sua conta',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'E-mail', prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary)),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textGrey),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Esqueci a senha', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _login, child: const Text('Faça login')),
              const SizedBox(height: 16),
              Row(children: [
                const Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('ou', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
                ),
                const Expanded(child: Divider(color: AppColors.border)),
              ]),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _login,
                icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.primary),
                label: Text('Login com Google', style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.w500)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Não tem conta? ', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
                GestureDetector(
                  onTap: _login,
                  child: Text('Criar conta', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
