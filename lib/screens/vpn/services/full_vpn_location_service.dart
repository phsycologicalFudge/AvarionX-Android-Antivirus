import 'dart:convert';
import 'package:http/http.dart' as http;

class FullVpnLocation {
  final String ip;
  final String? country;
  final String? city;
  final double? lat;
  final double? lng;

  const FullVpnLocation({
    required this.ip,
    this.country,
    this.city,
    this.lat,
    this.lng,
  });

  factory FullVpnLocation.fromJson(Map<String, dynamic> j) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return double.tryParse(s);
    }

    return FullVpnLocation(
      ip: (j["ip"] ?? "").toString(),
      country: j["country"]?.toString(),
      city: j["city"]?.toString(),
      lat: toDouble(j["lat"]),
      lng: toDouble(j["lng"]),
    );
  }
}

class FullVpnLocationService {
  final String apiBase;

  const FullVpnLocationService({required this.apiBase});

  Future<FullVpnLocation> fetchMyIpLocation({required String token}) async {
    final res = await http.get(
      Uri.parse("$apiBase/vpn/my-ip"),
      headers: {"authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return FullVpnLocation.fromJson(j);
    }

    if (res.statusCode == 401) {
      throw Exception("unauthorized");
    }

    throw Exception("http_${res.statusCode}");
  }
}
