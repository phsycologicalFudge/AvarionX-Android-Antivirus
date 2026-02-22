import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../translations/app_localizations.dart';
import 'network_protection_models.dart';

class NetworkLiveLogsScreen extends StatefulWidget {
  const NetworkLiveLogsScreen({super.key});

  @override
  State<NetworkLiveLogsScreen> createState() => _NetworkLiveLogsScreenState();
}

class _NetworkLiveLogsScreenState extends State<NetworkLiveLogsScreen> {
  static const _dnsEventChannel = EventChannel('cs_dns_events');

  StreamSubscription<dynamic>? _dnsSub;
  final List<DnsEvent> _dnsEvents = [];

  void _vpnLog(String msg) {
    debugPrint('[CS VPN] $msg');
  }

  @override
  void initState() {
    super.initState();
    _dnsSub = _dnsEventChannel.receiveBroadcastStream().listen((event) {
      if (!mounted) return;
      if (event is Map) {
        final e = DnsEvent.fromMap(event);
        setState(() {
          _dnsEvents.insert(0, e);
          if (_dnsEvents.length > 800) {
            _dnsEvents.removeRange(800, _dnsEvents.length);
          }
        });
      }
    }, onError: (err) {
      _vpnLog('DNS event stream error: $err');
    });
  }

  @override
  void dispose() {
    _dnsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.networkLiveLogsTitle)),
      body: SafeArea(
        child: _dnsEvents.isEmpty
            ? Center(child: Text(l10n.networkLiveLogsEmpty, style: text.bodyMedium))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _dnsEvents.length,
          itemBuilder: (context, i) {
            final e = _dnsEvents[i];
            final ts = DateTime.fromMillisecondsSinceEpoch(e.tsMs);
            final hh = ts.hour.toString().padLeft(2, '0');
            final mm = ts.minute.toString().padLeft(2, '0');
            final ss = ts.second.toString().padLeft(2, '0');
            final time = '$hh:$mm:$ss';

            final meta = <String>[];
            if (e.upstream != null && e.upstream!.trim().isNotEmpty) meta.add(e.upstream!);
            if (e.latencyMs != null) meta.add('${e.latencyMs}ms');
            if (e.matchList != null && e.matchType != null) meta.add('${e.matchList}:${e.matchType}');
            final sub = meta.isEmpty ? e.plan : '${e.plan}  •  ${meta.join('  •  ')}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        time,
                        style: text.bodySmall?.copyWith(color: text.bodySmall?.color?.withOpacity(0.8)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.qname,
                            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          if (sub.isNotEmpty)
                            Text(
                              sub,
                              style: text.bodySmall?.copyWith(
                                color: text.bodySmall?.color?.withOpacity(0.75),
                                height: 1.25,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      e.blocked ? l10n.networkLiveLogsBlocked : l10n.networkLiveLogsAllowed,
                      style: text.bodySmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}