import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/ui/widgets/post/post_item_widget.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/loading/build_loading_failure.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
    required this.postId,
    required this.postBloc,
    required this.onShowGallery,
  });
  final int postId;
  final PostBloc postBloc;
  final Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    widget.postBloc.add(LoadPost(postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PostLoading) {
            return customCircularProgressIndicator(context: context);
          }
          if (state is PostLoadingFailure) {
            return buildLoadingFailure(
              context: context,
              onTap: () => widget.postBloc.add(LoadPost(postId: widget.postId)),
            );
          }
          if (state is PostLoaded) {
            return _buildPostScreen(state);
          }
          return Center(
            child: Text(
              'Экран поста (заглушка)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostScreen(PostLoaded state) {
    return Column(
      children: [
        SizedBox(height: 20),
        PostItemWidget(
          post: state.post,
          onLikePressed: () {},
          onShowGallery: widget.onShowGallery,
          onShowComments: null,
          user: state.user,
          onEdit: ({required Post post}) {},
          onDelete: ({required Post post}) {},
          onSubscribe: ({required Post post}) {},
        ),
      ],
    );
  }
}
