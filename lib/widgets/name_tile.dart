import 'package:flutter/material.dart';

import '../models/generated_name.dart';

/// One row of the infinite list: avatar with initials, the name, and a heart.
class NameTile extends StatelessWidget {
  const NameTile({
    super.key,
    required this.name,
    required this.index,
    required this.isSaved,
    required this.onTap,
  });

  final GeneratedName name;
  final int index;
  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // Alternate avatar colours so the list has some rhythm.
    final avatarBg = index.isEven ? scheme.primary : scheme.secondary;
    final avatarFg = index.isEven ? scheme.onPrimary : scheme.onSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: avatarBg,
            foregroundColor: avatarFg,
            child: Text(name.initials),
          ),
          title: Text(
            name.text,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('#${index + 1}'),
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isSaved),
              color: isSaved ? Colors.redAccent : scheme.outline,
              semanticLabel: isSaved ? 'Remove from saved' : 'Save',
            ),
          ),
        ),
      ),
    );
  }
}
