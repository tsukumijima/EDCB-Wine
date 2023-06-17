
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

> **Note**  
> 同梱の EDCB は [DTV-Builds](https://github.com/tsukumijima/DTV-Builds) にて公開している EDCB のビルド済みアーカイブのうち、EDCB-230326 (64bit) をベースに Wine 環境では不要 or 動作しないファイルを除外・調整したものになります。

Wine 環境からは、EDCB の実行ファイルや設定ファイル群は `Z:\EDCB` (コンテナ側 Linux: `/EDCB`) としてマウントされています。  
ファイル内容はデスクトップ環境内のファイルマネージャーから確認できます。

ホストマシンのルートファイルシステムは `Z:\host-rootfs` (コンテナ側 Linux: `/host-rootfs`) にマウントされています。  
たとえばホストマシン側の録画フォルダが `/mnt/hdd-record/TV-Record` にある場合、EpgTimerSrv や EpgDataCap_Bon の設定 UI で `Z:\host-rootfs\mnt\hdd-record\TV-Record` を指定すれば、EDCB で録画した録画ファイルをホストマシンの録画フォルダに保存できます。

> **Warning**  
> `Z:\host-rootfs` 以外のフォルダに録画ファイルを保存する設定にしてしまうと、`docker compose down` でコンテナを停止・削除したときに録画ファイルも一緒に消えてしまうため、十分注意してください。

`EDCB/` フォルダには、

- `Common.example.ini`
- `EpgDataCap_Bon.example.ini`
- `EpgTimerSrv.example.ini`

の3つのサンプル設定ファイルが同梱されています（私が実際に使っている設定データをベースに調整したもの）。  
コンテナが起動した後に一から EpgDataCap_Bon や EpgTimerSrv の設定を行うこともできますが、個人的にはこの `*.example.ini` を `*.ini` にコピーして使うことをおすすめします。

```bash
$ cp EDCB/Common.example.ini EDCB/Common.ini
$ cp EDCB/EpgDataCap_Bon.example.ini EDCB/EpgDataCap_Bon.ini
$ cp EDCB/EpgTimerSrv.example.ini EDCB/EpgTimerSrv.ini
```

> **Note**  
> このサンプル設定ファイルでは、ホスト側の録画フォルダが `/mnt/hdd-record/TV-Record` 、録画情報フォルダ (`*.ts.program.txt` / `*.ts.err` が保存される) は `/mnt/hdd-record/TV-Record/RecordInfo` に作成されているものとしています。  
> ini をコピーした後に手動で編集するか、コンテナ起動後に EpgTimerSrv の設定 UI から各自の録画環境にあわせて変更してください。

> **Note**  
> もし一から設定を行う場合、デフォルトでは EDCB Material WebUI は動作しないほか、KonomiTV のバックエンドとしても利用できません。   
> EpgTimerSrv の設定 UI から、手動でネットワーク接続や HTTP サーバー機能を有効にする必要があります。

### 3. Docker イメージのビルド・コンテナの起動

以下のコマンドを実行して Docker イメージをビルドし、コンテナを起動します。

> **Note**  
> ビルド後の Docker イメージのサイズは 4.5GB ほどあります。  
> Wine と Xfce の動作環境が入っている関係で若干大きめです（これでも頑張って減らした方…）。

```bash
$ docker compose up -d --build
```

ビルドが完了すると、すぐに EpgTimerSrv (EpgTimer Service) が起動します。  
EpgTimerSrv は、Docker コンテナの起動中は常時起動されるように設定されています。

> **Note**  
> デスクトップ画面のタスクトレイから EpgTimerSrv を終了すると、Supervisor の `autorestart` 設定により、すぐに EpgTimerSrv が起動されます。  
> EpgTimerSrv への設定変更を即座に適用したい場合に、Docker コンテナを再起動することなく設定変更を適用できるため便利です。

### 4. EDCB の設定

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/1a36664e-22be-4192-aa6d-32cc4c0ef68a)

ブラウザで `http://<ホストマシンのIPアドレス>:6510` にアクセスすると、Docker コンテナ内で動作している EDCB-Wine 環境のデスクトップ画面を操作できます。

この Xfce のデスクトップ環境は、軽量化のため EDCB のほかには日本語入力用の Fcitx5-mozc 、ファイルマネージャー、タスクマネージャー、ターミナル、設定アプリ以外は一切インストールされていません。  
EpgTimerSrv と EpgDataCap_Bon の動作確認と UI 操作が行える、最低限の環境となっています。

> **Note**  
> 英数字と日本語の入力切り替えは、`Ctrl (Control) + Space` で行えます。  
> おそらく noVNC 側の問題で全角/半角キーが反応しないため、IME の切り替えはこの方法で行ってください。

EpgTimerSrv の設定 UI は、画面右上のタスクトレイを右クリック → `[システム]` → `[Srv 設定]` から表示できます。

ステップ 2 で事前にサンプル設定ファイルをコピーしてある場合は、録画保存フォルダ / 録画情報保存フォルダのみ変更してください。  
サンプル設定ファイルで既にある程度設定を済ませてあるため、それ以外の設定変更はおそらく不要です（適宜お好みで調整してください）。

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/361a65fe-df8f-4648-bf54-feb348fad89d)

デスクトップ左側の EpgDataCap_Bon のアイコンをクリックすると、EDCB の録画アプリである EpgDataCap_Bon を起動できます。  
録画フォルダ設定は EpgTimerSrv と共通 (`Common.ini`) なので、ここで設定する必要はありません。  
それ以外の設定で、もし必要なものがあれば適宜設定してください。

-----

なお、EpgTimer に関しては、Wine-mono を使えば動作はすると思われるものの、

- EpgTimerNW により Windows マシンからリモート操作可能なこと
- EMWUI により Web ブラウザから操作可能なこと
- Wine-mono を入れると Docker イメージサイズがかなり膨らむことが予想されたこと
- さすがに Wine だと重そうなこと

を考慮し、対応を見送りました。

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/1b308f3b-991e-47f9-9646-823e62380b09)

Windows PC から EpgTimer でリモート操作したい場合は、[DTV-Builds](https://github.com/tsukumijima/DTV-Builds) で公開している EDCB のビルド済みアーカイブから EpgTimer.exe を入手したあと、EpgTimerNW.exe にリネームして、適当な場所に新規作成したフォルダに移動してください。  

その後 EpgTimerNW.exe を起動すると、EDCB-Wine 上で起動している EpgTimerSrv にリモート接続できます。

### 5. EDCB Material WebUI にアクセス

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/4f14a26c-c279-4eb5-8cab-80d1d54938de)

ブラウザで `http://<ホストマシンのIPアドレス>:5510/EMWUI/epg.html` にアクセスすると、EDCB Material WebUI の Web 画面が表示されます。

基本操作は Windows での EDCB Material WebUI と同じです。  
ただし、テレビのリモート視聴 / 録画ファイルのストリーミングのみ、Wine 環境では FFmpeg がまともに動作しないため、あえて動作しない状態にしています。

> **Note**  
> 前述の通り、EDCB-Wine で起動した EDCB は KonomiTV のバックエンドとしても利用できます。  
> テレビのライブストリーミングでは代わりに [KonomiTV](https://github.com/tsukumijima/KonomiTV) を利用することをおすすめします。録画視聴機能は鋭意開発中…。

## License

[MIT License](License.txt)
