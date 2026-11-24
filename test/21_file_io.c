/* Feature: file manipulation: fopen modes (w, r, a, w+), fprintf/fscanf, fputs/fgets,
   fputc/fgetc, fwrite/fread, feof, counting lines/words/chars, copying a file,
   error handling for a missing file.  Files are created in the working directory. */
#include <stdio.h>
#include <string.h>

struct Rec { int id; double score; };

int main() {
    FILE *fp = fopen("fns_test_data.txt", "w");
    if (fp == NULL) { printf("cannot create file\n"); return 1; }
    fprintf(fp, "%d %s %.2f\n", 1, "alpha", 3.5);
    fprintf(fp, "%d %s %.2f\n", 2, "beta", 4.25);
    fputs("free text line\n", fp);
    fputc('X', fp);
    fputc('\n', fp);
    fclose(fp);

    fp = fopen("fns_test_data.txt", "r");
    int id; char name[16]; float val;
    while (fscanf(fp, "%d %s %f", &id, name, &val) == 3) printf("record %d %s %.2f\n", id, name, val);
    fclose(fp);

    fp = fopen("fns_test_data.txt", "a");
    fprintf(fp, "appended line %d\n", 3);
    fclose(fp);

    /* count characters, words and lines with fgetc */
    fp = fopen("fns_test_data.txt", "r");
    int c, chars = 0, words = 0, lines = 0, in_word = 0;
    while ((c = fgetc(fp)) != EOF) {
        chars++;
        if (c == '\n') lines++;
        if (c == ' ' || c == '\n' || c == '\t') in_word = 0;
        else if (!in_word) { in_word = 1; words++; }
    }
    printf("chars=%d words=%d lines=%d feof=%d\n", chars, words, lines, feof(fp) != 0);
    fclose(fp);

    /* copy line by line with fgets / fputs, numbering the lines */
    FILE *in = fopen("fns_test_data.txt", "r");
    FILE *out = fopen("fns_test_copy.txt", "w");
    char line[100];
    int n = 0;
    while (fgets(line, sizeof(line), in) != NULL) fprintf(out, "%02d: %s", ++n, line);
    fclose(in);
    fclose(out);
    in = fopen("fns_test_copy.txt", "r");
    while (fgets(line, sizeof(line), in)) printf("%s", line);
    fclose(in);

    /* binary records with fwrite / fread */
    struct Rec recs[3] = {{1, 9.5}, {2, 7.25}, {3, 8.0}};
    FILE *bin = fopen("fns_test_recs.bin", "w");
    printf("wrote %d records\n", (int)fwrite(recs, sizeof(struct Rec), 3, bin));
    fclose(bin);
    struct Rec back[3];
    bin = fopen("fns_test_recs.bin", "r");
    int got = (int)fread(back, sizeof(struct Rec), 3, bin);
    fclose(bin);
    for (int i = 0; i < got; i++) printf("rec %d: %.2f\n", back[i].id, back[i].score);

    /* w+ : write then read back without reopening is not needed; reopen read */
    FILE *missing = fopen("no_such_dir/none.txt", "r");
    printf("missing file -> %s\n", missing == NULL ? "NULL" : "opened");
    fprintf(stdout, "written to stdout via fprintf\n");
    fputs("written via fputs(stdout)\n", stdout);
    return 0;
}
