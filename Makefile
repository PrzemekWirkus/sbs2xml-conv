# Project sbs2xml
#
# About:
# Simple parser which will convert your IBM Rhapsody SBS files to XML format.
#
# Usage:
#
# To compile and build whole project:
#   make all
#
# To convert 'myfile.sbs' to simple XML output
#   cat myfile.sbs | sbs2xml
#   cat myfile.sbs | sbs2xml > myfile.xml
#
# Notes:
# YY_BUF_SIZE is too small to parse bigger SBS files so we need to change it
#
# Versions:
# Version 0.2, February 2014 - added to GitHub.
# Version 0.1, April 2013 - concept developed.

# Uncomment below if you have problem with Make on Windows
SHELL=C:/Windows/System32/cmd.exe

CPP=g++ -O2 -fpermissive
CC=gcc -O2
YACC=bison -d
LEXX=flex
GAWK=gawk
EXECUTABLE_NAME=sbs2xml

SOURCE = main.cpp
YACC_LEXX_SOURCE = lex.yy.c grama.tab.c
OBJS = $(patsubst %.c, %.o, $(YACC_LEXX_SOURCE)) $(patsubst %.cpp, %.o, $(SOURCE))

flex:
	${LEXX} lexer.l
	${GAWK} "/#define YY_BUF_SIZE/{gsub(/16384/, "(1024*1024)")};{print}" lex.yy.c > lex.yy.c.new
	rm -f lex.yy.c
	mv lex.yy.c.new lex.yy.c

bison:
	$(YACC) grama.y

all: flex bison ${OBJS}
	${CC} ${YACC_LEXX_SOURCE} -c
	${CPP} ${SOURCE} -c
	${CPP} -s ${OBJS} -o ${EXECUTABLE_NAME}.exe

clean:
	rm -f *.o
	rm -f grama.tab.c grama.tab.h lex.yy.c ${EXECUTABLE_NAME}.exe

help:
	@echo sbs2xml Makefile help, 2014
	@echo Make options:
	@echo   make all   - build all
	@echo   make flex  - only generate Flex files
	@echo   make bison - only generate Bison files
	@echo   make clean - clean all
	@echo   make help  - Print this help
