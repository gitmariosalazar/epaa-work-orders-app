import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/search/domain/usecases/get_connection_with_properties.dart';
import 'package:clean_architecture/utils/convert_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/work_order_form_state.dart';
import 'client_edit_dialog.dart';

class StepClientSelection extends StatefulWidget {
  final WorkOrderFormState form;
  final void Function(WorkOrderFormState updatedForm) onFormChange;
  final Map<String, String>? errors;

  const StepClientSelection({
    super.key,
    required this.form,
    required this.onFormChange,
    this.errors,
  });

  @override
  State<StepClientSelection> createState() => _StepClientSelectionState();
}

class _StepClientSelectionState extends State<StepClientSelection> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;
  List<ConnectionEntity> _connections = [];
  String? _searchErrorMessage;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese una cédula, RUC o clave catastral para buscar.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _searchErrorMessage = null;
    });

    try {
      final getConnection = GetIt.I<GetConnection>();
      final results = await getConnection(query);

      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _connections = results;
        if (results.isEmpty) {
          _searchErrorMessage = 'No se encontraron acometidas para "$query".';
        }
      });

      if (results.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se encontraron ${results.length} acometida(s).'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Si solo hay 1 resultado, seleccionarla automáticamente
        if (results.length == 1) {
          _selectConnection(results.first);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _connections = [];
        _searchErrorMessage = 'Error al buscar en el servidor: $e';
      });
    }
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      _connections = [];
      _searchErrorMessage = null;
    });
    widget.onFormChange(
      widget.form.copyWith(
        clientId: '',
        clientName: '',
        clientEmail: '',
        clientPhone: '',
        tipoPersona: 'NATURAL',
        cadastralKey: '',
        location: '',
        clearSelectedConnection: true,
        clearCoordinates: true,
      ),
    );
  }

  void _selectConnection(ConnectionEntity conn) {
    String clientName = '';
    String clientId = conn.clientId;
    String clientEmail = '';
    String clientPhone = '';
    String tipoPersona = 'NATURAL';

    if (conn.person != null) {
      final p = conn.person!;
      clientId = p.personId;
      clientName = '${p.firstName ?? ''} ${p.lastName ?? ''}'.trim();
      clientEmail = (p.emails.isNotEmpty && p.emails.first != null)
          ? p.emails.first!.email
          : '';
      clientPhone = (p.phones.isNotEmpty && p.phones.first != null)
          ? p.phones.first!.numero
          : '';
      tipoPersona = 'NATURAL';
    } else if (conn.company != null) {
      final c = conn.company!;
      clientId = c.ruc;
      clientName = c.businessName ?? c.commercialName ?? '';
      clientEmail = (c.emails.isNotEmpty && c.emails.first != null)
          ? c.emails.first!.email
          : '';
      clientPhone = (c.phones.isNotEmpty && c.phones.first != null)
          ? c.phones.first!.numero
          : '';
      tipoPersona = 'JURIDICA';
    }

    double? lat;
    double? lng;

    if (conn.connectionCoordinates != null &&
        conn.connectionCoordinates!.trim().isNotEmpty) {
      try {
        final coords = extractCoordinates(conn.connectionCoordinates!);
        lat = coords['latitude'];
        lng = coords['longitude'];
      } catch (_) {}
    }

    widget.onFormChange(
      widget.form.copyWith(
        clientId: clientId,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        tipoPersona: tipoPersona,
        cadastralKey: conn.connectionCadastralKey,
        location: conn.connectionAddress,
        latitude: lat,
        longitude: lng,
        selectedConnection: conn,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Acometida ${conn.connectionCadastralKey} seleccionada.'),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (_) => ClientEditDialog(
        initialName: widget.form.clientName,
        initialEmail: widget.form.clientEmail,
        initialPhone: widget.form.clientPhone,
        onSave: (name, email, phone) {
          widget.onFormChange(
            widget.form.copyWith(
              clientName: name,
              clientEmail: email,
              clientPhone: phone,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasClient = widget.form.clientName.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search Card ──
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        color: cs.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Buscar por Cédula o Clave Catastral',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _handleSearch(),
                          decoration: InputDecoration(
                            hintText: 'Cédula, RUC o Clave (Ej: 14-293)',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                            ),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _isSearching ? null : _handleSearch,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSearching
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Buscar'),
                      ),
                      if (_connections.isNotEmpty ||
                          _searchCtrl.text.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          tooltip: 'Limpiar',
                          onPressed: _clearSearch,
                        ),
                      ],
                    ],
                  ),
                  if (_searchErrorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _searchErrorMessage!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Validation Errors ──
          if (widget.errors?['clientId'] != null ||
              widget.errors?['clientName'] != null ||
              widget.errors?['cadastralKey'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errors?['clientId'] ??
                          widget.errors?['clientName'] ??
                          widget.errors?['cadastralKey'] ??
                          '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Connections List Table (si hay resultados) ──
          if (_connections.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  'Acometidas encontradas (${_connections.length}) — Seleccione una:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _connections.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final conn = _connections[index];
                final isSelected =
                    widget.form.selectedConnection?.connectionId ==
                        conn.connectionId ||
                    (widget.form.cadastralKey == conn.connectionCadastralKey &&
                        conn.connectionCadastralKey.isNotEmpty);

                return InkWell(
                  onTap: () => _selectConnection(conn),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primaryContainer.withValues(alpha: 0.35)
                          : cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.6),
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: isSelected,
                          onChanged: (_) => _selectConnection(conn),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Clave: ${conn.connectionCadastralKey}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (conn.connectionStatus != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: conn.connectionStatus == true
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: conn.connectionStatus == true
                                              ? Colors.green.shade300
                                              : Colors.red.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        conn.connectionStatus == true
                                            ? 'ACTIVA'
                                            : 'INACTIVA',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: conn.connectionStatus == true
                                              ? Colors.green.shade800
                                              : Colors.red.shade800,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                conn.connectionAddress,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (conn.connectionMeterNumber != null &&
                                      conn.connectionMeterNumber!.isNotEmpty)
                                    Text(
                                      'Medidor: ${conn.connectionMeterNumber!}  •  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  if (conn.connectionRateName.isNotEmpty)
                                    Text(
                                      'Tarifa: ${conn.connectionRateName}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          // ── Titular Card ──
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: hasClient
                              ? Colors.blue.shade50
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: hasClient
                                    ? Colors.blue.shade600
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Titular de la Orden',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: hasClient
                                    ? Colors.blue.shade800
                                    : cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (hasClient)
                        OutlinedButton.icon(
                          onPressed: _openEditDialog,
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text(
                            'Actualizar Datos',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: hasClient
                            ? cs.primary
                            : cs.surfaceContainerHighest,
                        foregroundColor: hasClient
                            ? Colors.white
                            : cs.onSurfaceVariant,
                        child: Text(
                          hasClient && widget.form.clientName.trim().isNotEmpty
                              ? widget.form.clientName
                                    .trim()
                                    .substring(0, 1)
                                    .toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasClient
                                  ? widget.form.clientName
                                  : 'Sin titular seleccionado',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasClient
                                  ? 'Cliente vinculado al predio'
                                  : 'Busque por cédula o clave catastral para seleccionar',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildTitularRow(
                    context,
                    Icons.badge_outlined,
                    'Cédula / RUC',
                    widget.form.clientId.isNotEmpty
                        ? widget.form.clientId
                        : 'Sin identificación',
                  ),
                  const SizedBox(height: 8),
                  _buildTitularRow(
                    context,
                    Icons.phone_outlined,
                    'Teléfono',
                    widget.form.clientPhone.isNotEmpty
                        ? widget.form.clientPhone
                        : 'Sin teléfono',
                  ),
                  const SizedBox(height: 8),
                  _buildTitularRow(
                    context,
                    Icons.email_outlined,
                    'Correo Electrónico',
                    widget.form.clientEmail.isNotEmpty
                        ? widget.form.clientEmail
                        : 'Sin correo',
                  ),
                  const SizedBox(height: 8),
                  _buildTitularRow(
                    context,
                    Icons.business_outlined,
                    'Tipo de Persona',
                    widget.form.tipoPersona == 'JURIDICA'
                        ? 'Persona Jurídica'
                        : 'Persona Natural',
                  ),
                  if (widget.form.cadastralKey.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildTitularRow(
                      context,
                      Icons.map_outlined,
                      'Acometida / Clave',
                      widget.form.cadastralKey,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade800,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Busque por Cédula, RUC o Clave Catastral para vincular la acometida y titular automáticamente.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitularRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
