import 'package:flutter/material.dart';
import 'controls/controll_planet.dart';
import 'models/class_planet.dart';
import 'View/screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ControlePlaneta _controle = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _carregarPlanetas();
  }

  Future<void> _carregarPlanetas() async {
    _planetas = await _controle.lerPlanetas();
    setState(() {});
  }

  void _abrirDetalhes(Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhes(planeta: planeta),
      ),
    );
  }

  void _excluirPlaneta(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Confirmar Exclusão', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Você excluirá esse arquivo permanentemente!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await _controle.excluirPlaneta(id);
              _carregarPlanetas();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Planetas'),
        actions: const [
          Icon(Icons.refresh),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/space_bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),
          ListView.builder(
            itemCount: _planetas.length,
            itemBuilder: (context, index) {
              final planeta = _planetas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  color: Colors.black,
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  shadowColor: const Color.fromRGBO(147, 112, 219, 0.5),
                  child: ListTile(
                    title: Text(planeta.nome),
                    subtitle: planeta.apelido?.isNotEmpty == true 
                        ? Text('Apelido: ${planeta.apelido}') 
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _abrirEdicao(context, planeta),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluirPlaneta(planeta.id!),
                        ),
                      ],
                    ),
                    onTap: () => _abrirDetalhes(planeta),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _abrirEdicao(context, Planeta.vazio()),
      ),
    );
  }

  void _abrirEdicao(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: planeta.id == null,
          planeta: planeta,
          onFinalizado: _carregarPlanetas,
        ),
      ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key, required this.planeta});
  final Planeta planeta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planeta.nome),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/space_bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.black.withOpacity(0.8),
            elevation: 10,
            shadowColor: const Color.fromRGBO(68, 138, 255, 0.3),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conteúdo dos detalhes
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}