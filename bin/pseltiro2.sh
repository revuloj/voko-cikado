#!/bin/bash

psselect -p$1 $2 | psbook | \
pstops "4:0L@0.7(1w,0)+1L@0.7(1w,.5h),2R@0.7(0,1h)+3R@0.7(0,.5h)" $3

