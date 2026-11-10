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

/// Placeholder jobs until the jobs endpoint is available.
const sampleJobs = <Job>[
  Job(
    type: JobType.pickup,
    status: JobStatus.assigned,
    reference: 'BK-E-DA-0001',
    area: 'Al Aziziyah, Dammam',
    zone: 'Zone 4B',
    kind: 'First-Mile Pickup',
    detail: '2 Packages (300 kg)',
    detailHighlight: '2 Packages (300 kg)',
    routeCode: 'RUH-RET-101',
    accountNumber: 'SAU-DAM-E-0001',
    serviceCode: 'FPD',
    direction: 'Forward Pickup',
    serviceScope: 'Domestic',
    country: 'Saudi Arabia',
    city: 'Dammam',
    contactNumber: '05000000',
    date: '2026-11-07',
    timeWindow: '12:00 - 14:00',
    address: 'test',
    shortAddress: 'test',
    shipmentType: 'Parcel',
    packagingType: 'Single',
    expectedPackages: '2',
    expectedShipment: '200',
    expectedWeight: '300',
    remarks: 'Ready',
  ),
  Job(
    type: JobType.delivery,
    status: JobStatus.assigned,
    reference: 'AWB-772910',
    area: 'Khanshlila, Riyadh',
    zone: 'Street 14',
    kind: 'Last-Mile Delivery',
    detail: 'Electronics (Fragile)',
    routeCode: 'RUH-RET-101',
    accountNumber: 'SAU-RUH-E-0002',
    serviceCode: 'LMD',
    direction: 'Last-Mile Delivery',
    serviceScope: 'Domestic',
    country: 'Saudi Arabia',
    city: 'Riyadh',
    contactNumber: '05000001',
    date: '2026-11-07',
    timeWindow: '14:00 - 16:00',
    address: 'Street 14',
    shortAddress: 'test',
    shipmentType: 'Parcel',
    packagingType: 'Single',
    expectedPackages: '1',
    expectedShipment: '100',
    expectedWeight: '4',
    remarks: 'Fragile',
  ),
];
