import 'package:chatgpt/model/models_model.dart';
import 'package:chatgpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowBottomSheetModel extends StatelessWidget {
  const ShowBottomSheetModel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatViewController>(context);

    List<ModelsModel> listModels = controller.modelsList;
    return listModels.isEmpty
        ? FutureBuilder(
            future: controller.loadAllModels(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                controller.modelsList = snapshot.data as List<ModelsModel>;
                return popupMenu(controller);
              }
              return const Text('Error');
            },
          )
        : popupMenu(controller);
  }

  Widget popupMenu(ChatViewController controller) {
    return PopupMenuButton<ModelsModel>(
        initialValue: controller.currentModel,
        itemBuilder: (context) {
          return controller.modelsList
              .map<PopupMenuItem<ModelsModel>>(
                  (e) => PopupMenuItem<ModelsModel>(
                      onTap: () {
                        controller.currentModel = e;
                      },
                      child: Row(
                        children: [
                          if (e == controller.currentModel)
                            const Icon(Icons.check, color: Colors.green),
                          Text(
                            e.id,
                            style: TextStyle(
                                color: e == controller.currentModel
                                    ? Colors.green
                                    : null),
                          ),
                        ],
                      )))
              .toList();
        });
  }
}
