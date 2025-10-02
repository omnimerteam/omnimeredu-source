class RoleGuard {
  static const Map<String, String> roleAlias = {
    'SuperAdmin': 'super_admin',
    'SchoolAdmin': 'school_admin',
    'Teacher': 'teacher',
    'Student': 'student',
    'CanteenStaff': 'canteen_staff',
    'Nurse': 'nurse',
    'Security': 'security',
  };

  static const Map<String, List<String>> accessRules = {
    '/main': [
      'super_admin',
      'school_admin',
      'teacher',
      'student',
      'canteen_staff',
      'nurse',
      'security',
    ],
    '/school-admin/school': ['school_admin'],
    '/school-admin/classes': ['school_admin', 'teacher'],
    '/school-admin/classes/detail': ['school_admin', 'teacher'],
    '/school-admin/membership-requests': ['school_admin'],
    '/school-admin/grades': ['school_admin'],
    '/school-admin/students': ['school_admin', 'teacher'],
    '/school-admin/personnel': [
      'school_admin',
      'teacher',
      'canteen_staff',
      'nurse',
      'security',
    ],
  };

  static bool canAccess(String dbRole, String routeName) {
    // Chuẩn hoá role về key chuẩn
    final normalizedRole = roleAlias[dbRole];
    if (normalizedRole == null) return false;

    final allowedRoles = accessRules[routeName];
    if (allowedRoles == null) return false;

    return allowedRoles.contains(normalizedRole);
  }
}
