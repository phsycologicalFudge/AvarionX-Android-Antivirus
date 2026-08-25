import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../translations/app_localizations.dart';
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

  String _countryLabel(AppLocalizations l10n, String country) {
    switch (country) {
      case 'United Kingdom':
        return l10n.countryUnitedKingdom;
      case 'United States':
        return l10n.countryUnitedStates;
      case 'Canada':
        return l10n.countryCanada;
      case 'Ireland':
        return l10n.countryIreland;
      case 'France':
        return l10n.countryFrance;
      case 'Germany':
        return l10n.countryGermany;
      case 'Netherlands':
        return l10n.countryNetherlands;
      case 'Spain':
        return l10n.countrySpain;
      case 'Italy':
        return l10n.countryItaly;
      case 'Sweden':
        return l10n.countrySweden;
      case 'Norway':
        return l10n.countryNorway;
      case 'Denmark':
        return l10n.countryDenmark;
      case 'Poland':
        return l10n.countryPoland;
      case 'Turkey':
        return l10n.countryTurkey;
      case 'Greece':
        return l10n.countryGreece;
      case 'Romania':
        return l10n.countryRomania;
      case 'Ukraine':
        return l10n.countryUkraine;
      case 'Russia':
        return l10n.countryRussia;
      case 'India':
        return l10n.countryIndia;
      case 'Pakistan':
        return l10n.countryPakistan;
      case 'Bangladesh':
        return l10n.countryBangladesh;
      case 'Sri Lanka':
        return l10n.countrySriLanka;
      case 'Nepal':
        return l10n.countryNepal;
      case 'Japan':
        return l10n.countryJapan;
      case 'South Korea':
        return l10n.countrySouthKorea;
      case 'Singapore':
        return l10n.countrySingapore;
      case 'Malaysia':
        return l10n.countryMalaysia;
      case 'Thailand':
        return l10n.countryThailand;
      case 'Vietnam':
        return l10n.countryVietnam;
      case 'Philippines':
        return l10n.countryPhilippines;
      case 'Indonesia':
        return l10n.countryIndonesia;
      case 'Australia':
        return l10n.countryAustralia;
      case 'New Zealand':
        return l10n.countryNewZealand;
      case 'Brazil':
        return l10n.countryBrazil;
      case 'Argentina':
        return l10n.countryArgentina;
      case 'Chile':
        return l10n.countryChile;
      case 'Mexico':
        return l10n.countryMexico;
      case 'Colombia':
        return l10n.countryColombia;
      case 'Peru':
        return l10n.countryPeru;
      case 'South Africa':
        return l10n.countrySouthAfrica;
      case 'Nigeria':
        return l10n.countryNigeria;
      case 'Kenya':
        return l10n.countryKenya;
      case 'Egypt':
        return l10n.countryEgypt;
      case 'UAE':
        return l10n.countryUAE;
      case 'Saudi Arabia':
        return l10n.countrySaudiArabia;
      case 'Israel':
        return l10n.countryIsrael;
      default:
        return country;
    }
  }

  Future<void> _run() async {
    if (_running) return;

    final l10n = AppLocalizations.of(context)!;
    final country = _selectedCountry;
    final targets = _targetsForCountry(country);

    setState(() {
      _running = true;
      _status = l10n.networkSpeedTestRunning;
      _results.clear();
    });

    for (var i = 0; i < targets.length; i++) {
      final t = targets[i];
      setState(() {
        _status = l10n.networkSpeedTestTesting(i + 1, targets.length, t.domain);
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
      _status = l10n.networkSpeedTestDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.networkSpeedTestTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.networkSpeedTestCountry, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: _countryList
                    .map((c) => DropdownMenuItem(value: c, child: Text(_countryLabel(AppLocalizations.of(context)!, c))))
                    .toList(),
                onChanged: _running ? null : (v) => setState(() => _selectedCountry = v ?? _selectedCountry),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _running ? null : _run,
                  child: Text(_running ? AppLocalizations.of(context)!.networkSpeedTestRunning : AppLocalizations.of(context)!.networkSpeedTestRunTest),
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
                    AppLocalizations.of(context)!.networkSpeedTestNoResultsYet,
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
                                  AppLocalizations.of(context)!.networkSpeedTestDnsTLS(dns, tcp),
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
                            ok ? AppLocalizations.of(context)!.ok : AppLocalizations.of(context)!.networkSpeedTestFail,
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
