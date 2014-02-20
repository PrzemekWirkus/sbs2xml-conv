%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char*);

char* string_add_front(const char* prefix, const char* delimiter, const char* str);

%}

%union
{
    const char* str_name;
    const char* str_string_literal;
    const char* str_guid;
    const char* str_cgtime;
    const char* str_type_char;
    const char* str_int;
    const char* str_float;
    char* str_number;
    char* str_numbers;
};

%type <str_name> _NAME
%type <str_string_literal> _STRING_LITERAL
%type <str_guid> _GUID
%type <str_cgtime> _CGTIME
%type <str_type_char> _TYPE_CHAR
%type <str_int> _INT
%type <str_float> _FLOAT

%type <str_number> number
%type <str_numbers> numbers

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
            {
                printf("<%s>%s</%s>", $2, $4, $2);
            }
            | '-' _NAME '=' _GUID_STR _GUID ';'
            {
                printf("<%s>GUID %s</%s>", $2, $5, $2);
            }
            | '-' _NAME '=' _OLDID_STR numbers ';'
            {
                printf("<%s>OLDID %s</%s>\n", $2, $5, $2);
            }
            | '-' _NAME '=' _CGTIME ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
            }
            | '-' _NAME '=' _STRING_LITERAL numbers ';'
            {
                printf("<%s>%s %s</%s>\n", $2, $4, $5, $2);
            }
            | '-' _NAME '=' _STRING_LITERAL ';'
            {
                printf("<%s><![CDATA[%s]]></%s>\n", $2, $4, $2);
            }
            | '-' _NAME '=' _TYPE_CHAR ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
            }
            | '-' _NAME '=' _NAME ';'
            {
                printf("<%s>%s</%s>\n", $2, $4, $2);
            }
            | '-' _TEXTRTF_STR '=' _STRING_LITERAL ';'
            | definition
            ;

numbers:    { $$ = _strdup(""); }
            | numbers number 
            {
                if ($1[0] == '\0')
                {
                    $$ = _strdup($2); 
                }
                else
                {
                    $$ = string_add_front($1, " ", $2); 
                }
            }
            ;

number:     _INT            { $$ = $1; }
            | '-' _INT      { $$ = string_add_front("-", "", $2); }
            | _FLOAT        { $$ = $1; }
            | '-' _FLOAT    { $$ = string_add_front("-", "", $2); }
            ;

%%
