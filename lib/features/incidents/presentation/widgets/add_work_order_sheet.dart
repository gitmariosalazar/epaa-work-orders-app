import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/features/users/users.dart';
import 'package:clean_architecture/features/work-orders/domain/params/create_work_order_from_incident_params.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/process/create_work_order_from_incident_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

/// Hoja "Generar OT" para una incidencia sin orden de trabajo.
/// Réplica de `AddWorkOrderModal.tsx` (epaa-web):
/// * Resumen de la incidencia.
/// * Selección obligatoria de un **técnico inspector**
///   (`FindTechniciansUseCase('INSPECTOR')`).
/// * `CreateWorkOrderFromIncidentUseCase({incidentCode, userIdAssignee})`.
///
/// Las dependencias son abstracciones de dominio inyectables (DIP), lo que
/// permite reutilizarla desde la tarjeta y desde el detalle (SRP/DRY).
class AddWorkOrderSheet extends StatefulWidget {
  final IncidentDetailRowResponse incident;

  /// Inyectables para tests; si son null se resuelven desde GetIt.
  final FindTechniciansUseCase? findTechnicians;
  final CreateWorkOrderFromIncidentUseCase? createWorkOrder;

  const AddWorkOrderSheet({
    super.key,
    required this.incident,
    this.findTechnicians,
    this.createWorkOrder,
  });

  /// Abre la hoja. Devuelve `true` si la OT se generó correctamente.
  static Future<bool> show(
    BuildContext context,
    IncidentDetailRowResponse incident,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddWorkOrderSheet(incident: incident),
    );
    return result ?? false;
  }

  @override
  State<AddWorkOrderSheet> createState() => _AddWorkOrderSheetState();
}

class _AddWorkOrderSheetState extends State<AddWorkOrderSheet> {
  final _searchCtrl = TextEditingController();

  List<TechnicianEntity> _technicians = const [];
  TechnicianEntity? _selected;
  bool _loading = true;
  bool _submitting = false;
  String? _loadError;
  String _query = '';

  /// Resuelve dependencias de forma perezosa y tolerante: si el use case no
  /// está registrado (p. ej. tras un hot reload sin reiniciar el injector) se
  /// construye a partir de su repositorio, que sí está registrado.
  FindTechniciansUseCase get _findTechnicians =>
      widget.findTechnicians ??
      (GetIt.I.isRegistered<FindTechniciansUseCase>()
          ? GetIt.I<FindTechniciansUseCase>()
          : FindTechniciansUseCase(GetIt.I<UserRepository>()));

  CreateWorkOrderFromIncidentUseCase get _createWorkOrder =>
      widget.createWorkOrder ??
      (GetIt.I.isRegistered<CreateWorkOrderFromIncidentUseCase>()
          ? GetIt.I<CreateWorkOrderFromIncidentUseCase>()
          : CreateWorkOrderFromIncidentUseCase(
              GetIt.I<WorkOrderRepository>(),
            ));

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTechnicians() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final result = await _findTechnicians(TechnicianType.inspector);
    if (!mounted) return;
    result.when(
      success: (list) => setState(() {
        _technicians = list
            .where((t) => t.id.isNotEmpty)
            .toList();
        _loading = false;
      }),
      failure: (message, _) => setState(() {
        _loadError = message;
        _loading = false;
      }),
      loading: () {},
    );
  }

  List<TechnicianEntity> get _filtered {
    if (_query.isEmpty) return _technicians;
    final q = _query.toLowerCase();
    return _technicians
        .where(
          (t) =>
              t.fullName.toLowerCase().contains(q) ||
              (t.idCard ?? '').toLowerCase().contains(q) ||
              (t.email ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  bool get _canSubmit => _selected != null && !_submitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _submitting = true);

    final result = await _createWorkOrder(
      CreateWorkOrderFromIncidentParams(
        incidentCode: widget.incident.incidentCode,
        userIdAssignee: _selected!.id,
      ),
    );
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    if (result is SuccessState) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          content: Text(
            'Se creó la OT para el incidente ${widget.incident.incidentCode}',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      setState(() => _submitting = false);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            result.message?.isNotEmpty == true
                ? result.message!
                : 'No se pudo generar la orden de trabajo',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(cs),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IncidentSummary(incident: widget.incident),
                    const SizedBox(height: 16),
                    _InfoBanner(
                      text:
                          'Seleccione un técnico inspector para asignarle la orden de trabajo.',
                    ),
                    const SizedBox(height: 14),
                    Text.rich(
                      TextSpan(
                        text: 'Técnico Inspector ',
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: cs.error),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTechnicianPicker(cs),
                  ],
                ),
              ),
            ),
            _buildFooter(cs),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_add,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Generar OT - ${widget.incident.incidentCode}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Cerrar',
                onPressed: _submitting
                    ? null
                    : () => Navigator.of(context).pop(false),
                icon: Icon(Icons.close_rounded, color: cs.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianPicker(ColorScheme cs) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Cargando técnicos...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    if (_loadError != null) {
      return Column(
        children: [
          Text(_loadError!, style: TextStyle(color: cs.error, fontSize: 12)),
          TextButton.icon(
            onPressed: _loadTechnicians,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      );
    }

    final items = _filtered;
    return Column(
      children: [
        TextField(
          controller: _searchCtrl,
          enabled: !_submitting,
          onChanged: (v) => setState(() => _query = v.trim()),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Buscar e.g. Juan Perez...',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 260),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No se encontraron técnicos inspectores.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final t = items[i];
                    final selected = _selected?.id == t.id;
                    return ListTile(
                      dense: true,
                      enabled: !_submitting,
                      selected: selected,
                      selectedTileColor: cs.primary.withValues(alpha: 0.08),
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: selected
                            ? cs.primary
                            : cs.primary.withValues(alpha: 0.12),
                        child: Text(
                          t.fullName.isNotEmpty
                              ? t.fullName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 13,
                            color: selected ? cs.onPrimary : cs.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        t.fullName.isNotEmpty ? t.fullName : '(sin nombre)',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        [
                          t.positionName,
                          t.idCard,
                        ].whereType<String>().where((s) => s.isNotEmpty).join(
                          ' • ',
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: selected
                          ? Icon(Icons.check_circle_rounded, color: cs.primary)
                          : null,
                      onTap: () => setState(() => _selected = t),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFooter(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _submitting
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              onPressed: _canSubmit ? _submit : null,
              icon: _submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add_rounded),
              label: Text(_submitting ? 'Generando...' : 'Generar OT'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Resumen del incidente (equivale a `IncidentSummaryInfo` de epaa-web).
class _IncidentSummary extends StatelessWidget {
  final IncidentDetailRowResponse incident;
  const _IncidentSummary({required this.incident});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.subject_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 6),
              const Text(
                'Resumen del Incidente',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row(
            Icons.sell_outlined,
            const Color(0xFF3B82F6),
            'Categoría / Tipo',
            '${incident.categoryName}\n${incident.incidentTypeName}',
          ),
          _row(
            Icons.calendar_today_rounded,
            const Color(0xFFF97316),
            'Fecha de Reporte',
            DateFormat('dd/MM/yyyy HH:mm').format(incident.reportDate),
          ),
          if (incident.connectionId?.isNotEmpty == true)
            _row(
              Icons.lan_outlined,
              const Color(0xFF22C55E),
              'Acometida Asociada',
              incident.connectionId!,
            ),
          _row(
            Icons.location_on_outlined,
            const Color(0xFFEF4444),
            'Ubicación',
            incident.referenceAddress?.isNotEmpty == true
                ? incident.referenceAddress!
                : 'Sin dirección registrada',
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descripción del Reporte:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  incident.reportDescription.isNotEmpty
                      ? incident.reportDescription
                      : 'El usuario no proporcionó una descripción detallada.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: incident.reportDescription.isNotEmpty
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;
  const _InfoBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
