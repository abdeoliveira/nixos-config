#!/usr/bin/env bash

REMOTE_PHONE_DIR=/data/data/com.termux/files/home/storage/shared/password-store

rsync -avzP --delete $PASSWORD_STORE_DIR/ phone:$REMOTE_PHONE_DIR/
