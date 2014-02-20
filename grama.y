%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char*);

%}

%union
{
    const char* str_name;
    const char* str_string_literal;
    const char* str_guid;
    const char* str_cgtime;
    const char* str_type_char;
};

%type <str_name> _NAME
%type <str_string_literal> _STRING_LITERAL
%type <str_guid> _GUID
%type <str_cgtime> _CGTIME
%type <str_type_char> _TYPE_CHAR

%token _INT
%token _FLOAT
%token _GUID
%token _GUID_STR
%token _OLDID_STR
%token _TEXTRTF_STR
%token _STRING_LITERAL
%token _RPY_ARCHIVE_VERSION_STR
%token _RPY_ARCHIVE_VERSION_NO
%token _CPP_STR
%token _NAME
%token _TYPE_CHAR
%token _CGTIME
%token _OBRACE
%token _EBRACE

%%

sbs:        sbs_header
            {
                const char * header = "<?xml version=\"1.0\" ?>\n";
                printf(header);
            }
            definitions
            ;

sbs_header: _RPY_ARCHIVE_VERSION_STR _RPY_ARCHIVE_VERSION_NO _CPP_STR _INT
            ;

definitions:
            | definitions definition
            ;

definition: _OBRACE _NAME
            {
                printf("<%s>", $2);
            }
            properties _EBRACE
            {
                printf("</%s>\n", $2);
                free((void*)$2);
            }
           ;

properties:
            | properties property
            ;

property:   '-' _NAME '=' definition
            | '-' _NAME '=' numbers ';'
            | '-' _NAME '=' _GUID_STR _GUID ';'
            {
                printf("<%s>%s</%s>", $2, $5, $2);
                free((void*)$2);
                free((void*)$5);
            }
            | '-' _NAME '=' _OLDID_STR numbers ';'
            | '-' _NAME '=' _CGTIME ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
                free((void*)$2);
                free((void*)$4);
            }
            | '-' _NAME '=' _STRING_LITERAL numbers ';'
            | '-' _NAME '=' _STRING_LITERAL ';'
            {
                const char* str_4 = strip_string_quotes($4);
                printf("<%s><![CDATA[%s]]></%s>\n", $2, str_4, $2);
                free((void*)$2);
                free((void*)$4);
            }
            | '-' _NAME '=' _TYPE_CHAR ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
                free((void*)$2);
                free((void*)$4);
            }
            | '-' _NAME '=' _NAME ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
                free((void*)$2);
                free((void*)$4);
            }
            | '-' _TEXTRTF_STR '=' _STRING_LITERAL ';'
            | definition
            ;

numbers:
            | numbers number
            ;

number:     _INT
            | '-' _INT
            | _FLOAT
            | '-' _FLOAT
            ;

%%
