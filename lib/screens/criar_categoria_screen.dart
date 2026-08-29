import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CriarCategoriaScreen extends StatefulWidget {
  final Function(String) onCriar;
  const CriarCategoriaScreen({super.key, required this.onCriar});

  @override
  State<CriarCategoriaScreen> createState() => _CriarCategoriaScreenState();
}

class _CriarCategoriaScreenState extends State<CriarCategoriaScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Categoria'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Título')),
            const SizedBox(height: 16),
            Text('Descrição', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Descrição'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onCriar(_controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Criar categoria'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
