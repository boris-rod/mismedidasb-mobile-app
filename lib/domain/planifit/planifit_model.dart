class BleDevice {
  String name;
  String address;
  int rssi;

  BleDevice({this.name, this.address, this.rssi});

  factory BleDevice.fromJson(Map<dynamic, dynamic> json) {
    return BleDevice(
      name: json['device_name'],
      address: json['device_address'],
      rssi: json['device_rssi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'device_name': name, 'device_address': address, 'rssi': rssi};
  }
}

class StepOneDayAllInfo {
  String calendar;
  int steps;
  double distance;
  double calories;
  int runSteps;
  double runCalories;
  double runDistance;
  int runDurationTime;
  int walkSteps;
  double walkCalories;
  double walkDistance;
  int walkDurationTime;

  StepOneDayAllInfo(
      {this.calendar,
      this.steps,
      this.distance,
      this.calories,
      this.runSteps,
      this.runCalories,
      this.runDistance,
      this.runDurationTime,
      this.walkSteps,
      this.walkCalories,
      this.walkDistance,
      this.walkDurationTime});

  factory StepOneDayAllInfo.fromJson(Map<dynamic, dynamic> json) {
    return StepOneDayAllInfo(
        calendar: json['calendar'],
        steps: json['step'],
        distance: json['distance'],
        calories: json['calories'],
        runSteps: json['run_steps'],
        runCalories: json["run_calories"],
        runDistance: json["run_distance"],
        runDurationTime: json["run_duration_time"],
        walkSteps: json["walk_steps"],
        walkCalories: json["walk_calories"],
        walkDistance: json["walk_distance"],
        walkDurationTime: json["walk_duration_time"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'calendar': calendar,
      'step': steps,
      'distance': distance,
      'calories': calories,
      'run_steps': runSteps,
      'run_calories': runCalories,
      'run_distance': runDistance,
      'run_duration_time': runDurationTime,
      'walk_steps': walkSteps,
      'walk_calories': walkCalories,
      'walk_distance': walkDistance,
      'walk_duration_time': walkDurationTime
    };
  }
}

class Rate {
  int tempRate;
  int tempStatus;

  Rate({this.tempRate, this.tempStatus});

  factory Rate.fromJson(Map<dynamic, dynamic> json) {
    return Rate(
      tempRate: json['temp_rate'],
      tempStatus: json['temp_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'temp_rate': tempRate, 'temp_status': tempStatus};
  }
}

class Rate24 {
  int maxHeartRateValue;
  int minHeartRateValue;
  int averageHeartRateValue;
  bool isRealTimeValue;

  Rate24(
      {this.maxHeartRateValue,
      this.minHeartRateValue,
      this.averageHeartRateValue,
      this.isRealTimeValue});

  factory Rate24.fromJson(Map<dynamic, dynamic> json) {
    return Rate24(
      maxHeartRateValue: json['max_heart_rate_value'],
      minHeartRateValue: json['min_heart_rate_value'],
      averageHeartRateValue: json['average_heart_rate_value'],
      isRealTimeValue: json['is_real_time_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_heart_rate_value': maxHeartRateValue,
      'min_heart_rate_value': minHeartRateValue,
      'average_heart_rate_value': averageHeartRateValue,
      'is_real_time_value': isRealTimeValue
    };
  }
}

class BloodPressure {
  int tempBloodPressureStatus;
  int highPressure;
  int lowPressure;

  BloodPressure(
      {this.tempBloodPressureStatus, this.highPressure, this.lowPressure});

  factory BloodPressure.fromJson(Map<dynamic, dynamic> json) {
    return BloodPressure(
        tempBloodPressureStatus: json['temp_blood_pressure_status'],
        highPressure: json['high_pressure'],
        lowPressure: json['low_pressure']);
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_blood_pressure_status': tempBloodPressureStatus,
      'high_pressure': highPressure,
      'lowPressure': lowPressure
    };
  }
}
