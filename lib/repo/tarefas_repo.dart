import 'dart:convert';
import 'package:lista_de_tarefas_1/models/tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = "todo_list";

class TarefasRepo {
  late SharedPreferences sharedPreferences;

  // Método para pegar a lista de tarefas da memória
  Future<List<Tarefa1>> pegarLista() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List<dynamic> jsonDecoded = json.decode(jsonString) as List;

    // Convertendo a lista JSON em uma lista de objetos Tarefa1
    return jsonDecoded.map((e) => Tarefa1.fromJson(e)).toList();
  }

  // Método para salvar a lista de tarefas na memória
  void salvarTarefasMemoria(List<Tarefa1> tarefas) {
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
