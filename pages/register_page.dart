import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final instagramC = TextEditingController();

  bool loading = false;

  Future<void> daftar() async {
    if (namaC.text.isEmpty ||
        emailC.text.isEmpty ||
        passC.text.isEmpty ||
        instagramC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data harus diisi')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'nama': namaC.text,
        'email': emailC.text,
        'instagram': instagramC.text,
        'photo': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal daftar: $e')),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 45),
            const Icon(Icons.rocket_launch, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Daftar Akun',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: namaC,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: instagramC,
              decoration: const InputDecoration(
                labelText: 'Akun Instagram',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : daftar,
              child: Text(loading ? 'Loading...' : 'Daftar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Apakah sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}