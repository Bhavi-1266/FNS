/* Valid: multi-level pointers, scaled pointer arithmetic for char/int/double/struct,
   pointer comparison, void*, nullptr, pointer<->integer casts, sizeof through pointers. */
struct P { int x; double d; char c; };
int main(void) {
    int v = 3; int *p = &v; int **pp = &p; int ***ppp = &pp;
    ***ppp = 7; **pp += 1; (*p)++; *p = **pp + ***ppp;
    int *q = *pp; int **qq = pp + 1;         /* scale 4 */
    char cbuf[4]; char *cp = cbuf; cp += 2; cp++;   /* scale 1 */
    double dv[3]; double *dp = dv + 1;             /* scale 8 */
    struct P arr[2]; struct P *sp = arr; sp++;     /* scale sizeof(P) */
    sp->x = 1; (*sp).d = 2.0; arr[1].c = 'z'; (sp - 1)->x = 4;
    struct P **spp = &sp; (*spp)->x = 9; (**spp).x++;
    int n = p == q; int m = p != 0; int o = !p;
    void *vp = p; p = vp; vp = 0; p = nullptr;
    int *np = 0; if (np) v++; if (!np) v--;
    long diff = p - q;
    int casted = (int) p; int *back = (int *) casted; char *cc = (char *) p;
    unsigned char uc = (char) v;
    int si = sizeof(struct P); int sp2 = sizeof(sp); int sd = sizeof(*dp); int spp2 = sizeof(**spp);
    return v + n + m + o + (int) diff + casted + *back + *cc + uc + si + sp2 + sd + spp2 + (int)(dp - dv) + (int)(qq - pp);
}
