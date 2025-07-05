import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/class.dart';
import '../../pages/class/class_create_page.dart';
import '../../pages/class/class_edit_page.dart';
import '../../pages/class/class_page.dart';
import '../../repositories/class_repository.dart';
import '../../utils/shared_preference_service.dart';

class ClassListWidget extends StatefulWidget {
  const ClassListWidget({super.key});

  @override
  State<ClassListWidget> createState() => _ClassListWidgetState();
}

class _ClassListWidgetState extends State<ClassListWidget> {
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    user_id = await SharedPreferenceService.getUserId() ?? 1001;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ClassRepository>(
        context,
        listen: false,
      ).fetchTeacherClassList(user_id),
    );
  }

  Future<void> buildDialog(
    BuildContext context,
    ClassRepository classRepository,
    Class classObject,
  ) async {
    return await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: const Text('This class will be deleted forever'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async => deleteClass(classRepository, classObject, context),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.red.shade900,
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteClass(
    ClassRepository classRepository,
    Class classObject,
    BuildContext context,
  ) async {
    await classRepository.deleteClass(classObject.id);

    if (context.mounted) {
      if (classRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Class deleted successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(classRepository.errorMessageSnackBar),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ClassCreatePage(),
                ),
              ),
              child: const Text('Create class'),
            ),
          ),
          const SizedBox(height: 16.0),
          Consumer<ClassRepository>(
            builder: (context, classRepository, child) {
              List<Class> classList = classRepository.classList;

              if (classRepository.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (classRepository.errorMessage.isNotEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          classRepository.errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        OutlinedButton.icon(
                          onPressed: () async =>
                              await classRepository.fetchTeacherClassList(user_id),
                          icon: const Icon(Icons.refresh_outlined),
                          label: const Text(
                            'Retry',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (classList.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "You haven't added any classes yet",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await classRepository.fetchTeacherClassList(user_id),
                  child: ListView.builder(
                    itemCount: classList.length,
                    itemBuilder: (context, index) {
                      Class classObject = classList[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => ClassPage(classObject: classObject),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: const CircleAvatar(
                            child: Icon(Icons.class_outlined),
                          ),
                          title: Text(
                            classObject.class_name ?? '',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Text(classObject.code ?? ''),
                          trailing: MenuAnchor(
                            builder: (context, controller, child) => IconButton(
                              onPressed: () =>
                                  controller.isOpen ? controller.close() : controller.open(),
                              icon: const Icon(Icons.more_vert_rounded),
                            ),
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => ClassEditPage(
                                      classObject: classObject,
                                    ),
                                  ),
                                ),
                                child: const Text('Edit'),
                              ),
                              MenuItemButton(
                                onPressed: () async =>
                                    buildDialog(context, classRepository, classObject),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
