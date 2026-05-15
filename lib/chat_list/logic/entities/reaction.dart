import 'package:social_network_flutter/feed/logic/entites/user.dart';

class Reaction {
  final int id;
  final String reaction;
  final User user;

  Reaction({required this.id, required this.reaction, required this.user});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as int,
      reaction: json['reaction'] as String,
      user: User.fromJson(json['user']),
    );
  }
}
