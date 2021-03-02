#!/bin/bash
P=("AB" "B" "CD" "DA")
T="BABDACAB"
COPY=${T}
# Ok let's try mkfifo, not for Frodo, but for fun.
pipe=/tmp/queue
if [ ! -p ${pipe} ]; then
  mkfifo ${pipe}
fi
# create file descriptor for r/w
exec 3<> ${pipe}
push()
{
  echo ${1} >${pipe}
}
pop()
{
  if read -t 1 line <&4; then
    echo ${line}
  else
    echo -1 # timeout
  fi
}
mark()
{
  j=${1}
  printf -v COPY "${COPY:0:j}*${COPY:j+1}"
}
vangard=-1
push 0
while :; do
  j=$(pop)
  (( j == -1 )) && break
  [ "${COPY:j:1}" == "*" ] && continue
  (( j > vangard )) && vangard=${j}
  for p in ${P[@]}; do
    k=${#p}
    [ $p == ${T:j:k} ] && push $((j + k))
  done
  mark ${j}
done
echo ${T}
echo ${COPY}
echo "Prefix lenght: ${vangard}"
# close file descriptor
exec 3<&-
# log:
