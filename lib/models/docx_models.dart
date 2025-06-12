class TextRun {
  final String text;
  final bool isBold;

  TextRun(this.text, {this.isBold = false});
}

class DocxParagraph {
  final List<TextRun> runs;
  final String style;
  final int? spacingAfter;

  DocxParagraph(this.runs, {this.style = 'Normal', this.spacingAfter});
}

class DocxStyle {
  final String id;
  final String name;
  final int fontSize;
  final bool bold;
  final String alignment;
  final int spacingBefore;

  DocxStyle({
    required this.id,
    required this.name,
    required this.fontSize,
    this.bold = false,
    this.alignment = 'left',
    this.spacingBefore = 0,
  });
}

class DocxDocument {
  final List<DocxParagraph> paragraphs;
  final List<DocxStyle> styles;

  DocxDocument({required this.paragraphs, required this.styles});

  String toDocumentXml() {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.writeln(
        '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">');
    buffer.writeln('<w:body>');

    for (var para in paragraphs) {
      buffer.writeln('<w:p>');
      buffer.writeln('<w:pPr>');
      if (para.style.isNotEmpty) {
        buffer.writeln('<w:pStyle w:val="${para.style}"/>');
      }
      if (para.spacingAfter != null) {
        buffer.writeln('<w:spacing w:after="${para.spacingAfter}"/>');
      }
      buffer.writeln('</w:pPr>');
      for (var run in para.runs) {
        buffer.writeln('<w:r>');
        buffer.writeln('<w:rPr>');
        if (para.style == 'Normal') {
          buffer.writeln('<w:b w:val="${run.isBold ? 'true' : 'false'}"/>');
        } else {
          if (run.isBold) {
            buffer.writeln('<w:b/>');
          }
        }
        buffer.writeln('</w:rPr>');
        buffer.writeln('<w:t xml:space="preserve">${run.text}</w:t>');
        buffer.writeln('</w:r>');
      }
      buffer.writeln('</w:p>');
    }

    buffer.writeln('<w:sectPr>');
    buffer.writeln('<w:pgSz w:w="12240" w:h="15840"/>');
    buffer.writeln(
        '<w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0"/>');
    buffer.writeln('<w:cols w:space="720"/>');
    buffer.writeln('</w:sectPr>');

    buffer.writeln('</w:body>');
    buffer.writeln('</w:document>');
    return buffer.toString();
  }

  String toStylesXml() {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.writeln(
        '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">');

    for (var style in styles) {
      buffer.writeln('<w:style w:type="paragraph" w:styleId="${style.id}">');
      buffer.writeln('<w:name w:val="${style.name}"/>');
      buffer.writeln('<w:rPr>');
      buffer.writeln('<w:sz w:val="${style.fontSize}"/>');
      if (style.bold) {
        buffer.writeln('<w:b/>');
      }
      buffer.writeln('</w:rPr>');
      if (style.alignment != 'left' || style.spacingBefore > 0) {
        buffer.writeln('<w:pPr>');
        if (style.alignment != 'left') {
          buffer.writeln('<w:jc w:val="${style.alignment}"/>');
        }
        if (style.spacingBefore > 0) {
          buffer.writeln('<w:spacing w:before="${style.spacingBefore}"/>');
        }
        buffer.writeln('</w:pPr>');
      }
      buffer.writeln('</w:style>');
    }

    buffer.writeln('</w:styles>');
    return buffer.toString();
  }
}