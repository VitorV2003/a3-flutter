import 'package:flutter/material.dart';

void main() {
  runApp(const ProdutosColoniaisApp());
}

class ProdutosColoniaisApp extends StatelessWidget {
  const ProdutosColoniaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.yellow[700],
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
          ),
        ),
      ),
      home: const ProdutosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage>
    with SingleTickerProviderStateMixin {
  final Map<String, int> _quantidade = {};
  final Map<String, String> _imagens = {};
  final Map<String, double> _precos = {};
  double _total = 0.0;

  String _selectedPaymentMethod = 'Crédito';
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  void _adicionarCarrinho(String titulo, double preco, String imagem) {
    setState(() {
      if (_quantidade.containsKey(titulo)) {
        _quantidade[titulo] = (_quantidade[titulo] ?? 0) + 1;
      } else {
        _quantidade[titulo] = 1;
        _imagens[titulo] = imagem;
        _precos[titulo] = preco;
      }
      _total += preco;
    });
  }

  void _removerCarrinho(String titulo, double preco) {
    setState(() {
      if (_quantidade.containsKey(titulo) && _quantidade[titulo]! > 0) {
        _quantidade[titulo] = (_quantidade[titulo] ?? 0) - 1;
        _total -= preco;

        if (_quantidade[titulo] == 0) {
          _quantidade.remove(titulo);
          _imagens.remove(titulo);
          _precos.remove(titulo);
        }
      }
    });
  }

  void _removerProduto(String titulo) {
    setState(() {
      double precoProduto = _precos[titulo] ?? 0.0;
      int quantidadeProduto = _quantidade[titulo] ?? 0;

      _total -= (precoProduto * quantidadeProduto);
      _quantidade.remove(titulo);
      _imagens.remove(titulo);
      _precos.remove(titulo);
    });
  }

  void _mostrarPedido() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meu pedido'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ..._quantidade.keys.map((String key) {
                  return ListTile(
                    leading: Image.asset(_imagens[key]!),
                    title: Text(key),
                    subtitle: Text('Quantidade: ${_quantidade[key]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removerProduto(key);
                        Navigator.of(context).pop();
                        _mostrarPedido(); // Reabre o diálogo
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                _metodoPagamentoWidget(),
                const SizedBox(height: 16),
                _enderecoEntregaWidget(),
              ],
            ),
          ),
          actions: [
            Text(
              'Total: R\$ ${_total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: _finalizarPedido,
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Cor do texto para branco
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _finalizarPedido() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pedido Realizado com Sucesso'),
          content: const Text(
            'Seu pedido foi realizado com sucesso!\n'
            '\nOs dados da entrega chegarão no seu zap.',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _limparCarrinho();
              },
            ),
          ],
        );
      },
    );
  }

  void _limparCarrinho() {
    setState(() {
      _quantidade.clear();
      _imagens.clear();
      _precos.clear();
      _total = 0.0;
    });
  }

  Widget _metodoPagamentoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Método de Pagamento',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
          children: [
            ListTile(
              title: const Text('PIX'),
              leading: const Icon(Icons.qr_code),
              trailing: Radio<String>(
                value: 'PIX',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                  Navigator.of(context).pop(); // Fecha o diálogo atual
                  _mostrarPedido(); // Abre novamente para atualizar
                },
              ),
            ),
            ListTile(
              title: const Text('Crédito'),
              leading: const Icon(Icons.credit_card),
              trailing: Radio<String>(
                value: 'Crédito',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                  Navigator.of(context).pop(); // Fecha o diálogo atual
                  _mostrarPedido(); // Abre novamente para atualizar
                },
              ),
            ),
            ListTile(
              title: const Text('Débito ou Dinheiro'),
              leading: const Icon(Icons.attach_money),
              trailing: Radio<String>(
                value: 'Débito ou Dinheiro',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                  Navigator.of(context).pop(); // Fecha o diálogo atual
                  _mostrarPedido(); // Abre novamente para atualizar
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Método selecionado: $_selectedPaymentMethod',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _enderecoEntregaWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Endereço de Entrega',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _ruaController,
          decoration: const InputDecoration(labelText: 'Rua'),
        ),
        TextField(
          controller: _bairroController,
          decoration: const InputDecoration(labelText: 'Bairro'),
        ),
        TextField(
          controller: _numeroController,
          decoration: const InputDecoration(labelText: 'Número'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('imagens/logo_site.png', width: 50, height: 50),
        title: const Text('Produtos Coloniais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _mostrarPedido,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Carnes'),
              Tab(text: 'Queijos'),
              Tab(text: 'Linguiças'),
              Tab(text: 'Vinhos'),
              Tab(text: 'Embutidos e Defumados'),
              Tab(text: 'Manteigas e Cremes'),
              Tab(text: 'Cachaça'),
              Tab(text: 'Conservas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _produtosCategoriaCarnes(),
                _produtosCategoriaQueijos(),
                _produtosCategoriaLinguicas(),
                _produtosCategoriaVinhos(),
                _produtosCategoriaEmbutidoseDefumados(),
                _produtosCategoriaManteigaseCremes(),
                _produtosCategoriaCachaca(),
                _produtosCategoriaConservas(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _produtosCategoriaCarnes() {
    return ListView(
      children: [
        produtoItem(
          'Costela Bovina',
          'Costela macia, ideal para churrasco.',
          'imagens/costela_bovina.jpg',
          75.00,
        ),
        produtoItem(
          'Picanha Premium',
          'Picanha suculenta, perfeita para grelhar.',
          'imagens/picanha_premium.jpg',
          120.00,
        ),
        produtoItem(
          'Filé Mignon Bovino',
          'Corte nobre, macio e suculento. Ideal para grelhar e preparar pratos especiais.',
          'imagens/file_mignon.jpg',
          85.00,
        ),
        produtoItem(
          'Alcatra',
          'Corte versátil e macio, ótimo para grelhar ou preparar no forno.',
          'imagens/alcatra.jpg',
          120.00,
        ),
        produtoItem(
          'Carne Moída',
          'Moída de primeira, ideal para hambúrgueres e pratos do dia a dia.',
          'imagens/carne_moida.jpg',
          120.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaQueijos() {
    return ListView(
      children: [
        produtoItem(
          'Queijo Colonial',
          'Queijo artesanal, maturado, com sabor marcante. Peso: 300g',
          'imagens/queijo_colonial.png',
          40.00,
        ),
        produtoItem(
          'Queijo Coalho',
          'Perfeito para assar na brasa ou grelhar. Sabor levemente salgado. Peso: 400g',
          'imagens/coalho.jpg',
          30.00,
        ),
        produtoItem(
          'Queijo Parmesão',
          'Queijo duro e envelhecido, ótimo para ralar e acompanhar massas. Peso: 500g',
          'imagens/queijoparmesao.jpg',
          55.00,
        ),
        produtoItem(
          'Queijo Gorgonzola',
          'Queijo azul de sabor intenso e textura cremosa. Ideal para molhos. Peso: 300g',
          'imagens/queijogorgongon.jpg',
          45.00,
        ),
        produtoItem(
          'Queijo Minas Frescal',
          'Queijo leve e fresco, ótimo para o café da manhã. Peso: 400g',
          'imagens/minas.jpg',
          25.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaLinguicas() {
    return ListView(
      children: [
        produtoItem(
          'Linguiça Colonial',
          'Linguiça feita com carne suína e temperos especiais. Peso: 500g',
          'imagens/linguica_colonial.png',
          30.00,
        ),
        produtoItem(
          'Linguiça Apimentada',
          'Para quem gosta de um toque picante, feita com pimenta natural. Peso: 500g',
          'imagens/linguica_apimentada.jpg',
          35.00,
        ),
        produtoItem(
          'Linguiça Pernil',
          'Linguiça artesanal feita com carne suína e temperos especiais. Peso: 500g',
          'imagens/linguica_pernil.jpg',
          32.00,
        ),
        produtoItem(
          'Linguiça Toscana',
          'Clássica linguiça toscana, ideal para churrasco. Peso: 500g',
          'imagens/linguica_toscana.jpg',
          30.00,
        ),
        produtoItem(
          'Linguiça de Costela',
          'Feita com costela suína, sabor intenso e aroma defumado. Peso: 500g',
          'imagens/linguica_de_costela.jpg',
          37.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaVinhos() {
    return ListView(
      children: [
        produtoItem(
          'Vinho Colonial',
          'Um vinho artesanal, produzido a partir de uvas selecionadas, com sabor encorpado e aromas frutados. Perfeito para acompanhar refeições ou para um brinde especial. Volume: 750ml',
          'imagens/vinho_colonial.png',
          30.00,
        ),
        produtoItem(
          'Vinho Branco Suave',
          'Vinho leve e frutado, perfeito para peixes e saladas. Volume: 750 ml.',
          'imagens/vinho_branco.jpg',
          60.00,
        ),
        produtoItem(
          'Vinho Rosé',
          'Vinho jovem e refrescante, ótimo para dias quentes. Volume: 750ml',
          'imagens/vinho_rose.jpg',
          55.00,
        ),
        produtoItem(
          'Espumante Brut',
          'Espumante seco, ideal para comemorações e harmonização com frutos do mar. Volume: 750ml',
          'imagens/espumante_brut.jpg',
          75.00,
        ),
        produtoItem(
          'Vinho Tinto Reserva',
          'Envelhecido em barris de carvalho, sabor complexo e marcante. Volume: 750ml',
          'imagens/vinho_tinto_reserva.jpg',
          95.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaEmbutidoseDefumados() {
    return ListView(
      children: [
        produtoItem(
          'Presunto Defumado',
          'Presunto artesanal defumado, sabor marcante. Peso: 500g',
          'imagens/presuntodefumado.jpg',
          35.00,
        ),
        produtoItem(
          'Bacon Defumado',
          'Bacon defumado artesanal, perfeito para receitas. Peso: 300g',
          'imagens/bacondefumado.jpg',
          28.00,
        ),
        produtoItem(
          'Salame Italiano',
          'Salame artesanal, com sabor intenso. Peso: 250g',
          'imagens/salameitaliano.jpg',
          30.00,
        ),
        produtoItem(
          'Costelinha Defumada',
          'Costelinha de porco defumada, ideal para feijoadas e cozidos. Peso: 500g',
          'imagens/costelinhadefumada.jpg',
          50.00,
        ),
        produtoItem(
          'Pastrami',
          'Carne curada e defumada, sabor intenso e maciez inigualável. Peso: 500g',
          'imagens/pastrami.jpg',
          50.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaManteigaseCremes() {
    return ListView(
      children: [
        produtoItem(
          'Manteiga com Sal',
          'Manteiga artesanal com sal. Peso: 200g',
          'imagens/manteigacomsal.jpg',
          15.00,
        ),
        produtoItem(
          'Manteiga sem Sal',
          'Manteiga artesanal sem sal. Peso: 200g',
          'imagens/manteigasemsal.jpg',
          15.00,
        ),
        produtoItem(
          'Creme de Ricota',
          'Creme de ricota leve e cremoso. Peso: 250g',
          'imagens/cremedericota.jpg',
          12.00,
        ),
        produtoItem(
          'Manteiga Colonial',
          'Manteiga artesanal com sabor intenso e textura cremosa. Peso: 200g',
          'imagens/manteigacolonial.jpg',
          15.00,
        ),
        produtoItem(
          'Creme de Queijo',
          'Creme de queijo artesanal, perfeito para acompanhar pães e biscoitos. Peso: 150g',
          'imagens/requeijao.jpg',
          18.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaCachaca() {
    return ListView(
      children: [
        produtoItem(
          'Cachaça Prata',
          'Cachaça artesanal, sabor suave e ideal para drinks. Volume: 500 ml',
          'imagens/cachacaprata.jpg',
          20.00,
        ),
        produtoItem(
          'Cachaça Envelhecida',
          'Cachaça envelhecida em barril de carvalho, sabor complexo. Volume: 500 ml',
          'imagens/cachacaenvelhecida.jpg',
          35.00,
        ),
        produtoItem(
          'Cachaça com Mel',
          'Cachaça artesanal com toque de mel, sabor levemente adocicado. Volume: 500 ml',
          'imagens/cachacamel.jpg',
          40.00,
        ),
        produtoItem(
          'Cachaça de Umburana',
          'Envelhecida em barris de umburana, com notas amadeiradas. Volume: 500 ml',
          'imagens/cachacaumburana.jpg',
          50.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaConservas() {
    return ListView(
      children: [
        produtoItem(
          'Picles de Pepino',
          'Picles crocante e saboroso. Peso: 300g',
          'imagens/piclespepino.jpg',
          10.00,
        ),
        produtoItem(
          'Conserva de Azeitonas',
          'Azeitonas em conserva, ideal para petiscos. Peso: 200g',
          'imagens/conservaazeitona.jpg',
          12.00,
        ),
        produtoItem(
          'Pepperoni em Conserva',
          'Pepperoni em conserva, excelente para pizzas e petiscos. Peso: 150g',
          'imagens/conservapepperoni.jpg',
          14.00,
        ),
        produtoItem(
          'Conserva de Pimenta',
          'Pimentas selecionadas e curtidas, ideal para pratos apimentados. Peso: 250g',
          'imagens/conservapimenta.jpg',
          15.00,
        ),
        produtoItem(
          'Conserva de Alho',
          'Dentes de alho curtidos em azeite, ótimo acompanhamento. Peso: 200g',
          'imagens/conservaalho.jpg',
          12.00,
        ),
      ],
    );
  }

  Widget produtoItem(
      String titulo, String descricao, String imagem, double preco) {
    int quantidade = _quantidade[titulo] ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(imagem, width: 70, height: 70, fit: BoxFit.cover),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$descricao\nPreço: R\$ ${preco.toStringAsFixed(2)}\nQuantidade no carrinho: $quantidade',
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removerCarrinho(titulo, preco),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => _adicionarCarrinho(titulo, preco, imagem),
            ),
          ],
        ),
      ),
    );
  }
}
