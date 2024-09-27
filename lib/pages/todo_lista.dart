import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_1/models/tarefa.dart';
import 'package:lista_de_tarefas_1/repo/tarefas_repo.dart';
import 'package:lista_de_tarefas_1/widgets/tarefa_com_item.dart';

class TodoLista extends StatefulWidget {
  const TodoLista({super.key});

  @override
  State<TodoLista> createState() => _TodoListaState();
}

class _TodoListaState extends State<TodoLista> {
  final TextEditingController todocontroller = TextEditingController();
  final TarefasRepo tarefasRepo = TarefasRepo();

  List<Tarefa1> tarefas = [];
  Tarefa1? tarefaDeletada;
  int? posTarefaDeletada;
  String? errorText;

  @override
  void initState() {
    super.initState();

    tarefasRepo.pegarLista().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: todocontroller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Exemplo: Estudar geografia',
                        errorText: errorText, // Passa errorText corretamente
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String text = todocontroller.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText =
                              "A tarefa não pode ser vazia"; // Define a mensagem de erro
                        });
                        return;
                      }

                      setState(() {
                        errorText =
                            null; // Limpa a mensagem de erro se não houver erro
                        Tarefa1 novaTarefa =
                            Tarefa1(title: text, dateTime: DateTime.now());
                        tarefas.add(novaTarefa);
                      });

                      todocontroller.clear();
                      tarefasRepo.salvarTarefasMemoria(tarefas);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    return TarefaComItem(
                      tarefa: tarefas[index],
                      deletarTarefa: deletarTarefa,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${tarefas.length} tarefas pendentes',
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: querMesmoDeletarTudo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Limpar tudo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deletarTarefa(Tarefa1 tarefa) {
    tarefaDeletada = tarefa;
    posTarefaDeletada = tarefas.indexOf(tarefa);

    tarefasRepo.salvarTarefasMemoria(tarefas);

    setState(() {
      tarefas.remove(tarefa);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa '${tarefa.title}' foi removida com sucesso!",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.purple,
          onPressed: () {
            setState(() {
              tarefas.insert(posTarefaDeletada!, tarefaDeletada!);
            });
            tarefasRepo.salvarTarefasMemoria(tarefas);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // aviso para deletar todas as terefas, mais complexo que só um clear
  void querMesmoDeletarTudo() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Limpar tudo?"),
              content: const Text("Você tem certeza que quer fazer isso?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deletarTodasAsTarefas();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                  child: const Text("Limpar tudo"),
                )
              ],
            ));
  }

  void deletarTodasAsTarefas() {
    setState(() {
      tarefas.clear();
    });
    tarefasRepo.salvarTarefasMemoria(tarefas);
  }
}

// aula 104 - Programação Assincrona e continuação de dados no dart. 
