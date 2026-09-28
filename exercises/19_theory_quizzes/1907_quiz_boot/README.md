# 1907 · Boot: firmware, partitions, GRUB, kernel

**Topic:** Theory quizzes · **Difficulty:** ★★★☆☆ · **Commands:** UEFI, GPT, GRUB, initrd

Answer in `answer.txt` as `N: answer`.

1. Firmware interface that replaced the BIOS. (acronym)
2. Partition table that replaced MBR. (acronym)
3. Maximum number of **primary** partitions in MBR. (number)
4. Maximum number of primary partitions in GPT. (number)
5. Maximum partition size supported by MBR. (e.g. `2TB`)
6. Default second-stage boot loader of most Linux distributions. (name)
7. Command that installs it on a disk (e.g. on `/dev/sda`): only the command name. (command)
8. Configuration file it reads at boot. (path)
9. Ubuntu command that regenerates that file (it should not be edited by hand). (command)
10. File with its general configuration parameters. (path)
11. Usual path of the Linux kernel image. (path)
12. Name of the temporary RAM disk with modules needed to mount the root filesystem. (name)
13. GRUB mechanism used to boot Windows (passing control to another loader). (two words or the GRUB
    command)
14. UEFI feature that prevents running software not signed by the manufacturer. (two words)
15. After loading itself, the kernel looks for the initial process. Which PID does it get? (number)
16. Put in order (letters, no spaces): a) the kernel runs the initial process b) the firmware checks
    the hardware c) the boot loader loads the kernel d) the partition table is loaded

---
Write your answers in `answer.txt` (one `N: answer` line per question), then run `check 1907`.
