
# EDCB-Wine

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/f36daa56-4dfd-47ca-bc7c-350a5ff8c154)

**Windows 向けの予約録画ソフトである [EDCB](https://github.com/tkntrec/EDCB) を、[Wine](https://www.winehq.org/) を使って Linux 上で動作させるための Docker Compose 構成一式です。**  

事前に Docker コンテナ上に Xfce / X11VNC / noVNC をセットアップしているため、**ブラウザから Xfce の軽量 Linux デスクトップにリモートアクセスし、すぐに EpgTimerSrv の各種設定や EpgDataCap_Bon でのチャンネルスキャンを行えます。**

さらに [EDCB Material WebUI (EMWUI)](https://github.com/EMWUI/EDCB_Material_WebUI) を組み込んでいるため、**ブラウザから EDCB の設定・予約・録画などを行えます。**  
また、**[KonomiTV](https://github.com/tsukumijima/KonomiTV) のバックエンドとしても利用できることを確認済みです。**

「Wine 使うってゲテモノじゃね？」と感じる方もいるかもしれませんが（私も試作するまではそう思っていました…）、若干の注意点こそあるものの、**魔法のように安定して動作します。**

Core i5-9400 の環境では常時 CPU 使用率が 5% 以下で、メモリ使用量も 500MB 以下と、デスクトップ環境まで入っている割にはかなり軽量と言えると思います。  
このリポジトリでは設定や動作確認用にデスクトップ環境を用意していますが、EDCB は（設定を除けば）デスクトップ環境がなくても EpgTimerNW や EDCB Material WebUI からリモート操作が可能なため、デスクトップ環境をオミットすれば、より軽量なコンテナにできるはずです。

**予約録画も単発予約・EPG 予約ともに問題なく動作することを確認済みです。**  
まだ長期テストはできていませんが、**十分実用に耐えうるレベルだと思います。**

## Usage

### 1. 動作確認環境

- Ubuntu 20.04 LTS
  - Wine 環境は Docker コンテナに完全に封じ込めていてホストマシンの環境には依存しないため、ほかの Linux でも動くはず
- Docker v24.0.2 or later
- Docker Compose v2.18.1 or later
- Mirakurun v3.9.0-rc.4

EDCB を動作させている Wine 環境からは直接 Linux のホストマシンで動作しているチューナーハードにアクセスできないため、Mirakurun or mirakc / BonDriver_mirakc を併用し、ホストマシンのチューナーを Docker の仮想 NIC 越しに利用する構成となっています。  
そのため、ホストマシン上で Mirakurun or mirakc がセットアップ済みで、すでに稼働していることが前提となります。

> **Note**  
> BonDriver_mirakc は BonDriver_Mirakurun の上位互換のようで、Mirakurun でも問題なく動作します (Mirakurun でのみ動作確認済み) 。  
> BonDriver_mirakc に限らず、チューナーをネットワーク越しに利用する仮想 BonDriver であればなんでも使えるはずです。

### 2. 事前準備

```bash
$ git clone https://github.com/tsukumijima/EDCB-Wine.git
$ cd EDCB-Wine
```

EDCB の動作環境一式 (EDCB Material WebUI 含む) 既にこのリポジトリの `EDCB/` フォルダに同梱されているため、別途構築する必要はありません。

Wine 環境からは、EDCB の実行ファイルや設定ファイル群は `Z:\EDCB` (コンテナ側 Linux: `/EDCB`) としてマウントされています。  
ファイル内容はデスクトップ環境内のファイルマネージャーから確認できます。

ホストマシンのルートファイルシステムは `Z:\host-rootfs` (コンテナ側 Linux: `/host-rootfs`) にマウントされています。  
たとえばホストマシン側の録画フォルダが `/mnt/hdd-record/TV-Record` にある場合、EpgTimerSrv や EpgDataCap_Bon の設定 UI で `Z:\host-rootfs\mnt\hdd-record\TV-Record` を指定すれば、EDCB で録画した録画ファイルをホストマシンの録画フォルダに保存できます。

> **Warning**  
> `Z:\host-rootfs` 以外のフォルダに録画ファイルを保存する設定にしてしまうと、`docker compose down` でコンテナを停止・削除したときに録画ファイルも一緒に消えてしまうため、十分注意してください。

### 3. Docker イメージのビルド・コンテナの起動

以下のコマンドを実行して Docker イメージをビルドし、コンテナを起動します。
    
```bash
$ docker compose up -d --build
```

### 4. EDCB の設定

ブラウザで `http://<ホストマシンのIPアドレス>:6510` にアクセスすると、Docker コンテナ内で動作している EDCB-Wine 環境のデスクトップ画面を操作できます。

この Xfce のデスクトップ環境は、軽量化のため EDCB のほかには日本語入力用の Fcitx5-mozc 、ファイルマネージャー、タスクマネージャー、ターミナル、設定アプリ以外は一切インストールされていません。最低限 EpgTimerSrv (設定画面含む) と EpgDataCap_Bon を実行・操作できる環境となっています。

> **Note**  
> 英数字と日本語の入力切り替えは、`Ctrl + Space` で行えます。  
> おそらく noVNC 側の問題で全角/半角キーが反応しないため、IME の切り替えはこの方法で行ってください。


-----

なお、EpgTimer に関しては、Wine-mono を使えば動作はすると思われるものの、

- EpgTimerNW により Windows マシンからリモート操作可能なこと
- EMWUI により Web ブラウザから操作可能なこと
- Wine-mono を入れると Docker イメージサイズがかなり膨らむことが予想されたこと
- さすがに Wine だと重そうなこと

を考慮し、対応を見送りました。

### 5. EDCB Material WebUI にアクセス

ブラウザで `http://<ホストマシンのIPアドレス>:5510/EMWUI/epg.html` にアクセスすると、EDCB Material WebUI の Web 画面が表示されます。

## License

[MIT License](License.txt)
