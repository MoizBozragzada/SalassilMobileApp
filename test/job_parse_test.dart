import 'package:flutter_test/flutter_test.dart';
import 'package:salassil_express/features/jobs/domain/job.dart';

/// Mirrors the shape of GET /mobile-courier-app/jobs (trimmed).
final _response = [
  {
    'jobType': 'Booking',
    'jobCategory': 'Pickup',
    'awbNumber': null,
    'awb': null,
    'bookingNumber': 'BK-C-RI-0005',
    'accountNumber': 'SAU-RIY-C-00001',
    'serviceCode': 'FPD',
    'direction': 'Forward Pickup',
    'serviceScope': 'Domestic',
    'countryName': 'Saudi Arabia',
    'cityName': 'Riyadh',
    'pickupAreaName': 'N/R-ALQIRAWAN',
    'operationalRouteCode': 'RIY-RET-104',
    'pickupAddress': 'TEST',
    'pickupShortAddress': 'TEST',
    'pickupContactNumber': '0313131313',
    'pickupTimeWindow': '8:00 - 10:00',
    'pickupDate': '2026-11-16',
    'shipmentType': 'Freight',
    'packagingType': 'Single',
    'expectedPackages': 20,
    'expectedShipment': 40,
    'expectedWeight': 1.00,
    'bookingRemarks': 'test',
    'status': 'ASSIGNED',
    'startedAt': null,
    'completedAt': null,
  },
  {
    'jobType': 'AWB',
    'jobCategory': 'Delivery',
    'awbNumber': 900000181,
    'awb': {
      'pieces': 2.0,
      'weight': 10.0,
      'content': 'cloth',
      'shipmentCategory': 'Parcel',
      'recipientsContactNumber': '031341131414',
      'deliveryAddress': 'test',
      'deliveryStreetName': 'test street',
      'deliveryDistrict': 'test district',
      'destinationCity': 'Dammam',
      'destinationCountry': 'Saudi Arabia',
      'serviceType': 'E-Commerce Delivery Service',
    },
    'bookingNumber': null,
    'accountNumber': 'SAU-RIY-I-00001',
    'direction': null,
    'cityName': null,
    'operationalRouteCode': 'RIY-RET-104',
    'pickupAddress': 'Test ',
    'pickupDate': '2026-11-01',
    'expectedPackages': null,
    'status': 'ASSIGNED',
    'startedAt': null,
    'completedAt': null,
  },
  {
    'jobType': 'Booking',
    'jobCategory': 'Pickup',
    'bookingNumber': 'BK-E-DA-0001',
    'direction': 'Forward Pickup',
    'cityName': 'Dammam',
    'pickupAreaName': 'N/R-ALNARJIS',
    'status': 'COMPLETED',
    'startedAt': '2026-11-11T01:33:35.659572',
    'completedAt': '2026-11-11T01:35:33.849463',
  },
];

void main() {
  test('parses a top-level list of jobs', () {
    final jobs = Job.parseList(_response)!;
    expect(jobs.length, 3);

    final pickup = jobs[0];
    expect(pickup.type, JobType.pickup);
    expect(pickup.status, JobStatus.assigned);
    expect(pickup.reference, 'BK-C-RI-0005');
    expect(pickup.area, 'N/R-ALQIRAWAN, Riyadh');
    expect(pickup.routeCode, 'RIY-RET-104');
    expect(pickup.timeWindow, '8:00 - 10:00');
    expect(pickup.contactNumber, '0313131313');
    expect(pickup.address, 'TEST');
    expect(pickup.detail, '20 Packages (1 kg)');
    expect(pickup.kind, 'Forward Pickup');

    final delivery = jobs[1];
    expect(delivery.type, JobType.delivery);
    expect(delivery.reference, '900000181');
    expect(delivery.area, 'test district, Dammam');
    expect(delivery.address, 'test');
    expect(delivery.contactNumber, '031341131414');
    expect(delivery.detail, '2 Packages (10 kg)');
    expect(delivery.status, JobStatus.assigned);

    final done = jobs[2];
    expect(done.status, JobStatus.completed);
    expect(done.completedAt, isNotNull);
  });

  test('returns null when no list is present', () {
    expect(Job.parseList({'message': 'ok'}), isNull);
  });
}
