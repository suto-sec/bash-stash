#!/bin/bash
groupadd auditores
usermod -aG auditores luke
usermod -aG auditores sally
gpasswd -d sally auditores > /dev/null
getent group auditores
id -Gn luke

