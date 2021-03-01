/***************************************************************
 *                                     Problem 5: Longest Prefix 
 *    The structure of some biological objects is represented by 
 *    the sequence of their constituents. These constituents are
 *    denoted by uppercase letters. Biologists are interested in
 *    decomposing a long sequence into shorter ones. These short
 * sequences are called primitives. We say that a sequence S can
 *  be composed from a given set of primitives P, if there are n
 * primitives p1,...,pn in P such that the concatenation p1...pn
 *           of the primitives equals S. By the concatenation of 
 *    primitives p1,...,pn we mean putting them together in that
 *  order without blanks. The same primitive can occur more than
 *  once in the concatenation and not necessarily all primitives
 *     are present. For instance the sequence ABABACABAAB can be 
 * composed from the set of primitives {A, AB, BA, CA, BBC}. The
 *     first K characters of S are the prefix of S with length K.
 *  Write a program which accepts as input a set of primitives P 
 *    and a sequence of constituents T. The program must compute 
 *   the length of the longest prefix, that can be composed from
 *                                               primitives in P.
 *                                                             *
 * Example:                                                    *
 * Input:                                                      *
 * P: A,AB,BBC,CA,BA                                           *
 * T: ABABACABAABCB                                            *
 * Output: 11                                                  *
 * https://ioinformatics.org/files/ioi1996problem5.pdf         */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define QSIZ 256 // Queue SIZe
//            0   1    2     3    4
char *P[] = {"A","AB","BBC","CA","BA"};
int len[] = { 1,  2,   3,    2,   2};
//         0123456789012
char *T = "ABABACABAABCB";
int N = (sizeof P)/(sizeof *P);
int Q[QSIZ]; // the queue
int F = 0, R = 0; // front and rear pointers
#define empty() (F == R)
int pop(void)
{
  int value = Q[F];
  if (++F == QSIZ) F = 0;
  return value;
}
void push(int value)
{
  Q[R] = value;
  if (++R == QSIZ) R = 0;
}
int ck(int i, int j)
// Check if P[j] matches a string originating from T[i]
{
  return !strncmp(T + i, P[j], len[j]);
}
int main(void)
{
  char *copy = (char *) malloc(strlen(T) + 1); // visited ck
  strcpy(copy, T);
  push(0);
  int vanguard = -1; // yeah!
  while (!empty()) {
    int i = pop();
    if (copy[i] == '*') continue;
    if (vanguard < i) vanguard = i;
    for (int j = 0; j < N; ++j) {
      if (ck(i, j)) push(i + len[j]);
    }
    copy[i] = '*'; // mark as visited
  }
  printf("%d\n", vanguard);
}
// log: gcc prefix.c && ./a.out
