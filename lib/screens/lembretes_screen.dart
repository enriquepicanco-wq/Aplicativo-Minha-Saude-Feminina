import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class LembretesScreen extends StatefulWidget {
  const LembretesScreen({super.key});

  @override
  State<LembretesScreen> createState() => _LembretesScreenState();
}

class _LembretesScreenState extends State<LembretesScreen> {
  final List<Map<String, String>> _lembretes = [
    {'titulo': 'Consulta ginecológica', 'data': '20/05/2026', 'hora': '09:00'},
    {'titulo': 'Exame preventivo', 'data': '25/05/2026', 'hora': '10:30'},
    {'titulo': 'Tomar medicamento', 'data': '14/05/2026', 'hora': '08:00'},
  ];

  void _abrirCriarLembrete() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CriarLembreteScreen(
      onSalvar: (titulo, data, hora) {
        setState(() => _lembretes.insert(0, {'titulo': titulo, 'data': data, 'hora': hora}));
      },
    )));
  }

  void _deletar(int index) {
    setState(() => _lembretes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Lembretes'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCriarLembrete,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _lembretes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.border),
                  const SizedBox(height: 16),
                  Text('Nenhum lembrete ainda', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Text('Toque no + para criar', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.border)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _lembretes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final l = _lembretes[i];
                return Dismissible(
                  key: Key(l['titulo']! + i.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  onDismissed: (_) => _deletar(i),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                          child: const Icon(Icons.alarm, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l['titulo']!, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textGrey),
                                  const SizedBox(width: 4),
                                  Text('${l['data']} às ${l['hora']}',
                                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.textGrey),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CriarLembreteScreen extends StatefulWidget {
  final Function(String, String, String) onSalvar;
  const CriarLembreteScreen({super.key, required this.onSalvar});

  @override
  State<CriarLembreteScreen> createState() => _CriarLembreteScreenState();
}

class _CriarLembreteScreenState extends State<CriarLembreteScreen> {
  final _tituloController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  TimeOfDay _horaSelecionada = TimeOfDay.now();

  Future<void> _selecionarData() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (d != null) setState(() => _dataSelecionada = d);
  }

  Future<void> _selecionarHora() async {
    final h = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (h != null) setState(() => _horaSelecionada = h);
  }

  void _salvar() {
    if (_tituloController.text.trim().isEmpty) return;
    final data = '${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}';
    final hora = '${_horaSelecionada.hour.toString().padLeft(2, '0')}:${_horaSelecionada.minute.toString().padLeft(2, '0')}';
    widget.onSalvar(_tituloController.text.trim(), data, hora);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Nova Lembrança'), leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(controller: _tituloController, decoration: const InputDecoration(hintText: 'Ex: Consulta médica')),
            const SizedBox(height: 20),
            Text('Data', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selecionarData,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Text('Hora', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selecionarHora,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  const Icon(Icons.access_time, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('${_horaSelecionada.hour.toString().padLeft(2, '0')}:${_horaSelecionada.minute.toString().padLeft(2, '0')}',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark)),
                ]),
              ),
            ),
            const Spacer(),
            ElevatedButton(onPressed: _salvar, child: const Text('Criar lembrete')),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
