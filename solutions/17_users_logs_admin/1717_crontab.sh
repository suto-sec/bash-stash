#!/bin/bash
(crontab -l 2>/dev/null; echo "0 */4 * * * $HOME/ipLog.sh >> $HOME/ipLog.log 2>&1") | crontab -

