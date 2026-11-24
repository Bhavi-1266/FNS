/* Feature: command line input: argc / argv (run.sh passes test/args/20_command_line.args). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    printf("argc = %d\n", argc);
    for (int i = 1; i < argc; i++) printf("argv[%d] = \"%s\" (length %d)\n", i, argv[i], (int)strlen(argv[i]));
    if (argc < 4) { printf("usage: prog <op> <a> <b> [words...]\n"); return 1; }
    int a = atoi(argv[2]), b = atoi(argv[3]);
    char op = argv[1][0];
    int r = op == 'a' ? a + b : op == 's' ? a - b : op == 'm' ? a * b : 0;
    printf("%c(%d, %d) = %d\n", op, a, b, r);
    int longest = 4;
    for (int i = 4; i < argc; i++) if (strlen(argv[i]) > strlen(argv[longest])) longest = i;
    if (argc > 4) printf("longest word: %s\n", argv[longest]);
    double total = 0;
    for (int i = 2; i < 4; i++) total += atof(argv[i]);
    printf("total as double = %.1f\n", total);
    printf("argv[argc] is %s\n", argv[argc] == NULL ? "NULL" : "not NULL");
    return 0;
}
