

abstract class FoodProductEvent  {
  // @override
  // List<Object> get props => [];
}

class FoodProductEventFetched extends FoodProductEvent {
  final String  categoryId;
  FoodProductEventFetched(this.categoryId);
}
