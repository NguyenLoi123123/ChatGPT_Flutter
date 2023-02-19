import 'package:chatgpt/data/methods.dart';
import 'package:chatgpt/model/base_model.dart.dart';

class LanguageVoiceModel extends BaseModel {
  LanguageVoiceModel(super.data);

  String get name => Methods.getString(data, 'name');
  String get locale => Methods.getString(data, 'locale');
  String get displayName => Methods.getString(data, 'displayName');
}
