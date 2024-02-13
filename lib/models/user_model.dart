import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePicture;
  final String bannerPicture;
  final String bio;
  final String uid;
  final bool isXVerified;
  UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePicture,
    required this.bannerPicture,
    required this.bio,
    required this.uid,
    required this.isXVerified,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePicture,
    String? bannerPicture,
    String? bio,
    String? uid,
    bool? isXVerified,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePicture: profilePicture ?? this.profilePicture,
      bannerPicture: bannerPicture ?? this.bannerPicture,
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
      isXVerified: isXVerified ?? this.isXVerified,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'email': email});
    result.addAll({
      'name': name,
    });
    result.addAll({
      'followers': followers,
    });
    result.addAll({
      'following': following,
    });
    result.addAll({
      'profilePicture': profilePicture,
    });
    result.addAll({
      'bannerPicture': bannerPicture,
    });
    result.addAll({
      'uid': uid,
    });
    result.addAll({
      'bio': bio,
    });
    result.addAll({
      'isXVerified': isXVerified,
    });
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      followers: List<String>.from((map['followers'])),
      following: List<String>.from((map['following'])),
      profilePicture: map['profilePicture'] ?? '',
      bannerPicture: map['bannerPicture'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      isXVerified: map['isXVerified'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePicture: $profilePicture, bannerPicture: $bannerPicture, bio: $bio, uid: $uid, isXVerified: $isXVerified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePicture == profilePicture &&
        other.bannerPicture == bannerPicture &&
        other.bio == bio &&
        other.uid == uid &&
        other.isXVerified == isXVerified;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePicture.hashCode ^
        bannerPicture.hashCode ^
        bio.hashCode ^
        uid.hashCode ^
        isXVerified.hashCode;
  }
}
