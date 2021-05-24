part of 'models.dart';

class Users extends Equatable {

  final String uid;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String pic;
  final String createdAt;
  final String updatedAt;

  Users(
    this.uid,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.pic,
    this.createdAt,
    this.updatedAt
  );

  @override
  // TODO: implement props
  List<Object> get props => [
    uid,
    email,
    password,
    firstName,
    lastName,
    phone,
    address,
    pic,
    createdAt,
    updatedAt,
  ];

}