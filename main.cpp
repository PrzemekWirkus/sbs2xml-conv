#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>

extern "C"
{
    struct yy_buffer_state;
    int yylex(void);
    int yyparse ();
    yy_buffer_state* yy_create_buffer(FILE*, int);
    void yy_switch_to_buffer(yy_buffer_state*);

    void yyerror(const char* str)
    {
        printf("%s", str);
    }

    extern int yydebug;

    const char* strip_string_quotes(char* str)
    {
        const int len = strlen(str);
        str[len - 1] = '\0';
        return str + 1;
    }
    
    void print_xml_special_characters(const char* str)
    {
        const int len = strlen(str);
        for (int i = 0; i < len; i++)
        {
            const char c = str[i];
            switch (c)
            {
                case '"':  printf("&quot;"); break;
                case '&':  printf("&amp;");  break;
                case '\'': printf("&apos;"); break;
                case '<':  printf("&lt;");   break;
                case '>':  printf("&gt;");   break;
                default: printf("%c", c);
            }
        }
    }
}

int main(int argc, char *argv[])
{
    int ret = yyparse();
    return ret;
}
