#!/bin/bash
F=$(tar -tzf backup.tgz | grep '/config\.ini$')
tar -xOzf backup.tgz "$F"
tar -xzf backup.tgz "$F"

