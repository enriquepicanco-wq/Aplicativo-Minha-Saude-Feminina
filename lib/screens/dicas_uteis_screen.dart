import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DicasUteisScreen extends StatelessWidget {
  const DicasUteisScreen({super.key});

  static const _dicas = [
    {
      'titulo': '🌸 Saúde é prioridade!',
      'texto': 'Minha mãe dizia que saúde mental é tão importante quanto saúde física. Cuide-se sempre!',
    },
    {
      'titulo': '💊 Seus remédios',
      'texto': 'Nunca se esqueça de tomar sua medicação. Se tiver dúvidas, consulte sempre seu médico de confiança.',
    },
    {
      'titulo': '🌺 Nova dica!',
      'texto': 'Pratique exercícios regularmente. A atividade física ajuda a controlar hormônios e melhora o humor.',
    },
    {
      'titulo': '🥗 Alimentação saudável',
      'texto': 'Uma dieta equilibrada é fundamental para a saúde feminina em todas as fases da vida.',
    },
    {
      'titulo': '😴 Qualidade do sono',
      'texto': 'Dormir bem é essencial. Tente manter uma rotina de sono regular de 7 a 9 horas por noite.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Dicas Úteis'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _dicas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final d = _dicas[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['titulo']!, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                      const SizedBox(height: 6),
                      Text(d['texto']!, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark, height: 1.6)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Voltar', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class SuporteScreen extends StatelessWidget {
  const SuporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Suporte'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: Icon(Icons.support_agent, size: 80, color: AppColors.primary)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💬 Suporte', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                        const SizedBox(height: 8),
                        Text(
                          'Você pode tirar dúvidas, relatar problemas ou dar sugestões. Nossa equipe está sempre disponível para te ajudar!\n\n'
                          'Nosso suporte funciona de segunda a sexta das 8h às 18h. Responderemos o mais breve possível.\n\n'
                          'Suas informações são tratadas com total privacidade e segurança.',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Enviar mensagem'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Voltar', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
