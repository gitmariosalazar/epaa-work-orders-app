// features/dashboard/presentation/widgets/statistics_state_view.dart

import 'package:clean_architecture/features/dashboard/presentation/cubits/statistics/statistics_cubit.dart';
import 'package:flutter/material.dart';

/// Renderiza los estados comunes (cargando / error / vacío) de cualquier
/// [StatisticsState] y delega el estado con datos a [builder].
class StatisticsStateView<T> extends StatelessWidget {
  final StatisticsState<T> state;
  final VoidCallback onRetry;
  final WidgetBuilder builder;
  final String emptyMessage;

  const StatisticsStateView({
    super.key,
    required this.state,
    required this.onRetry,
    required this.builder,
    this.emptyMessage = 'No hay estadísticas disponibles',
  });

  @override
  Widget build(BuildContext context) {
    final s = state;
    return switch (s) {
      StatisticsInitial<T>() || StatisticsLoading<T>() => const _Centered(
        child: CircularProgressIndicator(),
      ),
      StatisticsError<T>(:final message) => _Message(
        icon: Icons.cloud_off_rounded,
        message: message,
        isError: true,
        onRetry: onRetry,
      ),
      StatisticsLoaded<T>(:final items) when items.isEmpty => _Message(
        icon: Icons.insert_chart_outlined_rounded,
        message: emptyMessage,
        onRetry: onRetry,
      ),
      StatisticsLoaded<T>() => builder(context),
    };
  }
}

class _Centered extends StatelessWidget {
  final Widget child;
  const _Centered({required this.child});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.of(context).size.height * 0.6,
    child: Center(child: child),
  );
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isError;
  final VoidCallback onRetry;

  const _Message({
    required this.icon,
    required this.message,
    required this.onRetry,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _Centered(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: isError ? cs.error : cs.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: cs.onSurface),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
