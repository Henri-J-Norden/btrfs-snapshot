#!/usr/bin/env bash

filesystem=$1
#snapperconf=$2
path="${filesystem}/.snapshots"

# Check argument: filesystem
if [ -z "$filesystem" ]; then
    echo -e "Missing argument: filesystem" >&2
    exit 1
fi


# https://github.com/dim-geo/btrfs-snapshot-diff
#sed -i "s#<\(description\)>\([^\t]*\)\(\t.*\)\?</\1>#<\1>\2\t3MB</\1>#g" info.xml
btrfs quota enable $path
warn=$(btrfs qgroup show "$path" 2>&1 > /dev/null)

if [ -z "$warn" ]; then
	echo "path | snapper number | btrfs subvolume id | exclusive size"
	for s in "${path}/"*; do
		info="$s/info.xml"
		num="${s##*/}"
		id=$(btrfs subvolume list "$filesystem" | grep "/$num/" | awk '{print $2}')
		size=$(btrfs qgroup show "$path" | grep "/$id " | awk '{print $3}')
		echo -e "$s  $num  $id  $size"
		sed -i "s#<\(description\)>\([^\t]*\)\(\t.*\)\?</\1>#<\1>\2\t$size</\1>#g" $info
		#snapper -C "$snapperconf" modify -d "" 1
	done
	#service snapperd restart
else
	echo "Cannot update sizes: $warn"
fi
