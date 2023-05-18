class User {
  String? uid;
  String name;
  String lastname;
  int age;
  String gender;
  String email;
  String password;

  User(
    {
      this.uid,
      required this.name,
      required this.lastname,
      required this.age,
      required this.gender,
      required this.email,
      required this.password,
    }
  );
}