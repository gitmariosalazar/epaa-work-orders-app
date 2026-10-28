// features/workers/presentation/widgets/workers_list.dart

import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkersList extends StatelessWidget {
  final List<WorkerEntity> workers;
  final void Function(WorkerEntity worker)? onWorkerTap;

  const WorkersList({super.key, required this.workers, this.onWorkerTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 24 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: workers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final worker = workers[index];
        return _WorkerCard(
          worker: worker,
          onTap: () {
            if (onWorkerTap != null) {
              onWorkerTap!(worker);
            } else {
              _showWorkerDetailsSheet(context, worker);
            }
          },
        );
      },
    );
  }

  void _showWorkerDetailsSheet(BuildContext context, WorkerEntity worker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _WorkerDetailBottomSheet(worker: worker),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final WorkerEntity worker;
  final VoidCallback onTap;

  const _WorkerCard({required this.worker, required this.onTap});

  String _getInitials(String firstNames, String lastNames) {
    final f = firstNames.trim();
    final l = lastNames.trim();
    final c1 = f.isNotEmpty ? f[0].toUpperCase() : '';
    final c2 = l.isNotEmpty ? l[0].toUpperCase() : '';
    final res = '$c1$c2';
    return res.isNotEmpty ? res : 'T';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final fullName = '${worker.firstNames} ${worker.lastNames}'.trim();
    final initials = _getInitials(worker.firstNames, worker.lastNames);

    final hasPhone =
        worker.phoneNumber.trim().isNotEmpty &&
        worker.phoneNumber.trim().length > 3;
    final hasCell =
        worker.cellPhone.trim().isNotEmpty &&
        worker.cellPhone.trim().length > 3;
    final hasEmail =
        worker.email.trim().isNotEmpty && worker.email.trim().length > 3;
    final hasAddress = worker.address.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHighest.withValues(alpha: 0.65)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.55),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: cs.primary.withValues(alpha: 0.08),
          highlightColor: cs.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado: Avatar + Nombre + Cédula + Flecha indicadora
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar con iniciales
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primary.withValues(alpha: isDark ? 0.28 : 0.14),
                            cs.primary.withValues(alpha: isDark ? 0.48 : 0.24),
                          ],
                        ),
                        border: Border.all(
                          color: cs.primary.withValues(
                            alpha: isDark ? 0.5 : 0.35,
                          ),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: isDark ? cs.primary : cs.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nombre y Cédula
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isNotEmpty
                                ? fullName
                                : 'Sin Nombre Registrado',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: cs.onSurface,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.14 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: cs.primary.withValues(
                                  alpha: isDark ? 0.3 : 0.2,
                                ),
                                width: 0.7,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.badge_outlined,
                                  size: 11.5,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  worker.identification.isNotEmpty
                                      ? 'C.I. ${worker.identification}'
                                      : 'Sin Cédula',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Indicador de acción
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: isDark ? 0.4 : 0.6,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),

                if (hasPhone || hasCell || hasEmail || hasAddress) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: cs.outlineVariant.withValues(
                        alpha: isDark ? 0.3 : 0.5,
                      ),
                    ),
                  ),

                  // Filas de Información
                  if (hasCell)
                    _InfoRow(
                      icon: Icons.smartphone_rounded,
                      label: 'Celular',
                      value: worker.cellPhone,
                    ),

                  if (hasPhone &&
                      (!hasCell || worker.phoneNumber != worker.cellPhone))
                    _InfoRow(
                      icon: Icons.phone_rounded,
                      label: 'Teléfono',
                      value: worker.phoneNumber,
                    ),

                  if (hasEmail)
                    _InfoRow(
                      icon: Icons.alternate_email_rounded,
                      label: 'Email',
                      value: worker.email,
                    ),

                  if (hasAddress)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Dirección',
                      value: worker.address,
                      maxLines: 1,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 12.5, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerDetailBottomSheet extends StatelessWidget {
  final WorkerEntity worker;

  const _WorkerDetailBottomSheet({required this.worker});

  String _getInitials(String firstNames, String lastNames) {
    final f = firstNames.trim();
    final l = lastNames.trim();
    final c1 = f.isNotEmpty ? f[0].toUpperCase() : '';
    final c2 = l.isNotEmpty ? l[0].toUpperCase() : '';
    final res = '$c1$c2';
    return res.isNotEmpty ? res : 'T';
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('$label copiado al portapapeles')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _makeCall(BuildContext context, String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        _copyToClipboard(context, phone, 'Teléfono');
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:${email.trim()}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        _copyToClipboard(context, email, 'Correo');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final fullName = '${worker.firstNames} ${worker.lastNames}'.trim();
    final initials = _getInitials(worker.firstNames, worker.lastNames);
    final primaryPhone = worker.cellPhone.trim().isNotEmpty
        ? worker.cellPhone.trim()
        : worker.phoneNumber.trim();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Avatar grande con iniciales
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: isDark ? 0.3 : 0.15),
                  cs.primary.withValues(alpha: isDark ? 0.5 : 0.25),
                ],
              ),
              border: Border.all(
                color: cs.primary.withValues(alpha: isDark ? 0.6 : 0.4),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nombre completo
          Text(
            fullName.isNotEmpty ? fullName : 'Sin Nombre',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Cédula badge
          if (worker.identification.isNotEmpty)
            GestureDetector(
              onTap: () =>
                  _copyToClipboard(context, worker.identification, 'Cédula'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      'C.I. ${worker.identification}',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.copy_rounded, size: 12, color: cs.primary),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 18),

          // Botones de acción rápida (Llamar, Correo, Copiar resumen)
          Row(
            children: [
              if (primaryPhone.isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makeCall(context, primaryPhone),
                    icon: const Icon(Icons.call_rounded, size: 16),
                    label: const Text('Llamar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      side: BorderSide(
                        color: cs.primary.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              if (primaryPhone.isNotEmpty && worker.email.trim().isNotEmpty)
                const SizedBox(width: 10),
              if (worker.email.trim().isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sendEmail(context, worker.email),
                    icon: const Icon(Icons.mail_outline_rounded, size: 16),
                    label: const Text('Correo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      side: BorderSide(
                        color: cs.primary.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Lista de detalles completos
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
                  : cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _DetailTile(
                  icon: Icons.badge_outlined,
                  title: 'Cédula de Identidad',
                  value: worker.identification.isNotEmpty
                      ? worker.identification
                      : 'No registrada',
                  onCopy: worker.identification.isNotEmpty
                      ? () => _copyToClipboard(
                          context,
                          worker.identification,
                          'Cédula',
                        )
                      : null,
                ),
                if (worker.cellPhone.trim().isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _DetailTile(
                    icon: Icons.smartphone_rounded,
                    title: 'Teléfono Celular',
                    value: worker.cellPhone,
                    onCopy: () =>
                        _copyToClipboard(context, worker.cellPhone, 'Celular'),
                  ),
                ],
                if (worker.phoneNumber.trim().isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _DetailTile(
                    icon: Icons.phone_rounded,
                    title: 'Teléfono Convencional',
                    value: worker.phoneNumber,
                    onCopy: () => _copyToClipboard(
                      context,
                      worker.phoneNumber,
                      'Teléfono',
                    ),
                  ),
                ],
                if (worker.email.trim().isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _DetailTile(
                    icon: Icons.alternate_email_rounded,
                    title: 'Correo Electrónico',
                    value: worker.email,
                    onCopy: () =>
                        _copyToClipboard(context, worker.email, 'Correo'),
                  ),
                ],
                if (worker.address.trim().isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _DetailTile(
                    icon: Icons.location_on_outlined,
                    title: 'Dirección Domiciliaria',
                    value: worker.address,
                    onCopy: () =>
                        _copyToClipboard(context, worker.address, 'Dirección'),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Botón Cerrar
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onCopy;

  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(
                Icons.copy_rounded,
                size: 16,
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              tooltip: 'Copiar',
              onPressed: onCopy,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
