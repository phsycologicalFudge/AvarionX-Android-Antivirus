import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pro_temp_service.dart';
import '../../services/scan_scheduler.dart';
import '../../translations/app_localizations.dart';

class ScheduledScansScreen extends StatefulWidget {
  const ScheduledScansScreen({super.key});

  @override
  State<ScheduledScansScreen> createState() => _ScheduledScansScreenState();
}

class _ScheduledScansScreenState extends State<ScheduledScansScreen> {
  bool _loaded = false;

  bool _isPro = false;
  bool _enabled = true;
  int _hours = 168;
  String _mode = 'smart';

  bool _useTime = false;
  int _timeHour = 9;
  int _timeMinute = 0;

  bool _pluggedOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final effective = await ProGate.sync();

    if (!mounted) return;

    setState(() {
      _isPro = effective;
      _enabled = prefs.getBool('scheduled_scan_enabled') ?? true;
      _hours = prefs.getInt('scheduled_scan_hours') ?? 168;
      _mode = prefs.getString('scheduled_scan_mode') ?? 'smart';

      _useTime = prefs.getBool('scheduled_scan_use_time') ?? false;
      _timeHour = prefs.getInt('scheduled_scan_time_h') ?? 9;
      _timeMinute = prefs.getInt('scheduled_scan_time_m') ?? 0;

      _pluggedOnly = prefs.getBool('scheduled_scan_plugged_only') ?? false;

      _loaded = true;
    });
  }

  Future<void> _setEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('scheduled_scan_enabled', v);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() => _enabled = v);
  }

  Future<void> _setHours(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scheduled_scan_hours', v);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() => _hours = v);
  }

  Future<void> _setMode(String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scheduled_scan_mode', v);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() => _mode = v);
  }

  Future<void> _setUseTime(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('scheduled_scan_use_time', v);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() => _useTime = v);
  }

  Future<void> _setTime(int h, int m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scheduled_scan_time_h', h);
    await prefs.setInt('scheduled_scan_time_m', m);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() {
      _timeHour = h;
      _timeMinute = m;
    });
  }

  Future<void> _setPluggedOnly(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('scheduled_scan_plugged_only', v);
    await ScheduledScanScheduler.enableFromPrefs();
    if (!mounted) return;
    setState(() => _pluggedOnly = v);
  }

  void _showInfo() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final theme = Theme.of(context);
        final text = theme.textTheme;
        final l10n = AppLocalizations.of(context)!;

        return AlertDialog(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            l10n.scheduledScansInfoTitle,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            l10n.scheduledScansInfoBody,
            style: text.bodySmall?.copyWith(
              height: 1.4,
              color: text.bodySmall?.color?.withOpacity(0.85),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  String _modeTitle(AppLocalizations l10n, String v) {
    switch (v) {
      case 'rapid':
        return l10n.scanModeRapidTitle;
      case 'installed':
        return l10n.scanModeInstalledTitle;
      case 'smart':
      default:
        return l10n.scanModeSmartTitle;
    }
  }

  String _hoursLabel(AppLocalizations l10n, int h) {
    if (h == 24) return l10n.scheduledEveryDay;
    if (h == 72) return l10n.scheduledEvery3Days;
    if (h == 168) return l10n.scheduledEveryWeek;
    if (h == 336) return l10n.scheduledEvery2Weeks;

    final days = (h / 24).round();
    if (h % 24 == 0) {
      if (days == 21) return l10n.scheduledEvery3Weeks;
      if (days == 30) return l10n.scheduledMonthly;
      return l10n.scheduledEveryDays(days.toString());
    }

    return l10n.scheduledEveryHours(h.toString());
  }

  String _timeLabel(BuildContext context, int h, int m) {
    final t = TimeOfDay(hour: h, minute: m);
    return t.format(context);
  }

  List<int> _frequencyHours() {
    return [
      24,
      48,
      72,
      96,
      120,
      144,
      168,
      336,
      504,
      720,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final locked = !_isPro;
    final controlsEnabled = _loaded && !locked;
    final allowEditing = controlsEnabled && _enabled;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          l10n.scheduledScansTitle,
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showInfo,
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.scheduledScansHeader,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface.withOpacity(0.88),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.scheduledScansSubheader,
                            style: text.bodySmall?.copyWith(
                              height: 1.35,
                              color: text.bodySmall?.color?.withOpacity(0.72),
                            ),
                          ),
                          if (locked) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                l10n.proRequiredToCustomize,
                                style: text.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface.withOpacity(0.78),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.scheduledScansEnabledTitle,
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.scheduledScansEnabledSubtitle,
                            style: text.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enabled,
                      onChanged: controlsEnabled ? (v) => _setEnabled(v) : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.scheduledChargingOnlyTitle,
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.scheduledChargingOnlySubtitle,
                            style: text.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _pluggedOnly,
                      onChanged: allowEditing ? (v) => _setPluggedOnly(v) : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scheduledScansModeTitle,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _mode,
                      items: [
                        DropdownMenuItem(
                          value: 'smart',
                          child: Text(l10n.scanModeSmartTitle, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'rapid',
                          child: Text(l10n.scanModeRapidTitle, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: 'installed',
                          child: Text(l10n.scanModeInstalledTitle, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                      onChanged: allowEditing
                          ? (v) {
                        if (v == null) return;
                        _setMode(v);
                      }
                          : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.scheduledScansModeHint(_modeTitle(l10n, _mode)),
                      style: text.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scheduledScansFrequencyTitle,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _hours,
                      items: _frequencyHours().map((h) {
                        return DropdownMenuItem(
                          value: h,
                          child: Text(_hoursLabel(l10n, h), overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: allowEditing
                          ? (v) {
                        if (v == null) return;
                        _setHours(v);
                      }
                          : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.6),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.35),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.scheduledScansFrequencyHint(_hoursLabel(l10n, _hours)),
                      style: text.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.scheduledPreferredTimeTitle,
                                style: text.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.scheduledPreferredTimeSubtitle,
                                style: text.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _useTime,
                          onChanged: allowEditing ? (v) => _setUseTime(v) : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withOpacity(_useTime && allowEditing ? 0.6 : 0.35),
                              ),
                            ),
                            child: Text(
                              _timeLabel(context, _timeHour, _timeMinute),
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface.withOpacity(_useTime && allowEditing ? 0.9 : 0.45),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: (_useTime && allowEditing)
                              ? () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: _timeHour, minute: _timeMinute),
                            );
                            if (picked == null) return;
                            _setTime(picked.hour, picked.minute);
                          }
                              : null,
                          child: Text(l10n.scheduledPickTime),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            l10n.metaPassPoweredBy,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.32),
            ),
          ),
        ),
      ),
    );
  }
}
