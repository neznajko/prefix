package main
import "fmt"
// Queue
func makequeue() []int {
  return make([]int, 0)
}
func push(Q *[]int, j int) {
  *Q = append(*Q, j)
}
func pop(Q *[]int) int {
  j := (*Q)[0]
  *Q = (*Q)[1:]
  return j
}
// Get lengths of primitives P
func getlen(P []string) []int {
  var L []int
  for _, p := range(P) {
    L = append(L, len(p))
  }
  return L
}
func main() {
  P := []string {"A", "AB", "CA", "BAC"} // primitives
  L := getlen(P)
  T := "ACABACBA" // the biological object
  V := make([]bool, len(T)) // visited history
  a := -1 // vanguard
  Q := makequeue()
  // Ok let's go
  push(&Q, 0)
  for 0 < len(Q) {
    j := pop(&Q)
    if V[j] == true { continue }
    if j > a { a = j }
    for i, p := range(P) {
      k := j + L[i]
      if k > len(T) { continue }
      if p == T[j:k] {
        push(&Q, k)
      }
    }
    V[j] = true;
  }
  fmt.Println(V, "Prefix length: ", a)
}
// log:
