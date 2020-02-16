class HabitModel{
  int id;
  String title;
  List<String> subtitle;

  HabitModel({this.id, this.title, this.subtitle});

  static List<HabitModel> getHabits(){
    return [
      HabitModel(id: 1, title: "Planifique 5 comidas por dia", subtitle: ["Desayuno/Merienda/Comida/Merienda/Cena."]),
      HabitModel(id: 2, title: "2. Distribuya su consumo calórico diario:", subtitle: ["50-60% Hidratos de Carbono.", "30-35% Grasas.", "10-15% Proteínas."]),
      HabitModel(id: 3, title: "3. Ingiera furtas y vegetales a diario:", subtitle: ["Ej. naranja, fresas, lechuga o tomate."]),
      HabitModel(id: 4, title: "4. Comea despacio y mastique bien los alimentos:", subtitle: ["Evite ver Tv o revisar el móvil mientras come."]),
      HabitModel(id: 5, title: "5. Beba alrededor de 2 litros de agua durante el día:", subtitle: ["Evitar bebidas azucaradas y bebidas energéticas."]),
      HabitModel(id: 6, title: "6. Fomente la Actividad Física diaria:", subtitle: ["Ej. caminar, subir escaleras o pasear en bici."]),
      HabitModel(id: 7, title: "7. Realice Ejercicio Físico regularmente:", subtitle: ["Ej. 3 veces por semana (30-45 minutos por sesión)."]),
      HabitModel(id: 8, title: "8. Reduzca el consumo de alcohol:", subtitle: ["No beba a diario, debe haber días de abstinencia.", "Máximo una o dos copas de vino o botellines de cerveza."]),
      HabitModel(id: 9, title: "9. Establezca límites para el uso del teléfono movil:", subtitle: ["Puede perder alrededor de 4 horas de su día.", "Pase más tiempo conectado con la familia o amigos."]),
      HabitModel(id: 9, title: "10. Fomente un ocio saludable:", subtitle: ["Pasee al aire libre con su familia o amigos."]),
    ];
  }
}