class HealthMeasureResultModel {
  int age;
  int weight;
  int height;
  int sex;

  int physicalExercise;
  String physicalExerciseValue;

  List<int> diet;
  List<String> dietValue;

  String result;

  HealthMeasureResultModel(
      {this.age,
      this.weight,
      this.height,
      this.sex,
      this.physicalExercise,
      this.diet,
      this.physicalExerciseValue,
      this.dietValue,
      this.result});
}
