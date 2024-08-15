#!/bin/bash

# ----------------------------------------------------------------------------------------------------

# 更新する EDCB のバージョン
# このバージョンは tsukumijima/DTV-Builds の GitHub リポジトリに公開されているものと一致している必要がある
EDCB_VERSION="240622"

# ----------------------------------------------------------------------------------------------------

# シェルスクリプトの実行時にエラーが発生したらスクリプトを終了する
set -Eeuo pipefail

# このスクリプトがあるディレクトリに移動
cd "$(dirname "$0")"

# EDCB のビルド済みアーカイブをダウンロード
rm -rf EDCB-${EDCB_VERSION}
wget https://github.com/tsukumijima/DTV-Builds/raw/master/EDCB-${EDCB_VERSION}.zip
unzip EDCB-${EDCB_VERSION}.zip
rm EDCB-${EDCB_VERSION}.zip

# 64bit 以外を削除
mv EDCB-${EDCB_VERSION}/EDCB_64bit/* EDCB-${EDCB_VERSION}/
rm -rf EDCB-${EDCB_VERSION}/EDCB_32bit/
rm -rf EDCB-${EDCB_VERSION}/EDCB_64bit/

# EDCB-Wine では不要 or 動作しないファイルを削除
rm -rf EDCB-${EDCB_VERSION}/EdcbPlugIn/
rm -rf EDCB-${EDCB_VERSION}/PostBatExamples/
rm -rf EDCB-${EDCB_VERSION}/Setting/HttpPublic.ini  # EDCB-Wine 側で別途カスタマイズしているため
rm -rf EDCB-${EDCB_VERSION}/Tools/asyncbuf.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/ffmpeg.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/ffprobe.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/psisiarc.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/psisimux.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/relayread.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/tsmemseg.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/tsreadex.exe
rm -rf EDCB-${EDCB_VERSION}/Tools/*.bat
rm -rf EDCB-${EDCB_VERSION}/Tools/*.dll
rm -rf EDCB-${EDCB_VERSION}/Tools/*.ps1
rm -rf EDCB-${EDCB_VERSION}/B1Decoder.dll
rm -rf EDCB-${EDCB_VERSION}/B25Decoder.dll
rm -rf EDCB-${EDCB_VERSION}/EpgTimer.exe
rm -rf EDCB-${EDCB_VERSION}/EpgTimer.exe.rd.xaml
rm -rf EDCB-${EDCB_VERSION}/EpgTimerAdminProxy.exe
rm -rf EDCB-${EDCB_VERSION}/EpgTimerNW.exe
rm -rf EDCB-${EDCB_VERSION}/EpgTimerPlugIn.tvtp
rm -rf EDCB-${EDCB_VERSION}/*.bat

# EDCB ディレクトリにコピー
cp -ar EDCB-${EDCB_VERSION}/* EDCB/
rm -rf EDCB-${EDCB_VERSION}
