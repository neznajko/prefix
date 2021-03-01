## prefix
**T***hus* is a nice problem, the text and the link are in *prefix.c*.
There is an alphabet of capital letters e.g. **{A,B,C,D}**, which 
represent *constituents* of some biological objects. And a string of
characters (**S**), which according to text might has a length up to
*500,000!* Also there is given a set of *primitives* let's say
**{"A", "BA", "CAB", "D"}**. The task is to find the so called *prefix*
of *S*, it's the longest possible substring originating from *0*,
that can be represented as a concatenation of *primitives*. For example 
the *prefix* of ``ADABACABCAA`` is ``A+D+A+BA+CAB=ADABACAB``.

**H***aving* in mind the upper boundary, initially I tried to search for
an immediate approach, but couldn't find one, and figured a solution
similar to ***bfs*** with a *Queue*. As it turns out, even if we have
an infinite string, that wouldn't affect the algorithm's performance,
because the probability of having *prefix* with length *500,000* is
*dzero*. I've made simple analysis of the algorithm's time complexity,
and came up with a *O(n)* solution, where *n* is the number of 
*primitives*, could be wrong of course.

```bash
If {p[j]|0 <= j < n} is the set of primitives, and s is the
probability of a single match, that is 1/len(A), where A is the
alphabet, than the probability of matching a primitive is:

 b:=sum{j=0,n-1}[s**(len<p[j]>)].

If we consider all primitives having equal lengths w, than

 b = n[s**{w}].

Now the Q is; What is the probability of having exactly N
matches[boom] We must endup with a failure, so the answer is:

 e(N):= b**{N}(1 - b).

The avearge N iz:

 E[N] = sum{j=0,inf}(Ne[N]) = (1 - b)sum{j=0,inf}(Nb**{N}) =

 = (1 - b)b/(1 - b)**2 = b/(1 - b)

If prefix has length k, than in the worst case k + 1 letters
have been visited and on each letter n primitives are checked
for total running time O(kn), now we can use the above
formula as k ~ wE[N], and O(kn) = O(bn/(1 - b)) = O(n).
```
