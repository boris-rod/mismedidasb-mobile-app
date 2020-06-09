class RewardModel {
  int id;
  int userId;
  String message;
  int points;
  int rewardCategoryId;
  int categoryId;
  int category;

  RewardModel(
      {this.id,
      this.userId,
      this.message = "",
      this.points = 0,
      this.rewardCategoryId,
      this.categoryId,
      this.category});
}
