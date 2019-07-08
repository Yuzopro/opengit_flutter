class LoadingBean<T> {
  bool isLoading;
  T data;

  LoadingBean({this.isLoading, this.data});

  @override
  String toString() {
    return 'LoadingBean{isLoading: $isLoading, data: $data}';
  }
}
