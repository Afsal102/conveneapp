class UserInfo {
  final String uid;
  final String email;
  final String? name;
  final String? profilePic;
  final bool showTutorial;

  const UserInfo({
    required this.uid,
    required this.email,
    required this.name,
    required this.showTutorial,
    required this.profilePic,
  });

  UserInfo copyWith({
    String? uid,
    String? email,
    String? name,
    String? profilePic,
    bool? showTutorial,
  }) {
    return UserInfo(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      showTutorial: showTutorial ?? this.showTutorial,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
