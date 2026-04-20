class RequestState<T> {
  final T? data;
  final String? message;
  final String? error;
  final bool isLoading;

  RequestState({this.data, this.message, this.error, this.isLoading = false});

  factory RequestState.idle() {
    return RequestState();
  }

  factory RequestState.loading() {
    return RequestState(isLoading: true);
  }

  factory RequestState.data(T? data, {String? message}) {
    return RequestState(data: data, message: message);
  }

  factory RequestState.error(String? error) {
    return RequestState(error: error);
  }
}
