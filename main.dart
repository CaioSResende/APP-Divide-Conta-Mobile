import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DivideContaApp());
}

class DivideContaApp extends StatelessWidget {
  const DivideContaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divide Conta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3F51B5),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final _valorTotalController = TextEditingController();
  final _qtdPessoasController = TextEditingController();
  final _porcentagemController = TextEditingController();

  double? _valorGarcom;
  double? _valorTotalAPagar;
  double? _valorPorPessoa;

  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    _valorTotalController.dispose();
    _qtdPessoasController.dispose();
    _porcentagemController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    setState(() {
      _valorGarcom = null;
      _valorTotalAPagar = null;
      _valorPorPessoa = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _calcularDivisao() {
    final valorTotalTexto = _valorTotalController.text.trim();
    final qtdPessoasTexto = _qtdPessoasController.text.trim();
    final porcentagemTexto = _porcentagemController.text.trim();

    // Validação: campos vazios
    if (valorTotalTexto.isEmpty ||
        qtdPessoasTexto.isEmpty ||
        porcentagemTexto.isEmpty) {
      _mostrarErro('Preencha todos os campos antes de calcular.');
      return;
    }

    final valorTotalConta = double.tryParse(valorTotalTexto.replaceAll(',', '.'));
    final quantidadePessoas = int.tryParse(qtdPessoasTexto);
    final porcentagemGarcom =
        double.tryParse(porcentagemTexto.replaceAll(',', '.'));

    // Validação: valor da conta precisa ser válido e positivo
    if (valorTotalConta == null || valorTotalConta <= 0) {
      _mostrarErro('Informe um valor total válido.');
      return;
    }

    // Validação: quantidade de pessoas precisa ser maior que zero
    if (quantidadePessoas == null || quantidadePessoas <= 0) {
      _mostrarErro('A quantidade de pessoas deve ser maior que zero.');
      return;
    }

    // Validação: porcentagem precisa ser válida (>= 0)
    if (porcentagemGarcom == null || porcentagemGarcom < 0) {
      _mostrarErro('Informe uma porcentagem válida.');
      return;
    }

    // --- Cálculos ---
    final valorGarcom = valorTotalConta * (porcentagemGarcom / 100.0);
    final valorTotalAPagar = valorTotalConta + valorGarcom;
    final valorPorPessoa = valorTotalAPagar / quantidadePessoas;

    setState(() {
      _valorGarcom = valorGarcom;
      _valorTotalAPagar = valorTotalAPagar;
      _valorPorPessoa = valorPorPessoa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisão de Conta do Bar')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _valorTotalController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Valor total da conta (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _qtdPessoasController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantidade de pessoas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _porcentagemController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Comissão do garçom (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calcularDivisao,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Calcular'),
                ),
              ),
              if (_valorTotalAPagar != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Comissão do garçom: ${_formatoMoeda.format(_valorGarcom)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valor total a pagar: ${_formatoMoeda.format(_valorTotalAPagar)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valor por pessoa: ${_formatoMoeda.format(_valorPorPessoa)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
