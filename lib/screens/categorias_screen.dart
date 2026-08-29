import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'criar_categoria_screen.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final List<Map<String, dynamic>> _categorias = [
    {'icon': Icons.child_care, 'label': 'Adolescência e Puberdade', 'qtd': 8},
    {'icon': Icons.pregnant_woman, 'label': 'Gestação e Pós-Parto', 'qtd': 12},
    {'icon': Icons.psychology, 'label': 'Saúde Mental', 'qtd': 15},
    {'icon': Icons.favorite, 'label': 'Saúde Sexual e Reprodutiva', 'qtd': 10},
    {'icon': Icons.self_improvement, 'label': 'Menopausa', 'qtd': 6},
    {'icon': Icons.healing, 'label': 'Ação e Reabilitação', 'qtd': 4},
    {'icon': Icons.spa, 'label': 'Menopausa', 'qtd': 7},
    {'icon': Icons.medical_services, 'label': 'Prevenção de Doenças', 'qtd': 9},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Categoria'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = _categorias[i];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                        child: Icon(c['icon'] as IconData, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Text(c['label'] as String,
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark))),
                      Text('${c['qtd']} artigos', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 18),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CriarCategoriaScreen(
                onCriar: (label) => setState(() => _categorias.add({'icon': Icons.category, 'label': label, 'qtd': 0})),
              ))),
              icon: const Icon(Icons.add),
              label: const Text('Nova Categoria'),
            ),
          ),
        ],
      ),
    );
  }
}
