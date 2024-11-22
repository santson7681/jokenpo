import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Jogo(),
    );
  }
}

class Jogo extends StatefulWidget {
  const Jogo({super.key});

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var _imageApp = const AssetImage("assets/padrao.png");
  var _result = "";  // Variável para armazenar o resultado (Quem ganhou)
  int _pontosUsuario = 0;  // Pontuação do usuário
  int _pontosApp = 0;  // Pontuação do aplicativo

  // Função para validar a entrada do usuário
  bool _isEntradaValida(String escolhaUsuario) {
    return escolhaUsuario == "pedra" || escolhaUsuario == "papel" || escolhaUsuario == "tesoura";
  }

  void _reiniciarJogo() {
    setState(() {
      _pontosUsuario = 0;
      _pontosApp = 0;
      _result = "";
      _imageApp = const AssetImage("assets/padrao.png");
    });
  }

  void _opcaoSelecionada(String escolhaUsuario) {
    // Valida a entrada do usuário
    if (!_isEntradaValida(escolhaUsuario)) {
      setState(() {
        _result = "Escolha inválida. Tente novamente!";
      });
      return;
    }

    var opcoes = ["pedra", "papel", "tesoura"];
    var numero = Random().nextInt(3);
    var escolhaApp = opcoes[numero];

    // Lógica para determinar a escolha do app
    switch (escolhaApp) {
      case "pedra":
        setState(() {
          _imageApp = const AssetImage("assets/pedra.png");
        });
        break;
      case "papel":
        setState(() {
          _imageApp = const AssetImage("assets/papel.png");
        });
        break;
      case "tesoura":
        setState(() {
          _imageApp = const AssetImage("assets/tesoura.png");
        });
        break;
    }

    // Lógica para comparar a escolha do usuário com a do app e determinar o vencedor
    String resultado = "";
    if (escolhaUsuario == escolhaApp) {
      resultado = "Empate!";
    } else if ((escolhaUsuario == "pedra" && escolhaApp == "tesoura") ||
        (escolhaUsuario == "papel" && escolhaApp == "pedra") ||
        (escolhaUsuario == "tesoura" && escolhaApp == "papel")) {
      resultado = "Você ganhou!";
      _pontosUsuario++;  // Incrementa os pontos do usuário
    } else {
      resultado = "Você perdeu!";
      _pontosApp++;  // Incrementa os pontos do app
    }

    // Checa se algum dos jogadores atingiu 24 pontos
    if (_pontosUsuario >= 24) {
      resultado = "";  // Limpa o resultado anterior
      // Navega para a tela de vitória
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaVitoria(onReiniciar: _reiniciarJogo)),
      );
    } else if (_pontosApp >= 24) {
      resultado = "O Robo venceu o jogo com 24 pontos! Tente novamente!";
      Future.delayed(const Duration(seconds: 3), () {
        _reiniciarJogo();  // Reinicia o jogo após 3 segundos
      });
    }

    setState(() {
      _result = resultado;  // Atualiza o resultado no UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Santson JokenPo"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 3, bottom: 16),
            child: Text(
              "Escolha do App:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Image(image: _imageApp), // Mostra a imagem da escolha do app
          const Padding(
            padding: EdgeInsets.only(top: 3, bottom: 16),
            child: Text(
              "Escolha uma opção abaixo:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => _opcaoSelecionada("pedra"),
                child: Image.asset("assets/pedra.png", height: 120),
              ),
              GestureDetector(
                onTap: () => _opcaoSelecionada("papel"),
                child: Image.asset("assets/papel.png", height: 120),
              ),
              GestureDetector(
                onTap: () => _opcaoSelecionada("tesoura"),
                child: Image.asset("assets/tesoura.png", height: 120),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Exibe o resultado da partida centralizado
          Text(
            _result,
            textAlign: TextAlign.center,  // Centraliza o texto
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // Exibe os pontos de cada jogador
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Pontos do Usuário: $_pontosUsuario\nPontos do App: $_pontosApp",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaVitoria extends StatelessWidget {
  final VoidCallback onReiniciar;

  const TelaVitoria({super.key, required this.onReiniciar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vitória!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/trofeu.png", height: 200), // Imagem do troféu
            const SizedBox(height: 20),
            const Text(
              "You Win!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  onReiniciar(); // Chama a função para reiniciar o jogo
                  Navigator.pop(context); // Volta para a tela inicial
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Aumenta o padding
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Reiniciar Jogo"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
