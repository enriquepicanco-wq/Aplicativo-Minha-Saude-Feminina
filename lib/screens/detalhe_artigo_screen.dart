import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

class DetalheArtigoScreen extends StatelessWidget {
  final String id;
  final String titulo;
  final String categoria;
  final String conteudoHtml;

  const DetalheArtigoScreen({
    super.key,
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.conteudoHtml,
  });

  // Extrai blocos de conteúdo: texto ou imagem
  List<Map<String, String>> _parseConteudo(String html) {
    final List<Map<String, String>> blocos = [];
    String restante = html;

    while (restante.isNotEmpty) {
      final imgStart = restante.indexOf('<img');
      if (imgStart == -1) {
        // Sem mais imagens, pega o resto como texto
        final texto = _limparHtml(restante).trim();
        if (texto.isNotEmpty) blocos.add({'tipo': 'texto', 'valor': texto});
        break;
      }

      // Texto antes da imagem
      if (imgStart > 0) {
        final texto = _limparHtml(restante.substring(0, imgStart)).trim();
        if (texto.isNotEmpty) blocos.add({'tipo': 'texto', 'valor': texto});
      }

      // Extrair src da imagem
      final imgEnd = restante.indexOf('>', imgStart);
      final imgTag = restante.substring(imgStart, imgEnd + 1);
      final srcMatch = RegExp(r'src="([^"]+)"').firstMatch(imgTag);
      if (srcMatch != null) {
        blocos.add({'tipo': 'imagem', 'valor': srcMatch.group(1)!});
      }

      restante = restante.substring(imgEnd + 1);
    }

    return blocos;
  }

  String _limparHtml(String html) {
    return html
        .replaceAll(RegExp(r'<h1[^>]*>'), '\n')
        .replaceAll(RegExp(r'</h1>'), '\n')
        .replaceAll(RegExp(r'<h2[^>]*>'), '\n')
        .replaceAll(RegExp(r'</h2>'), '\n')
        .replaceAll(RegExp(r'<h3[^>]*>'), '\n')
        .replaceAll(RegExp(r'</h3>'), '\n')
        .replaceAll(RegExp(r'<p[^>]*>'), '')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<li[^>]*>'), '• ')
        .replaceAll(RegExp(r'</li>'), '\n')
        .replaceAll(RegExp(r'<ul[^>]*>|</ul>|<ol[^>]*>|</ol>'), '\n')
        .replaceAll(RegExp(r'<strong[^>]*>|</strong>'), '')
        .replaceAll(RegExp(r'<em[^>]*>|</em>'), '')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  Widget _renderImagem(String src) {
    try {
      if (src.startsWith('data:image')) {
        // Imagem base64
        final base64Data = src.split(',').last;
        final bytes = base64Decode(base64Data);
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Image.memory(bytes, fit: BoxFit.cover, width: double.infinity),
        );
      } else {
        // Imagem via URL
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Image.network(src, fit: BoxFit.cover, width: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              height: 100,
              color: AppColors.primaryLight,
              child: const Center(child: Icon(Icons.broken_image_outlined, color: AppColors.primary)),
            ),
          ),
        );
      }
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocos = _parseConteudo(conteudoHtml.isEmpty ? '<p>Conteúdo não disponível.</p>' : conteudoHtml);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(child: Icon(Icons.health_and_safety, size: 72, color: Colors.white54)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                    child: Text(categoria,
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 12),
                  Text(titulo,
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),
                  // Renderiza blocos de texto e imagem
                  ...blocos.map((bloco) {
                    if (bloco['tipo'] == 'imagem') {
                      return _renderImagem(bloco['valor']!);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(bloco['valor']!,
                          style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textDark, height: 1.8)),
                    );
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
