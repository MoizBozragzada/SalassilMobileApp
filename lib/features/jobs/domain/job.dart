enum JobType { pickup, delivery }

enum JobStatus { assigned, inProgress, completed }

class Job {
  const Job({
    required this.type,
    required this.status,
    required this.reference,
    required this.area,
    required this.zone,
    required this.kind,
    required this.detail,
    this.detailHighlight,
    required this.routeCode,
    required this.accountNumber,
    required this.serviceCode,
    required this.direction,
    required this.serviceScope,
    required this.country,
    required this.city,
    required this.contactNumber,
    required this.date,
    required this.timeWindow,
    required this.address,
    required this.shortAddress,
    required this.shipmentType,
    required this.packagingType,
    required this.expectedPackages,
    required this.expectedShipment,
    required this.expectedWeight,
    required this.remarks,
    this.startedAt,
    this.completedAt,
  });

  final JobType type;
  final JobStatus status;

  /// Booking number for pickups, air waybill number for deliveries.
  final String reference;

  /// Area shown on the list cards, e.g. "Al Aziziyah, Dammam".
  final String area;
  final String zone;

  /// e.g. "First-Mile Pickup".
  final String kind;
  final String detail;

  /// Part of [detail] shown in the accent color (e.g. package count).
  final String? detailHighlight;

  final String routeCode;

  // Details screen fields.
  final String accountNumber;
  final String serviceCode;
  final String direction;
  final String serviceScope;
  final String country;
  final String city;
  final String contactNumber;
  final String date;

  /// e.g. "12:00 - 14:00".
  final String timeWindow;
  final String address;
  final String shortAddress;
  final String shipmentType;
  final String packagingType;
  final String expectedPackages;
  final String expectedShipment;
  final String expectedWeight;
  final String remarks;

  /// ISO timestamps from the API, null until the job is started/completed.
  final String? startedAt;
  final String? completedAt;

  /// Parses the jobs endpoint response. Returns null when no list of jobs
  /// is found at all (an empty list is a valid, empty result).
  ///
  /// The response format is not documented, so this finds the first list in
  /// the body and matches field names ignoring case, underscores and dashes.
  static List<Job>? parseList(dynamic json) {
    final list = _findList(json, 0);
    if (list == null) return null;
    return [
      for (final item in list)
        if (item is Map) ?_fromMap(item),
    ];
  }

  static List<dynamic>? _findList(dynamic json, int depth) {
    if (json is List) return json;
    if (json is! Map || depth > 3) return null;
    for (final value in json.values) {
      if (value is List) return value;
    }
    for (final value in json.values) {
      final found = _findList(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }

  static String _norm(String key) =>
      key.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');

  static String? _text(dynamic v) {
    if (v is String) return v.trim().isEmpty ? null : v.trim();
    if (v is num) return v == v.truncate() ? v.truncate().toString() : v.toString();
    if (v is Map) {
      for (final key in ['name', 'name_en', 'title', 'label']) {
        final inner = v[key];
        if (inner is String && inner.trim().isNotEmpty) return inner.trim();
      }
    }
    return null;
  }

  static void _flatten(Map m, Map<String, dynamic> out, int depth) {
    for (final e in m.entries) {
      final key = _norm(e.key.toString());
      out.putIfAbsent(key, () => e.value);
      if (e.value is Map && depth < 2) _flatten(e.value as Map, out, depth + 1);
    }
  }

  static Job? _fromMap(Map raw) {
    final f = <String, dynamic>{};
    _flatten(raw, f, 0);

    String? pick(List<String> keys) {
      for (final key in keys) {
        final value = _text(f[_norm(key)]);
        if (value != null) return value;
      }
      return null;
    }

    final booking = pick(['booking_number', 'booking_no']);
    final awb = pick(['awb_number', 'awb_no', 'waybill_number']);
    final reference = booking ??
        awb ??
        pick(['job_number', 'job_no', 'reference', 'reference_number', 'id']);
    if (reference == null) return null;

    // `jobCategory` is "Pickup" / "Delivery"; `jobType` is "Booking" / "AWB".
    final typeText = (pick([
              'job_category',
              'type',
              'task_type',
              'direction',
              'service_type',
            ]) ??
            '')
        .toLowerCase();
    final JobType type;
    if (typeText.contains('deliver')) {
      type = JobType.delivery;
    } else if (typeText.contains('pick')) {
      type = JobType.pickup;
    } else {
      type = (awb != null && booking == null)
          ? JobType.delivery
          : JobType.pickup;
    }
    final isPickup = type == JobType.pickup;

    final startedAt = pick(['started_at']);
    final completedAt = pick(['completed_at']);
    final statusText = (pick(['status', 'job_status']) ?? '').toLowerCase();
    final JobStatus status;
    if (completedAt != null || statusText.contains('complete')) {
      status = JobStatus.completed;
    } else if (startedAt != null || statusText.contains('progress')) {
      status = JobStatus.inProgress;
    } else {
      status = JobStatus.assigned;
    }

    // Pickups use the pickup_* fields; deliveries use the nested awb object.
    final areaName = isPickup
        ? pick(['pickup_area_name', 'pickup_area', 'area_name'])
        : pick(['delivery_district', 'delivery_area', 'destination_rsc']);
    final city = isPickup
        ? pick(['city_name', 'city', 'job_city'])
        : pick(['destination_city', 'city_name', 'job_city']);
    final area = [areaName, city].whereType<String>().join(', ');

    final packages =
        pick(['expected_packages', 'package_count', 'pieces', 'packages']);
    final weight = pick(['expected_weight', 'weight']);
    final shipmentType =
        pick(['shipment_type', 'shipment_category', 'product_type']);
    final detail = packages != null
        ? '$packages Packages${weight != null ? ' ($weight kg)' : ''}'
        : (shipmentType ?? '-');

    return Job(
      type: type,
      status: status,
      reference: reference,
      area: area.isEmpty ? '-' : area,
      zone: pick(['zone', 'zone_name', 'territory']) ?? '-',
      kind: pick(['direction', 'service_type', 'service_name']) ??
          (isPickup ? 'Pickup' : 'Delivery'),
      detail: detail,
      detailHighlight: packages != null ? detail : null,
      routeCode: pick(['operational_route_code', 'route_code', 'route']) ?? '-',
      accountNumber: pick(['account_number', 'account_no']) ?? '-',
      serviceCode: pick(['service_code']) ?? '-',
      direction: pick(['direction']) ?? '-',
      serviceScope:
          pick(['service_scope', 'shipment_scope', 'scope']) ?? '-',
      country: (isPickup
              ? pick(['country_name', 'country', 'job_country'])
              : pick(['destination_country', 'country_name', 'job_country'])) ??
          '-',
      city: city ?? '-',
      contactNumber: (isPickup
              ? pick(['pickup_contact_number', 'contact_number'])
              : pick([
                  'recipients_contact_number',
                  'pickup_contact_number',
                  'contact_number',
                ])) ??
          '-',
      date: pick(['pickup_date', 'delivery_date', 'scheduled_date']) ?? '-',
      timeWindow: pick(['pickup_time_window', 'time_window']) ?? '-',
      address: (isPickup
              ? pick(['pickup_address', 'address'])
              : pick(['delivery_address', 'pickup_address', 'address'])) ??
          '-',
      shortAddress: (isPickup
              ? pick(['pickup_short_address', 'short_address'])
              : pick([
                  'delivery_street_name',
                  'pickup_short_address',
                  'short_address',
                ])) ??
          '-',
      shipmentType: shipmentType ?? '-',
      packagingType: pick(['packaging_type', 'packaging']) ?? '-',
      expectedPackages: packages ?? '-',
      expectedShipment:
          pick(['expected_shipment', 'shipment_number']) ?? '-',
      expectedWeight: weight ?? '-',
      remarks: pick(['booking_remarks', 'remarks', 'content']) ?? '-',
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }

  String get typeLabel => type == JobType.pickup ? 'Pickup' : 'Delivery';

  String get referenceLabel =>
      type == JobType.pickup ? 'BOOKING NUMBER' : 'AIR WAYBILL NUMBER';

  /// The area name without the city, e.g. "Al Aziziyah".
  String get areaName => area.split(',').first.trim();

  String get statusLabel {
    switch (status) {
      case JobStatus.assigned:
        return 'Assigned';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
    }
  }
}
