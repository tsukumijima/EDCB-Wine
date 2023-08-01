#!/bin/bash
echo "予約ファイルに含まれるTransportStreamIDの情報を変更します。"
echo "チャンネル再編などでTransportStreamIDが変更されたときに使います。"
echo "ChSet4.txtやChSet5.txtはあらかじめチャンネルスキャンなどで更新してください。"
echo "はじめに非破壊テストを行います。"
read -p "Press any key to continue... " -n1 -s
wine "$(dirname "$0")/tsidmove.exe" --dry-run
if [ $? -eq 1 ]; then
    echo ""
    echo ""
    echo "テストは正常終了しました。実際に変更を行います。"
    echo "必要なら予約ファイルをバックアップしてください。"
    read -p "Press any key to continue... " -n1 -s
    wine "$(dirname "$0")/tsidmove.exe" --run
    if [ $? -eq 1 ]; then
        exit 1
    else
        exit 0
    fi
else
    echo ""
    echo ""
    echo "エラーが発生しました。終了します。"
    exit 1
fi
