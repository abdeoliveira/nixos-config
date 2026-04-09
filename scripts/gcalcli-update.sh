#!/usr/bin/env bash

ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1 || exit 0

if gcalcli agenda now 11:59pm --nostarted --tsv > /tmp/gcalcli_agenda.tmp; then
    mv /tmp/gcalcli_agenda.tmp /tmp/gcalcli_agenda.txt
    exit 0
else
    exit $?
fi
