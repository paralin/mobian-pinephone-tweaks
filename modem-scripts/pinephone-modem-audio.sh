#!/bin/sh

QDAI_EXPECTED="1,0,0,2,0,1,1,1"
MODEM_ID=""

get_modem_id()
{
    MODEM_LIST="`mmcli -L | grep QUECTEL`"
    if [ "$MODEM_LIST" ]; then
        # mmcli output is "   /org/freedesktop/ModemManager1/Modem/MODEM_ID ..."
        # MODEM_PATH will store the D-Bus object path, from which we'll extract
        # MODEM_ID
        MODEM_PATH="`echo "$MODEM_LIST" | sed 's%[^/]*\(/[^ ]*\).*%\1%'`"
        MODEM_ID=`basename "$MODEM_PATH"`
    fi
}

# Wait for the modem to be available
while [ ! "$MODEM_ID" ]; do
    sleep 1
    get_modem_id
done

# Check the current DAI configuration, and change it if necessary
QDAI_STATE=`mmcli -m $MODEM_ID --command='AT+QDAI?' | sed "s%response: '+QDAI: \(.*\)'%\1%"`
if [ "$QDAI_STATE" != "$QDAI_EXPECTED" ]; then
    mmcli -m $MODEM_ID --command="AT+QDAI=$QDAI_EXPECTED" > /dev/null 2>&1
fi
