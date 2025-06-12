import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../utils/excel_generator.dart';

class ExcelPage extends StatelessWidget {
  const ExcelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExcelGenerator(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Excel Generator'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<ExcelGenerator>(
          builder: (context, excelGenerator, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[100]!,
                    Colors.blue[300]!,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FadeInUp(
                      child: Text(
                        'Excel Creator',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black26,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: const Text(
                        'View your fabric test report in the app or generate an Excel file!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: excelGenerator.isLoading
                                ? null
                                : () async {
                              await excelGenerator.loadData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: Colors.blueGrey[300],
                            ),
                            child: const Text('Load Data'),
                          ),
                          const SizedBox(width: 16),
                          if (excelGenerator.dataLoaded)
                            ElevatedButton(
                              onPressed: excelGenerator.isLoading
                                  ? null
                                  : () async {
                                await excelGenerator.createExcel();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: Colors.blueGrey[300],
                              ),
                              child: const Text('Generate Excel'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (excelGenerator.isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    if (excelGenerator.message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: excelGenerator.message!.contains('Error')
                                ? Colors.red[400]!.withOpacity(0.9)
                                : Colors.green[400]!.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            excelGenerator.message!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (excelGenerator.dataLoaded && !excelGenerator.isLoading)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Report Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: excelGenerator.reportDetails.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        '${entry.key}: ${entry.value}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Test Results',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 16,
                                  headingRowColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.blue[600]!),
                                  dataRowColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.white.withOpacity(0.9)),
                                  columns: const [
                                    DataColumn(
                                        label: Text('Test',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Test Method No.',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Result',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Standard',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Minimum',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Maximum',
                                            style: TextStyle(color: Colors.white))),
                                    DataColumn(
                                        label: Text('Remarks',
                                            style: TextStyle(color: Colors.white))),
                                  ],
                                  rows: excelGenerator.testData.map((row) {
                                    return DataRow(
                                      cells: row.map((cell) {
                                        return DataCell(
                                          Text(
                                            cell,
                                            style: const TextStyle(color: Colors.black87),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}