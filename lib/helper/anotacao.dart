import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/anotacao.dart';

class AnotacaoHelper {
  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  late Database _db; // Ajustado para usar 'late'

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(); // Corrigido para usar '_internal' no construtor

  Future<Database> get db async { // Tornado assíncrono para compatibilidade
    if (_db != null) {
      return _db;
    } else {
      _db = await _inicializarDB();
      return _db;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Corrigido SQL para adicionar a cláusula 'INTEGER' no ID
    String sql = """
      CREATE TABLE $nomeTabela(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo VARCHAR,
        descricao TEXT,
        data DATETIME
      )
    """;
    await db.execute(sql);
  }

  Future<Database> _inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_anotacoes.db");

    var db = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return resultado;
  }
  recuperarAnotacoes() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC ";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }
}
