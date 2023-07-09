#!/bin/bash
folder_name="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
rm -rf $folder_name
rm -rf prod
rm -rf build