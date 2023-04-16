#!/usr/bin/env bash

filesystem=$1

# Check argument: filesystem
if [ -z "$filesystem" ]; then
    echo -e "Missing argument: filesystem" >&2
    exit 1
fi

btrfs filesystem du -s "$filesystem"/.snapshot/*
