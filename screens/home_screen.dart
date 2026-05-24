import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/counter_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Счетчик нажатий'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => auth.signOut(),
                  tooltip: 'Выйти',
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer2<CounterProvider, AuthProvider>(
        builder: (context, counterProvider, authProvider, child) {
          if (counterProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Количество нажатий:',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  if (authProvider.isAuthenticated)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Вы вошли как: ${authProvider.userEmail}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  const SizedBox(height: 32),

                  Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: authProvider.isAuthenticated
                              ? [Colors.blue.shade200, Colors.blue.shade100]
                              : [Colors.grey.shade300, Colors.grey.shade200],
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text('Счетчик', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),
                          Text(
                            '${counterProvider.counter}',
                            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton.icon(
                    onPressed: () => counterProvider.increment(),
                    icon: const Icon(Icons.add),
                    label: const Text('НАЖМИ МЕНЯ', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (counterProvider.counter > 0)
                    TextButton.icon(
                      onPressed: () => counterProvider.reset(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Сбросить счетчик'),
                    ),

                  if (!authProvider.isAuthenticated) ...[
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text('Войдите для дополнительных функций', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Войти / Зарегистрироваться'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}