import 'package:flutter/material.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.feedBloc});
  final FeedBloc feedBloc;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
