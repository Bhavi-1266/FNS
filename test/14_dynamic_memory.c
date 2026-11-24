/* Feature: dynamic memory: malloc, calloc, realloc, free, dynamic arrays, dynamic strings,
   dynamic 2-D arrays, a linked list, a stack and a binary search tree on the heap,
   allocation failure (an impossible size gives NULL and leaves old blocks intact). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node { int data; struct Node *next; } Node;
typedef struct Tree { int key; struct Tree *left, *right; } Tree;

Node *push_front(Node *head, int v) {
    Node *n = (Node *)malloc(sizeof(Node));
    n->data = v;
    n->next = head;
    return n;
}

Node *reverse(Node *head) {
    Node *prev = NULL;
    while (head) { Node *next = head->next; head->next = prev; prev = head; head = next; }
    return prev;
}

Tree *insert(Tree *t, int k) {
    if (!t) {
        t = (Tree *)malloc(sizeof(Tree));
        t->key = k; t->left = t->right = NULL;
    } else if (k < t->key) t->left = insert(t->left, k);
    else t->right = insert(t->right, k);
    return t;
}
void inorder(Tree *t) { if (t) { inorder(t->left); printf("%d ", t->key); inorder(t->right); } }
int height(Tree *t) { if (!t) return 0; int l = height(t->left), r = height(t->right); return 1 + (l > r ? l : r); }
void free_tree(Tree *t) { if (t) { free_tree(t->left); free_tree(t->right); free(t); } }

int main() {
    int n = 5;
    int *a = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) a[i] = i * i;
    a = (int *)realloc(a, 2 * n * sizeof(int));     /* grow: old values kept */
    for (int i = n; i < 2 * n; i++) a[i] = -i;
    for (int i = 0; i < 2 * n; i++) printf("%d ", a[i]);
    printf("\n");
    free(a);

    double *z = (double *)calloc(4, sizeof(double));  /* zeroed */
    printf("calloc: %.1f %.1f\n", z[0], z[3]);
    free(z);

    char *s = (char *)malloc(32);
    strcpy(s, "dynamic");
    strcat(s, " string");
    printf("%s (%d)\n", s, (int)strlen(s));
    free(s);

    int rows = 3, cols = 4;
    int **grid = (int **)malloc(rows * sizeof(int *));
    for (int r = 0; r < rows; r++) {
        grid[r] = (int *)malloc(cols * sizeof(int));
        for (int c = 0; c < cols; c++) grid[r][c] = r * cols + c;
    }
    printf("grid[2][3]=%d grid[1][0]=%d\n", grid[2][3], grid[1][0]);
    for (int r = 0; r < rows; r++) free(grid[r]);
    free(grid);

    Node *list = NULL;
    for (int i = 1; i <= 5; i++) list = push_front(list, i * 10);
    list = reverse(list);
    for (Node *p = list; p; p = p->next) printf("%d ", p->data);
    printf("\n");
    while (list) { Node *next = list->next; free(list); list = next; }

    /* stack using a growing array */
    int cap = 2, top = 0;
    int *stack = (int *)malloc(cap * sizeof(int));
    for (int i = 0; i < 9; i++) {
        if (top == cap) { cap *= 2; stack = (int *)realloc(stack, cap * sizeof(int)); }
        stack[top++] = i;
    }
    printf("cap=%d popped:", cap);
    while (top > 0) printf(" %d", stack[--top]);
    printf("\n");
    free(stack);

    Tree *root = NULL;
    int keys[] = {50, 30, 70, 20, 40, 60, 80, 35};
    for (int i = 0; i < 8; i++) root = insert(root, keys[i]);
    inorder(root);
    printf("height=%d\n", height(root));
    free_tree(root);

    /* memory is reused after free */
    void *p1 = malloc(64);
    free(p1);
    void *p2 = malloc(64);
    printf("malloc after free ok: %d\n", p2 != NULL);
    free(p2);
    free(NULL);

    /* allocation failure: NULL is returned, nothing is corrupted */
    char *keep = malloc(8);
    keep[0] = 'k'; keep[1] = 0;
    printf("malloc(SIZE_MAX) -> %s\n", malloc((size_t)-1) == NULL ? "NULL" : "block");
    char *grown = realloc(keep, (size_t)-1);
    printf("failed realloc -> %s, old block still \"%s\"\n", grown == NULL ? "NULL" : "block", keep);
    free(keep);
    return 0;
}
