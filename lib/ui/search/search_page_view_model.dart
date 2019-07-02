typedef OnQuery = void Function(String file);

abstract class SearchPageViewModel {
  OnQuery onFetch;

  SearchPageViewModel(this.onFetch);
}