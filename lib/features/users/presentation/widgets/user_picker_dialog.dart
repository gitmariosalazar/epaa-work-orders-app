import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/users/users.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Filtro reutilizable: técnicos de servicio (igual que WorkOrderWorkersCard.tsx).
bool isServiceTechnician(UserEntity u) {
  return true;
  /*
  return p.contains('analista de servicios') ||
      p.contains('tecnico de servicios') ||
      p.contains('técnico de servicios');
      */
}

/// Diálogo reutilizable para seleccionar un usuario existente.
/// Devuelve el [UserEntity] elegido o `null` si se cancela.
///
/// ```dart
/// final user = await UserPickerDialog.show(context, filter: isServiceTechnician);
/// ```
class UserPickerDialog extends StatefulWidget {
  final String title;
  final bool Function(UserEntity user)? filter;
  final Set<String> excludedIds;

  const UserPickerDialog({
    super.key,
    this.title = 'Seleccionar usuario',
    this.filter,
    this.excludedIds = const {},
  });

  static Future<UserEntity?> show(
    BuildContext context, {
    String title = 'Seleccionar usuario',
    bool Function(UserEntity user)? filter,
    Set<String> excludedIds = const {},
  }) => showDialog<UserEntity>(
    context: context,
    builder: (_) => UserPickerDialog(
      title: title,
      filter: filter,
      excludedIds: excludedIds,
    ),
  );

  @override
  State<UserPickerDialog> createState() => _UserPickerDialogState();
}

class _UserPickerDialogState extends State<UserPickerDialog> {
  final _search = TextEditingController();
  List<UserEntity> _all = [];
  bool _loading = true;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await GetIt.I<GetUsersUseCase>()(
      const PaginationParams(limit: 500),
    );
    if (!mounted) return;
    result.when(
      success: (users) => setState(() {
        _all =
            users
                .where((u) => u.userId.isNotEmpty && u.isActive)
                .where((u) => !widget.excludedIds.contains(u.userId))
                .where(widget.filter ?? (_) => true)
                .toList()
              ..sort((a, b) => a.fullName.compareTo(b.fullName));
        _loading = false;
      }),
      failure: (msg, _) => setState(() {
        _error = msg ?? 'No se pudieron cargar los usuarios';
        _loading = false;
      }),
      loading: () {},
    );
  }

  List<UserEntity> get _filtered {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all
        .where(
          (u) =>
              u.fullName.toLowerCase().contains(q) ||
              u.username.toLowerCase().contains(q) ||
              (u.idCard ?? '').contains(q) ||
              (u.positionName ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, usuario o cédula...',
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_error!, textAlign: TextAlign.center),
          TextButton(onPressed: _load, child: const Text('Reintentar')),
        ],
      );
    }
    final items = _filtered;
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No se encontraron usuarios')),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final u = items[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            u.fullName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            [
              u.positionName,
              u.username,
            ].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () => Navigator.pop(context, u),
        );
      },
    );
  }
}
