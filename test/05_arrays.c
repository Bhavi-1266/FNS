/* Feature: arrays of int and char: initialisation, partial init (zero fill), inferred size,
   passing to functions, searching/sorting, strings as char arrays, sizeof. */
#include <stdio.h>

int sum(int a[], int n) { int s = 0; for (int i = 0; i < n; i++) s += a[i]; return s; }

void bubble_sort(int *a, int n) {
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - 1 - i; j++)
            if (a[j] > a[j + 1]) { int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t; }
}

int binary_search(const int *a, int n, int key) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        if (a[mid] == key) return mid;
        if (a[mid] < key) lo = mid + 1; else hi = mid - 1;
    }
    return -1;
}

int my_strlen(const char s[]) { int n = 0; while (s[n] != '\0') n++; return n; }

void reverse(char s[]) {
    int n = my_strlen(s);
    for (int i = 0; i < n / 2; i++) { char t = s[i]; s[i] = s[n - 1 - i]; s[n - 1 - i] = t; }
}

int global_arr[5];
char global_msg[] = "global";

int main() {
    int a[8] = {42, 7, 19, 3, 88, -5, 0, 19};
    int partial[6] = {1, 2};
    int inferred[] = {10, 20, 30};
    printf("sizeof a=%d inferred=%d n=%d\n", (int)sizeof(a), (int)sizeof(inferred),
           (int)(sizeof(inferred) / sizeof(inferred[0])));
    for (int i = 0; i < 6; i++) printf("%d ", partial[i]);
    printf("\nsum=%d\n", sum(a, 8));
    bubble_sort(a, 8);
    for (int i = 0; i < 8; i++) printf("%d ", a[i]);
    printf("\nfind 19 -> %d, find 4 -> %d\n", binary_search(a, 8, 19) >= 0, binary_search(a, 8, 4));

    for (int i = 0; i < 5; i++) global_arr[i] = i * i;
    printf("global: %d %d %s\n", global_arr[0], global_arr[4], global_msg);

    char word[20] = "compiler";
    char letters[] = {'m', 'i', 'p', 's', '\0'};
    printf("%s %d %s %d\n", word, my_strlen(word), letters, (int)sizeof(letters));
    reverse(word);
    printf("reversed: %s\n", word);
    word[3] = '\0';
    printf("truncated: %s\n", word);

    /* character counting */
    char text[] = "Hello, World! 123";
    int up = 0, low = 0, dig = 0, other = 0;
    for (int i = 0; text[i]; i++) {
        char c = text[i];
        if (c >= 'A' && c <= 'Z') up++;
        else if (c >= 'a' && c <= 'z') low++;
        else if (c >= '0' && c <= '9') dig++;
        else other++;
    }
    printf("upper=%d lower=%d digits=%d other=%d\n", up, low, dig, other);

    /* array of strings */
    const char *days[] = {"Mon", "Tue", "Wed"};
    char names[3][8] = {"ann", "bob", "cy"};
    for (int i = 0; i < 3; i++) printf("%s-%s ", days[i], names[i]);
    printf("\n%c%c\n", names[1][0], days[2][2]);

    /* modifying through index arithmetic */
    int fib[12];
    fib[0] = 0; fib[1] = 1;
    for (int i = 2; i < 12; i++) fib[i] = fib[i - 1] + fib[i - 2];
    printf("fib[11]=%d\n", fib[11]);
    return 0;
}
