sbs2xml-conv
============

Very simple SBS (IBM Rhapsody) file format converter to XML.

##Rationale

In various projects using IBM Rhapsody 7.5 RAD environment additional automation is required or welcomed. There are few ways to access data stored in SBS / CLS Rhapsody’s file formats (e.g. using Rhapsody plugins).

In order to extract classes, methods, function names, bodies (code) etc. you can convert your SBS / CLS files to friendly XML format and parse them using your favourite XML parser.

You can for example create your own “stupid” code generator for the CLS (class file) and extract all classes, functions etc. to separate file(s) in format you prefer and with transformation you wish to apply.

Blocks of data which should not be parsed by XML are encapsulated in CDATA sections (http://www.w3schools.com/xml/xml_cdata.asp). Make sure your favourite XML parser supports it before you parse sbs2xml parser output. For example TinyXML library will support it well (http://www.grinninglizard.com/tinyxml/).

Sbs2xml parser will output not indented XML data. If you want “pretty print” XML you can use Notepad++ and XML Tools plugin to format output XML properly.

##External SW dependencies

    make  - Controls the generation of executable.
    flex  - Tokenizer: http://flex.sourceforge.net/
    bison - GNU parser generator: http://www.gnu.org/software/bison/
    gawk  - GNU AWK special-purpose programming language: http://www.gnu.org/software/gawk/
