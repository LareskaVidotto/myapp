import 'package:flutter/material.dart';

// Importando classes para controle de dados, modelos e telas.
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';
import 'telas/tela_planeta.dart';

void main() {
  // Ponto de entrada da aplicação, inicia o aplicativo Flutter.
  runApp(const MyApp());
}

// Widget principal da aplicação, define o ponto de entrada e a configuração geral do aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp define a estrutura da aplicação e suas propriedades.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Desabilita a faixa de debug no canto superior direito.
      title: 'Planetas', // Define o título do aplicativo.
      theme: ThemeData(
        // Define o tema do aplicativo com base em um seed color e Material 3.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Aplicativo - Planeta', // Define a tela inicial do aplicativo.
      ),
    );
  }
}

/// Widget com estado que representa a tela principal do aplicativo.
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title, // O título da tela principal.
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // Cria o estado para o widget.
}

/// Estado do widget MyHomePage, responsável pelo gerenciamento do estado da tela principal.
class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Instância do controlador de planetas.
  List<Planeta> _planetas = []; // Lista que armazena os planetas exibidos na tela.

  @override
  void initState() {
    // Método chamado quando o widget é inserido na árvore de widgets.
    super.initState();
    _atualizarPlanetas(); // Atualiza a lista de planetas ao iniciar a tela.
  }

  /// Atualiza a lista de planetas, buscando-os através do controlador.
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas(); // Busca a lista de planetas.
    setState(() {
      // Atualiza o estado do widget com os planetas obtidos.
      _planetas = resultado;
    });
  }

  /// Navega para a tela de inclusão de um novo planeta.
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true, // Indica que é uma inclusão.
          planeta: Planeta.vazio(), // Cria um planeta vazio para inclusão.
          onFinalizado: () {
            // Função chamada após a inclusão.
            _atualizarPlanetas(); // Atualiza a lista de planetas após a inclusão.
          },
        ),
      ),
    );
  }

  /// Navega para a tela de alteração de um planeta existente.
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false, // Indica que é uma alteração.
          planeta: planeta, // Passa o planeta a ser alterado.
          onFinalizado: () {
            // Função chamada após a alteração.
            _atualizarPlanetas(); // Atualiza a lista de planetas após a alteração.
          },
        ),
      ),
    );
  }

  /// Exclui um planeta com base em seu ID e atualiza a lista.
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id); // Exclui o planeta pelo ID.
    _atualizarPlanetas(); // Atualiza a lista de planetas após a exclusão.
  }

  @override
  Widget build(BuildContext context) {
    // Constrói a interface do usuário do widget.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Exibe o título na barra do aplicativo.
      ),
      body: ListView.builder(
        // Lista os planetas em uma lista rolavel.
        itemCount: _planetas.length, // Quantidade de planetas a serem listados.
        itemBuilder: (context, index) {
          final planeta = _planetas[index]; // Obtém o planeta atual.
          return ListTile(
              // Item da lista que exibe os dados do planeta.
              title: Text(planeta.nome), // Exibe o nome do planeta.
              subtitle: Text(planeta.apelido ??
                  ''), // Exibe o apelido do planeta, caso exista.
              trailing: Row(
                // Linha que contém os botões de edição e exclusão.
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    // Botão para editar o planeta.
                    icon: const Icon(Icons.edit),
                    onPressed: () => _alterarPlaneta(context, planeta),
                  ),
                  IconButton(
                    // Botão para excluir o planeta.
                    icon: const Icon(Icons.delete),
                    onPressed: () => _excluirPlaneta(planeta.id!),
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Botão para adicionar um novo planeta.
        onPressed: () {
          _incluirPlaneta(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}