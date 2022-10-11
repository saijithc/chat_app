import 'dart:convert';

class Users {
  String userId;
  Users({required this.userId});
}

// Details detailsFromJson(String str) => Details.fromJson(json.decode(str));

// String detailsToJson(Details data) => json.encode(data.toJson());

// class Details {
//   Details({
//     required this.chatroomId,
//     required this.user,
//     required this.userEmail,
//   });

//   final String chatroomId;
//   final List<String> user;
//   final String userEmail;

//   factory Details.fromJson(Map<String, dynamic> json) => Details(
//         chatroomId: json["chatroomId"],
//         user: List<String>.from(json["user"].map((x) => x)),
//         userEmail: json["userEmail"],
//       );

//   Map<String, dynamic> toJson() => {
//         "chatroomId": chatroomId,
//         "user": List<dynamic>.from(user.map((x) => x)),
//         "userEmail": userEmail,
//       };
// }
