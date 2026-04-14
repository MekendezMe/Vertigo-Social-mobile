import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/widgets/show_posts_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/drawer/custom_drawer.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.feedBloc,
    required this.onShowProfile,
    required this.onShowSettings,
    required this.onShowGallery,
    required this.onShowComments,
  });
  final FeedBloc feedBloc;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;
  final Function({required BuildContext context, required int postId})
  onShowComments;
  final Function({
    required BuildContext context,
    required List<String> media,
    required int index,
  })
  onShowGallery;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    widget.feedBloc.add(LoadFeed());
  }

  Widget _buildLoadingFailure({String? error}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error ?? "Ошибка при загрузке",
            style: context.theme.textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          mainButton(
            context: context,
            child: Text("Повторить"),
            onTap: () {
              widget.feedBloc.add(LoadFeed());
            },
          ),
        ],
      ),
    );
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
              child: customCircularProgressIndicator(context: context),
            );
          }
          if (state is FeedLoadingFailure) {
            return _buildLoadingFailure(error: state.error?.toString());
          }
          if (state is FeedLoaded) {
            return RefreshIndicator(
              backgroundColor: context.color.darkGray,
              color: context.color.lightPurple,
              onRefresh: () async {
                final completer = Completer<void>();

                final subscription = widget.feedBloc.stream.listen((state) {
                  if (state is FeedLoaded || state is FeedLoadingFailure) {
                    completer.complete();
                  }
                });

                widget.feedBloc.add(LoadFeed());

                await completer.future;

                await subscription.cancel();
              },
              child: ShowPostsWidget(
                state: state,
                feedBloc: widget.feedBloc,
                onShowGallery: widget.onShowGallery,
                onShowComments: widget.onShowComments,
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
