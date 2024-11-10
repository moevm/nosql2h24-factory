class MetadataEntity {
  final DateTime? lastUpdated;
  final List<String>? tags;
  final String? qrCode;

  MetadataEntity({
    required this.lastUpdated,
    required this.tags,
    required this.qrCode,
  });
}