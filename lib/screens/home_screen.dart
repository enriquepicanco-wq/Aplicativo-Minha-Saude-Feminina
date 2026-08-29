import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'categorias_screen.dart';
import 'detalhe_artigo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categorias = [
    {'icon': Icons.child_care, 'label': 'Adolescência e Puberdade'},
    {'icon': Icons.psychology, 'label': 'Saúde Mental'},
    {'icon': Icons.favorite, 'label': 'Saúde Sexual e Reprodutiva'},
    {'icon': Icons.pregnant_woman, 'label': 'Gestação e Pós-Parto'},
    {'icon': Icons.self_improvement, 'label': 'Menopausa'},
    {'icon': Icons.healing, 'label': 'Prevenção de Doenças'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Olá! 👋',
                              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGrey)),
                          Text('Minha Saúde',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_outline, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categorias',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const CategoriasScreen())),
                      child: Text('Ver Categorias',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final cat = _categorias[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(cat['icon'] as IconData, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(cat['label'] as String,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryDark),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _categorias.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text('Artigos em Destaque',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('artigos')
                    .where('publicado', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 130,
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('Nenhum artigo publicado ainda',
                            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
                      ),
                    );
                  }

                  final artigos = snapshot.data!.docs;
                  final colors = [AppColors.primary, AppColors.primaryDark];

                  return SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: artigos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final data = artigos[i].data() as Map<String, dynamic>;
                        final id = artigos[i].id;
                        final titulo = data['titulo'] ?? 'Sem título';
                        final categoria = data['categoria'] ?? 'Geral';
                        final conteudo = data['conteudo'] ?? '';

                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DetalheArtigoScreen(
                                id: id,
                                titulo: titulo,
                                categoria: categoria,
                                conteudoHtml: conteudo,
                              ))),
                          child: Container(
                            width: 160,
                            decoration: BoxDecoration(
                              color: colors[i % colors.length],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.article_outlined, color: Colors.white70, size: 28),
                                const SizedBox(height: 8),
                                Text(titulo,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Text(categoria,
                                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
