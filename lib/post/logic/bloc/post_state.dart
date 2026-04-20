part of 'post_bloc.dart';

abstract class PostState extends Equatable {}

class PostInitial extends PostState {
  @override
  List<Object?> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object?> get props => [];
}

class PostLoaded extends PostState {
  final Post post;
  final List<Comment> comments;
  final User user;

  PostLoaded({required this.post, required this.comments, required this.user});
  @override
  List<Object?> get props => [post, comments, user];
}

class PostLoadingFailure extends PostState {
  final Object? error;

  PostLoadingFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
