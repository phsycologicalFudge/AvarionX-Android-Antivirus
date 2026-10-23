import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AvHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final bool? showBack;
  final VoidCallback? onBack;

  const AvHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.actions = const [],
    this.bottom,
    this.showBack,
    this.onBack,
  });

  static const double barHeight = 66;

  @override
  Size get preferredSize =>
      Size.fromHeight(barHeight + (bottom == null ? 0 : bottom!.preferredSize.height + 16));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final back = showBack ?? (ModalRoute.of(context)?.impliesAppBarDismissal ?? false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Material(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: IconTheme.merge(
                  data: IconThemeData(color: scheme.onSurface.withOpacity(0.78)),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        if (back)
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            onPressed: onBack ?? () => Navigator.maybePop(context),
                          )
                        else
                          const SizedBox(width: 16),
                        Expanded(
                          child: DefaultTextStyle.merge(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface.withOpacity(0.92),
                            ),
                            child: titleWidget ?? Text(title ?? ''),
                          ),
                        ),
                        ...actions,
                        if (actions.isNotEmpty) const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                child: Material(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: bottom,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
