enum PERSONAL_DATA_FIELD_TYPE { STRING, INT, DOUBLE, DATE, BOOLEAN }

class PersonalDataModel {
  int id;
  String name;
  String measureUnit;
  String codeName;
  int order;
  String type;
  int typeId;
  String value;

  PersonalDataModel(
      {this.id,
      this.name,
      this.measureUnit,
      this.codeName,
      this.order,
      this.type,
      this.typeId,
      this.value});

  static List<PersonalDataModel> getPersonalDataList() {
    List<PersonalDataModel> list = [];
    PersonalDataModel age = PersonalDataModel(
        id: 1,
        name: "Edad",
        measureUnit: "Years",
        codeName: "AGE",
        order: 1,
        type: "INT",
        typeId: 1);

    PersonalDataModel weight = PersonalDataModel(
        id: 1,
        name: "Peso",
        measureUnit: "Kg",
        codeName: "WEIGHT",
        order: 2,
        type: "DOUBLE",
        typeId: 2);

    PersonalDataModel height = PersonalDataModel(
        id: 1,
        name: "Talla",
        measureUnit: "cm",
        codeName: "HEIGHT",
        order: 3,
        type: "INT",
        typeId: 1);

    PersonalDataModel sex = PersonalDataModel(
        id: 1,
        name: "Sexo",
        measureUnit: "u",
        codeName: "SEX",
        order: 4,
        type: "STRING",
        typeId: 0);

    list.add(age);
    list.add(weight);
    list.add(height);
    list.add(sex);
    return list;
  }
}

class UserPersonalDataModel{
  int id;
  String codeName;
}
