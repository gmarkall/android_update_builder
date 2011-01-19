#!/bin/bash

let buildnum=`cat buildnum`+1
echo $buildnum | tee buildnum
