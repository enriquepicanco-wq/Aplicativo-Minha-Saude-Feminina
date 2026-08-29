import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class CicloMenstrual {
  final DateTime inicio;
  final DateTime? fim;

  CicloMenstrual({required this.inicio, this.fim});

  Map<String, dynamic> toJson() => {
        'inicio': inicio.toIso8601String(),
        'fim': fim?.toIso8601String(),
      };

  factory CicloMenstrual.fromJson(Map<String, dynamic> json) => CicloMenstrual(
        inicio: DateTime.parse(json['inicio']),
        fim: json['fim'] != null ? DateTime.parse(json['fim']) : null,
      );

  int get duracao => fim != null ? fim!.difference(inicio).inDays + 1 : 1;
}

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  List<CicloMenstrual> _ciclos = [];
  DateTime _mesSelecionado = DateTime.now();

  @override
  void initState() {
    super.initState();
    _carregarCiclos();
  }

  Future<void> _carregarCiclos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('ciclos_menstruais');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _ciclos = decoded.map((e) => CicloMenstrual.fromJson(e)).toList();
        _ciclos.sort((a, b) => b.inicio.compareTo(a.inicio));
      });
    }
  }

  Future<void> _salvarCiclos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ciclos_menstruais', jsonEncode(_ciclos.map((c) => c.toJson()).toList()));
  }

  void _registrarInicio(DateTime data) {
    DateTime? fimSelecionado;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Registrar Ciclo', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Início:', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
              Text(_fmt(data), style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 16),
              Text('Término (opcional):', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: data.add(const Duration(days: 4)),
                    firstDate: data,
                    lastDate: data.add(const Duration(days: 14)),
                    builder: (ctx, child) => Theme(
                      data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
                      child: child!,
                    ),
                  );
                  if (picked != null) setDialogState(() => fimSelecionado = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(fimSelecionado != null ? _fmt(fimSelecionado!) : 'Selecionar data de término',
                        style: GoogleFonts.poppins(fontSize: 13, color: fimSelecionado != null ? AppColors.textDark : AppColors.textGrey)),
                  ]),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: GoogleFonts.poppins(color: AppColors.textGrey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                setState(() { _ciclos.insert(0, CicloMenstrual(inicio: data, fim: fimSelecionado)); _ciclos.sort((a, b) => b.inicio.compareTo(a.inicio)); });
                _salvarCiclos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Ciclo registrado!', style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ));
              },
              child: Text('Salvar', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deletarCiclo(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Excluir registro?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Essa ação não pode ser desfeita.', style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: GoogleFonts.poppins(color: AppColors.textGrey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () { setState(() => _ciclos.removeAt(index)); _salvarCiclos(); Navigator.pop(context); },
            child: Text('Excluir', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  DateTime? get _proximoCiclo {
    if (_ciclos.isEmpty) return null;
    if (_ciclos.length == 1) return _ciclos.first.inicio.add(const Duration(days: 28));
    int total = 0, count = 0;
    for (int i = 0; i < _ciclos.length - 1; i++) {
      final diff = _ciclos[i].inicio.difference(_ciclos[i + 1].inicio).inDays.abs();
      if (diff > 0 && diff < 60) { total += diff; count++; }
    }
    return _ciclos.first.inicio.add(Duration(days: count > 0 ? (total / count).round() : 28));
  }

  int get _mediaDuracao {
    final comFim = _ciclos.where((c) => c.fim != null).toList();
    if (comFim.isEmpty) return 5;
    return (comFim.map((c) => c.duracao).reduce((a, b) => a + b) / comFim.length).round();
  }

  bool _isDiaMenstrual(DateTime dia) {
    for (final c in _ciclos) {
      final fim = c.fim ?? c.inicio.add(const Duration(days: 4));
      if (!dia.isBefore(c.inicio) && !dia.isAfter(fim)) return true;
    }
    return false;
  }

  bool _isDiaPrevisao(DateTime dia) {
    final prox = _proximoCiclo;
    if (prox == null) return false;
    final fim = prox.add(Duration(days: _mediaDuracao - 1));
    return !dia.isBefore(prox) && !dia.isAfter(fim);
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  List<DateTime?> _diasDoMes() {
    final primeiro = DateTime(_mesSelecionado.year, _mesSelecionado.month, 1);
    final ultimo = DateTime(_mesSelecionado.year, _mesSelecionado.month + 1, 0);
    final List<DateTime?> dias = [];
    for (int i = 0; i < primeiro.weekday % 7; i++) dias.add(null);
    for (int i = 1; i <= ultimo.day; i++) dias.add(DateTime(_mesSelecionado.year, _mesSelecionado.month, i));
    while (dias.length % 7 != 0) dias.add(null);
    return dias;
  }

  static const _meses = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'];
  static const _semana = ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb'];

  @override
  Widget build(BuildContext context) {
    final dias = _diasDoMes();
    final hoje = DateTime.now();
    final prox = _proximoCiclo;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Calendário Menstrual'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_outline, color: AppColors.primary, size: 20),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth > 500 ? 500.0 : constraints.maxWidth;
          return Center(
            child: SizedBox(
              width: maxW,
              child: Column(
                children: [
                  // Banner previsão
                  if (prox != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        const Icon(Icons.calendar_month, color: Colors.white, size: 26),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Próximo ciclo previsto', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                          Text(_fmt(prox), style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ])),
                        Column(children: [
                          Text('${prox.difference(hoje).inDays}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                          Text('dias', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
                        ]),
                      ]),
                    ),

                  // Navegação mês
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => setState(() => _mesSelecionado = DateTime(_mesSelecionado.year, _mesSelecionado.month - 1)),
                        icon: const Icon(Icons.chevron_left, color: AppColors.primary),
                      ),
                      Text('${_meses[_mesSelecionado.month - 1]} ${_mesSelecionado.year}',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => setState(() => _mesSelecionado = DateTime(_mesSelecionado.year, _mesSelecionado.month + 1)),
                        icon: const Icon(Icons.chevron_right, color: AppColors.primary),
                      ),
                    ]),
                  ),

                  // Cabeçalho dias semana
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: _semana.map((d) => Expanded(
                        child: Center(child: Text(d, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textGrey))),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Grid calendário — expandido para preencher o espaço disponível
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: List.generate((dias.length / 7).ceil(), (semana) {
                          return Expanded(
                            child: Row(
                              children: List.generate(7, (dia) {
                                final idx = semana * 7 + dia;
                                if (idx >= dias.length || dias[idx] == null) return const Expanded(child: SizedBox());
                                final d = dias[idx]!;
                                final isHoje = d.year == hoje.year && d.month == hoje.month && d.day == hoje.day;
                                final isMenstrual = _isDiaMenstrual(d);
                                final isPrevisao = !isMenstrual && _isDiaPrevisao(d);

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => _registrarInicio(d),
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: isMenstrual ? AppColors.primary : isPrevisao ? AppColors.primaryLight : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: isHoje && !isMenstrual ? Border.all(color: AppColors.primary, width: 1.5) : null,
                                      ),
                                      child: Center(
                                        child: Text('${d.day}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: isHoje || isMenstrual ? FontWeight.w600 : FontWeight.normal,
                                            color: isMenstrual ? Colors.white : isPrevisao ? AppColors.primary : AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // Legenda + botão registrar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _legenda(AppColors.primary, 'Menstruação'),
                      const SizedBox(width: 16),
                      _legenda(AppColors.primaryLight, 'Previsão', border: true),
                      const SizedBox(width: 16),
                      _legenda(Colors.transparent, 'Hoje', border: true, borderColor: AppColors.primary),
                    ]),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _registrarInicio(DateTime.now()),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Registrar ciclo'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 42),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  // Histórico compacto
                  if (_ciclos.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                            child: Text('Histórico', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: _ciclos.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 6),
                              itemBuilder: (context, i) {
                                final c = _ciclos[i];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                                  child: Row(children: [
                                    const Icon(Icons.water_drop, color: AppColors.primary, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text('Início: ${_fmt(c.inicio)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                      Text(c.fim != null ? 'Término: ${_fmt(c.fim!)} • ${c.duracao} dias' : 'Término não registrado',
                                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGrey)),
                                    ])),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      onPressed: () => _deletarCiclo(i),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _legenda(Color cor, String label, {bool border = false, Color borderColor = AppColors.border}) {
    return Row(children: [
      Container(
        width: 14, height: 14,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle, border: border ? Border.all(color: borderColor) : null),
      ),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGrey)),
    ]);
  }
}
