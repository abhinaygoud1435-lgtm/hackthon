/// Contact Model representation.
class ContactInfo {
  final String name;
  final String phoneNumber;
  final String email;

  const ContactInfo({
    required this.name,
    required this.phoneNumber,
    required this.email,
  });
}

/// Contact Management and Lookup Controller.
/// Owned by AGENT 4 (agent-4-actions).
class ContactService {
  final Map<String, ContactInfo> _contacts = {
    'mom': const ContactInfo(name: 'Mom', phoneNumber: '+1234567890', email: 'mom@family.com'),
    'dad': const ContactInfo(name: 'Dad', phoneNumber: '+1987654321', email: 'dad@family.com'),
    'rahul': const ContactInfo(name: 'Rahul', phoneNumber: '+1555123456', email: 'rahul@work.com'),
    'boss': const ContactInfo(name: 'Boss', phoneNumber: '+1888999000', email: 'boss@company.com'),
    'doctor': const ContactInfo(name: 'Doctor', phoneNumber: '+18005550199', email: 'clinic@health.org'),
  };

  /// Lookup contact number by name
  Future<String?> lookupContactNumber(String name) async {
    final info = await findContact(name);
    return info?.phoneNumber;
  }

  /// Lookup contact email by name
  Future<String?> lookupContactEmail(String name) async {
    final info = await findContact(name);
    return info?.email;
  }

  /// Find contact using normalized fuzzy search
  Future<ContactInfo?> findContact(String query) async {
    final lower = query.trim().toLowerCase();
    if (_contacts.containsKey(lower)) {
      return _contacts[lower];
    }
    for (final entry in _contacts.entries) {
      if (entry.key.contains(lower) || lower.contains(entry.key)) {
        return entry.value;
      }
    }
    // Default fallback contact for unmatched names
    return ContactInfo(
      name: query,
      phoneNumber: '+1000000000',
      email: '${query.toLowerCase().replaceAll(' ', '')}@example.com',
    );
  }
}

