class AppVersion {
  const AppVersion._();

  static bool isUpdateRequired({
    required String currentVersion,
    required String latestVersion,
  }) {
    final currentParts = _parseVersion(currentVersion);
    final latestParts = _parseVersion(latestVersion);

    if (currentParts == null || latestParts == null) {
      return false;
    }

    final partCount =
        currentParts.length > latestParts.length
            ? currentParts.length
            : latestParts.length;

    for (var index = 0; index < partCount; index++) {
      final currentPart = index < currentParts.length ? currentParts[index] : 0;
      final latestPart = index < latestParts.length ? latestParts[index] : 0;

      if (currentPart < latestPart) {
        return true;
      }
      if (currentPart > latestPart) {
        return false;
      }
    }

    return false;
  }

  static List<int>? _parseVersion(String version) {
    final normalizedVersion = version.trim().split('+').first;
    if (normalizedVersion.isEmpty) {
      return null;
    }

    final parts = <int>[];
    for (final part in normalizedVersion.split('.')) {
      final parsedPart = int.tryParse(part);
      if (parsedPart == null) {
        return null;
      }
      parts.add(parsedPart);
    }

    return parts;
  }
}
