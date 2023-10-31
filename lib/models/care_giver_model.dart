class CareGiver {
  final String fullName;
  final String mobileNumber;
  final String email;
  final String careType;
  final String address;
  final String password;
  final DateTime birthday;
  final String city;
  final String description;
  final String bank;
  final String bankBranch;
  final String accName;
  final String accNumber;
  final String profilePicture;
  final double ratings;
  final List<String> acceptedWorks;
  final List<String> pendingWorks;

  CareGiver({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.birthday,
    required this.address,
    required this.password,
    required this.careType,
    required this.profilePicture,
    this.city = '',
    this.description = '',
    this.accName = '',
    this.accNumber = '',
    this.bank = '',
    this.bankBranch = '',
    this.acceptedWorks = const [],
    this.pendingWorks = const [],
    this.ratings = 0.0,
  });
}
