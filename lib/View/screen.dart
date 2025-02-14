//importando as bibliotecas necessárias
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controls/controll_planet.dart';
import '../models/class_planet.dart';

//Classe da tela de criação de planetas
class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final VoidCallback onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

//Classe que cria o estado da tela de criação de planetas
//Adicionando os campos e validações
class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final _controle = ControlePlaneta();
  late Planeta _planeta;

  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _tamanhoCtrl = TextEditingController();
  final TextEditingController _distanciaCtrl = TextEditingController();
  final TextEditingController _apelidoCtrl = TextEditingController();
  final TextEditingController _descricaoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _planeta = widget.planeta;
    _nomeCtrl.text = _planeta.nome;
    _tamanhoCtrl.text = _planeta.tamanho.toString();
    _distanciaCtrl.text = _planeta.distancia.toString();
    _apelidoCtrl.text = _planeta.apelido ?? '';
    _descricaoCtrl.text = _planeta.descricao ?? '';
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _tamanhoCtrl.dispose();
    _distanciaCtrl.dispose();
    _apelidoCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      widget.isIncluir 
          ? await _controle.inserirPlaneta(_planeta)
          : await _controle.alterarPlaneta(_planeta);
      
      widget.onFinalizado();
      Navigator.pop(context);
    }
  }

//Criação do layout definindo os campos e validações em conjunto
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Planeta'),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _campoTexto(_nomeCtrl, 'Nome', validar: _validarNome),
                _campoNumerico(_tamanhoCtrl, 'Tamanho (km)'),
                _campoNumerico(_distanciaCtrl, 'Distância (km)'),
                _campoTexto(_apelidoCtrl, 'Apelido (opcional)'),
                _campoTexto(_descricaoCtrl, 'Descrição (opcional)', linhas: 5),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _botao('Cancelar', () => Navigator.pop(context)),
                    _botao('Salvar', _salvar),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//Funções para criar os campos e validações dos campos de texto e 
//numeros

//Na função campo numerico esta sendo adicionado as validações e 
//tambem o teclado de apenas numeros.
  Widget _campoNumerico(TextEditingController ctrl, String label) {
  return _campoTexto(
    ctrl,
    label,
    linhas: 1,
    validar: (v) {
      if (v == null || v.isEmpty) return 'Campo obrigatório';
      if (double.tryParse(v.replaceAll(',', '.')) == null) {
        return 'Apenas números são permitidos';
      }
      return null;
    },
    onSaved: (v) {
      final valor = double.tryParse(v!.replaceAll(',', '.')) ?? 0.0;
      if (ctrl == _tamanhoCtrl) _planeta.tamanho = valor;
      if (ctrl == _distanciaCtrl) _planeta.distancia = valor;
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    ],
  );
}

//Na função campo texto esta sendo adicionado as validações e 
//tambem o teclado normal com letras.
Widget _campoTexto(
  TextEditingController ctrl,
  String label, {
  int linhas = 1,
  String? Function(String?)? validar,
  Function(String?)? onSaved,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    color: Colors.black.withOpacity(0.7),
    elevation: 5,
    shadowColor: const Color.fromRGBO(68, 138, 255, 0.3),
    child: TextFormField(
      controller: ctrl,
      maxLines: linhas,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(12),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters ?? [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ ]')),
      ],
      validator: validar,
      onSaved: (v) {
        if (onSaved != null) {
          onSaved(v);
        } else {
          if (ctrl == _nomeCtrl) _planeta.nome = v!;
          if (ctrl == _apelidoCtrl) _planeta.apelido = v;
          if (ctrl == _descricaoCtrl) _planeta.descricao = v;
        }
      },
    ),
  );
}


//Definindo os botões de salvar e cancelar
  Widget _botao(String texto, VoidCallback acao) {
    return Card(
      elevation: 8,
      shadowColor: const Color.fromRGBO(147, 112, 219, 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: acao,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(texto, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

//Validando os campos de texto
  String? _validarNome(String? v) {
    if (v == null || v.isEmpty) return 'Nome é obrigatório';
    if (v.length < 3) return 'Mínimo 3 caracteres';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ ]+$').hasMatch(v)) {
      return 'Apenas letras são permitidas';
    }
    return null;
  }
}


  