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
    required this.remarks,
    required this.city,
    required this.routeCode,
    required this.schedule,
    required this.packaging,
    required this.packageSummary,
    required this.date,
    required this.time,
    required this.assignedBy,
    required this.assignedHub,
  });

  final JobType type;
  final JobStatus status;

  /// Booking number for pickups, air waybill number for deliveries.
  final String reference;
  final String area;
  final String zone;

  /// e.g. "First-Mile Pickup".
  final String kind;
  final String detail;

  /// Part of [detail] shown in the accent color (e.g. package count).
  final String? detailHighlight;

  // Details screen fields.
  final String remarks;
  final String city;
  final String routeCode;

  /// Time window, e.g. "10:00 - 11:30 AM".
  final String schedule;
  final String packaging;

  /// e.g. "3 Pkgs • 15 kg".
  final String packageSummary;
  final String date;
  final String time;
  final String assignedBy;
  final String assignedHub;

  String get typeLabel => type == JobType.pickup ? 'Pickup' : 'Delivery';

  String get referenceLabel =>
      type == JobType.pickup ? 'BOOKING NUMBER' : 'AIR WAYBILL NUMBER';

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
    reference: 'BK-I-RI-0001',
    area: 'Al Malaz, Riyadh',
    zone: 'Zone 4B',
    kind: 'First-Mile Pickup',
    detail: '3 Packages (15 kg)',
    detailHighlight: '3 Packages (15 kg)',
    remarks: 'Ready',
    city: 'Riyadh (Central)',
    routeCode: 'RUH-RET-101',
    schedule: '10:00 - 11:30 AM',
    packaging: 'Standard Carton Boxes',
    packageSummary: '3 Pkgs • 15 kg',
    date: 'Today, 24 Oct',
    time: '10:00 - 11:30 AM',
    assignedBy: 'Dispatch Ops - Sarah Al-Mansoor',
    assignedHub: 'Central Hub',
  ),
  Job(
    type: JobType.delivery,
    status: JobStatus.assigned,
    reference: 'AWB-772910',
    area: 'Khanshlila, Riyadh',
    zone: 'Street 14',
    kind: 'Last-Mile Delivery',
    detail: 'Electronics (Fragile)',
    remarks: 'Fragile - handle with care',
    city: 'Riyadh (Central)',
    routeCode: 'RUH-RET-101',
    schedule: '14:00 - 15:30 PM',
    packaging: 'Fragile Electronics Box',
    packageSummary: '1 Pkg • 4 kg',
    date: 'Today, 24 Oct',
    time: '14:00 - 15:30 PM',
    assignedBy: 'Dispatch Ops - Sarah Al-Mansoor',
    assignedHub: 'Central Hub',
  ),
];
