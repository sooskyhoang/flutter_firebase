class CustomUser {
  final String uid;

  CustomUser({required this.uid});
}

class UserData extends CustomUser {
  final String name;
  final String sugars;
  final int strength;

  UserData(
      {required String uid,
      required this.name,
      required this.sugars,
      required this.strength})
      : super(uid: uid);
}
