#!/bin/sh

# This is an example of Jonesy updater script.
# It can be used if you unable to use jobs scheduler like Cron.
# See README.md for more.

echo "Press Ctrl + C to stop."
while true
do
  jonesy fetch
  # ^^^^
  # Modify your $PATH by adding jonesy script directory or use absolute
  # path to it instead
  sleep "1h"
done
