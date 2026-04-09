import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/entites/request/create_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/edit_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/like_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/unlike_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/response/create_post_response.dart';
import 'package:social_network_flutter/feed/logic/entites/response/edit_post_response.dart';
import 'package:social_network_flutter/feed/logic/entites/response/get_post_response.dart';
import 'package:social_network_flutter/feed/logic/entites/response/get_posts_response.dart';
import 'package:social_network_flutter/feed/logic/entites/response/reaction_post_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FeedRepository {
  final RequestSender requestSender;
  final Talker talker;

  FeedRepository({required this.requestSender, required this.talker});

  Future<GetPostsResponse> getPosts(GetPostsRequest request) async {
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => GetPostsResponse.fromJson(json),
        queryParams: request.queryParamsToJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPostResponse> getPost(GetPostRequest request) async {
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => GetPostResponse.fromJson(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePostResponse> createPost(CreatePostRequest request) async {
    try {
      FormData? formData;
      if (request.images.isNotEmpty) {
        formData = await request.getBodyWithPhotos();
      }
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => CreatePostResponse.fromJson(json),
        formData: formData,
        body: request.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<EditPostResponse> editPost(EditPostRequest request) async {
    try {
      FormData? formData;
      if (request.images.isNotEmpty) {
        formData = await request.getBodyWithPhotos();
      }
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => EditPostResponse.fromJson(json),
        formData: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReactionPostResponse> likePost(LikePostRequest request) async {
    final response = await requestSender.send(
      request: request,
      fromJson: (json) => ReactionPostResponse.fromJson(json),
    );
    return response;
  }

  Future<ReactionPostResponse> unlikePost(UnlikePostRequest request) async {
    final response = await requestSender.send(
      request: request,
      fromJson: (json) => ReactionPostResponse.fromJson(json),
    );
    return response;
  }
}

// List<Post> _mockPosts = List.generate(10, (index) => _generateMockPost(index));

// final mockGetPostsResponse = GetPostsResponse(
//   posts: _mockPosts,
//   isLastPage: false,
// );

// Post _generateMockPost(int index) {
//   final names = [
//     'Анна',
//     'Дмитрий',
//     'Елена',
//     'Максим',
//     'Ольга',
//     'Алексей',
//     'Мария',
//     'Иван',
//     'Татьяна',
//     'Сергей',
//   ];
//   final lastNames = [
//     'Смирнова',
//     'Петров',
//     'Волкова',
//     'Иванов',
//     'Кузнецова',
//     'Соколов',
//     'Лебедева',
//     'Козлов',
//     'Новикова',
//     'Морозов',
//   ];
//   final usernames = [
//     'anna_s',
//     'dima_p',
//     'lena_v',
//     'max_i',
//     'olga_k',
//     'alex_s',
//     'maria_l',
//     'ivan_k',
//     'tanya_n',
//     'sergey_m',
//   ];
//   final avatars = [
//     'https://randomuser.me/api/portraits/women/1.jpg',
//     'https://randomuser.me/api/portraits/men/2.jpg',
//     'https://randomuser.me/api/portraits/women/3.jpg',
//     'https://randomuser.me/api/portraits/men/4.jpg',
//     'https://randomuser.me/api/portraits/women/5.jpg',
//     'https://randomuser.me/api/portraits/men/6.jpg',
//     'https://randomuser.me/api/portraits/women/7.jpg',
//     'https://randomuser.me/api/portraits/men/8.jpg',
//     'https://randomuser.me/api/portraits/women/9.jpg',
//     'https://randomuser.me/api/portraits/men/10.jpg',
//   ];

//   final texts = [
//     'Сегодня был потрясающий закат 🌅 Иногда нужно просто остановиться и насладиться моментом. #жизньпрекрасна',
//     'Закончил работу над новым проектом! 🚀 3 месяца кропотливого труда, и вот результат. Спасибо всем, кто поддерживал!',
//     'Утренняя йога — лучшее начало дня 🧘‍♀️ Как вам такой вид из окна?',
//     'Только что прочитал отличную книгу "Сто лет одиночества". Маркес гений! 📚 Советую всем.',
//     'Вкуснейший ужин сегодня приготовила 🍝 Делитесь своими рецептами в комментариях!',
//     'Погода шепчет 🌞 Выбрались на природу с семьей. Отдыхаем от городской суеты.',
//     'Новый трек залил на стриминги 🎵 Ссылка в шапке профиля. Жду ваших отзывов!',
//     'Учимся чему-то новому каждый день. Сегодня начал курс по AI 🤖 Очень интересно!',
//     'Спасибо всем за поздравления! 🎉 30 лет — только начало. Чувствую себя на 20 💪',
//     'Мой кот — лучшее средство от стресса 😺🐾 Как ваши питомцы поднимают настроение?',
//   ];

//   final likes = [124, 89, 256, 45, 178, 67, 342, 23, 156, 98];
//   final comments = [23, 45, 31, 12, 56, 19, 78, 8, 42, 27];

//   final now = DateTime.now();
//   final createdAt = now.subtract(
//     Duration(hours: index * 3, minutes: index * 10),
//   );

//   return Post(
//     creator: User(
//       id: index + 1,
//       name: '${names[index]} ${lastNames[index]}',
//       username: usernames[index],
//       avatar: index < 10 ? avatars[index] : avatars[0],
//     ),
//     id: index + 1,
//     text: texts[index % texts.length],
//     images: avatars,
//     likesCount: likes[index],
//     commentsCount: comments[index],
//     likedByUser: index % 2 == 0 ? true : false,
//     createdAt: createdAt,
//   );
// }
