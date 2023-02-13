import 'package:chatgpt/data/methods.dart';
import 'package:chatgpt/model/base_model.dart.dart';

class ModelsModel  extends BaseModel {
  ModelsModel (super.data);

  String get id => Methods.getString(data, 'id');
  int get created => Methods.getInt(data, 'created');
  String get root => Methods.getString(data, 'root');
}
