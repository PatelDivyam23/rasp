import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb, ChangeNotifier;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:universal_html/html.dart' as html;

class ExcelGenerator extends ChangeNotifier {
  List<List<String>> testData = [];
  Map<String, String> reportDetails = {};
  bool _dataLoaded = false;
  bool _isLoading = false;
  String? _message;
  static int _fileCounter = 0; // Static counter for file naming

  bool get dataLoaded => _dataLoaded;
  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> loadData() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      reportDetails = {
        'Company': 'Kusumgar Limited (Formerly Known As Kusumgar Private Limited)',
        'Certification': 'An ISO 9001:2015 Company',
        'Report No': 'Q250001330',
        'Date': '05-04-2025',
        'Rec Dt of Sample': '05-04-2025',
        'Project Leader': 'Sandeep',
        'Date of Testing': '05-04-2025',
        'Reg/Dev': 'Regular',
        'MFG Quality No': 'PWNN4201',
        'Sales Quality No': 'CLOTH,NYL,65",FG 24165,INTERNATIONAL-P44378 T4-NB',
        'Product No': 'INT-P443',
        'Dimensions': 'ACL02 GN0088 WRSI01 170',
        'Customer Name': 'Airborne Systems Limited.',
        'Material': 'Nylon 66',
        'Type of Finish': 'WRSI01 No Finish',
        'SO No': 'SO2425-001457',
        'Batch No': '24P41768',
        'MFG Unit': 'Kusumgar Limited',
        'Colour': 'GN0088 LD No. 4448 - Blue',
        'No of Samples': '1',
        'P/c Roll No Result': '24045849',
        'Final Flag': 'OK',
        'Tested By': 'Anil Pandit',
        'Prepared By': 'Chandan Verma',
        'Remarked By': 'All Parameters are ok',
        'Verified By': 'qa.vapi',
        'Verified DateTime': '26-04-2025 13:01:51',
      };

      testData = [
        ['Width Inch', 'ASTM D 3774', '67.0000', '65.00', '35.00', '75.00', ''],
        ['Weight Oz/Yd2', 'ASTM D 3776', '1.1200', '1.20', '1.00', '1.20', ''],
        ['Thrd Count-Wp inch', 'ASTM D 3775', '132.0000', '126.00', '126.00', '145.00', ''],
        ['Thrd Count-Wt inch', 'ASTM D 3775', '136.0000', '132.00', '132.00', '150.00', ''],
        ['BS-Wp lbf', 'ASTM D 5035', '48.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wp lbf', 'ASTM D 5035', '48.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wp lbf', 'ASTM D 5035', '48.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wp lbf', 'ASTM D 5035', '48.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wp lbf', 'ASTM D 5035', '48.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wt lbf', 'ASTM D 5035', '46.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wt lbf', 'ASTM D 5035', '46.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wt lbf', 'ASTM D 5035', '46.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wt lbf', 'ASTM D 5035', '46.0000', '45.00', '45.00', '80.00', ''],
        ['BS-Wt lbf', 'ASTM D 5035', '46.0000', '45.00', '45.00', '80.00', ''],
        ['%Elong-Wp', 'ASTM D 5035', '23.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wp', 'ASTM D 5035', '23.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wp', 'ASTM D 5035', '23.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wp', 'ASTM D 5035', '23.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wp', 'ASTM D 5035', '23.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wt', 'ASTM D 5035', '21.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wt', 'ASTM D 5035', '21.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wt', 'ASTM D 5035', '21.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wt', 'ASTM D 5035', '21.0000', '20.00', '20.00', '50.00', ''],
        ['%Elong-Wt', 'ASTM D 5035', '21.0000', '20.00', '20.00', '50.00', ''],
        ['TS-Wp lbf', 'ASTM D 2261', '7.0000', '5.00', '5.00', '15.00', ''],
        ['TS-Wp lbf', 'ASTM D 2261', '7.0000', '5.00', '5.00', '15.00', ''],
        ['TS-Wp lbf', 'ASTM D 2261', '7.0000', '5.00', '5.00', '15.00', ''],
        ['TS-Wp lbf', 'ASTM D 2261', '7.0000', '5.00', '5.00', '15.00', ''],
        ['TS-Wp lbf', 'ASTM D 2261', '7.0000', '5.00', '5.00', '15.00', ''],
        ['TS-Wt lbf', 'ASTM D 2261', '6.5000', '5.00', '5.00', '15.00', ''],
        ['TS-Wt lbf', 'ASTM D 2261', '6.5000', '5.00', '5.00', '15.00', ''],
        ['TS-Wt lbf', 'ASTM D 2261', '6.5000', '5.00', '5.00', '15.00', ''],
        ['TS-Wt lbf', 'ASTM D 2261', '6.5000', '5.00', '5.00', '15.00', ''],
        ['TS-Wt lbf', 'ASTM D 2261', '6.5000', '5.00', '5.00', '15.00', ''],
        ['Thick inch', 'ASTM D 1777', '0.0015', '0.00', '0.00', '0.00', ''],
        ['AP@1/2 Inch (ft3/ft2/m)Av', 'ASTM D 737', '0.7700', '1.75', '0.50', '3.00', ''],
        ['AP@1/2ynos (ft3/ft2/m)Mn', 'ASTM D 737', '0.6400', '1.75', '0.50', '3.00', ''],
        ['AP@1/2 Inch (ft3/ft2/m)Mx', 'ASTM D 737', '0.8600', '1.75', '0.50', '3.00', ''],
        ['Water Repellency', 'AATCC 22', '90.0000', '80.00', '80.00', '100.00', ''],
        ['pH Value', 'AATCC 61', '6.2000', '7.30', '5.50', '9.00', ''],
        ['CF-Rub-Dry', 'AATCC 8', '4.5000', '3.50', '3.50', '5.00', ''],
        ['CF-Rub-Wet', 'AATCC 8', '4.5000', '3.50', '3.50', '5.00', ''],
      ];

      _dataLoaded = true;
      _message = 'Data loaded successfully!';
    } catch (e) {
      _message = 'Error loading data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createExcel() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      // Increment file counter for unique file naming
      _fileCounter++;
      final String fileNameBase = 'Fabric_Test_Report_$_fileCounter';

      // Create a new Excel workbook and get the first sheet
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      // Disable gridlines to make the sheet appear completely blank outside the table area
      sheet.showGridlines = false;

      // --- Set Column Widths ---
      sheet.getRangeByIndex(1, 1).columnWidth = 23.56;
      sheet.getRangeByIndex(1, 2).columnWidth = 17.00;
      sheet.getRangeByIndex(1, 3).columnWidth = 8.33;
      sheet.getRangeByIndex(1, 4).columnWidth = 5.67;
      sheet.getRangeByIndex(1, 5).columnWidth = 5.67;
      sheet.getRangeByIndex(1, 6).columnWidth = 5.67;
      sheet.getRangeByIndex(1, 7).columnWidth = 5.67;
      sheet.getRangeByIndex(1, 8).columnWidth = 18.33;


      // --- Set Row Heights ---
      sheet.getRangeByIndex(1, 1).rowHeight = 1.80;
      sheet.getRangeByIndex(2, 1).rowHeight = 102.60;

      // --- Define Styles ---
      final companyTitleStyle = workbook.styles.add('companyTitleStyle');
      companyTitleStyle
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 20
        ..bold = true;

      final companyTitleStyle1 = workbook.styles.add('companyTitleStyle1');
      companyTitleStyle1
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11;

      final company = workbook.styles.add('company');
      company
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11
        ..bold = true;

      final type = workbook.styles.add('Type');
      type
        ..hAlign = xlsio.HAlignType.right
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11;

      final type10 = workbook.styles.add('Type10');
      type10
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11
        ..wrapText = true;

      final labelStyle = workbook.styles.add('labelStyle');
      labelStyle
        ..hAlign = xlsio.HAlignType.left
        ..vAlign = xlsio.VAlignType.center
        ..bold = true;

      final valueStyle = workbook.styles.add('valueStyle');
      valueStyle
        ..hAlign = xlsio.HAlignType.left
        ..vAlign = xlsio.VAlignType.center;

      final yellowValueStyle = workbook.styles.add('yellowValueStyle');
      yellowValueStyle
        ..hAlign = xlsio.HAlignType.left
        ..vAlign = xlsio.VAlignType.center
        ..backColorRgb = const Color(0xFFFFFF00);

      final tableHeaderStyle = workbook.styles.add('tableHeaderStyle');
      tableHeaderStyle
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11
        ..bold = true
        ..wrapText = true
        ..borders.all.lineStyle = xlsio.LineStyle.thin
        ..borders.all.color = '#000000';

      final type4 = workbook.styles.add('Type4');
      type4
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11;

      final type5 = workbook.styles.add('Type5');
      type5
        ..hAlign = xlsio.HAlignType.left
        ..vAlign = xlsio.VAlignType.top
        ..fontSize = 11
        ..bold = true;

      final type6 = workbook.styles.add('Type6');
      type6
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.bottom
        ..fontSize = 9;

      final type7 = workbook.styles.add('Type7');
      type7
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.center
        ..fontSize = 11;

      final type8 = workbook.styles.add('Type8');
      type8
        ..hAlign = xlsio.HAlignType.left
        ..vAlign = xlsio.VAlignType.top
        ..fontSize = 11;

      final type11 = workbook.styles.add('Type11');
      type11
        ..hAlign = xlsio.HAlignType.center
        ..vAlign = xlsio.VAlignType.top
        ..fontSize = 11
        ..bold = true;

      final rightBorderStyle = workbook.styles.add('rightBorderStyle');
      rightBorderStyle.borders.right.lineStyle = xlsio.LineStyle.thin;

      final topBorderStyle = workbook.styles.add('topBorderStyle');
      topBorderStyle.borders.top.lineStyle = xlsio.LineStyle.thin;

      final bottomBorderStyle = workbook.styles.add('bottomBorderStyle');
      bottomBorderStyle.borders.bottom.lineStyle = xlsio.LineStyle.thin;

      // --- Header Section ---
      sheet.getRangeByName('A2:H2').merge();
      sheet.getRangeByName('A2').setText('Kusumgar Limited');
      sheet.getRangeByName('A2:H2').cellStyle = companyTitleStyle;

      sheet.getRangeByName('A3:H3').merge();
      sheet.getRangeByName('A3').setText('TEST REPORT');
      sheet.getRangeByName('A3:H3').cellStyle = companyTitleStyle1;


      sheet.getRangeByName('A4').setText('Report No.');
      sheet.getRangeByName('A4').cellStyle = company;

      sheet.getRangeByName('B4').setText('Q250001330');
      sheet.getRangeByName('B4').cellStyle = company;

      sheet.getRangeByName('C4').setText('Date');
      sheet.getRangeByName('C4').cellStyle = company;

      sheet.getRangeByName('D4:H4').merge();
      sheet.getRangeByName('D4').setText('21-04-2025');
      sheet.getRangeByName('D4:H4').cellStyle = type10;

      sheet.getRangeByName('A5:A15').merge();
      sheet.getRangeByName('A5').setText('Item');
      sheet.getRangeByName('A5:A15').cellStyle = type10;

      sheet.getRangeByName('B5:B15').merge();
      sheet.getRangeByName('B5').setText('166452 CLOTH,NYL,65",     FG 24165 INTERNATIONAL-P44378 T4-NB PRODUCT NO: INT-P44378 T4-NB');
      sheet.getRangeByName('B5:B15').cellStyle = type10;

      sheet.getRangeByName('C5:C15').merge();
      sheet.getRangeByName('C5').setText('Customer');
      sheet.getRangeByName('C5:C15').cellStyle = type10;

      sheet.getRangeByName('D5:H5').merge();
      sheet.getRangeByName('D5').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('D5:H5').cellStyle = type10;

      sheet.getRangeByName('E6:H6').merge();
      sheet.getRangeByName('E6').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E6:H6').cellStyle = type10;

      sheet.getRangeByName('E7:H7').merge();
      sheet.getRangeByName('E7').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E7:H7').cellStyle = type10;

      sheet.getRangeByName('E8:H8').merge();
      sheet.getRangeByName('E8').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E8:H8').cellStyle = type10;

      sheet.getRangeByName('E9:H9').merge();
      sheet.getRangeByName('E9').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E9:H9').cellStyle = type10;

      sheet.getRangeByName('E10:H10').merge();
      sheet.getRangeByName('E10').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E10:H10').cellStyle = type10;

      sheet.getRangeByName('E11:H11').merge();
      sheet.getRangeByName('E11').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E11:H11').cellStyle = type10;

      sheet.getRangeByName('E12:H12').merge();
      sheet.getRangeByName('E12').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E12:H12').cellStyle = type10;

      sheet.getRangeByName('E13:H13').merge();
      sheet.getRangeByName('E13').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E13:H13').cellStyle = type10;

      sheet.getRangeByName('E14:H14').merge();
      sheet.getRangeByName('E14').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E14:H14').cellStyle = type10;

      sheet.getRangeByName('E15:H15').merge();
      sheet.getRangeByName('E15').setText('Airborne Systems NA of CA Inc.');
      sheet.getRangeByName('E15:H15').cellStyle = type10;











      // sheet.getRangeByName('H5:I5').merge();
      // sheet.getRangeByName('H5').setText('KCPL/K/QA/TR-01');
      // sheet.getRangeByName('H5:I5').cellStyle = type10;
      // sheet.getRangeByName('H5:I5').cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      // sheet.getRangeByName('H5:I5').cellStyle.borders.all.color = '#000000';
      //
      // // --- Labels and Values (B6:B20, C6:F20, G6:G20, H6:I20) ---
      // sheet.getRangeByName('C6:F6').merge();
      // sheet.getRangeByName('C7:F7').merge();
      // sheet.getRangeByName('C8:F8').merge();
      // sheet.getRangeByName('C9:F9').merge();
      // sheet.getRangeByName('C11:F11').merge();
      // sheet.getRangeByName('C12:F12').merge();
      // sheet.getRangeByName('C13:F13').merge();
      // sheet.getRangeByName('C14:F14').merge();
      // sheet.getRangeByName('C15:F15').merge();
      // sheet.getRangeByName('C16:F16').merge();
      // sheet.getRangeByName('C17:F17').merge();
      // sheet.getRangeByName('C18:F18').merge();
      // sheet.getRangeByName('C19:F19').merge();
      // sheet.getRangeByName('C20:F20').merge();
      //
      // sheet.getRangeByName('B6').setText('Report No');
      // sheet.getRangeByName('B6').cellStyle = labelStyle;
      // sheet.getRangeByName('C6:F6').setText('Q250001330');
      // sheet.getRangeByName('C6').cellStyle = yellowValueStyle;
      //
      // sheet.getRangeByName('B7').setText('Rec Dt of Sample');
      // sheet.getRangeByName('B7').cellStyle = labelStyle;
      // sheet.getRangeByName('C7:F7').setText('05-04-2025');
      // sheet.getRangeByName('C7:F7').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B8').setText('Date of Testing');
      // sheet.getRangeByName('B8').cellStyle = labelStyle;
      // sheet.getRangeByName('C8:F8').setText('05-04-2025');
      // sheet.getRangeByName('C8:F8').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B9').setText('MFG Quality No');
      // sheet.getRangeByName('B9').cellStyle = labelStyle;
      // sheet.getRangeByName('C9:F9').setText('PWNN4201');
      // sheet.getRangeByName('C9:F9').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B10').setText('Dimensions');
      // sheet.getRangeByName('B10').cellStyle = labelStyle;
      // sheet.getRangeByName('C10').setText('ACL02');
      // sheet.getRangeByName('C10').cellStyle = valueStyle;
      // sheet.getRangeByName('D10').setText('GN0088');
      // sheet.getRangeByName('D10').cellStyle = valueStyle;
      // sheet.getRangeByName('E10').setText('WRSI01');
      // sheet.getRangeByName('E10').cellStyle = valueStyle;
      // sheet.getRangeByName('F10').setText('170');
      // sheet.getRangeByName('F10').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B11').setText('Material');
      // sheet.getRangeByName('B11').cellStyle = labelStyle;
      // sheet.getRangeByName('C11:F11').setText('NYLON 66 NYLON 66');
      // sheet.getRangeByName('C11:F11').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B12').setText('SO No');
      // sheet.getRangeByName('B12').cellStyle = labelStyle;
      // sheet.getRangeByName('C12:F12').setText('SO2425-001457');
      // sheet.getRangeByName('C12:F12').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B13').setText('MFG Unit');
      // sheet.getRangeByName('B13').cellStyle = labelStyle;
      // sheet.getRangeByName('C13:F13').setText('Kusumgar LIMITED (Ka');
      // sheet.getRangeByName('C13:F13').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B14').setText('Colour');
      // sheet.getRangeByName('B14').cellStyle = labelStyle;
      // sheet.getRangeByName('C14:F14').setText('GN0088 LD NO. 4448 - Blue');
      // sheet.getRangeByName('C14:F14').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B15').setText('Warp Yarn');
      // sheet.getRangeByName('B15').cellStyle = labelStyle;
      // sheet.getRangeByName('C15:F15').setText('');
      // sheet.getRangeByName('C15:F15').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B16').setText('Warp Yarn-1');
      // sheet.getRangeByName('B16').cellStyle = labelStyle;
      // sheet.getRangeByName('C16:F16').setText('');
      // sheet.getRangeByName('C16:F16').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B17').setText('Weft Yarn');
      // sheet.getRangeByName('B17').cellStyle = labelStyle;
      // sheet.getRangeByName('C17:F17').setText('');
      // sheet.getRangeByName('C17:F17').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B18').setText('Weft Yarn-1');
      // sheet.getRangeByName('B18').cellStyle = labelStyle;
      // sheet.getRangeByName('C18:F18').setText('');
      // sheet.getRangeByName('C18:F18').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B19').setText('Reed');
      // sheet.getRangeByName('B19').cellStyle = labelStyle;
      // sheet.getRangeByName('C19:F19').setText('');
      // sheet.getRangeByName('C19:F19').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('B20').setText('Pick');
      // sheet.getRangeByName('B20').cellStyle = labelStyle;
      // sheet.getRangeByName('C20:F20').setText('');
      // sheet.getRangeByName('C20:F20').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('H6:I6').merge();
      // sheet.getRangeByName('H7:I7').merge();
      // sheet.getRangeByName('H8:I8').merge();
      // sheet.getRangeByName('H9:I9').merge();
      // sheet.getRangeByName('H10:I10').merge();
      // sheet.getRangeByName('H11:I11').merge();
      // sheet.getRangeByName('H12:I12').merge();
      // sheet.getRangeByName('H13:I13').merge();
      // sheet.getRangeByName('H14:I14').merge();
      // sheet.getRangeByName('H15:I15').merge();
      // sheet.getRangeByName('H16:I16').merge();
      // sheet.getRangeByName('H17:I17').merge();
      // sheet.getRangeByName('H18:I18').merge();
      // sheet.getRangeByName('H19:I19').merge();
      //
      // sheet.getRangeByName('G6').setText('Date');
      // sheet.getRangeByName('G6').cellStyle = labelStyle;
      // sheet.getRangeByName('H6:I6').setText('05-04-2025');
      // sheet.getRangeByName('H6:I6').cellStyle = valueStyle;
      //
      // sheet.getRangeByName('G7').setText('Project Leader');
      // sheet.getRangeByName('G7').cellStyle = labelStyle;
      // sheet.getRangeByName('H7:I7').setText('Sandeep');
      // sheet.getRangeByName('H7:I7').cellStyle = valueStyle;

      sheet.getRangeByName('G8').setText('Reg/Dev');
      sheet.getRangeByName('G8').cellStyle = labelStyle;
      sheet.getRangeByName('H8:I8').setText('Regular');
      sheet.getRangeByName('H8:I8').cellStyle = valueStyle;

      sheet.getRangeByName('G9').setText('Sales Quality No');
      sheet.getRangeByName('G9').cellStyle = labelStyle;
      sheet.getRangeByName('H9:I9').setText('CLOTH,NYL,65",FG');
      sheet.getRangeByName('H9:I9').cellStyle = valueStyle;

      sheet.getRangeByName('G10').setText('Customer Name');
      sheet.getRangeByName('G10').cellStyle = labelStyle;
      sheet.getRangeByName('H10:I10').setText('Airborne Systems Limited.');
      sheet.getRangeByName('H10:I10').cellStyle = yellowValueStyle;

      sheet.getRangeByName('G11').setText('Type of Finish');
      sheet.getRangeByName('G11').cellStyle = labelStyle;
      sheet.getRangeByName('H11:I11').setText('WRSI01 No Finish');
      sheet.getRangeByName('H11:I11').cellStyle = valueStyle;

      sheet.getRangeByName('G12').setText('Batch No');
      sheet.getRangeByName('G12').cellStyle = labelStyle;
      sheet.getRangeByName('H12:I12').setText('24P41768');
      sheet.getRangeByName('H12:I12').cellStyle = valueStyle;

      sheet.getRangeByName('G13').setText('Unit');
      sheet.getRangeByName('G13').cellStyle = labelStyle;
      sheet.getRangeByName('H13:I13').setText('');
      sheet.getRangeByName('H13:I13').cellStyle = valueStyle;

      sheet.getRangeByName('G14').setText('Stenter No.');
      sheet.getRangeByName('G14').cellStyle = labelStyle;
      sheet.getRangeByName('H14:I14').setText('');
      sheet.getRangeByName('H14:I14').cellStyle = valueStyle;

      sheet.getRangeByName('G15').setText('Loom No');
      sheet.getRangeByName('G15').cellStyle = labelStyle;
      sheet.getRangeByName('H15:I15').setText('');
      sheet.getRangeByName('H15:I15').cellStyle = valueStyle;

      sheet.getRangeByName('G16').setText('Beam No');
      sheet.getRangeByName('G16').cellStyle = labelStyle;
      sheet.getRangeByName('H16:I16').setText('');
      sheet.getRangeByName('H16:I16').cellStyle = valueStyle;

      sheet.getRangeByName('G17').setText('No of Samples');
      sheet.getRangeByName('G17').cellStyle = labelStyle;
      sheet.getRangeByName('H17:I17').setText('1');
      sheet.getRangeByName('H17:I17').cellStyle = valueStyle;

      sheet.getRangeByName('G18').setText('R.S');
      sheet.getRangeByName('G18').cellStyle = labelStyle;
      sheet.getRangeByName('H18:I18').setText('');
      sheet.getRangeByName('H18:I18').cellStyle = valueStyle;

      sheet.getRangeByName('G19').setText('P/c Roll No Result');
      sheet.getRangeByName('G19').cellStyle = labelStyle;
      sheet.getRangeByName('H19:I19').setText('24045849');
      sheet.getRangeByName('H19:I19').cellStyle = yellowValueStyle;

      // --- Table Data (B21:I63) ---
      for (int i = 0; i < testData.length; i++) {
        int row = 22 + i;

        sheet.getRangeByName('C$row:D$row').merge();
        sheet.getRangeByName('B$row').setValue(testData[i][0]);
        sheet.getRangeByName('C$row:D$row').setValue(testData[i][1]);
        sheet.getRangeByName('E$row').setValue(testData[i][2]);
        sheet.getRangeByName('F$row').setValue(testData[i][3]);
        sheet.getRangeByName('G$row').setValue(testData[i][4]);
        sheet.getRangeByName('H$row').setValue(testData[i][5]);
        sheet.getRangeByName('I$row').setValue(testData[i][6]);

        final dataStyle = workbook.styles.add('dataStyle$row');
        dataStyle
          ..hAlign = xlsio.HAlignType.center
          ..vAlign = xlsio.VAlignType.center
          ..borders.all.lineStyle = xlsio.LineStyle.thin
          ..borders.all.color = '#000000'
          ..wrapText = true;

        sheet.getRangeByName('B$row').cellStyle = dataStyle;
        sheet.getRangeByName('C$row:D$row').cellStyle = dataStyle;
        sheet.getRangeByName('E$row').cellStyle = dataStyle;
        sheet.getRangeByName('F$row').cellStyle = dataStyle;
        sheet.getRangeByName('G$row').cellStyle = dataStyle;
        sheet.getRangeByName('H$row').cellStyle = dataStyle;
        sheet.getRangeByName('I$row').cellStyle = dataStyle;
      }

      sheet.getRangeByName('B21').setText('Test');
      sheet.getRangeByName('C21:D21').setText('Test Method No.');
      sheet.getRangeByName('E21').setText('Result');
      sheet.getRangeByName('F21').setText('Standard');
      sheet.getRangeByName('G21').setText('Minimum');
      sheet.getRangeByName('H21').setText('Maximum');
      sheet.getRangeByName('I21').setText('Remarks');

      sheet.getRangeByName('B21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('C21:D21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('E21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('F21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('G21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('H21').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('I21').cellStyle = tableHeaderStyle;

      // --- Footer Section (B64:I69) ---
      sheet.getRangeByName('B64:C64').merge();
      sheet.getRangeByName('B65:C65').merge();
      sheet.getRangeByName('B66:C66').merge();
      sheet.getRangeByName('B67:C67').merge();
      sheet.getRangeByName('B68:C68').merge();
      sheet.getRangeByName('G64:I64').merge();
      sheet.getRangeByName('G65:I65').merge();
      sheet.getRangeByName('G66:I66').merge();
      sheet.getRangeByName('D64:F64').merge();
      sheet.getRangeByName('D65:F65').merge();
      sheet.getRangeByName('D66:F66').merge();
      sheet.getRangeByName('D67:I67').merge();
      sheet.getRangeByName('D68:E68').merge();
      sheet.getRangeByName('F68:G68').merge();
      sheet.getRangeByName('H68:I68').merge();
      sheet.getRangeByName('B69:I69').merge();

      sheet.getRangeByName('B64:C64').setText('Final Flag');
      sheet.getRangeByName('B64:C64').cellStyle = tableHeaderStyle;

      sheet.getRangeByName('B65:C65').setText('Tested By');
      sheet.getRangeByName('B65:C65').cellStyle = tableHeaderStyle;

      sheet.getRangeByName('B66:C66').setText('Anil Pandit');
      sheet.getRangeByName('B66:C66').cellStyle = type7;

      sheet.getRangeByName('B67:C67').setText('Remarked By:');
      sheet.getRangeByName('B67:C67').cellStyle = type11;

      sheet.getRangeByName('B68:C68').setText('Verified by:');
      sheet.getRangeByName('B68:C68').cellStyle = type11;

      sheet.getRangeByName('G64:I64').setText('For : Kusumgar Limited');
      sheet.getRangeByName('G64:I64').cellStyle = tableHeaderStyle;
      sheet.getRangeByName('G64:I64').cellStyle.borders.bottom.lineStyle = xlsio.LineStyle.none;

      sheet.getRangeByName('G65:I65').cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      sheet.getRangeByName('G65:I65').cellStyle.borders.all.color = '#000000';
      sheet.getRangeByName('G65:I65').cellStyle.borders.top.lineStyle = xlsio.LineStyle.none;
      sheet.getRangeByName('G65:I65').cellStyle.borders.bottom.lineStyle = xlsio.LineStyle.none;

      sheet.getRangeByName('D64:F64').setText('OK');
      sheet.getRangeByName('D64').cellStyle = type4;

      sheet.getRangeByName('D65:F65').setText('Prepared By');
      sheet.getRangeByName('D65:F65').cellStyle = tableHeaderStyle;

      sheet.getRangeByName('D66:F66').setText('Chandan Verma');
      sheet.getRangeByName('D66').cellStyle = type4;

      sheet.getRangeByName('D67:I67').setText('All Parameters are ok ,');
      sheet.getRangeByName('D67:I67').cellStyle = type8;

      sheet.getRangeByName('D68:E68').setText('qa.vapi');
      sheet.getRangeByName('D68').cellStyle = type8;

      sheet.getRangeByName('F68:G68').setText('Verified Date Time');
      sheet.getRangeByName('F68').cellStyle = type5;

      sheet.getRangeByName('H68:I68').setText('26-04-2025  13:01:51');
      sheet.getRangeByName('H68').cellStyle = type5;

      sheet.getRangeByName('B69:I69').setText('This is ERP generated report henceforth no signature required');
      sheet.getRangeByName('B69:I69').cellStyle = type6;

      // --- Apply Borders ---
      final tableRange = sheet.getRangeByName('B21:I63');
      tableRange.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      tableRange.cellStyle.borders.all.color = '#000000';

      final table2Range = sheet.getRangeByName('B64:I69');
      table2Range.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      table2Range.cellStyle.borders.all.color = '#000000';

      for (int row = 1; row <= 69; row++) {
        final cellA = sheet.getRangeByIndex(row, 1);
        cellA.cellStyle = rightBorderStyle;
      }

      for (int row = 1; row <= 4; row++) {
        sheet.getRangeByName('I$row').cellStyle = rightBorderStyle;
      }

      for (int row = 6; row <= 20; row++) {
        sheet.getRangeByName('I$row').cellStyle = rightBorderStyle;
      }



























      // --- Save and Export the Excel File ---
      List<int>? bytes;
      try {
        bytes = workbook.saveAsStream();
      } catch (e) {
        throw Exception('Failed to save Excel file: $e');
      } finally {
        workbook.dispose();
      }

      if (bytes == null || bytes.isEmpty) {
        throw Exception('Excel file generation failed: No data generated');
      }

      if (kIsWeb) {
        try {
          final blob = html.Blob(
              [bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', '$fileNameBase.xlsx')
            ..click();
          html.Url.revokeObjectUrl(url);

          _message = 'Excel file downloaded! Check your downloads folder.';
        } catch (e) {
          _message = 'Error downloading file on web: $e';
        }
      } else {
        try {
          final String path = (await getApplicationSupportDirectory()).path;
          final String fileName = '$path/$fileNameBase.xlsx';
          final File file = File(fileName);
          try {
            await file.writeAsBytes(bytes, flush: true);
          } catch (e) {
            throw Exception('Failed to save file on mobile: $e');
          }

          try {
            final result = await OpenFilex.open(fileName);
            _message = result.type == ResultType.done
                ? 'Excel file created and opened!'
                : 'Error opening file: ${result.message}';
          } catch (e) {
            _message = 'Error opening file on mobile: $e';
          }
        } catch (e) {
          _message = 'Error saving file on mobile: $e';
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error in createExcel: $e\nStack trace: $stackTrace');
      _message = 'Error generating Excel file: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}