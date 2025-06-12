import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/docx_generator.dart';

class DocxPage extends StatefulWidget {
  const DocxPage({super.key});

  @override
  State<DocxPage> createState() => _DocxPageState();
}

class _DocxPageState extends State<DocxPage> {
  final DocxGenerator _docxGenerator = DocxGenerator();
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docx Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_rounded,
                        size: 64,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Generate Certificate',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create a professional Certificate of Conformance/Compliance in .docx format.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: _isGenerating
                              ? null
                              : () async {
                            setState(() {
                              _isGenerating = true;
                            });
                            await _docxGenerator.generateAndOpenDocx(context);
                            setState(() {
                              _isGenerating = false;
                            });
                          },
                          child: _isGenerating
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text('Generate & Download (.docx)'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The generated file will be saved to your device\'s Downloads or Documents folder.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}