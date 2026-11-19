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

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final letters = [firstName, lastName]
        .where((s) => s.isNotEmpty && s != _missing)
        .map((s) => s[0].toUpperCase())
        .join();
    return letters.isEmpty ? '--' : letters;
  }

  static const _missing = '-';

  /// Builds a profile from the employee endpoint's JSON.
  ///
  /// The response format is not documented, so this accepts the employee
  /// object at the top level or nested under keys such as `data`, matches
  /// field names ignoring case, underscores and dashes, and returns null if
  /// no employee-looking object is found.
  static DriverProfile? tryParse(dynamic json) {
    final map = _findEmployeeMap(json, 0);
    if (map == null) return null;

    final fields = {
      for (final e in map.entries) _norm(e.key.toString()): e.value,
    };

    String? pick(List<String> keys) {
      for (final key in keys) {
        final value = _text(fields[_norm(key)]);
        if (value != null) return value;
      }
      return null;
    }

    bool flag(List<String> keys) {
      for (final key in keys) {
        final v = fields[_norm(key)];
        if (v is bool) return v;
        if (v is num) return v != 0;
        if (v is String) {
          const yes = {'1', 'true', 'yes', 'on duty', 'onduty', 'active'};
          return yes.contains(v.trim().toLowerCase());
        }
      }
      return false;
    }

    var first = pick(['first_name', 'firstname', 'fname', 'first_name_en']);
    var last = pick(['last_name', 'lastname', 'lname', 'last_name_en']);
    if (first == null && last == null) {
      final full = pick(['name', 'full_name', 'fullname', 'employee_name']);
      if (full != null) {
        final parts = full.split(RegExp(r'\s+'));
        first = parts.first;
        last = parts.length > 1 ? parts.sublist(1).join(' ') : null;
      }
    }

    return DriverProfile(
      firstName: first ?? _missing,
      lastName: last ?? '',
      gender: pick(['gender', 'sex']) ?? _missing,
      dateOfBirth:
          pick(['date_of_birth', 'dob', 'birth_date', 'birthdate']) ?? _missing,
      residentCity: pick(['resident_city', 'city', 'city_name']) ?? _missing,
      countryCode:
          pick(['country_code', 'country', 'nationality']) ?? _missing,
      employeeId: pick([
            'employee_id',
            'employee_no',
            'employee_number',
            'employee_code',
            'emp_id',
            'code',
            'id',
          ]) ??
          _missing,
      status: pick(['status', 'employment_status', 'employee_status']) ??
          _missing,
      position:
          pick(['position', 'designation', 'job_title', 'role', 'title']) ??
              _missing,
      joinedDate: pick([
            'joined_date',
            'joining_date',
            'date_of_joining',
            'hire_date',
            'joined_at',
          ]) ??
          _missing,
      dispatchHub: pick([
            'base_dispatch_hub',
            'dispatch_hub',
            'base_hub',
            'hub_name',
            'hub',
            'branch',
          ]) ??
          _missing,
      hubBay: pick(['hub_bay', 'bay']) ?? _missing,
      company: pick(['company', 'company_name']) ?? 'Salassil Express',
      onDuty: flag(['on_duty', 'is_on_duty', 'duty_status']),
      verified: flag(['verified', 'is_verified']),
      routeCode:
          pick(['route_code', 'operational_route_code', 'route']) ?? _missing,
      routeName: pick(['route_name', 'route_description']) ?? '',
      zone: pick(['zone', 'territory', 'zone_name']) ?? _missing,
      department: pick(['department', 'department_name']) ?? _missing,
    );
  }

  static String _norm(String key) =>
      key.toLowerCase().replaceAll(RegExp(r'[_\-\s]'), '');

  /// Strings and numbers as text; nested objects via their `name`.
  static String? _text(dynamic v) {
    if (v is String) return v.trim().isEmpty ? null : v.trim();
    if (v is num) return v.toString();
    if (v is Map) {
      for (final key in ['name', 'name_en', 'title', 'label']) {
        final inner = v[key];
        if (inner is String && inner.trim().isNotEmpty) return inner.trim();
      }
    }
    return null;
  }

  static const _identityKeys = {
    'firstname',
    'fullname',
    'name',
    'employeename',
    'employeeid',
    'employeeno',
    'employeecode',
    'empid',
  };

  static Map<dynamic, dynamic>? _findEmployeeMap(dynamic json, int depth) {
    if (depth > 4) return null;
    if (json is List && json.isNotEmpty) {
      return _findEmployeeMap(json.first, depth + 1);
    }
    if (json is! Map) return null;
    if (json.keys.any((k) => _identityKeys.contains(_norm(k.toString())))) {
      return json;
    }
    for (final value in json.values) {
      final found = _findEmployeeMap(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }
}
