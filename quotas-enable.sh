#!/bin/bash

s="btrfs quota enable"


for p in $(snapper list-configs | grep -o " /.*"); do
	echo ""
	echo $s $p
	$s $p
done

