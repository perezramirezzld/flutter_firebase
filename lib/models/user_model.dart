class UserLocal {
  String? uid;
  String name;
  String lastname;
  String role;
  int age;
  String gender;
  String email;
  String password;

  UserLocal(
    {
      this.uid,
      required this.name,
      required this.lastname,
      required this.role,
      required this.age,
      required this.gender,
      required this.email,
      required this.password,
    }
  );
}