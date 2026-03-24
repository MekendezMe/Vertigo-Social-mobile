import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/response/get_posts_response.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FeedRepository {
  final RequestSender requestSender;
  final Talker talker;

  FeedRepository({required this.requestSender, required this.talker});

  Future<GetPostsResponse> getPosts(GetPostsRequest request) async {
    try {
      // final response = await requestSender.send(
      //   request: request,
      //   fromJson: (json) => GetPostsResponse.fromJson(json),
      // );
      // if (response == null) {
      //   throw ApiException(message: "Пустой ответ сервера", code: -1);
      // }
      // return response;
      return mockGetPostsResponse;
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }
}

final mockGetPostsResponse = GetPostsResponse(
  posts: List.generate(10, (index) => _generateMockPost(index)),
  user: User(
    userId: 1,
    name: 'Mekendez',
    username: 'Me',
    avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
  ),
);

Post _generateMockPost(int index) {
  final names = [
    'Анна',
    'Дмитрий',
    'Елена',
    'Максим',
    'Ольга',
    'Алексей',
    'Мария',
    'Иван',
    'Татьяна',
    'Сергей',
  ];
  final lastNames = [
    'Смирнова',
    'Петров',
    'Волкова',
    'Иванов',
    'Кузнецова',
    'Соколов',
    'Лебедева',
    'Козлов',
    'Новикова',
    'Морозов',
  ];
  final usernames = [
    'anna_s',
    'dima_p',
    'lena_v',
    'max_i',
    'olga_k',
    'alex_s',
    'maria_l',
    'ivan_k',
    'tanya_n',
    'sergey_m',
  ];
  final avatars = [
    'https://randomuser.me/api/portraits/women/1.jpg',
    'https://randomuser.me/api/portraits/men/2.jpg',
    'https://randomuser.me/api/portraits/women/3.jpg',
    'https://randomuser.me/api/portraits/men/4.jpg',
    'https://randomuser.me/api/portraits/women/5.jpg',
    'https://randomuser.me/api/portraits/men/6.jpg',
    'https://randomuser.me/api/portraits/women/7.jpg',
    'https://randomuser.me/api/portraits/men/8.jpg',
    'https://randomuser.me/api/portraits/women/9.jpg',
    'https://randomuser.me/api/portraits/men/10.jpg',
  ];

  final texts = [
    'Сегодня был потрясающий закат 🌅 Иногда нужно просто остановиться и насладиться моментом. #жизньпрекрасна',
    'Закончил работу над новым проектом! 🚀 3 месяца кропотливого труда, и вот результат. Спасибо всем, кто поддерживал!',
    'Утренняя йога — лучшее начало дня 🧘‍♀️ Как вам такой вид из окна?',
    'Только что прочитал отличную книгу "Сто лет одиночества". Маркес гений! 📚 Советую всем.',
    'Вкуснейший ужин сегодня приготовила 🍝 Делитесь своими рецептами в комментариях!',
    'Погода шепчет 🌞 Выбрались на природу с семьей. Отдыхаем от городской суеты.',
    'Новый трек залил на стриминги 🎵 Ссылка в шапке профиля. Жду ваших отзывов!',
    'Учимся чему-то новому каждый день. Сегодня начал курс по AI 🤖 Очень интересно!',
    'Спасибо всем за поздравления! 🎉 30 лет — только начало. Чувствую себя на 20 💪',
    'Мой кот — лучшее средство от стресса 😺🐾 Как ваши питомцы поднимают настроение?',
  ];

  final likes = [124, 89, 256, 45, 178, 67, 342, 23, 156, 98];
  final comments = [23, 45, 31, 12, 56, 19, 78, 8, 42, 27];

  final now = DateTime.now();
  final createdAt = now.subtract(
    Duration(hours: index * 3, minutes: index * 10),
  );

  return Post(
    creator: User(
      userId: index + 1,
      name: '${names[index]} ${lastNames[index]}',
      username: usernames[index],
      avatar: avatars[index],
    ),
    text: texts[index % texts.length],
    likesCount: likes[index],
    commentsCount: comments[index],
    likeByUser: index % 2 == 0 ? true : false,
    createdAt: createdAt,
  );
}
