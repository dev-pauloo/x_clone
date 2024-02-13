import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:x_clone/core/enums/post_type_enum.dart';

class Post {
  final String text;
  final List<String?>? hashtags; // Use '?' for optional lists
  final String? link;
  final List<String?>? imageLink;
  final String uid;
  final PostType postType;
  final DateTime postedAt;
  final List<String?>? likes;
  final List<String?>? commentIds;
  final String id;
  final int? resharedCount;

  Post({
    required this.text,
    this.hashtags,
    this.link,
    this.imageLink,
    required this.uid,
    required this.postType,
    required this.postedAt,
    this.likes,
    this.commentIds,
    required this.id,
    this.resharedCount,
  });

  Post copyWith({
    String? text,
    List<String?>? hashtags, // Use '?' for optional lists
    String? link,
    List<String?>? imageLink,
    String? uid,
    PostType? postType,
    DateTime? postedAt,
    List<String?>? likes,
    List<String?>? commentIds,
    String? id,
    int? resharedCount,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLink: imageLink ?? this.imageLink,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      resharedCount: resharedCount ?? this.resharedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'hashtags': hashtags?.map((e) => e).toList(), // Convert to non-null list
      'link': link,
      'imageLink': imageLink,
      'uid': uid,
      'postType': postType.type,
      'postedAt': postedAt.millisecondsSinceEpoch,
      'likes': likes?.map((e) => e).toList(), // Convert to non-null list
      'commentIds':
          commentIds?.map((e) => e).toList(), // Convert to non-null list
      'resharedCount': resharedCount,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      hashtags: map['hashtags']?.cast<String>(), // Cast and handle null
      link: map['link'] ?? '',
      imageLink: map['imageLink']?.cast<String>(), // Cast and handle null
      uid: map['uid'] ?? '',
      postType: (map['postType'] as String).toPostTypeEnum(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      likes: map['likes']?.cast<String>(), // Cast and handle null
      commentIds: map['commentIds']?.cast<String>(), // Cast and handle null
      id: map['id'] ?? '',
      resharedCount: map['resharedCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLink: $imageLink, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes, commentIds: $commentIds, id: $id, resharedCount: $resharedCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLink, imageLink) &&
        other.uid == uid &&
        other.postType == postType &&
        other.postedAt == postedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.resharedCount == resharedCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        link.hashCode ^
        postedAt.hashCode ^
        postType.hashCode ^
        hashtags.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        resharedCount.hashCode ^
        uid.hashCode;
  }
}
