import 'package:chatgpt/model/models_model.dart';
import 'package:chatgpt/view/setting_page/controller/setting_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends ModalRoute {
  @override
  Color? get barrierColor => Colors.black.withOpacity(0.6);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    List<Widget> list = _listWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            return list[index];
          }),
    );
  }

  List<Widget> _listWidget(BuildContext context) {
    final controller = Provider.of<SettingPageController>(context);
    return [
      dropdownItem<ModelsModel>(
          label: 'Chọn model:',
          onChanged: (p0) {
            if (p0 != null) {
              controller.currentModel = p0;
            }
          },
          list: controller.listModelsModel,
          value: controller.currentModel,
          child: (v) {
            return Text(v.id);
          }),
      dropdownItem<String>(
          label: 'Chọn ngôn ngữ audio:',
          list: controller.listLanguageVoice,
          value: controller.currentLanguageVoice,
          onChanged: ((p0) {
            if (p0 != null) {
              controller.currentLanguageVoice = p0;
            }
          }),
          child: (v) {
            return Text(v);
          }),
    ];
  }

  Widget dropdownItem<T>(
      {required String label,
      required List<T> list,
      required T value,
      required void Function(T?)? onChanged,
      required Widget Function(T model) child}) {
    return _rowItem(
        text: label,
        widget: DropdownButton<T>(
          items: list.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: child(value),
            );
          }).toList(),
          onChanged: onChanged,
          elevation: 3,
          icon: const Icon(Icons.arrow_drop_down),
          value: value,
        ));
  }

  Widget _rowItem({required String text, required Widget widget}) {
    return Row(
      children: [Expanded(child: Text(text)), const SizedBox(width: 8), widget],
    );
  }
}
