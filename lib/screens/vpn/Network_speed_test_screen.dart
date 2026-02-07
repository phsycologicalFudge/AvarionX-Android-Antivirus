import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class NetworkSpeedTestScreen extends StatefulWidget {
  const NetworkSpeedTestScreen({super.key});

  @override
  State<NetworkSpeedTestScreen> createState() => _NetworkSpeedTestScreenState();
}

class _TestTarget {
  final String country;
  final String domain;
  const _TestTarget(this.country, this.domain);
}

class _TestResult {
  final String country;
  final String domain;
  final int dnsMs;
  final int tcpMs;
  final bool ok;
  final String? err;
  const _TestResult({
    required this.country,
    required this.domain,
    required this.dnsMs,
    required this.tcpMs,
    required this.ok,
    required this.err,
  });
}

class _NetworkSpeedTestScreenState extends State<NetworkSpeedTestScreen> {
  static const Map<String, List<String>> _domainsByCountry = {
    'United Kingdom': ['bbc.co.uk', 'gov.uk', 'nhs.uk', 'guardian.co.uk'],
    'United States': ['whitehouse.gov', 'nasa.gov', 'nytimes.com', 'cloudflare.com'],
    'Canada': ['canada.ca', 'cbc.ca', 'gc.ca'],
    'Ireland': ['gov.ie', 'rte.ie'],
    'France': ['service-public.fr', 'lemonde.fr', 'gouv.fr'],
    'Germany': ['bund.de', 'tagesschau.de', 'bahn.de'],
    'Netherlands': ['government.nl', 'nos.nl'],
    'Spain': ['administracion.gob.es', 'rtve.es'],
    'Italy': ['governo.it', 'rai.it'],
    'Sweden': ['sweden.se', 'svt.se'],
    'Norway': ['regjeringen.no', 'nrk.no'],
    'Denmark': ['denmark.dk', 'dr.dk'],
    'Poland': ['gov.pl', 'tvp.pl'],
    'Turkey': ['turkiye.gov.tr', 'trt.net.tr'],
    'Greece': ['gov.gr', 'ert.gr'],
    'Romania': ['gov.ro', 'hotnews.ro'],
    'Ukraine': ['kmu.gov.ua', 'suspilne.media'],
    'Russia': ['kremlin.ru', 'tass.ru'],
    'India': ['india.gov.in', 'nic.in', 'ndtv.com'],
    'Pakistan': ['pakistan.gov.pk', 'dawn.com'],
    'Bangladesh': ['bangladesh.gov.bd', 'prothomalo.com'],
    'Sri Lanka': ['gov.lk', 'newsfirst.lk'],
    'Nepal': ['nepal.gov.np', 'kathmandupost.com'],
    'Japan': ['nhk.or.jp', 'go.jp'],
    'South Korea': ['go.kr', 'kbs.co.kr'],
    'Singapore': ['gov.sg', 'straitstimes.com'],
    'Malaysia': ['malaysia.gov.my', 'thestar.com.my'],
    'Thailand': ['go.th', 'thairath.co.th'],
    'Vietnam': ['chinhphu.vn', 'vnexpress.net'],
    'Philippines': ['gov.ph', 'inquirer.net'],
    'Indonesia': ['indonesia.go.id', 'kompas.com'],
    'Australia': ['abc.net.au', 'australia.gov.au'],
    'New Zealand': ['govt.nz', 'rnz.co.nz'],
    'Brazil': ['gov.br', 'globo.com'],
    'Argentina': ['argentina.gob.ar', 'lanacion.com.ar'],
    'Chile': ['gob.cl', 'emol.com'],
    'Mexico': ['gob.mx', 'unam.mx'],
    'Colombia': ['gov.co', 'eltiempo.com'],
    'Peru': ['gob.pe', 'elcomercio.pe'],
    'South Africa': ['gov.za', 'news24.com'],
    'Nigeria': ['nigeria.gov.ng', 'guardian.ng'],
    'Kenya': ['mygov.go.ke', 'nation.africa'],
    'Egypt': ['sis.gov.eg', 'ahrams.org.eg'],
    'UAE': ['u.ae', 'gulfnews.com'],
    'Saudi Arabia': ['my.gov.sa', 'spa.gov.sa'],
    'Israel': ['gov.il', 'ynet.co.il'],
  };

  String _selectedCountry = 'United Kingdom';
  bool _running = false;
  String _status = '';
  final List<_TestResult> _results = [];

  List<String> get _countryList => _domainsByCountry.keys.toList()..sort();

  List<_TestTarget> _targetsForCountry(String c) {
    final domains = _domainsByCountry[c] ?? const <String>[];
    return domains.map((d) => _TestTarget(c, d)).toList();
  }

  Future<int> _measureDns(String domain) async {
    final sw = Stopwatch()..start();
    await InternetAddress.lookup(domain);
    sw.stop();
    return sw.elapsedMilliseconds;
  }

  Future<int> _measureTcpTls(String domain) async {
    final sw = Stopwatch()..start();
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    try {
      final uri = Uri.https(domain, '/');
      final req = await client.getUrl(uri).timeout(const Duration(seconds: 4));
      req.headers.set('user-agent', 'CS-SpeedTest/1.0');
      final resp = await req.close().timeout(const Duration(seconds: 4));
      await resp.drain<Uint8List>(Uint8List(0)).timeout(const Duration(seconds: 4));
      sw.stop();
      return sw.elapsedMilliseconds;
    } finally {
      client.close(force: true);
    }
  }

  Future<void> _run() async {
    if (_running) return;

    final country = _selectedCountry;
    final targets = _targetsForCountry(country);

    setState(() {
      _running = true;
      _status = 'Running…';
      _results.clear();
    });

    for (var i = 0; i < targets.length; i++) {
      final t = targets[i];
      setState(() {
        _status = 'Testing ${i + 1}/${targets.length} • ${t.domain}';
      });

      int dnsMs = -1;
      int tcpMs = -1;
      bool ok = false;
      String? err;

      try {
        dnsMs = await _measureDns(t.domain);
        tcpMs = await _measureTcpTls(t.domain);
        ok = true;
      } catch (e) {
        err = e.toString();
      }

      if (!mounted) return;
      setState(() {
        _results.add(_TestResult(
          country: t.country,
          domain: t.domain,
          dnsMs: dnsMs,
          tcpMs: tcpMs,
          ok: ok,
          err: err,
        ));
      });
    }

    if (!mounted) return;
    setState(() {
      _running = false;
      _status = 'Done';
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed test'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Country', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: _countryList
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: _running ? null : (v) => setState(() => _selectedCountry = v ?? _selectedCountry),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _running ? null : _run,
                  child: Text(_running ? 'Running' : 'Run test'),
                ),
              ),
              const SizedBox(height: 10),
              if (_status.isNotEmpty)
                Text(
                  _status,
                  style: text.bodySmall?.copyWith(color: text.bodySmall?.color?.withOpacity(0.75)),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: _results.isEmpty
                    ? Center(
                  child: Text(
                    'No results yet.',
                    style: text.bodyMedium?.copyWith(color: text.bodyMedium?.color?.withOpacity(0.75)),
                  ),
                )
                    : ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final r = _results[i];
                    final ok = r.ok;
                    final dns = r.dnsMs >= 0 ? '${r.dnsMs}ms' : '—';
                    final tcp = r.tcpMs >= 0 ? '${r.tcpMs}ms' : '—';
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.domain,
                                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'DNS: $dns  •  TLS: $tcp',
                                  style: text.bodySmall?.copyWith(
                                    color: text.bodySmall?.color?.withOpacity(0.75),
                                  ),
                                ),
                                if (!ok && (r.err?.isNotEmpty ?? false))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      r.err!,
                                      style: text.bodySmall?.copyWith(
                                        color: text.bodySmall?.color?.withOpacity(0.65),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ok ? 'OK' : 'Fail',
                            style: text.bodySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: ok ? Colors.greenAccent : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
