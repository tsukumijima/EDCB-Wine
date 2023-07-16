#!/bin/bash

WINE_DOSDEVICE_DIR="/home/ubuntu/.wine64/dosdevices"
mkdir -p "$WINE_DOSDEVICE_DIR"
cd "$WINE_DOSDEVICE_DIR"

# ホストマシンに接続されている HDD を、Wine 環境にドライブレターを付けてマウントするための設定用スクリプトです。
# このファイルを wine-mount.sh にコピーした後、各自の環境に合わせて調整してください。
# なお、マウントするホストマシン側のフォルダは /mnt/ 配下である必要があります。

# 例: ホストマシンの /mnt/hdd-record/ にマウントされている HDD を Wine 環境の D: ドライブにマウントする場合
# ln -s "/mnt/hdd-record/" "d:"
