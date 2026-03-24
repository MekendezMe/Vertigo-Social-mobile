part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {}

class LoadFeed extends FeedEvent {
  @override
  List<Object?> get props => [];
}
