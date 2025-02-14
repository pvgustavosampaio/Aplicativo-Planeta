//Criação do Banco de dados

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/class_planet.dart';

class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String arquivo) async {
    final caminho = join(await getDatabasesPath(), arquivo);
    return await openDatabase(
      caminho,
      version: 2,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE planetas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          tamanho REAL NOT NULL,
          distancia REAL NOT NULL,
          apelido TEXT,
          descricao TEXT
        )
      '''),
    );
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    return (await db.query('planetas')).map((e) => Planeta.fromMap(e)).toList();
  }

  Future<int> inserirPlaneta(Planeta p) => bd.then((db) => db.insert('planetas', p.toMap()));
  
  Future<int> alterarPlaneta(Planeta p) => bd.then((db) => 
    db.update('planetas', p.toMap(), where: 'id = ?', whereArgs: [p.id]));
  
  Future<int> excluirPlaneta(int id) => bd.then((db) => 
    db.delete('planetas', where: 'id = ?', whereArgs: [id]));
}