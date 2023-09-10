
# EDCB-Wine

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/f36daa56-4dfd-47ca-bc7c-350a5ff8c154)

**Windows 向けの予約録画ソフトである [EDCB](https://github.com/tkntrec/EDCB) を、[Wine](https://www.winehq.org/) を使って Linux 上で動作させるための Docker Compose 構成一式です。**  

事前に Docker コンテナ上に Xfce / X11VNC / noVNC をセットアップしているため、**ブラウザから Xfce の軽量 Linux デスクトップにリモートアクセスし、すぐに EpgTimerSrv の各種設定や EpgDataCap_Bon でのチャンネルスキャンを行えます。**

さらに [EDCB Material WebUI (EMWUI)](https://github.com/EMWUI/EDCB_Material_WebUI) を組み込んでいるため、**ブラウザから EDCB の設定・予約・録画などを行えます。**  
また、**[KonomiTV](https://github.com/tsukumijima/KonomiTV) のバックエンドとしても利用できることを確認済みです。**

「Wine 使うってゲテモノじゃね？」と感じる方もいるかもしれませんが（私も試作するまではそう思っていました…）、若干の注意点こそあるものの、**魔法のように安定して動作します。**  
EDCB のチューナーバックエンドとして Mirakurun / mirakc を利用する構成になっているため、すでに Mirakurun + EPGStation 環境を構築済みの方でも比較的簡単に導入できるはずです。

Core i5-9400 の環境では常時コア全体の CPU 使用率が 1% 以下で、メモリ使用量も 500MB 前後と、デスクトップ環境まで入っている割にはかなり軽量といえるのではないでしょうか。  
このリポジトリでは設定や動作確認向けにブラウザから操作可能なデスクトップ環境を用意していますが、EDCB は（設定を除けば）デスクトップ環境がなくても EpgTimerNW や EDCB Material WebUI からリモート操作が可能なため、デスクトップ環境をオミットすれば、より軽量なコンテナにできるはずです。

**予約録画も単発予約・EPG 予約ともに問題なく動作することを確認済みです。**  
まだ長期テストはできていませんが、**十分実用に耐えうるレベルだと思います。**

## Usage

### 1. 動作確認環境

- Ubuntu 20.04 LTS (Architecture: x64)
  - Wine 環境は Docker コンテナに完全に封じ込めていてホストマシンの環境には依存しないため、ほかの Linux でも動くはず
  - Wine を使っている関係で、ARM 環境ではおそらく動作しない (間違いなく遅いだろうけど QEMU を使えばいけるかも？)
- Docker v24.0.2 or later
- Docker Compose v2.18.1 or later
- Mirakurun v3.9.0-rc.4

EDCB の動作環境である Wine からは直接 Linux ホストマシン上に接続されているチューナーハードにアクセスできないため、**Mirakurun or mirakc / BonDriver_mirakc を併用し、ホストマシン上のチューナーを Mirakurun / mirakc 経由で利用する構成となっています。**  
そのため、**ホストマシン上で Mirakurun or mirakc がセットアップ済みで、すでに稼働していることが前提となります。**

> **Note**  
> BonDriver_mirakc は BonDriver_Mirakurun の上位互換のようで、Mirakurun でも問題なく動作します (Mirakurun でのみ動作確認済み) 。  
> BonDriver_mirakc に限らず、チューナーをネットワーク越しに利用する仮想 BonDriver であればなんでも使えるはずです。

### 2. 事前準備

#### 2.1. EDCB-Wine のリポジトリのクローン

まず、このリポジトリをクローンしてください。  
配置フォルダはどこでも構いませんが、一般的には `/opt/` 以下が無難だと思います。

```bash
$ git clone https://github.com/tsukumijima/EDCB-Wine.git
$ cd EDCB-Wine
```

EDCB の動作環境一式 (EDCB Material WebUI 含む) は既にこのリポジトリの `EDCB/` フォルダに同梱されているため、別途構築する必要はありません。  

> **Note**  
> 同梱の EDCB は [DTV-Builds](https://github.com/tsukumijima/DTV-Builds) にて公開している EDCB のビルド済みアーカイブのうち、EDCB-230326 (64bit) をベースに Wine 環境では不要 or 動作しないファイルを除外・調整したものになります。  
> 本来 Git のバージョン管理にバイナリファイルを含めるのはあまり良くないのですが、EDCB を構成する各ファイルを適切にバージョン管理したかったため、このような形になりました。

Wine 環境からは、EDCB の実行ファイルや設定ファイル群は `Z:\EDCB` (Docker コンテナ側: `/EDCB`) としてマウントされています。  
ファイル内容はデスクトップ環境内のファイルマネージャーから確認できます。

#### 2.2. ホストマシンに接続されている HDD のマウント設定

ホストマシンに接続されている HDD を Wine 環境内の EDCB から利用するには、別途設定が必要です。

```bash
$ cp wine-mount.example.sh wine-mount.sh
```

`wine-mount.sh` には、ホストマシンに接続されている HDD のマウント設定を記述します。  
`wine-mount.example.sh` からコピーして作成した `wine-mount.sh` を編集し、各自の環境に合わせて調整してください。

> **Note**  
> マウント対象のホストマシン側のフォルダは `/mnt/` 配下に配置されている必要があります。  
> これは、Docker Compose 構成でホストマシン上の `/mnt/` を Docker コンテナ上の `/mnt/` にマウントしているためです。

> **Note**  
> `.wine64/dosdevices/` 配下に `d:` のようなドライブレターの名前のシンボリックリンクを配置することで、リンク先のフォルダを Wine 環境にドライブとしてマウントできる Wine の機能を利用して実装しています。

たとえば、下記の環境で Wine 環境上の D: ドライブに `/mnt/hdd-record/` をマウントする際は、`wine-mount.sh` に次のように追記します。

- ホストマシンにマウントされている HDD のパス: `/mnt/hdd-record/`
- ホストマシン上の録画フォルダ: `/mnt/hdd-record/TV-Record/`

```bash
ln -s "/mnt/hdd-record/" "d:"
```

> **Note**  
> 複数の HDD が `/mnt/` 配下にマウントされている場合は、`wine-mount.sh` にそれぞれの HDD のマウント設定を追記してください。  
> その際、ドライブレターが HDD 間で重複しないように注意してください。  
> なお、Wine 側で予約されているため、ドライブレターに C: と Z: は利用できません。

あとは EpgTimerSrv や EpgDataCap_Bon の設定 UI で `D:\TV-Record` と指定すれば、EDCB で録画した録画ファイルをホストマシン上の HDD に永続的に保存できます。  
もちろん、`/mnt/hdd-record/` 配下のほかのフォルダにも `D:\` 以下からアクセスできます。

> **Warning**  
> `wine-mount.sh` に記述したフォルダ以外に保存しようとすると、`docker compose down` でコンテナを停止・削除したときに録画ファイルも一緒に消えてしまうため、十分注意してください。

#### 2.3. 設定ファイルのコピー

`EDCB/` フォルダには、

- `Common.example.ini` (EDCB 共通設定ファイル: Shift-JIS + CRLF)
- `EpgDataCap_Bon.example.ini` (EpgDataCap_Bon 設定ファイル: Shift-JIS + CRLF)
- `EpgTimerSrv.example.ini` (EpgTimerSrv 設定ファイル: UTF-16LE + CRLF)

の3つのサンプル設定ファイルが同梱されています（私が実際に使っている設定データをベースに調整したもの）。

```bash
$ cp EDCB/Common.example.ini EDCB/Common.ini
$ cp EDCB/EpgDataCap_Bon.example.ini EDCB/EpgDataCap_Bon.ini
$ cp EDCB/EpgTimerSrv.example.ini EDCB/EpgTimerSrv.ini
```

サンプル設定ファイルは（フォルダパスなど環境依存の項目以外は）追加の設定変更なしでそのまま予約録画ができるように調整されています。  
コンテナが起動した後に一から EpgDataCap_Bon や EpgTimerSrv の設定を行うこともできますが、**こだわりがなければこの `*.example.ini` を `*.ini` にコピーして使うことをおすすめします。**

----

なお、**設定ファイルを保存する際は、文字コードや改行コードに十分注意してください。**  
誤った文字コードや改行コードで保存すると、EDCB が正常に動作しなくなる可能性があります。

各設定ファイルの文字コードや改行コードは次のとおりです。ファイルごとに文字コードが異なるため特に注意が必要です。

- `Common.ini` / `EpgDataCap_Bon.ini`: Shift-JIS + CRLF
- `EpgTimerSrv.ini` / `Setting/HttpPublic.ini`: UTF-16LE + CRLF  
- `Setting/` 配下の *.txt (予約情報ファイル、チャンネル設定ファイルなど) : UTF-8 with BOM + CRLF

> **Note**  
> このサンプル設定ファイルでは、ホストマシン上の録画フォルダが `/mnt/hdd-record/TV-Record` 、録画情報フォルダ (`*.ts.program.txt` / `*.ts.err` が保存される) が `/mnt/hdd-record/TV-RecordInfo` にそれぞれ作成されている前提で作成されています。  
> `*.ini` をコピーした後に手動で設定ファイルを編集するか、コンテナ起動後に EpgTimerSrv の設定 UI を開き、それぞれ録画環境にあわせて変更してください。  

> **Note**  
> ホストマシン上の録画フォルダのパーミッションは、万が一の権限周りのトラブルを回避するため、777 (drwxrwxrwx) に設定することをおすすめします。  
> 基本 755 などでも問題はないとは思いますが、念のため…。

> **Note**  
> もしサンプル設定ファイルを使わず一から設定を行う場合、デフォルトの状態では EDCB Material WebUI は動作しないほか、KonomiTV のバックエンドとしても利用できません。   
> EpgTimerSrv の設定 UI から、手動でネットワーク接続や HTTP サーバー機能を有効にする必要があります。  
> EDCB を KonomiTV のバックエンドとして利用する場合は、[KonomiTV の当該ドキュメント](https://github.com/tsukumijima/KonomiTV#edcb-%E3%81%AE%E4%BA%8B%E5%89%8D%E8%A8%AD%E5%AE%9A) も参照してください。

### 3. Docker イメージのビルド・コンテナの起動

**以下のコマンドを実行して Docker イメージをビルドし、コンテナを起動します。**

> **Note**  
> **ビルド後の Docker イメージのサイズは 4.5GB 弱あります。**  
> Wine と Xfce の動作環境が入っている関係で若干大きめです（これでも頑張って減らした方…）。

```bash
$ docker compose up -d --build
```

**ビルドが完了すると、すぐに EpgTimerSrv (EpgTimer Service) が起動します。**  
EpgTimerSrv は、Docker コンテナの起動中は常時起動されるように設定されています。

> **Note**  
> デスクトップ画面のタスクトレイから EpgTimerSrv を終了すると、Supervisor の `autorestart` 設定により、再度 EpgTimerSrv が起動されます。  
> この挙動を利用すると、EpgTimerSrv の設定変更を即座に反映したい場合に、Docker コンテナを再起動することなくすぐに変更後の設定を反映できます。

> **Warning**  
> `docker compose stop` で Docker コンテナを停止する際、EpgTimerSrv は強制終了されてしまうようです (終了後にデバッグログが突然途切れる) 。  
> 本当は Graceful に終了できる状態が理想ではありますが、Wine 上で稼働していることもあり難しそうです。  
> 本来は行われるであろう終了時処理もおそらく行われないため、Docker コンテナを停止する際は、可能であれば一度タスクトレイから EpgTimerSrv を終了してから `docker compose stop` を実行した方がより安全だと思われます。

### 4. EDCB の設定

ブラウザで `http://<ホストマシンのIPアドレス>:6510` にアクセスすると、**Docker コンテナ内で稼働している Xfce のデスクトップ画面を Web ブラウザから操作できます！**  
別途操作側のデバイスに VNC や RDP のクライアントをインストールする必要はありません。

この Xfce のデスクトップ環境は軽量化のため、EDCB 本体（ホストマシン側からマウントされている）、日本語入力用の Fcitx5-mozc 、ファイルマネージャー、タスクマネージャー、ターミナル、設定 UI 以外のアプリは一切インストールされていません。  
EpgTimerSrv / EpgDataCap_Bon の動作確認と UI 操作が行える、最低限の GUI 環境となっています。

> **Note**  
> 英数字と日本語の入力切り替えは、`Ctrl (Control) + Space` で行えます。  
> おそらく noVNC 側の問題で全角/半角キーが反応しないため、IME 切り替えはこの方法で行ってください。

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/8785f152-363e-4364-82c5-0a2b49572988)

デスクトップ左側の EpgDataCap_Bon のアイコンをクリックすると、**EDCB の録画用アプリである EpgDataCap_Bon を起動できます！**  
初回起動時は「チャンネル情報の読み込みに失敗しました」と表示されますが、これからチャンネルスキャンを行うため問題ありません。

> **Note**  
> EpgTimerSrv (EpgTimer Service) が予約録画タスクを司る EDCB のコアとなるデーモンプロセスで、EpgDataCap_Bon は録画開始時や EPG 取得時に自動で EpgTimerSrv から起動・制御される、録画用アプリという位置づけです。  
> このため、受信確認・チャンネルスキャン・設定以外では、EpgDataCap_Bon を手動で起動する機会はあまりありません。  
> EpgDataCap_Bon 単体で録画することもできますが、EDCB Material WebUI or EpgTimerNW (後述) から行う方が便利で安全です。  
> EpgTimer は EpgTimerSrv サーバーのフロントエンド (C# 製) で、テレビ予約録画サーバーとしての EDCB は EpgTimerSrv と EpgDataCap_Bon だけで動作します。

**まずはチャンネルスキャンを行いましょう。**  
チャンネルスキャンが行われていないと、EpgTimerSrv は配置された BonDriver を認識できません。  

BonDriver_mirakc.dll をちゃんとオープンできる (EpgDataCap_Bon のウインドウに Signal の値が表示される) ことを確認してから、チャンネルスキャンを開始してください。  
地デジ・BS・CS のすべてのチャンネルをスキャンするため、スキャンの完了までには10分ほど時間がかかります。  
なお、深夜にチャンネルスキャンを行うと、停波中のチャンネルがスキャン結果から漏れてしまいます。できるだけ日中に行うようにしてください。

> **Note**  
> EpgDataCap_Bon で BonDriver_mirakc.dll のオープンに失敗した場合は、ホストマシン上で Mirakurun / mirakc が起動していないか、何らかの要因でうまく接続できていない可能性が高いです。  
> ホストマシン上で稼働しているサーバーとの通信を容易にするために `network_mode` を `host` に設定しているため、Docker コンテナからだけアクセスできなくなることはないはずです。  
> デスクトップ環境のターミナルから `wget -O - http://localhost:40772/api/version` と実行して、Mirakurun / mirakc にアクセスできるか確認してみてください。

> **Note**  
> 通常の BonDriver では受信感度としてそのまま dB 値が表示されますが、BonDriver_mirakc では Mirakurun / mirakc の構造上受信感度が取得できないため、代わりに TS ストリームのビットレート (Mbps 単位) が表示されるようです。

チャンネルスキャンが終わったら、EpgDataCap_Bon の設定 UI を確認しておきましょう。  
録画フォルダ設定は EpgTimerSrv と共通 (`Common.ini`) なので、ここで設定する必要はありません (もちろんここでやっておいても OK) 。  

ステップ 2 で事前にサンプル設定ファイルをコピーしてある場合は、特に設定変更をしなくてもそのまま動作するはずです。  
もし変更したい項目があれば適宜設定してください。

> **Note**  
> まったく CS や BS の有料放送を視聴しない場合は、EpgDataCap_Bon の設定 → `[EPG取得設定]` / `[サービス表示設定]` から、BS / CS の有料放送を EPG 取得の対象から除外しておくと便利です。

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/1a36664e-22be-4192-aa6d-32cc4c0ef68a)

**EpgTimerSrv の設定 UI は、画面右上のタスクトレイを右クリック → `[システム]` → `[Srv設定]` から表示できます！**

ステップ 2 で事前にサンプル設定ファイルをコピーしてある場合は、録画保存フォルダ / 録画情報保存フォルダと、BonDriver_mirakc.dll に割り当てるチューナー数、EPG 取得に利用するチューナー数のみ、環境に合わせて変更してください。  
サンプル設定ファイルで既にある程度設定を済ませてあるため、それ以外の設定変更は基本的に不要です（適宜お好みで調整してください）。

> **Warning**  
> 既知の問題として、**BonDriver_mirakc は EDCB から見るとあたかもマルチチューナーであるかのように振る舞いますが、実際に利用できるチューナーはマルチチューナーでない場合に注意が必要です。**  
> たとえば **Mirakurun と PX-W3U4 (地上波×2・BS/CS×2) を利用している環境では EpgTimerSrv のチューナー数設定で BonDriver_mirakc.dll に 4 チューナーを割り当てる必要がありますが、実際に 地デジ×4 or BS/CS×4 で同時に録画することはできません。**  
> このケースでは、**EPG 取得に利用するチューナー数は、地上波と BS/CS を合わせた総チューナー数の半分にする必要があります (PX-W3U4 であれば 2 本) 。**  
> さもないと、EPG 取得時に一斉に BS チャンネルを開こうとするなど、実際に利用できるチューナー数を超えてしまい、EPG 取得に失敗します。  
> また、PX-W3U4 で例えると 地デジ or BS/CS のどちらか片方で同じ時間帯に 3 チャンネル以上録画予約を追加した際（当然チューナー不足になる）、EpgTimerSrv 側でチューナー不足になることを事前に把握できない問題もあります。  
> この問題は、BonDriver_mirakc を地上波専用・BS/CS 専用の 2 つの BonDriver に分割できるオプションを追加する改造を行えば回避できると考えられます。

設定が終わったら、**一旦 EpgTimerSrv をタスクトレイから終了してください。**  
前述したようにすぐに EpgTimerSrv が再度起動され、変更後の設定が反映されます。

> **Warning**  
> まれにですが、デスクトップをクリックしてもソフトが起動しなくなったり、起動した場合も × ボタンで終了できなくなったりすることがあります。  
> 同時に x11vnc が謎に再起動していることが関係しているようですが、今のところ原因は不明です。  
> なお、この問題が起きた際の EDCB への動作の影響はありません。UI こそフリーズしたような状態になりますが、予約録画や EPG 取得は正常に行われます。  
> 発生間隔はランダムため、まったく発生しないこともあります。もしこの問題が発生した際は、Docker コンテナを再起動してみてください（その際、録画中でないかをしっかり確認してください）。  
> `docker compose exec edcb-wine /bin/bash` でコンテナに入り、Xvfb のプロセスを kill することでも対処できます。ただし、起動中の EpgTimerSrv や EpgDataCap_Bon はいずれにせよ強制終了されてしまうようなので、コンテナを再起動するのとさほど変わりません。

なお、EpgTimer に関しては、Wine-mono を使えば動作はすると思われるものの、

- EDCB Material Web UI を使えば、EpgTimer で使える機能の多くがブラウザ上から PC・スマホを問わず利用できること
- EpgTimerNW を使えば、Windows PC からリモートで EDCB-Wine 上で起動している EpgTimerSrv を操作できること
- Wine-mono を入れることで、Docker イメージサイズがかなり膨らむことが予想されたこと
- さすがに Wine だと動作が重そうなこと

を考慮し、対応を見送りました。

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/1b308f3b-991e-47f9-9646-823e62380b09)

Windows PC から EpgTimer を使い EpgTimerSrv をリモート操作したい場合は、[DTV-Builds](https://github.com/tsukumijima/DTV-Builds) で公開している EDCB のビルド済みアーカイブから EpgTimer.exe を入手したあと、EpgTimerNW.exe にリネームして、適当な場所に新規作成したフォルダに移動してください。  

その後 EpgTimerNW.exe を起動すると、**EDCB-Wine で稼働している EpgTimerSrv にリモート接続できます！**  
EpgTimerSrv のサーバー設定以外は、Windows 上で EDCB を使う際と同じように予約操作を行えます。  
番組改編期などで大量の EPG 予約追加/削除を一括で行いたいケースでは、EDCB Material WebUI より EpgTimerNW の方が便利です。

### 5. EDCB Material WebUI にアクセス

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/1aa0ff34-a83f-4bd0-b6c3-9fed72be1631)

ブラウザで `http://<ホストマシンのIPアドレス>:5510/EMWUI/epg.html` にアクセスすると、**EDCB Material WebUI の Web 画面が表示されます！**

初回起動時のみ EPG 取得が全く行われていないため、番組表には何も表示されていないか、不完全な状態になっています。  
サンプル設定ファイルでは、毎日 06:15 と 18:15 に定期的に EPG 取得を行うように設定しています。

<img width="50%" src="https://github.com/tsukumijima/EDCB-Wine/assets/39271166/56420d4f-5b14-4107-b1e4-0708f19d08bc"><br>

**すぐに EPG 取得を行いたい場合は、番組表ページ右上のメニューから「EPG 取得」をクリックしてください。**  
EPG 取得対象に設定したすべてのチャンネルの EPG 取得が開始されます。

EPG 取得完了にはかなり時間がかかります。  
**EPG 取得が完了すると、すべてのチャンネルの番組表が表示されるはずです。**

![Screenshot](https://github.com/tsukumijima/EDCB-Wine/assets/39271166/4f14a26c-c279-4eb5-8cab-80d1d54938de)

基本操作は Windows での EDCB Material WebUI と同じです。  
ただし、テレビのリモート視聴 / 録画ファイルのストリーミングのみ、Wine 環境では Lua からの外部コマンド実行が正しく動作しない (?) ため、あえて動作しない状態にしています。

EpgTimer でできることの大半は EDCB Material WebUI でも行えます。  
番組表からの予約追加や検索など、EPGStation 同様かそれ以上の操作性で、PC・スマホを問わず利用できるのが特徴です。

> **Note**  
> 前述のとおり、**EDCB-Wine で稼働している EDCB は KonomiTV のバックエンドとしても利用できます。**  
> テレビのライブストリーミングでは、代わりに [KonomiTV](https://github.com/tsukumijima/KonomiTV) を利用することをおすすめします（手前味噌）。録画視聴機能は鋭意開発中なのでしばしお待ちを…。

## License

[MIT License](License.txt)
