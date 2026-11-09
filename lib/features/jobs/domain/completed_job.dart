import 'job.dart';

enum CompletedOutcome { delivered, exception }

class CompletedJob {
  const CompletedJob({
    required this.type,
    required this.outcome,
    required this.reference,
    required this.timeText,
    required this.area,
    required this.zone,
    this.note,
    this.paymentLabel,
    this.paymentValue,
    this.paymentBadge,
    this.alert,
  });

  final JobType type;
  final CompletedOutcome outcome;
  final String reference;
  final String timeText;
  final String area;
  final String zone;

  /// e.g. "Delivered • E-Signature Captured".
  final String? note;

  /// Left label of the payment row, e.g. "COD Collected" or "Payment".
  final String? paymentLabel;

  /// Plain value on the right, e.g. "Prepaid (Online)".
  final String? paymentValue;

  /// Highlighted value on the right in a white pill, e.g. "SAR 145.00".
  final String? paymentBadge;

  /// Red alert strip, e.g. "Customer Unavailable • Rescheduled 16:00".
  final String? alert;

  String get referenceLabel =>
      type == JobType.pickup ? 'BOOKING NUMBER' : 'AIR WAYBILL NUMBER';
}

/// Placeholder data until the completed-jobs endpoint is available.
const sampleCompletedJobs = <CompletedJob>[
  CompletedJob(
    type: JobType.delivery,
    outcome: CompletedOutcome.delivered,
    reference: 'AWB-771804',
    timeText: 'Today, 11:15 AM',
    area: 'Al Sulaimaniyah, Riyadh',
    zone: 'Villa Entrance A',
    paymentLabel: 'COD Collected',
    paymentBadge: 'SAR 145.00 (POS Card)',
  ),
  CompletedJob(
    type: JobType.delivery,
    outcome: CompletedOutcome.delivered,
    reference: 'AWB-772910',
    timeText: 'Today, 10:40 AM',
    area: 'Khanshila, Riyadh',
    zone: 'Street 14',
    note: 'Delivered • E-Signature Captured',
    paymentLabel: 'Payment',
    paymentValue: 'Prepaid (Online)',
  ),
  CompletedJob(
    type: JobType.pickup,
    outcome: CompletedOutcome.exception,
    reference: 'BK-I-RI-0084',
    timeText: '10:00 - 11:30',
    area: 'Al Olaya, Riyadh',
    zone: 'Office Tower 2',
    alert: 'Customer Unavailable • Rescheduled 16:00',
  ),
];
