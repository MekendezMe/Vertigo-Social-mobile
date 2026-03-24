import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/base_container_widget.dart';
import 'package:social_network_flutter/feed/ui/widgets/post_item_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.feedBloc,
    required this.onShowProfile,
    required this.onShowSettings,
  });
  final FeedBloc feedBloc;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  TextEditingController inputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.feedBloc.add(LoadFeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: customDrawer(
          context: context,
          active: TypeScreen.feed,
          onShowSettings: () => widget.onShowSettings(context: context),
          onShowProfile: () => widget.onShowProfile(context: context),
          onShowFeed: null,
        ),
      ),
      body: BlocConsumer<FeedBloc, FeedState>(
        bloc: widget.feedBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(
              child: CircularProgressIndicator(color: context.color.dimPurple),
            );
          }
          if (state is FeedLoaded) {
            return _showPostsWidget(state, inputController);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _showPostsWidget(FeedLoaded state, TextEditingController controller) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _createPostWidget(state, controller)),
        SliverToBoxAdapter(child: SizedBox(height: 30)),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final post = state.posts[index];
            return postItemWidget(post: post, context: context);
          }, childCount: state.posts.length),
        ),
      ],
    );
  }

  Widget _createPostWidget(FeedLoaded state, TextEditingController controller) {
    final avatarUrl = state.user.avatar;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    return baseContainerWidget(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 14),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: hasAvatar
                        ? Image.network(
                            avatarUrl,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: mainTextField(
                      context: context,
                      controller: controller,
                      style: context.theme.textTheme.bodyLarge!,
                      hintText: "Что у вас нового?",
                      radius: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Divider(color: context.color.gray, thickness: 0.8),
          SizedBox(height: 25),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(Icons.photo),
                    color: context.color.gray,
                  ),
                  IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(Icons.attach_file),
                    color: context.color.gray,
                  ),
                  IconButton(
                    iconSize: 25,
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: context.color.gray,
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: mainButton(
                  backgroundColor: context.color.dimPurple.withOpacity(0.8),
                  context: context,
                  child: Text(
                    "Опубликовать",
                    style: context.theme.textTheme.bodyMedium,
                  ),
                  onTap: () {},
                  radius: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
