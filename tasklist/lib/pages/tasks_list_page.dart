import 'package:flutter/material.dart';
import 'package:tasklist/models/task.dart';
import 'package:tasklist/repositories/tasks_repository.dart';
import 'package:tasklist/widgets/tasks_list_item.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({Key? key}) : super(key: key);

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final TextEditingController taskController = TextEditingController();
  final TasksRepository tasksRepository = TasksRepository();
  String? errorText;

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskPosition;

  @override
  void initState() {
    super.initState();

    tasksRepository.getTasksList().then((value) => {
          setState(() {
            tasks = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Adicione uma tarefa',
                      errorText: errorText,
                      hintText: 'Ex: Estudar',
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                          width: 2,
                        ),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () {
                      String text = taskController.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText = "O texto não pode ser vazio";
                        });
                        return;
                      }

                      setState(() {
                        Task newTask =
                            Task(title: text, dateTime: DateTime.now());
                        tasks.add(newTask);
                        errorText = null;
                      });
                      taskController.clear();
                      tasksRepository.saveTasksList(tasks);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Icon(Icons.add, size: 30))
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (Task task in tasks)
                    TasksListItem(task: task, onDelete: onDelete),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text('Você possui ${tasks.length} tarefas pendentes'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: showClearAllModal,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('Limpar tudo'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = task;
    deletedTaskPosition = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${task.title} foi removida com sucesso'),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.purple,
        onPressed: () {
          setState(() {
            tasks.insert(deletedTaskPosition!, deletedTask!);
          });
          tasksRepository.saveTasksList(tasks);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showClearAllModal() {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Confirma exclusão de todas as tasks?"),
            content: const Text('Caso confirme, não será possível recuperar.'),
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.pop(context),
                      },
                  style: TextButton.styleFrom(primary: Colors.black),
                  child: const Text('Voltar')),
              TextButton(
                  onPressed: () => {
                        handleDeleteTasks(),
                        Navigator.pop(context),
                        tasksRepository.saveTasksList(tasks),
                      },
                  style: TextButton.styleFrom(primary: Colors.purple),
                  child: const Text('Excluir todos')),
            ],
          )),
    );
  }

  void handleDeleteTasks() {
    setState(() {
      tasks.clear();
      tasksRepository.saveTasksList(tasks);
    });
  }
}
