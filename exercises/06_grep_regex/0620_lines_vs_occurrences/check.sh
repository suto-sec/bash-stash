# checker spec for 0620 (see lib/engine.sh)
setup() {
  local i j
  for i in $(seq "$(randr 8 14)"); do
    for j in $(seq "$(randr 1 6)"); do pick kernel Kernel KERNEL kernels kernel_x kernel-x mykernel linux shell kernel. process; done | tr '\n' ' '
    echo
  done > texto.txt
}
