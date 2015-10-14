#!/bin/bash

psselect -p$1 $2 | psbook | psnup -2 $3 | pstops "2:0@1.0(-0.00cm,0.0cm),1U@1.0(21cm,29.7cm)"

