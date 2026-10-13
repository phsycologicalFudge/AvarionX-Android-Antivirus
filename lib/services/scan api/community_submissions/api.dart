import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class CommunitySubmitResult {
  final bool ok;
  final bool existing;
  final String? sampleId;
  final String? sha256;
  final String? error;
  final int statusCode;

  CommunitySubmitResult({
    required this.ok,
    required this.statusCode,
    this.existing = false,
    this.sampleId,
    this.sha256,
    this.error,
  });
}

class CommunityPreflightResult {
  final bool ok;
  final List<int> missingIndexes;
  final String? error;
  final int statusCode;

  CommunityPreflightResult({
    required this.ok,
    required this.statusCode,
    this.missingIndexes = const [],
    this.error,
  });
}

Future<CommunityPreflightResult> checkCommunitySamples(
  List<String> hashes,
) async {
  final client = HttpClient();

  try {
    final req = await client.postUrl(
      Uri.parse('https://platform.colourswift.com/api/community/check'),
    );
    req.headers.set('content-type', 'application/json; charset=utf-8');
    req.write(jsonEncode({
      'samples': [
        for (var i = 0; i < hashes.length; i++)
          {'index': i, 'sha256': hashes[i]},
      ],
    }));

    final res = await req.close();
    final body = await res.transform(utf8.decoder).join();

    Map<String, dynamic> json = {};
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {}

    if (res.statusCode == 200 && json['ok'] == true) {
      final raw = json['missingIndexes'];
      final missing = raw is List
          ? raw.map((value) => int.tryParse(value.toString())).whereType<int>().toList()
          : <int>[];
      return CommunityPreflightResult(
        ok: true,
        statusCode: res.statusCode,
        missingIndexes: missing,
      );
    }

    return CommunityPreflightResult(
      ok: false,
      statusCode: res.statusCode,
      error: json['error']?.toString() ?? 'unknown_error',
    );
  } catch (e) {
    return CommunityPreflightResult(
      ok: false,
      statusCode: 0,
      error: e.toString(),
    );
  } finally {
    client.close();
  }
}

Future<CommunitySubmitResult> submitCommunitySample(
  Uint8List bytes,
  String sha256,
) async {
  final client = HttpClient();
  final boundary = 'ax${DateTime.now().microsecondsSinceEpoch}';

  try {
    final req = await client.postUrl(
      Uri.parse('https://platform.colourswift.com/api/community/submit'),
    );
    req.headers.set('content-type', 'multipart/form-data; boundary=$boundary');

    req.write('--$boundary\r\n');
    req.write('Content-Disposition: form-data; name="sha256"\r\n\r\n');
    req.write('$sha256\r\n');
    req.write('--$boundary\r\n');
    req.write('Content-Disposition: form-data; name="file"; filename="sample.apk"\r\n');
    req.write('Content-Type: application/vnd.android.package-archive\r\n\r\n');
    req.add(bytes);
    req.write('\r\n--$boundary--\r\n');

    final res = await req.close();
    final body = await res.transform(utf8.decoder).join();

    Map<String, dynamic> json = {};
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {}

    if ((res.statusCode == 200 || res.statusCode == 201) && json['ok'] == true) {
      return CommunitySubmitResult(
        ok: true,
        statusCode: res.statusCode,
        existing: json['existing'] == true,
        sampleId: json['sampleId']?.toString(),
        sha256: json['sha256']?.toString(),
      );
    }

    return CommunitySubmitResult(
      ok: false,
      statusCode: res.statusCode,
      error: json['error']?.toString() ?? 'unknown_error',
    );
  } catch (e) {
    return CommunitySubmitResult(ok: false, statusCode: 0, error: e.toString());
  } finally {
    client.close();
  }
}
