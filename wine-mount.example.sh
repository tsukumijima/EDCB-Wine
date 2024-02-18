#!/bin/bash

WINE_DOSDEVICE_DIR="/home/ubuntu/.wine64/dosdevices"
mkdir -p "$WINE_DOSDEVICE_DIR"
cd "$WINE_DOSDEVICE_DIR"

# ホストマシンに接続されている HDD を、Wine 環境にドライブレターを付けてマウントするための設定用スクリプトです。
# このファイルを wine-mount.sh にコピーした後、各自の環境に合わせて調整してください。

# 注意:
# ・マウントするホストマシン側のフォルダは /mnt/ 配下である必要があります。
# ・ドライブレターのアルファベットは小文字で指定する必要があります。
# ・Wine 側で予約されているため、ドライブレターに C: と Z: は利用できません。
# ・複数の HDD をマウントする場合、ドライブレターが HDD 間で重複しないように注意してください。

# 例: ホストマシンの /mnt/hdd-record/ にマウントされている HDD を、Wine 環境の D: ドライブにマウントする
# ln -s "/mnt/hdd-record/" "d:"
