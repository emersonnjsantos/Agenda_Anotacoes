// ignore_for_file: file_names

import 'package:agenda_anotacoes/helper/anotacao.dart';
import 'package:agenda_anotacoes/model/anotacao.dart';
import 'package:flutter/material.dart';
import 'dart:developer';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();

  _exibirTelaCadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Título",
                  hintText: "Digite título...",
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite descrição...",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _salvarAnotacao();
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

}

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    // Criação da anotação corrigida
    Anotacao anotacao = Anotacao(null, titulo, descricao, DateTime.now().toString());

    _tituloController.clear();
    _descricaoController.clear();

    // Salvar no banco
    _db.salvarAnotacao(anotacao).then((id) {
      log("Anotação salva com ID: $id");
    }).catchError((error) {
      log("Erro ao salvar anotação: $error");
    });

    _tituloController.clear();
    _descricaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda de Anotações"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Corpo da Agenda'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.blueGrey,
        child: const Icon(Icons.account_box_sharp),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
