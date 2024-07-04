import 'package:flutter/material.dart';
import 'api_service.dart';
import 'crypto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uas Fadilah Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CryptoListPage(),
    );
  }
}

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({Key? key}) : super(key: key);

  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  late Future<List<Crypto>> futureCryptos;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCryptos = apiService.fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UasFadilah_DataCrypto'),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final cryptos = snapshot.data!;
          return ListView.builder(
            itemCount: cryptos.length,
            itemBuilder: (context, index) {
              final crypto = cryptos[index];
              return Card(
                color: Colors.blue[50],
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      crypto.symbol[0],
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                  title: Text(
                    '${crypto.name} (${crypto.symbol})',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
                  ),
                  subtitle: Text(
                    '\$${crypto.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
