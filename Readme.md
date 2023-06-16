
# EDCB-Wine

Windows 向け予約録画ソフトである [EDCB](https://github.com/tkntrec/EDCB) を、Wine / Xfce / VNC / noVNC を組み合わせて Linux 上で動作させ、ブラウザからデスクトップ環境を操作できるようにするための Docker コンテナです。

## Usage

まだ作ったばかりでちゃんと書けていませんが、一応動かす方法を載せておきます。

### 1. 動作確認環境

- Ubuntu 20.04 LTS
  - Docker コンテナに完全に環境を閉じ込めているので、他の Linux でも動くはず
- Docker v24.0.2 or later
- Docker Compose v2.18.1 or later
- Windows 版 BonDriverProxyEx
  - 私が [DTV-Builds](https://github.com/tsukumijima/DTV-Builds) で公開しているビルドを利用
  - Linux 版の [BonDriverProxyEx](https://github.com/u-n-k-n-o-w-n/BonDriverProxy_Linux) でもおそらく動くと思うが、上記ビルドが HaijinW 版なので、BonDriver_Proxy_T/S.dll を差し替える必要がある可能性が高そう
  - 「Wine からチューナーを操作できないなら、Linux 側ホストに立てた BonDriverProxy か何かを使えばええやん」という発想なので、BonDriver_Mirakurun とかでもいけると思う


## 2. 事前準備

EDCB フォルダに既に EDCB のバイナリと設定ファイル諸々が含まれているので、example.ini を ini にコピーして適宜パスを編集してください。  
一応編集しなくても GUI から設定できるとは思いますが…。

Wine の環境からは、EDCB は `Z:\EDCB` にマウントされています。  
また、ホストマシンの rootfs は `Z:\host-rootfs` に全公開されているので、そこから適宜 HDD のマウントパスなどを指定すれば、そこに録画を保存できます。

## 3. Docker イメージのビルド
    
```bash
$ docker compose up -d --build
```

## 4. EDCB にアクセス

ブラウザで `http://<ホストマシンのIPアドレス>:6510` にアクセスすると、noVNC による Docker 環境内のデスクトップが表示されます。  
この Xfce のデスクトップ環境は、EDCB のほかには日本語入力 (Ctrl + Space で切り替え) 用の Fcitx5-mozc・ファイルマネージャー・タスクマネージャー・設定アプリ以外は何も入っておらず、最低限 EpgTimerSrv の設定 UI と EpgDataCap_Bon を実行できる環境としています。

なお、EpgTimer に関しては、Wine-mono を使えばおそらく動作すると思われるものの、

- EpgTimerNW により Windows マシンからリモート操作可能なこと
- EMWUI により Web ブラウザから操作可能なこと
- Wine-mono を入れると Docker イメージサイズがかなり膨らむことが予想されたこと

から、対応を見送っています。

ブラウザで `http://<ホストマシンのIPアドレス>:5510/EMWUI/epg.html` にアクセスすると、EDCB Material WebUI (EMWUI) の Web 画面が表示されます。  
動作は通常の EMWUI と同様です。

## License

[MIT License](License.txt)
