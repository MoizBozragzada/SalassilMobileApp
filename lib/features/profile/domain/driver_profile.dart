class DriverProfile {
  const DriverProfile({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.residentCity,
    required this.countryCode,
    required this.employeeId,
    required this.status,
    required this.position,
    required this.joinedDate,
    required this.dispatchHub,
    required this.hubBay,
    required this.company,
    required this.onDuty,
    required this.verified,
    required this.routeCode,
    required this.routeName,
    required this.zone,
    required this.department,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String residentCity;
  final String countryCode;
  final String employeeId;
  final String status;
  final String position;
  final String joinedDate;
  final String dispatchHub;
  final String hubBay;
  final String company;
  final bool onDuty;
  final bool verified;
  final String routeCode;
  final String routeName;
  final String zone;
  final String department;

  String get fullName => '$firstName $lastName';
}

/// Placeholder profile until the driver profile endpoint is available.
const sampleDriverProfile = DriverProfile(
  firstName: 'Tariq',
  lastName: 'Mehmood',
  gender: 'Male',
  dateOfBirth: '14 Aug 1991',
  residentCity: 'Riyadh (Central Province)',
  countryCode: 'KSA',
  employeeId: 'SE-8842',
  status: 'Active / Full-time',
  position: 'Master Courier',
  joinedDate: '12 Mar 2021',
  dispatchHub: 'Riyadh Central Hub 4B',
  hubBay: '14',
  company: 'Salassil Express',
  onDuty: true,
  verified: true,
  routeCode: 'RUH-RET-001',
  routeName: 'Riyadh Central',
  zone: 'Zone 4B • Olaya & Al-Sulaimaniyah',
  department: 'Logistics Operations',
);
