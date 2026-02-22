class DnsEvent {
  final int tsMs;
  final String qname;
  final bool blocked;
  final String plan;
  final String? upstream;
  final int? latencyMs;
  final String? matchList;
  final String? matchType;

  DnsEvent({
    required this.tsMs,
    required this.qname,
    required this.blocked,
    required this.plan,
    required this.upstream,
    required this.latencyMs,
    required this.matchList,
    required this.matchType,
  });

  factory DnsEvent.fromMap(Map<dynamic, dynamic> m) {
    final decision = (m['decision'] is Map) ? (m['decision'] as Map) : null;
    final match = (decision != null && decision['match'] is Map) ? (decision['match'] as Map) : null;
    return DnsEvent(
      tsMs: (m['ts_ms'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      qname: (m['qname'] as String?) ?? 'unknown',
      blocked: (m['blocked'] as bool?) ?? false,
      plan: (m['plan'] as String?) ?? 'free',
      upstream: (m['upstream'] as String?),
      latencyMs: (m['latency_ms'] as int?),
      matchList: (match != null ? (match['list'] as String?) : null),
      matchType: (match != null ? (match['type'] as String?) : null),
    );
  }
}

class UpstreamPreset {
  final String key;
  final String title;
  final String subtitle;
  final String ip;

  const UpstreamPreset({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.ip,
  });
}