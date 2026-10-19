import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/components/widgets/app_search_bar.dart';
import 'package:clean_architecture/features/connections/search/presentation/info/cubit/search_connection_cubit.dart';
import 'connection_filter_chip.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final VoidCallback onSearch;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const SearchHeader({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.onSearch,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      controller: searchController,
      focusNode: focusNode,
      onSearch: onSearch,
      onClear: () => context.read<SearchConnectionCubit>().search(''),
      hintText: 'Clave catastral o Cédula/RUC',
      bottom: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ConnectionFilterChip(
              label: 'Todos',
              icon: const Icon(Icons.list_rounded),
              isSelected: activeFilter == 'todos',
              onTap: () => onFilterChanged('todos'),
            ),
            const SizedBox(width: 8),
            ConnectionFilterChip(
              label: 'Activos',
              icon: const Icon(Icons.check_circle_outline_rounded),
              isSelected: activeFilter == 'activos',
              onTap: () => onFilterChanged('activos'),
            ),
            const SizedBox(width: 8),
            ConnectionFilterChip(
              label: 'Inactivos',
              icon: const Icon(Icons.cancel_outlined),
              isSelected: activeFilter == 'inactivos',
              onTap: () => onFilterChanged('inactivos'),
            ),
          ],
        ),
      ),
    );
  }
}
