import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'detalhe_artigo_screen.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('artigos')
            .where('publicado', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.article_outlined, size: 64, color: AppColors.border),
                  const SizedBox(height: 16),
                  Text('Nenhum artigo publicado ainda',
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Text('Crie artigos no painel web',
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.border)),
                ],
              ),
            );
          }

          final artigos = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: artigos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final data = artigos[i].data() as Map<String, dynamic>;
              final id = artigos[i].id;
              final titulo = data['titulo'] ?? 'Sem título';
              final desc = data['descricao'] ?? '';
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
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16)),
                        ),
                        child: const Icon(Icons.health_and_safety_outlined,
                            color: AppColors.primary, size: 36),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(categoria,
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(height: 6),
                              Text(titulo,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark)),
                              const SizedBox(height: 4),
                              if (desc.isNotEmpty)
                                Text(desc,
                                    style: GoogleFonts.poppins(
                                        fontSize: 11, color: AppColors.textGrey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
