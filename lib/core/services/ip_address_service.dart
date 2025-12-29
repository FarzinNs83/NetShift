import 'dart:developer';

import 'package:get_ip_address/get_ip_address.dart';

/// Service for fetching and managing IP address information.
class IpAddressService {
  /// Fetches the current public IP address.
  /// Returns the IP address string, or an error message if failed.
  Future<IpAddressResult> getIpAddress() async {
    try {
      final IpAddress ipAddress = IpAddress(type: RequestType.text);
      final dynamic data = await ipAddress.getIpAddress();
      bool isIPv6 = data.toString().contains(':');

      if (isIPv6) {
        log("Failed: IPv6 detected");
        return IpAddressResult(
          success: false,
          ipAddress: "Failed(IPv6)",
          errorMessage: "IPv6 detected",
        );
      }

      log("IP Address: $data");
      return IpAddressResult(
        success: true,
        ipAddress: data.toString(),
      );
    } on IpAddressException catch (e) {
      log("IP Address Error: ${e.message}");
      return IpAddressResult(
        success: false,
        ipAddress: "Failed(Offline)",
        errorMessage: e.message,
      );
    }
  }
}

/// Result class for IP address fetching operations.
class IpAddressResult {
  final bool success;
  final String ipAddress;
  final String? errorMessage;

  const IpAddressResult({
    required this.success,
    required this.ipAddress,
    this.errorMessage,
  });
}
