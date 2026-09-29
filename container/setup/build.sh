#!/bin/bash
# Image build step (runs as root). Creates a classroom-like environment.
set -euo pipefail
S=/opt/lab-setup

# ---------- users & groups ----------
userdel -r ubuntu 2>/dev/null || true
groupdel ubuntu 2>/dev/null || true
groupadd -g 1000 alumno
for g in admin scanner winxp devs secops; do groupadd "$g"; done

useradd -m -u 1000 -g alumno -s /bin/bash -c "Alumno Lab,,," -G sudo,adm,cdrom,audio,video,secops alumno
useradd -m -u 1001 -s /bin/bash -c "Luke Skywalker,,," -G devs,audio luke
useradd -m -u 1002 -s /bin/bash -c "Sally Ride,,," -G devs,video sally
useradd -m -u 1003 -s /bin/sh   -c "Rod Serling,,," rod
useradd -m -u 1004 -s /bin/bash -c "Juan Garcia,,,," -G adm,cdrom,floppy,audio,video,scanner,admin,winxp,secops jgarcia
useradd -m -u 1005 -s /bin/bash -c "Maria Lopez,,," -G cdrom,floppy mlopez
useradd -m -u 1006 -s /bin/dash -c "Pedro Ruiz,,," pruiz
useradd -m -u 1007 -s /bin/bash -c "Raul Martin,,," -G devs rmartin
useradd -m -u 1008 -s /bin/sh   -c "Rosa Nieto,,," rosa
useradd -r -s /usr/sbin/nologin -d /var/lib/backupd -c "Backup daemon" backupd
for u in alumno luke sally rod jgarcia mlopez pruiz rmartin rosa; do echo "$u:lab" | chpasswd; done
passwd -l rosa >/dev/null

# sudo: password is "lab", but the checker must run unattended, so no prompt.
echo 'alumno ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/lab && chmod 440 /etc/sudoers.d/lab

# ---------- logs ----------
bash "$S/gen_logs.sh"

# ---------- example scripts (~/scripts.tgz) ----------
tmp=$(mktemp -d)
cp -r "$S/scripts" "$tmp/scripts"
tar -C "$tmp/scripts" -czf /home/alumno/scripts.tgz .
chown alumno:alumno /home/alumno/scripts.tgz
rm -rf "$tmp"

# ---------- shell setup for alumno ----------
cat >> /home/alumno/.bashrc <<'EOF'

# ---- bash stash ----
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
if [[ $- == *i* && -z $LAB_QUIET ]]; then
  echo "bash stash — exercises in ~/lab/exercises.  Commands: next | check <id> | check all | man <cmd>"
fi
EOF
chown alumno:alumno /home/alumno/.bashrc

install -m 755 "$S/lab-init" /usr/local/sbin/lab-init
# lab commands (the lab folder is bind-mounted at runtime)
for c in check play next progress; do ln -s "/home/alumno/lab/bin/$c" "/usr/local/bin/$c"; done

# ---------- VS Code in the browser (code-server): plain, no extensions ----------
CS=/home/alumno/.local/share/code-server/User
mkdir -p "$CS"
cat > "$CS/settings.json" <<'JSON'
{
  "workbench.colorTheme": "Default Dark Modern",
  "workbench.startupEditor": "none",
  "workbench.tips.enabled": false,
  "telemetry.telemetryLevel": "off",
  "security.workspace.trust.enabled": false,
  "extensions.ignoreRecommendations": true,
  "update.mode": "none",
  "terminal.integrated.defaultProfile.linux": "bash",
  "chat.disableAIFeatures": true,
  "chat.commandCenter.enabled": false,
  "workbench.secondarySideBar.defaultVisibility": "hidden"
}
JSON
touch /home/alumno/.sudo_as_admin_successful   # no "To run a command as administrator" hint
chown -R alumno:alumno /home/alumno/.local /home/alumno/.sudo_as_admin_successful
