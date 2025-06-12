import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import 'excel_page.dart';
import 'docx_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Company Logo
                    Image.asset(
                      'assets/logo.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),
                    // App Title
                    Text(
                      'Document Generator',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      'Generate professional Excel and Word documents with ease.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Buttons
                    CustomButton(
                      text: 'Generate Excel',
                      icon: Icons.table_chart,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ExcelPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Generate Docx',
                      icon: Icons.description,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DocxPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}