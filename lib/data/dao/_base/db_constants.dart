class DBConstants {
  static final String db_name = 'mismedidas';
  static final int db_version = 7;

  ///Common table schema
  static final Map<String, String> table_cols = {
    DBConstants.id_key: DBConstants.text_type,
    DBConstants.data_key: DBConstants.text_type,
    DBConstants.parent_key: DBConstants.text_type,
  };

  static final Map<String, String> table_offline_cols = {
    DBConstants.id_key: DBConstants.text_type,
    DBConstants.data_key: DBConstants.text_type,
    DBConstants.parent_key: DBConstants.text_type,
  };

  ///columns names
  static final String id_key = 'id';
  static final String data_key = 'data';
  static final String parent_key = 'parent_id';

  ///columns types
  static final String text_type = 'TEXT';
  static final String real_type = 'REAL';
  static final String int_type = 'INTEGER';

  ///table names
  static final String daily_food_activity_table = 'daily_food_activity_table';
  static final String food_table = 'food_table';
  static final String food_tag_table = 'food_tag_table';
//  static final String measure_health_table = 'measure_health_table';
//  static final String health_result_table = 'health_result_table';
}
