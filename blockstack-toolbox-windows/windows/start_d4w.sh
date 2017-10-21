#!/bin/bash

cat << EOF

    ...     ...
   .   .   .   .
   ,,..    ,,..
                    B L O C K S T A C K
    ...     ...
   .   .   .   .
   ,,..    ,,..


   Fetching latest Blockstack Docker Images...

EOF

export WIN_HYPERV=1

launcher pull

launcher start

trap "launcher stop ; echo 'Closing'" SIGINT SIGTERM
trap "launcher stop ; echo 'Closing'" EXIT

echo "Blockstack's background processes are listening on ports 6270 and 1337"
echo
echo "The Blockstack browser portal is listening on port 8888"
echo "To connect to the Blockstack browser, open http://localhost:8888 in your browser"
echo
echo "Blockstack is running. Hit Ctrl-C to Exit."

while :
do
  sleep 60
done
