--情報通知ログの表示を許可するかどうか
SHOW_NOTIFY_LOG=true
--デバッグ出力の表示を許可するかどうか
SHOW_DEBUG_LOG=false

--設定メニューからの設定の変更を許可するかどうか
ALLOW_SETTING=false

--※true/falseの設定は例えばリモートアドレスと比較して接続元の限定も可能
--ALLOW_SETTING=mg.request_info.remote_addr=='127.0.0.1' or mg.request_info.remote_addr=='::1'

--メニューに「システムスタンバイ」ボタンを表示するかどうか(Windows専用)
INDEX_ENABLE_SUSPEND=false
--メニューの「システムスタンバイ」ボタンを「システム休止」にするかどうか
INDEX_SUSPEND_USE_HIBERNATE=false

--配色について'dark'=強制ダークモード、'light'=強制ライトモード、''=環境に従う
COLOR_SCHEME=''

--「プロセス管理」に表示するプロセス名のリスト(Windowsでは末尾に".exe"が追加される)
PROCESS_MANAGEMENT_LIST={
  'EpgDataCap_Bon',
  'ffmpeg',
  'nvencc',
  'nvencc64',
  'qsvencc',
  'qsvencc64',
  'vceencc',
  'vceencc64',
  'jkcnsl',
  'jkrdlog',
}

--各種一覧のいちどに表示する行数
RESERVE_PAGE_COUNT=50
RECINFO_PAGE_COUNT=50
AUTOADDEPG_PAGE_COUNT=50

--リスト番組表の非表示にしたいサービス
HIDE_SERVICES={
  --非表示にしたいサービスを['ONID-TSID-SID']=true,のように指定
  --['1-2345-6789']=true,
}

--番組表の1分あたりの番組高さ
EPG_ONE_MIN_PX=2
--番組表の番組の最低表示高さ
EPG_MINIMUM_PX=12
--番組表のサービスあたりの幅
EPG_SERVICE_PX=150
--番組表の時刻軸を入れる間隔
EPG_TIME_COLUMN=3
--番組表の番組を絞り込みたいときはメモ欄かNOTキーワードの先頭を"#EPG_CUST_1"にした自動EPG予約を作る

--ライブラリに表示するフォルダをドキュメントルートから'/'区切りの相対パスで指定
--指定フォルダとその3階層下のフォルダにあるメディアファイルまでが表示対象
LIBRARY_LIST={
  'video',
}

--ライブラリなどに表示するメディアファイルの拡張子を指定
--EpgTimerSrv設定の「TSファイルの拡張子」はあらかじめ指定されている
MEDIA_EXTENSION_LIST={
  '.mp4',
  '.webm',
}

--メディアファイルのサムネイル画像の位置(0～1未満の値は割合、これ以外の正の値は秒数、負の値は末尾からの秒数)
--最大5個。今のところTSファイルのみ対応。TS-Live!モジュールが必要
THUMBNAILS={
  20,
  1/3,
  -20,
}

--シーク中にサムネイル画像を表示するかどうか。TS-Live!モジュールが必要
THUMBNAIL_ON_SEEK=true

--HLS(HTTP Live Streaming)を許可するかどうか。する場合はtsmemseg.exeを用意すること
ALLOW_HLS=true
--ネイティブHLS非対応環境でもhls.jsを使ってHLS再生するかどうか
ALWAYS_USE_HLS=true
--HLS再生時にトランスコーダーから受け取ったMPEG2-TSをMP4に変換するかどうか。有効時はHEVCトランスコードに対応
--※Android版Firefoxでは不具合があるため無効扱いになる
USE_MP4_HLS=true
--視聴機能(viewボタン)でLowLatencyHLSにするかどうか。再生遅延が小さくなる。ネイティブHLS環境ではHTTP/2が要求されるためhls.js使用時のみ有用
USE_MP4_LLHLS=true

--倍速再生の倍率のリスト
XCODE_FAST_RATES={
  0.5,
  0.75,
  1.0,
  1.25,
  1.5,
  2.0,
}

--トランスコードオプション
--HLSのときはセグメント長約4秒、最大8MBytes(=1秒あたり16Mbits)を想定しているので、オプションもそれに合わせること
--HLSでないときはフラグメントMP4などを使ったプログレッシブダウンロード。字幕は適当な重畳手法がまだないので未対応
--name:表示名
--xcoder:トランスコーダーのToolsフォルダからの相対パス。'|'で複数候補を指定可。見つからなければ最終候補にパスが通っているとみなす
--       Windows以外では".exe"が除去されて最終候補のみ参照される
--option:$OUTPUTは必須、再生時に適宜置換される。標準入力からMPEG2-TSを受け取るようにオプションを指定する
--filter(Cinema):等速再生用、filterCinemaは未定義でもよい。特別に':'とするとトランスコードを省略してそのまま出力する
--filter*FastFunc:倍速再生用、未定義でもよい。倍率に応じたオプションを返す関数を指定する
--editorFast:単独で倍速再生にできないトランスコーダーの手前に置く編集コマンド。指定方法はxcoderと同様
--editorOptionFastFunc:標準入出力ともにMPEG2-TSで倍速再生になるようにオプションを返す関数を指定する
--autoCinema:TS-Live!方式専用。Cinema(逆テレシネ)モードを自動切り替え
XCODE_OPTIONS={
  {
    --ffmpegの例。-b:vでおおよその最大ビットレートを決め、-qminで動きの少ないシーンのデータ量を節約する
    name='432p/h264/ffmpeg',
    xcoder='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    option='-f mpegts -analyzeduration 1M -i - -map 0:v:0? -vcodec libx264 -flags:v +cgop -profile:v main -level 31 -b:v 2400k -qmin 23 -maxrate 5M -bufsize 5M -preset veryfast $FILTER -s 768x432 -map 0:a:$AUDIO -acodec aac -ac 2 -b:a 160k $CAPTION -max_interleave_delta 500k $OUTPUT',
    filter='-g 120 -vf yadif=0:-1:1',
    filterCinema='-g 96 -vf pullup -r 24000/1001',
    filterFastFunc=function(rate) return '-g 120 -vf yadif=0:-1:1,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate end,
    filterCinemaFastFunc=function(rate) return '-g 96 -vf pullup,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -r 24000/1001' end,
    captionNone='-sn',
    captionHls='-map 0:s? -scodec copy',
    output={'mp4','-f mp4 -movflags frag_keyframe+empty_moov -'},
    outputHls={'m2t','-f mpegts -'},
  },
  {
    name='720p/h264/ffmpeg-nvenc',
    xcoder='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    option='-f mpegts -analyzeduration 1M -i - -map 0:v:0? -vcodec h264_nvenc -profile:v main -level 41 -b:v 3936k -qmin 23 -maxrate 8M -bufsize 8M -preset medium $FILTER -s 1280x720 -map 0:a:$AUDIO -acodec aac -ac 2 -b:a 160k $CAPTION -max_interleave_delta 500k $OUTPUT',
    filter='-g 120 -vf yadif=0:-1:1',
    filterCinema='-g 96 -vf pullup -r 24000/1001',
    filterFastFunc=function(rate) return '-g 120 -vf yadif=0:-1:1,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate end,
    filterCinemaFastFunc=function(rate) return '-g 96 -vf pullup,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -r 24000/1001' end,
    captionNone='-sn',
    captionHls='-map 0:s? -scodec copy',
    output={'mp4','-f mp4 -movflags frag_keyframe+empty_moov -'},
    outputHls={'m2t','-f mpegts -'},
  },
  {
    name='720p/h264/ffmpeg-qsv',
    xcoder='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    option='-f mpegts -analyzeduration 1M -i - -map 0:v:0? -vcodec h264_qsv -profile:v main -level 41 -b:v 3936k -min_qp_i 23 -min_qp_p 26 -min_qp_b 30 -maxrate 8M -bufsize 8M -preset medium $FILTER -s 1280x720 -map 0:a:$AUDIO -acodec aac -ac 2 -b:a 160k $CAPTION -max_interleave_delta 500k $OUTPUT',
    filter='-g 120 -vf yadif=0:-1:1',
    filterCinema='-g 96 -vf pullup -r 24000/1001',
    filterFastFunc=function(rate) return '-g 120 -vf yadif=0:-1:1,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate end,
    filterCinemaFastFunc=function(rate) return '-g 96 -vf pullup,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -r 24000/1001' end,
    captionNone='-sn',
    captionHls='-map 0:s? -scodec copy',
    output={'mp4','-f mp4 -movflags frag_keyframe+empty_moov -'},
    outputHls={'m2t','-f mpegts -'},
  },
  {
    name='720p/h264/ffmpeg-amf',
    xcoder='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    option='-f mpegts -analyzeduration 1M -i - -map 0:v:0? -vcodec h264_amf -profile:v main -level 41 -b:v 3936k -min_qp_i 23 -min_qp_p 26 -min_qp_b 30 -maxrate 8M -bufsize 8M -preset balanced $FILTER -s 1280x720 -map 0:a:$AUDIO -acodec aac -ac 2 -b:a 160k $CAPTION -max_interleave_delta 500k $OUTPUT',
    filter='-g 120 -vf yadif=0:-1:1',
    filterCinema='-g 96 -vf pullup -r 24000/1001',
    filterFastFunc=function(rate) return '-g 120 -vf yadif=0:-1:1,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate end,
    filterCinemaFastFunc=function(rate) return '-g 96 -vf pullup,setpts=PTS/'..rate..' -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -r 24000/1001' end,
    captionNone='-sn',
    captionHls='-map 0:s? -scodec copy',
    output={'mp4','-f mp4 -movflags frag_keyframe+empty_moov -'},
    outputHls={'m2t','-f mpegts -'},
  },
  {
    name='360p/webm/ffmpeg',
    xcoder='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    option='-f mpegts -analyzeduration 1M -i - -map 0:v:0? -vcodec libvpx -b:v 1888k -quality realtime -cpu-used 1 $FILTER -s 640x360 -map 0:a:$AUDIO -acodec libvorbis -ac 2 -b:a 160k $CAPTION -max_interleave_delta 500k $OUTPUT',
    filter='-vf yadif=0:-1:1',
    filterCinema='-vf pullup -r 24000/1001',
    filterFastFunc=function(rate) return '-vf yadif=0:-1:1,setpts=PTS/'..rate..' -af atempo='..rate end,
    filterCinemaFastFunc=function(rate) return '-vf pullup,setpts=PTS/'..rate..' -af atempo='..rate..' -r 24000/1001' end,
    captionNone='-sn',
    output={'webm','-f webm -'},
  },
  {
    --NVEncCの例。倍速再生にはffmpegも必要
    name='720p/h264/NVEncC',
    xcoder='NVEncC\\NVEncC64.exe|NVEncC\\NVEncC.exe|NVEncC64.exe|nvencc.exe',
    option='--input-format mpegts --input-analyze 1 --input-probesize 4M -i - --avhw --avsync forcecfr --profile main --level 4.1 --vbr 3936 --qp-min 23:26:30 --max-bitrate 8192 --vbv-bufsize 8192 --preset default $FILTER --output-res 1280x720 --audio-stream $AUDIO?:stereo --audio-codec $AUDIO?aac --audio-bitrate $AUDIO?160 --audio-disposition $AUDIO?default $CAPTION -m max_interleave_delta:500k $OUTPUT',
    audioStartAt=1,
    filter='--gop-len 120 --interlace tff --vpp-deinterlace normal',
    filterCinema='--gop-len 96 --interlace tff --vpp-deinterlace normal --vpp-decimate',
    filterFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(120*rate)..' --interlace tff --vpp-deinterlace normal' end,
    filterCinemaFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(96*rate)..' --interlace tff --vpp-deinterlace normal --vpp-decimate' end,
    editorFast='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    editorOptionFastFunc=function(rate) return '-f mpegts -analyzeduration 1M -i - -bsf:v setts=ts=TS/'..rate..' -map 0:v:0? -vcodec copy -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -map 0:a -acodec ac3 -ac 2 -b:a 640k -map 0:s? -scodec copy -max_interleave_delta 300k -f mpegts -' end,
    captionNone='',
    captionHls='--sub-copy',
    output={'mp4','-f mp4 --no-mp4opt -m movflags:frag_keyframe+empty_moov -o -'},
    outputHls={'m2t','-f mpegts -o -'},
  },
  {
    --QSVEncCの例。倍速再生にはffmpegも必要
    name='720p/h264/QSVEncC',
    xcoder='QSVEncC\\QSVEncC64.exe|QSVEncC\\QSVEncC.exe|QSVEncC64.exe|qsvencc.exe',
    option='--input-format mpegts --input-analyze 1 --input-probesize 4M -i - --avhw --avsync forcecfr --profile main --level 4.1 --qvbr 3936 --qvbr-quality 26 --fallback-rc --max-bitrate 8192 --vbv-bufsize 8192 $FILTER --output-res 1280x720 --audio-stream $AUDIO?:stereo --audio-codec $AUDIO?aac --audio-bitrate $AUDIO?160 --audio-disposition $AUDIO?default $CAPTION -m max_interleave_delta:500k $OUTPUT',
    audioStartAt=1,
    filter='--gop-len 120 --interlace tff --vpp-deinterlace normal',
    filterCinema='--gop-len 96 --interlace tff --vpp-deinterlace normal --vpp-decimate',
    filterFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(120*rate)..' --interlace tff --vpp-deinterlace normal' end,
    filterCinemaFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(96*rate)..' --interlace tff --vpp-deinterlace normal --vpp-decimate' end,
    editorFast='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    editorOptionFastFunc=function(rate) return '-f mpegts -analyzeduration 1M -i - -bsf:v setts=ts=TS/'..rate..' -map 0:v:0? -vcodec copy -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -map 0:a -acodec ac3 -ac 2 -b:a 640k -map 0:s? -scodec copy -max_interleave_delta 300k -f mpegts -' end,
    captionNone='',
    captionHls='--sub-copy',
    output={'mp4','-f mp4 --no-mp4opt -m movflags:frag_keyframe+empty_moov -o -'},
    outputHls={'m2t','-f mpegts -o -'},
  },
  {
    --QSVEncCの例。HEVC(未対応環境多め)。倍速再生にはffmpegも必要
    name='720p/hevc/QSVEncC',
    xcoder='QSVEncC\\QSVEncC64.exe|QSVEncC\\QSVEncC.exe|QSVEncC64.exe|qsvencc.exe',
    option='--input-format mpegts --input-analyze 1 --input-probesize 4M -i - --avhw --avsync forcecfr -c hevc --profile main --level 4.1 --qvbr 3936 --qvbr-quality 26 --fallback-rc --max-bitrate 8192 --vbv-bufsize 8192 $FILTER --output-res 1280x720 --audio-stream $AUDIO?:stereo --audio-codec $AUDIO?aac --audio-bitrate $AUDIO?160 --audio-disposition $AUDIO?default $CAPTION -m max_interleave_delta:500k $OUTPUT',
    audioStartAt=1,
    filter='--gop-len 120 --interlace tff --vpp-deinterlace normal',
    filterCinema='--gop-len 96 --interlace tff --vpp-deinterlace normal --vpp-decimate',
    filterFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(120*rate)..' --interlace tff --vpp-deinterlace normal' end,
    filterCinemaFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(96*rate)..' --interlace tff --vpp-deinterlace normal --vpp-decimate' end,
    editorFast='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    editorOptionFastFunc=function(rate) return '-f mpegts -analyzeduration 1M -i - -bsf:v setts=ts=TS/'..rate..' -map 0:v:0? -vcodec copy -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -map 0:a -acodec ac3 -ac 2 -b:a 640k -map 0:s? -scodec copy -max_interleave_delta 300k -f mpegts -' end,
    captionNone='',
    captionHls='--sub-copy',
    output={'mp4','-f mp4 --no-mp4opt -m movflags:frag_keyframe+empty_moov -o -'},
    outputHls={'m2t','-f mpegts -o -'},
  },
  {
    --VCEEncCの例。倍速再生にはffmpegも必要。あまり良い例ではない。ffmpegのh264_amfのほうが安定している雰囲気
    name='720p/h264/VCEEncC',
    xcoder='VCEEncC\\VCEEncC64.exe|VCEEncC\\VCEEncC.exe|VCEEncC64.exe|vceencc.exe',
    option='--input-format mpegts --input-analyze 1 --input-probesize 4M -i - --avsw --avsync forcecfr --profile main --level 4.1 --vbr 3936 --qp-min 23:26:30 --max-bitrate 8192 --vbv-bufsize 8192 --preset balanced $FILTER --output-res 1280x720 --audio-stream $AUDIO?:stereo --audio-codec $AUDIO?aac --audio-bitrate $AUDIO?160 --audio-disposition $AUDIO?default $CAPTION -m max_interleave_delta:500k $OUTPUT',
    audioStartAt=1,
    filter='--gop-len 120 --interlace tff --vpp-afs preset=default',
    filterCinema='--gop-len 96 --interlace tff --vpp-afs preset=cinema,24fps=true',
    filterFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(120*rate)..' --interlace tff --vpp-afs preset=default' end,
    filterCinemaFastFunc=function(rate) return '--fps '..math.floor(30000*rate+0.5)..'/1001 --gop-len '..math.floor(96*rate)..' --interlace tff --vpp-afs preset=cinema,24fps=true' end,
    editorFast='ffmpeg\\ffmpeg.exe|ffmpeg.exe',
    editorOptionFastFunc=function(rate) return '-f mpegts -analyzeduration 1M -i - -bsf:v setts=ts=TS/'..rate..' -map 0:v:0? -vcodec copy -af atempo='..rate..' -bsf:s setts=ts=TS/'..rate..' -map 0:a -acodec ac3 -ac 2 -b:a 640k -map 0:s? -scodec copy -max_interleave_delta 300k -f mpegts -' end,
    captionNone='',
    captionHls='--sub-copy',
    output={'mp4','-f mp4 --no-mp4opt -m movflags:frag_keyframe+empty_moov -o -'},
    outputHls={'m2t','-f mpegts -o -'},
  },
  {
    --TS-Live!方式の例。そのまま転送。トランスコーダー不要(tsreadex.exeは必要)
    name='TS-Live!',
    tslive=true,
    autoCinema=true,
    xcoder='',
    option='',
    filter=':',
    filterFastFunc=function() return ':' end,
    output={'m2t',''},
  },
}

--フォーム上の各オプションのデフォルト選択状態を指定する
XCODE_SELECT_OPTION=1
XCODE_CHECK_CINEMA=false
XCODE_SELECT_FAST=0
XCODE_CHECK_CAPTION=false
XCODE_CHECK_JIKKYO=false

--トランスコード時、初期値ミュートで再生するかどうか
--自動再生が無効になるブラウザが多いため、一時停止しつづけるとタイムアウトするトランスコード時はミュートを推奨
XCODE_VIDEO_MUTED=true

--非トランスコード時、初期値ミュートで再生するかどうか
VIDEO_MUTED=false

--音量の初期値。0～1、nilのとき未指定
VIDEO_VOLUME=nil

--字幕表示のオプション https://github.com/monyone/aribb24.js#options
ARIBB24_JS_OPTION=[=[
  normalFont:'"Rounded M+ 1m for ARIB","Kosugi Maru",sans-serif',
  drcsReplacement:true
]=]

--字幕表示にSVGRendererを使うかどうか。描画品質が上がる(ただし一部ブラウザで背景に線が入る)
ARIBB24_USE_SVG=false

--データ放送表示機能を使うかどうか。トランスコード中に表示する場合はpsisiarc.exeを用意すること
USE_DATACAST=true

--データ放送の郵便番号(7桁)の初期値。例えば東京都西新宿は'1600023'。''のとき未設定
NVRAM_ZIP=''

--データ放送の県域コード(1～50)の初期値。例えば東京都は14。0のとき未設定。県域とコードの対応はメニュー→NVRAM設定→地域を参照
NVRAM_REGION=0

--ライブ実況表示機能を使うかどうか
--利用にはJKCNSL_PATHを設定するか、実況を扱うツール側の対応(NicoJKの場合はcommentShareMode)が必要
USE_LIVEJK=true

--jkcnslを直接呼び出してライブ実況する場合、その絶対パス。Windows以外ではコマンド名
--コメント投稿したい場合はあらかじめjkcnsl側でログインしておく(jkcnslのReadmeを参照)
JKCNSL_PATH=nil
--JKCNSL_PATH='C:\\Path\\to\\jkcnsl.exe' --Windows
--JKCNSL_PATH='jkcnsl' --Windows以外

--jkcnslの設定ファイルなどが置かれている場所(通常、変更不要)
JKCNSL_UNIX_BASE_DIR='/var/local/jkcnsl'

--以下、JKCNSL_で始まる定数はjkcnslを直接呼び出してライブ実況する場合のオプション。意味はNicoJKの対応する設定と同じ
JKCNSL_REFUGE_URI=nil
JKCNSL_DROP_FORWARDED_COMMENT=false
JKCNSL_REFUGE_MIXING=false
JKCNSL_ANONYMITY=true

--実況の番号(jk?)と、チャットのID(ch???やlv???など)
--指定しない番号には"jkconst.lua"にある既定値が使われる
JKCNSL_CHAT_STREAMS={
  --jk7の対応づけを変更したいとき
  --[7]='ch???',
  --jk7はどこにも接続したくないとき
  --[7]='',
  --jk7はニコニコ実況だけにしたいとき
  --[7]='ch2646441,',
  --jk7はNX-Jikkyo・避難所だけにしたいとき("NX"の部分は任意の英数字)
  --[7]=',NX',
}

--実況ログ表示機能を使う場合、jkrdlog.exeの絶対パス。Windows以外ではコマンド名
JKRDLOG_PATH=nil
--JKRDLOG_PATH='C:\\Path\\to\\jkrdlog.exe' --Windows
--JKRDLOG_PATH='jkrdlog' --Windows以外

--実況コメントの文字の高さ(px)
JK_COMMENT_HEIGHT=32

--実況コメントの表示時間(秒)
JK_COMMENT_DURATION=5

--実況ログ表示機能のデジタル放送のサービスIDと、実況の番号(jk?)
--キーの下4桁の16進数にサービスID、上1桁にネットワークID(ただし地上波は15=0xF)を指定
--指定しないサービスには"jkconst.lua"にある既定値が使われる
JK_CHANNELS={
  --例:テレビ東京(0x0430)をjk7と対応づけたいとき
  --[0xF0430]=7,
  --例:NHKBS1(0x0065)とデフォルト(jk101)との対応付けを解除したいとき
  --[0x40065]=-1,
}

--chatタグ表示前の置換(JavaScript)
JK_CUSTOM_REPLACE=[=[
  // 広告などを下コメにする
  tag = tag.replace(/^<chat(?![^>]*? mail=)/, '<chat mail=""');
  tag = tag.replace(/^(<chat[^>]*? premium="3"[^>]*?>\/nicoad )(\{[^<]*?"totalAdPoint":)(\d+)/, "$1$3$2");
  tag = tag.replace(/^<chat(?=[^>]*? premium="3")([^>]*? mail=")([^>]*?>)\/nicoad (\d*)\{[^<]*?"message":("[^<]*?")[,}][^<]*/, '<chat align="right"$1shita small yellow $2$4($3pt)');
  tag = tag.replace(/^<chat(?=[^>]*? premium="3")([^>]*? mail=")([^>]*?>)\/spi /, '<chat align="right"$1shita small white2 $2');
]=]

--トランスコードするプロセスを1つだけに制限するかどうか(並列処理できる余裕がシステムにない場合など)
XCODE_SINGLE=false
--ログを"log"フォルダに保存するかどうか
XCODE_LOG=false
--出力バッファの量(bytes)。asyncbuf.exeを用意すること。変換負荷や通信のむらを吸収する
XCODE_BUF=0
--転送開始前に変換しておく量(bytes)
XCODE_PREPARE=0

--このサイズ以上のときページ圧縮する(nilのとき常に非圧縮)
GZIP_THRESHOLD_BYTE=4096

--処理するPOSTリクエストボディの最大値
POST_MAX_BYTE=1024*1024

----------定数定義ここまで----------

--以下、関数名はパスカルケース、定数名はアッパースネークケースとし、変数は関数スコープに閉じ込めること

function Checkbox(b)
  return ' type="checkbox" value="1"'..(b and ' checked' or '')
end

function Selected(b)
  return b and ' selected' or ''
end

function GetTranscodeQueries(qs)
  local reload=(mg.get_var(qs,'reload') or ''):match('^'..('[0-9a-f]'):rep(16,'?')..'$')
  local loadKey=reload or (mg.get_var(qs,'load') or ''):match('^'..('[0-9a-f]'):rep(16,'?')..'$')
  local option=GetVarInt(qs,'option',1,#XCODE_OPTIONS)
  return {
    option=option,
    tslive=XCODE_OPTIONS[option or 1].tslive,
    autoCinema=XCODE_OPTIONS[option or 1].autoCinema,
    offset=GetVarInt(qs,'offset',0,100),
    audio2=GetVarInt(qs,'audio2')==1,
    cinema=GetVarInt(qs,'cinema')==1,
    --0は明示的に等速を表す
    fast=option and not XCODE_OPTIONS[option].filterFastFunc and 0 or GetVarInt(qs,'fast',0,#XCODE_FAST_RATES),
    reload=not not reload,
    loadKey=loadKey,
    caption=(GetVarInt(qs,'caption') or XCODE_CHECK_CAPTION and 1)==1,
    jikkyo=(GetVarInt(qs,'jikkyo') or XCODE_CHECK_JIKKYO and 1)==1,
  }
end

function ConstructTranscodeQueries(xq)
  return (xq.option and '&amp;option='..xq.option or '')
    ..(xq.offset and '&amp;offset='..xq.offset or '')
    ..(xq.audio2 and '&amp;audio2=1' or '')
    ..(xq.cinema and '&amp;cinema=1' or '')
    ..(xq.fast and '&amp;fast='..xq.fast or '')
    ..(xq.loadKey and '&amp;'..(xq.reload and 're' or '')..'load='..xq.loadKey or '')
end

function VideoWrapperBegin()
  return '<div class="video-wrapper" id="vid-wrap">'
    ..'<div class="data-broadcasting-browser-container"><div class="data-broadcasting-browser-content"></div></div>'
    ..'<div class="video-full-container arib-video-invisible-container" id="vid-full">'
    ..'<div class="video-container arib-video-container arib-video-container-prepend arib-video-container-tunnel-pointer" id="vid-cont">'
end

function VideoWrapperEnd(jkList,shiftable)
  local s='</div>'
  if jkList then
    s=s..'<div id="jikkyo-comm"'..(shiftable and ' data-shiftable="1"' or '')..' style="display:none">'
      ..(shiftable and table.concat({'','-15)">-15','-1)">-1','1)">+1','15)">+15',''},'</button><button type="button" onclick="shiftJikkyo('):match('>(.*)<') or '')
      ..'<button type="button" onclick="document.getElementById(\'jikkyo-config\').classList.toggle(\'display\')">Set</button>'
      ..'<span id="jikkyo-config"><select name="id">\n'
      ..'<option value="0" selected>jk? (初期値)\n'
    local esc=edcb.htmlEscape
    edcb.htmlEscape=15
    for i,v in ipairs(jkList) do
      s=s..'<option value="'..v[1]..'">jk'..v[1]..' ('..EdcbHtmlEscape(v[2])..')\n'
    end
    edcb.htmlEscape=esc
    local i=0
    s=s..'</select><input name="tm" type="datetime-local"><select name="tmsec"><option selected>00s'
      ..('_'):rep(59):gsub('_',function() i=i+1 return ('<option>%02ds'):format(i) end)
      ..'</select><button type="button">変更</button></span><div id="jikkyo-chats"></div></div>'
  end
  s=s..'</div></div>'
  return s
end

function TranscodeSettingTemplate(xq,forDL,fsec)
  local s='<select name="option">'
  local esc=edcb.htmlEscape
  edcb.htmlEscape=15
  for i,v in ipairs(XCODE_OPTIONS) do
    if forDL or v.tslive or not ALLOW_HLS or not ALWAYS_USE_HLS or v.outputHls then
      s=s..'<option value="'..i..'"'..Selected((xq.option or XCODE_SELECT_OPTION)==i)..'>'..EdcbHtmlEscape(v.name)
    end
  end
  edcb.htmlEscape=esc
  s=s..'</select>\n'
  if fsec then
    s=s..'<select name="offset">'
    for i=0,100 do
      s=s..'<option value="'..i..'"'..Selected((xq.offset or 0)==i)..(fsec>0 and ' data-sec="'..math.floor(fsec*i/100)..'"' or '')..'>'
        ..(fsec>0 and ('%dm%02ds'):format(math.floor(fsec*i/100/60),fsec*i/100%60)..(i%5==0 and '|'..i..'%' or '') or i..'%')
    end
    s=s..'</select>\n'
      ..'<select name="fast">'
    local has1=false
    for i,v in ipairs(XCODE_FAST_RATES) do
      if not has1 and v==1 then
        has1=true
        i=0
      end
      s=s..'<option value="'..i..'"'..Selected((xq.fast or XCODE_SELECT_FAST)==i)..'>×'..v..(math.fmod(v,1)==0 and '.0' or '')
    end
    if not has1 then
      s=s..'<option value="0"'..Selected((xq.fast or XCODE_SELECT_FAST)==0)..'>×1.0'
    end
    s=s..'</select>\n'
  end
  s=s..'<label><input name="audio2"'..Checkbox(xq.audio2)..'>audio2</label>\n'
    ..'<label><input name="cinema"'..Checkbox(xq.cinema or not xq.option and XCODE_CHECK_CINEMA)..'>cinema</label>\n'
  if fsec then
    s=s..'<span id="vid-offset"></span>'
  end
  s=s..'<span id="vid-bitrate"></span>\n'
    ..'<input type="hidden" name="caption" value="">\n'
    ..'<input type="hidden" name="jikkyo" value="">\n'
  return s
end

function OnscreenButtonsScriptTemplate()
  return [=[
<script src="script.js?ver=20251011"></script>
<script>
runOnscreenButtonsScript();
</script>
]=]
end

function WebBmlScriptTemplate(label)
  local zip=NVRAM_ZIP:match('^'..('[0-9]'):rep(7)..'$')
  local prefecture=math.floor(math.max(NVRAM_REGION<=50 and NVRAM_REGION or 0,0))
  return USE_DATACAST and [=[
<div class="remote-control" style="display:none">
  <button
    type="button" id="key]=]..table.concat({'21">青','22">赤','23">緑','24">黄','1">↑','3">←','18">決定','4">→','2">↓','20">d','19">戻る'},[=[</button><button
    type="button" id="key]=])..[=[</button>
  <label class="expand-on-checked"><input type="checkbox">数字</label><span class="expand-on-checked">
    <button
      type="button" id="key]=]..table.concat({'6">1','7">2','8">3','9">4','10">5','11">6','12">7','13">8','14">9','15">10','16">11','17">12','5">0'},[=[</button><button
      type="button" id="key]=])..[=[</button></span>
  <span class="remote-control-receiving-status" style="display:none">Loading...</span>
  <div class="remote-control-indicator"></div>
</div>
<label class="video-side-item"><input id="cb-datacast" type="checkbox">]=]..label..[=[</label>
<script src="web_bml_play_ts.js"></script>
]=]..(not zip and prefecture==0 and '' or [=[
<script>
(function(){
  var prefix="nvram_prefix=receiverinfo%2F";
]=]..(not zip and '' or [=[
  if(!localStorage.getItem(prefix+"zipcode")){
    localStorage.setItem(prefix+"zipcode",btoa("]=]..zip..[=["));
  }
]=])..(prefecture==0 and '' or [=[
  if(!localStorage.getItem(prefix+"regioncode")){
    localStorage.setItem(prefix+"prefecture",btoa(String.fromCharCode(]=]..prefecture..[=[)));
    localStorage.setItem(prefix+"regioncode",btoa(String.fromCharCode(]=]..GetEwsRegionCode(prefecture)..'>>8,'..GetEwsRegionCode(prefecture)..[=[&0xff)));
  }
]=])..[=[
})();
</script>
]=]) or ''
end

function JikkyoScriptTemplate(live,jikkyo)
  return (live and USE_LIVEJK or not live and JKRDLOG_PATH) and [=[
<label class="video-side-item"><input id="cb-jikkyo"]=]..Checkbox(jikkyo)..[=[>jikkyo</label>
<label class="video-side-item enabled-on-checked"><input id="cb-jikkyo-onscr" type="checkbox" checked>scr</label>
<script src="danmaku.js"></script>
<script>
runJikkyoScript(]=]..JK_COMMENT_HEIGHT..','..JK_COMMENT_DURATION..',function(tag){'..JK_CUSTOM_REPLACE..[=[
  return tag;});
</script>
]=] or ''
end

function VideoScriptTemplate(ists)
  return OnscreenButtonsScriptTemplate()..WebBmlScriptTemplate(ists and 'data' or 'data.psc')..JikkyoScriptTemplate(false,XCODE_CHECK_JIKKYO)..[=[
<label id="label-caption" class="video-side-item" style="display:none"><input id="cb-caption"]=]..Checkbox(XCODE_CHECK_CAPTION)..[=[>CC.vtt</label>
<script src="aribb24.js"></script>
<script>
]=]..(VIDEO_MUTED and 'vid.e.muted=true;\n' or '')..(VIDEO_VOLUME and 'vid.e.volume='..VIDEO_VOLUME..';\n' or '')..[=[
runVideoScript(]=]..(ARIBB24_USE_SVG and 'true' or 'false')..',{'..ARIBB24_JS_OPTION..'}'..[=[);
</script>
]=]
end

function TranscodeScriptTemplate(live,caption,jikkyo,params)
  return OnscreenButtonsScriptTemplate()..WebBmlScriptTemplate('data')..JikkyoScriptTemplate(live,jikkyo)..[=[
<label id="label-caption" class="video-side-item" style="display:none"><input id="cb-caption"]=]..Checkbox(caption)..[=[>CC</label>
]=]..(live and '<label class="video-side-item"><input id="cb-live" type="checkbox">live</label>\n' or '')
  ..(not live and THUMBNAIL_ON_SEEK and EdcbFindFilePlain(mg.script_name:gsub('[^\\/]*$','')..'ts-live-misc.js') and [=[
<script src="ts-live.lua?t=-misc.js"></script>
<span id="vid-seek"><span class="thumb-popup"><canvas style="display:none"></canvas><input type="range" step="0.1" style="display:none" list="vid-seek-marker"></span>
]=] or [=[
<span id="vid-seek"><input type="range" step="0.1" style="display:none" list="vid-seek-marker">
]=])..[=[
<span id="vid-seek-status" style="visibility:hidden">&emsp; &emsp; 88m88s→|%</span>
</span><datalist id="vid-seek-marker"><option></datalist>
<input id="vid-volume" class="video-side-item" type="range" style="display:none">
<button id="vid-unmute" class="video-side-item" type="button" style="display:none">🔊</button>
<script>
]=]..(XCODE_VIDEO_MUTED and '(vid.c||vid.e).muted=true;\n' or '')..(VIDEO_VOLUME and '(vid.c||vid.e).volume='..VIDEO_VOLUME..';\n' or '')..[=[
vid.ofssec=]=]..math.floor(params.ofssec or 0)..[=[;
vid.fast=]=]..(params.fast and params.fast~=0 and XCODE_FAST_RATES[params.fast] or 1)..[=[;
runTranscodeScript("]=]..(live and USE_LIVEJK and 'ctok='..CsrfToken('comment.lua')..'&n='..params.n..(params.id and '&id='..params.id or '') or '')..[=[");
</script>
]=]
end

function HlsScriptTemplate(target)
  return [=[
<script src="aribb24.js"></script>
]=]..(ALWAYS_USE_HLS and [=[
<script src="hls.min.js"></script>
]=] or '')..[=[
<script>
runHlsScript(]=]
  ..(ARIBB24_USE_SVG and 'true' or 'false')..',{'..ARIBB24_JS_OPTION..'},'
  ..(ALWAYS_USE_HLS and 'true' or 'false')..','
  ..'"ctok='..CsrfToken(target)..'&open=1",'
  ..'"&hls='..(edcb.CreateRandom and edcb.CreateRandom(8) or os.time()%86400)..'",'
  ..'"'..(USE_MP4_HLS and '&hls4='..(USE_MP4_LLHLS and '2' or '1') or '')..'"'..[=[
);
</script>
]=]
end

function TsliveScriptTemplate(autoCinema)
  return [=[
<script src="aribb24.js"></script>
<script src="ts-live.lua?t=.js"></script>
<script>
runTsliveScript(]=]
  ..(autoCinema and 'true' or 'false')..','
  ..(ARIBB24_USE_SVG and 'true' or 'false')..',{'..ARIBB24_JS_OPTION..'}'..[=[
);
</script>
]=]
end

function ThumbnailTemplate(f,dur,fsize,fname)
  --戻り値の配列の先頭は描画目標になるタグ、以降はスクリプト
  local r={'<div id="vid-thumbs"></div>',[=[
<script type="text/javascript" src="ts-live.lua?t=-misc.js"></script>
<script type="text/javascript" src="thumb_script.js?ver=20250529"></script>
<script type="text/javascript">
setTimeout(function(){
  createMiscWasmModule().then(function(mod){
    runThumbnailScript(mod,[
        ["]=]}
  if EdcbFindFilePlain(mg.script_name:gsub('[^\\/]*$','')..'ts-live-misc.js') then
    for i=1,math.min(#THUMBNAILS,5) do
      local sec=math.floor(THUMBNAILS[i]<0 and dur+THUMBNAILS[i] or THUMBNAILS[i]<1 and dur*THUMBNAILS[i] or THUMBNAILS[i])
      if SeekSec(f,sec,dur,fsize) then
        --Iフレームを取得してスクリプト上に置いておく
        local stream=GetIFrameVideoStream(f)
        if stream then
          r[#r+1]=mg.base64_encode(stream)
          r[#r+1]='",'..sec..'],\n        ["'
        end
      end
    end
  end
  if #r<=2 then return {''} end
  r[#r]=r[#r]:gsub('].*','')..']\n      ],'..math.min(#THUMBNAILS,5)..','..(fname and '"'..mg.url_encode(fname)..'"' or 'null')..[=[);
  });
},0);
</script>
]=]
  return r
end

--EPG情報をTextに変換(EpgTimerUtil.cppから移植。EpgTimerSrvの番組情報と同じ形式)
function ConvertProgramText(v)
  local s=''
  if v then
    s=s..(v.startTime and FormatTimeAndDuration(v.startTime, v.durationSecond)..(v.durationSecond and '' or ' ～ 未定') or '未定')..'\n'
    local found=BinarySearch(edcb.GetServiceList() or {},v,CompareFields('onid',false,'tsid',false,'sid'))
    if found then
      s=s..found.service_name
    end
    s=s..'\n'..((v.shortInfo and v.shortInfo.event_name or ''):gsub('\r',''):gsub('^\n+','')..'\n'):gsub('\n\n+','\n')..'\n'
      ..DecorateUri(((v.shortInfo and v.shortInfo.text_char or ''):gsub('\r',''):gsub('^\n+','')..'\n'):gsub('\n\n+','\n'))..'\n'
    if v.extInfo then
      s=s..'詳細情報\n'..(v.extInfo.text_char:gsub('\r',''):gsub('^\n+','')..'\n\n'):gsub('\n\n\n+','\n\n')..'\n'
    end
    if v.contentInfoList then
      s=s..'ジャンル : \n'
      for i,w in ipairs(v.contentInfoList) do
        --0x0E00は番組付属情報、0x0E01はCS拡張用情報
        local nibble=w.content_nibble==0x0E00 and w.user_nibble+0x6000 or
                     w.content_nibble==0x0E01 and w.user_nibble+0x7000 or w.content_nibble
        local nibble1=math.floor(nibble/256)
        local name1=edcb.GetGenreName(nibble1*256+255)
        local name2=edcb.GetGenreName(nibble)
        s=s..(name1=='' and ('(0x%02X) - (0x%02X)'):format(nibble1,nibble%256)
                or name1..(name2~='' and ' - '..name2 or nibble1~=0x0F and (' - (0x%02X)'):format(nibble%256) or ''))..'\n'
      end
      s=s..'\n'
    end
    if v.componentInfo then
      local w=v.componentInfo
      local name=edcb.GetComponentTypeName(w.stream_content*256+w.component_type)
      local tc=(w.text_char:gsub('\r',''):gsub('^\n+','')..'\n'):gsub('\n\n+','\n')
      s=s..'映像 : '..(name=='' and ('(0x%02X,0x%02X)'):format(w.stream_content,w.component_type) or name)..'\n'..(#tc>1 and tc or '')
    end
    if v.audioInfoList and #v.audioInfoList>0 then
      s=s..'音声 : '
      for i,w in ipairs(v.audioInfoList) do
        local name=edcb.GetComponentTypeName(w.stream_content*256+w.component_type)
        local tc=(w.text_char:gsub('\r',''):gsub('^\n+','')..'\n'):gsub('\n\n+','\n')
        s=s..(name=='' and ('(0x%02X,0x%02X)'):format(w.stream_content,w.component_type) or name)..'\n'..(#tc>1 and tc or '')
          ..'サンプリングレート : '
          ..(({[1]='16',[2]='22.05',[3]='24',[5]='32',[6]='44.1',[7]='48'})[w.sampling_rate] or ('(0x%02X)'):format(w.sampling_rate))..'kHz\n'
      end
    end
    s=s..'\n'..(NetworkType(v.onid)=='地デジ' and '' or v.freeCAFlag and '有料放送\n\n' or '無料放送\n\n')
    if v.eventRelayInfo and #v.eventRelayInfo.eventDataList>0 then
      s=s..'イベントリレーあり : '
      for i,w in ipairs(v.eventRelayInfo.eventDataList) do
        local found=BinarySearch(edcb.GetServiceList() or {},w,CompareFields('onid',false,'tsid',false,'sid'))
        s=s..('ID:%d(0x%04X)-%d(0x%04X)-%d(0x%04X)-%d(0x%04X)'):format(w.onid,w.onid,w.tsid,w.tsid,w.sid,w.sid,w.eid,w.eid)
          ..(found and ' '..found.service_name or '')..'\n'
      end
      s=s..'\n'
    end
    s=s..('OriginalNetworkID:%d(0x%04X)\n'):format(v.onid,v.onid)
      ..('TransportStreamID:%d(0x%04X)\n'):format(v.tsid,v.tsid)
      ..('ServiceID:%d(0x%04X)\n'):format(v.sid,v.sid)
      ..('EventID:%d(0x%04X)\n'):format(v.eid,v.eid)
  end
  return s
end

--番組情報の文字列をタグ装飾する
function DecorateProgramText(s)
  s=s:gsub('\r?\n','\n')
  --日時とサービス名と番組名をスキップ
  local i,j=s:find('^[^\n]*\n[^\n]*\n.-\n\n')
  if i then
    --番組内容を装飾
    i,j=s:find('^.-\n\n',j+1)
    if i then
      local t=DecorateUri(s:sub(i,j))
      s=s:sub(1,i-1)..t..s:sub(j+1)
      --詳細情報があれば装飾
      i,j=s:find('^詳細情報\n.-\n\n\n',i+#t)
      if i then
        s=s:sub(1,i-1)..'<small>詳細情報</small>'
          ..DecorateUri(s:sub(i+12,j):gsub('\n%- ([^\n]*)','\n<span class="escape-text">- </span><b>%1</b>'))
          ..s:sub(j+1)
      end
    end
  end
  return s:gsub('\n','<br>\n')
end

--録画設定フォームのテンプレート
function RecSettingTemplate(rs,setting)
  local s='<label><input name="recEnabled"'..Checkbox(rs.recMode~=5)..'>有効</label><br>\n'
    ..'録画モード: <select name="recMode">'
  for i=1,#RecModeTextList() do
    s=s..'<option value="'..(i-1)..'"'..Selected((rs.recMode~=5 and rs.recMode or rs.noRecMode or 1)==i-1)..'>'..RecModeTextList()[i]
  end
  s=s..'</select><br>\n'
    ..'<label><input name="tuijyuuFlag"'..Checkbox(rs.tuijyuuFlag)..'>イベントリレー追従</label><br>\n'
    ..'優先度: <select name="priority">'
  for i=1,5 do
    s=s..'<option value="'..i..'"'..Selected(rs.priority==i)..'>'..i..(i==1 and ' (低)' or i==5 and ' (高)' or '')
  end
  --デフォルト値
  local rsdef=(edcb.GetReserveData(0x7FFFFFFF) or {}).recSetting
  s=s..'</select><br>\n'
    ..'<label><input name="pittariFlag"'..Checkbox(rs.pittariFlag)..'>ぴったり（？）録画</label><br>\n'
    ..'録画マージン: <label><input name="useDefMarginFlag"'..Checkbox(not rs.startMargin)..'><span class="enabled-on-checked">デフォルト</span></label> || <span class="disabled-on-checked">'
    ..'開始（秒） <input type="text" name="startMargin" value="'..(rs.startMargin or rsdef and rsdef.startMargin or 0)..'" size="5"> '
    ..'終了（秒） <input type="text" name="endMargin" value="'..(rs.endMargin or rsdef and rsdef.endMargin or 0)..'" size="5"></span><br>\n'
    ..'指定サービス対象データ: <label><input class="" name="serviceMode"'..Checkbox(rs.serviceMode%2==0)..'><span class="enabled-on-checked">デフォルト</span></label> || <span class="disabled-on-checked">'
    ..'<label><input name="serviceMode_1"'..Checkbox(math.floor(rs.serviceMode%2~=0 and rs.serviceMode/16 or rsdef and rsdef.serviceMode/16 or 0)%2~=0)..'>字幕を含める</label> '
    ..'<label><input name="serviceMode_2"'..Checkbox(math.floor(rs.serviceMode%2~=0 and rs.serviceMode/32 or rsdef and rsdef.serviceMode/32 or 0)%2~=0)..'>データカルーセルを含める</label></span><br>\n'
    ..'<table><tr><td>録画フォルダ</td><td>出力PlugIn</td><td>ファイル名PlugIn</td><td>部分受信</td></tr>\n'
  for i,v in ipairs(rs.recFolderList) do
    s=s..'<tr><td>'..v.recFolder..'</td><td>'..v.writePlugIn..'</td><td>'..v.recNamePlugIn..'</td><td>いいえ</td></tr>\n'
  end
  for i,v in ipairs(rs.partialRecFolder) do
    s=s..'<tr><td>'..v.recFolder..'</td><td>'..v.writePlugIn..'</td><td>'..v.recNamePlugIn..'</td><td>はい</td></tr>\n'
  end
  s=s..'</table>'..(setting and '<a href="'..setting..'">録画フォルダを編集</a>' or '（プリセットによる変更のみ対応）')..'<br>\n'
    ..'<label><input name="partialRecFlag"'..Checkbox(rs.partialRecFlag~=0)..'>部分受信（ワンセグ）を別ファイルに同時出力する</label><br>\n'
    ..'<label><input name="continueRecFlag"'..Checkbox(rs.continueRecFlag)..'>後ろの予約を同一ファイルで出力する</label><br>\n'
    ..'使用チューナー強制指定: <select name="tunerID"><option value="0"'..Selected(rs.tunerID==0)..'>自動'
  local a=edcb.GetTunerReserveAll()
  for i=1,#a-1 do
    s=s..'<option value="'..a[i].tunerID..'"'..Selected(a[i].tunerID==rs.tunerID)..('>ID:%08X('):format(a[i].tunerID)..a[i].tunerName..')'
  end
  s=s..'</select><br>\n'
    ..'録画後動作: <select name="suspendMode">'
    ..'<option value="0"'..Selected(rs.suspendMode==0)..'>'..(rsdef and ({'スタンバイ','休止','シャットダウン','何もしない'})[rsdef.suspendMode] or '')..'（デフォルト）'
    ..'<option value="1"'..Selected(rs.suspendMode==1)..'>スタンバイ'
    ..'<option value="2"'..Selected(rs.suspendMode==2)..'>休止'
    ..'<option value="3"'..Selected(rs.suspendMode==3)..'>シャットダウン'
    ..'<option value="4"'..Selected(rs.suspendMode==4)..'>何もしない</select> '
    ..'<label><input name="rebootFlag"'..Checkbox(rs.suspendMode==0 and rsdef and rsdef.rebootFlag or rs.suspendMode~=0 and rs.rebootFlag)..'>復帰後再起動する</label><br>\n'
    ..'録画後実行bat[*タグ]'..(setting and '' or '（プリセットによる変更のみ対応）')..':<br>\n'
    ..'<input type="text" name="batFilePath" value="'..rs.batFilePath..'" style="width:95%"'..(setting and '' or ' readonly')..'><br>\n'
  return s
end

function RecModeTextList()
  return {'全サービス','指定サービス','全サービス（デコード処理なし）','指定サービス（デコード処理なし）','視聴'}
end

function NetworkType(onid)
  return not onid and {'地デジ','BS','CS1','CS2','CS3','その他'}
    or NetworkType()[0x7880<=onid and onid<=0x7FE8 and 1 or onid==4 and 2 or onid==6 and 3 or onid==7 and 4 or onid==10 and 5 or 6]
end

--表示するサービスを選択する
function SelectChDataList(a)
  local r={}
  for i,v in ipairs(a) do
    --EPG取得対象サービスのみ
    if v.epgCapFlag then
      r[#r+1]=v
    end
  end
  return r
end

--サービスをソートする
function SortServiceListInplace(r)
  local bsmin={}
  for i,v in ipairs(r) do
    if NetworkType(v.onid)=='BS' and (bsmin[v.tsid] or 65536)>v.sid then
      bsmin[v.tsid]=v.sid
    end
  end
  table.sort(r,function(a,b) return
    ('%04X%04X%04X%04X'):format((NetworkType(a.onid)~='地デジ' and 65535 or a.remote_control_key_id or 0),
                                a.onid,(NetworkType(a.onid)=='BS' and bsmin[a.tsid] or a.tsid),a.sid)<
    ('%04X%04X%04X%04X'):format((NetworkType(b.onid)~='地デジ' and 65535 or b.remote_control_key_id or 0),
                                b.onid,(NetworkType(b.onid)=='BS' and bsmin[b.tsid] or b.tsid),b.sid) end)
  return r
end

--URIをタグ装飾する
function DecorateUri(s)
  local hwhost='-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  local hw='!#$%&()*+/:;=?@_~~'..hwhost
  local fwhost='－．０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'
  local fw='！＃＄％＆（）＊＋／：；＝？＠＿～￣'..fwhost
  --sを半角置換
  local r,i={},1
  while i<=#s do
    local j=fw:find(s:sub(i,i+2),1,true)
    if i+2<=#s and j and j%3==1 then
      r[#r+1]=hw:sub((j+2)/3,(j+2)/3)
      i=i+2
    else
      r[#r+1]=s:sub(i,i)
    end
    i=i+1
  end
  r=table.concat(r)

  --置換後nにある文字がsのどこにあるか
  local spos=function(n)
    local i=1
    while i<=#s and n>1 do
      n=n-1
      local j=fw:find(s:sub(i,i+2),1,true)
      if i+2<=#s and j and j%3==1 then
        i=i+2
      end
      i=i+1
    end
    return i
  end

  local t,n,i='',1,1
  while i<=#r do
    --特定のTLDっぽい文字列があればホスト部分をさかのぼる
    local h=0
    if r:find('^%.com/',i) or r:find('^%.jp/',i) or r:find('^%.tv/',i) then
      --装飾前文字列はHTMLエスケープ済みであることを仮定しているので<>"となりうる表現も除外する
      while i-h>1 and hwhost:find(r:sub(i-h-1,i-h-1),1,true) and
            (i-h<5 or not r:find('^&[lg]t;',i-h-4)) and (i-h<7 or not r:find('^&quot;',i-h-6)) do
        h=h+1
      end
    end
    if (h>0 and (i-h==1 or r:find('^[^/]',i-h-1))) or r:find('^https?://',i) then
      local j=i
      while j<=#r and hw:find(r:sub(j,j),1,true) and
            not r:find('^&[lg]t;',j) and not r:find('^&quot;',j) do
        j=j+1
      end
      t=t..s:sub(spos(n),spos(i-h)-1)..'<a rel="noreferrer" href="'..(h>0 and 'https://' or '')
        ..r:sub(i-h,j-1):gsub('&amp;','&'):gsub('&','&amp;')..'">'..s:sub(spos(i-h),spos(j)-1)..'</a>'
      n=j
      i=j-1
    end
    i=i+1
  end
  t=t..s:sub(spos(n))
  return t
end

--時間の文字列を取得する
function FormatTimeAndDuration(t,dur)
  dur=dur and (t.hour*3600+t.min*60+t.sec+dur)
  return ('%d/%02d/%02d(%s) %02d:%02d'):format(t.year,t.month,t.day,({'日','月','火','水','木','金','土',})[t.wday],t.hour,t.min)
    ..(t.sec~=0 and ('<small>:%02d</small>'):format(t.sec) or '')
    ..(dur and ('～%02d:%02d'):format(math.floor(dur/3600)%24,math.floor(dur/60)%60)..(dur%60~=0 and ('<small>:%02d</small>'):format(dur%60) or '') or '')
end

--システムのタイムゾーンに影響されずに時間のテーブルを数値表現にする (timezone=0のとき概ねos.date('!*t')の逆関数)
function TimeWithZone(t,timezone)
  return os.time(t)+90000-os.time(os.date('!*t',90000))-(timezone or 0)
end

--Windowsかどうか
WIN32=not package.config:find('^/')

--OSのディレクトリ区切りとなる文字集合
DIR_SEPS=WIN32 and '\\/' or '/'

--OSの標準ディレクトリ区切り
DIR_SEP=WIN32 and '\\' or '/'

--io.popenのバイナリオープンモード
POPEN_BINARY=WIN32 and 'b' or ''

--パスを連結する
function PathAppend(path,more)
  return path:gsub('['..DIR_SEPS..']*$',DIR_SEP)..more:gsub('^['..DIR_SEPS..']+','')
end

--パスとして同一かどうか
function IsEqualPath(path1,path2)
  return (WIN32 and path1:upper()==path2:upper()) or (not WIN32 and path1==path2)
end

--ドキュメントルートへの相対パスを取得する
function PathToRoot()
  return ('../'):rep(#mg.script_name:gsub('[^'..DIR_SEPS..']*['..DIR_SEPS..']+[^'..DIR_SEPS..']*','N')-
                     #(mg.document_root..'/'):gsub('[^'..DIR_SEPS..']*['..DIR_SEPS..']+','N'))
end

--OSの絶対パスをドキュメントルートからの相対パスに変換する
function NativeToDocumentPath(path)
  local root=(mg.document_root..'/'):gsub('['..DIR_SEPS..']+','/')
  if IsEqualPath(path:gsub('['..DIR_SEPS..']+','/'):sub(1,#root),root) then
    return path:gsub('['..DIR_SEPS..']+','/'):sub(#root+1)
  end
  return nil
end

--ドキュメントルートからの相対パスをOSの絶対パスに変換する
function DocumentToNativePath(path)
  --冗長表現の可能性を潰す
  local esc=edcb.htmlEscape
  edcb.htmlEscape=0
  path=edcb.Convert('utf-8','utf-8',path):gsub('/+','/')
  edcb.htmlEscape=esc
  --禁止文字と正規化のチェック
  if not path:find('[\0-\x1f\x7f'..(WIN32 and '\\:*?"<>|' or '')..']') and not path:find('%./') and not path:find('%.$') then
    return PathAppend(mg.document_root,path:gsub('/',DIR_SEP))
  end
  return nil
end

--EDCBフォルダのパス
function EdcbModulePath()
  return edcb.GetPrivateProfile('SET','ModulePath','','Common.ini')
end

--プラグインファイル等のフォルダのパス (指定されている場合)
function EdcbLibPath()
  local dir=edcb.GetPrivateProfile('SET','ModuleLibPath','','Common.ini')
  return dir~='' and dir
end

--設定関係保存フォルダのパス
function EdcbSettingPath()
  local dir=edcb.GetPrivateProfile('SET','DataSavePath','','Common.ini')
  return dir~='' and dir or PathAppend(EdcbModulePath(),'Setting')
end

--録画保存フォルダのパスのリスト
function EdcbRecFolderPathList()
  local n=tonumber(edcb.GetPrivateProfile('SET','RecFolderNum',0,'Common.ini')) or 0
  local r={n>0 and edcb.GetPrivateProfile('SET','RecFolderPath0','','Common.ini') or ''}
  if r[1]=='' then
    --必ず返す
    r[1]=EdcbSettingPath()
  end
  for i=2,n do
    local dir=edcb.GetPrivateProfile('SET','RecFolderPath'..(i-1),'','Common.ini')
    --空要素は詰める
    if dir~='' then
      r[#r+1]=dir
    end
  end
  return r
end

--プラグインファイル名を列挙する
function EnumPlugInFileName(name)
  local esc=edcb.htmlEscape
  edcb.htmlEscape=0
  local pattern=PathAppend(EdcbLibPath() or PathAppend(EdcbModulePath(),name),name)..(WIN32 and '*.dll' or '*.so')
  edcb.htmlEscape=esc
  local r={}
  for i,v in ipairs(edcb.FindFile(pattern,0) or {}) do
    if not v.isdir then
      r[#r+1]=v.name
    end
  end
  return r
end

--現在の変換モードでHTMLエスケープする
function EdcbHtmlEscape(s)
  return edcb.Convert('utf-8','utf-8',s)
end

--単一のファイルに関する情報を探す
function EdcbFindFilePlain(path)
  local n=path:find('[^'..DIR_SEPS..']*$')
  if not path:find('[*?]',n) then
    --そのまま
    local ff=edcb.FindFile(path,1)
    return ff and ff[1]
  end
  --ワイルドカード文字を含むので、その効果を打ち消すために*を?にして候補を比較
  for i,v in ipairs(edcb.FindFile(path:sub(1,n-1)..path:sub(n):gsub('%*','?'),0) or {}) do
    if IsEqualPath(EdcbHtmlEscape(path:sub(n)),v.name) then return v end
  end
  return nil
end

--プロセス名(拡張子を除いたもの)とコマンドラインのパターン(部分一致)に一致するコマンドをすべて終了させる
function TerminateCommandlineLike(name,pattern)
  if not WIN32 then
    --拡張正規表現の記号はエスケープ
    name=name:gsub('[$()*+.?[\\%]^{|}]','\\%0')
    pattern=pattern:gsub('[$()*+.?[\\%]^{|}]','\\%0')
    edcb.os.execute('pkill -9 -xf "'..name..(pattern=='' and '( .*)?' or
      pattern:find('^ ') and '('..pattern..'| .*'..pattern..').*' or ' .*'..pattern..'.*')..'"')
  elseif pattern=='' then
    edcb.os.execute('taskkill /f /im "'..name..'.exe"')
  elseif not edcb.os.execute('wmic process where "name=\''..name..'.exe\' and commandline like \'%'..pattern:gsub('_','[_]')..'%\'" call terminate >nul') then
    --wmicがないとき
    edcb.os.execute('powershell -NoProfile -c "try{(gwmi win32_process -filter \\"name=\''..name..'.exe\' and commandline like \'%'
      ..pattern:gsub('_','[_]')..'%\'\\").terminate()}catch{}"')
  end
end

--コマンドラインのコマンド名として使うコマンドを探す
function FindToolsCommand(name)
  if not WIN32 then
    --そのまま。ただし親プロセスのシグナルマスクを継承しないようにする
    return 'env --default-signal '..name
  end
  --EDCBのToolsフォルダにあるものを優先する
  local esc=edcb.htmlEscape
  edcb.htmlEscape=0
  local path=PathAppend(EdcbModulePath(),PathAppend('Tools',name..'.exe'))
  edcb.htmlEscape=esc
  --拡張子をつけて引用符で囲む
  return '"'..(EdcbFindFilePlain(path) and path or name..'.exe')..'"'
end

--コマンドラインの引数として使うパスを引用符で囲む
--※Windowsでは引用符などパスとして不正な文字がpathに含まれていないことが前提
--※Windowsでstartコマンドなどでネストされたコマンドの引数として使うときはnestedにする
function QuoteCommandArgForPath(path,nested)
  return WIN32 and '"'..(nested and path:gsub('[&^]','^%0') or path):gsub('%%','"%%"')..'"' or "'"..path:gsub("'","'\"'\"'").."'"
end

--SendTSTCPのストリーム取得用パイプのパス
function SendTSTCPPipePath(name,index)
  if WIN32 then
    --同時利用でも名前は同じ
    return '\\\\.\\pipe\\SendTSTCP_'..name
  end
  --同時利用のためのindexがつく
  local esc=edcb.htmlEscape
  edcb.htmlEscape=0
  local path=PathAppend(EdcbModulePath(),'SendTSTCP_'..name..'_'..index..'.fifo')
  edcb.htmlEscape=esc
  return path
end

--tsmemsegのストリーム取得用パイプのパス
function TsmemsegPipePath(name,suffix)
  if WIN32 then
    return '\\\\.\\pipe\\tsmemseg_'..name..suffix
  end
  local esc=edcb.htmlEscape
  edcb.htmlEscape=0
  local path=PathAppend(EdcbModulePath(),'tsmemseg_'..name..suffix..'.fifo')
  edcb.htmlEscape=esc
  return path
end

--tsmemsegのストリーム取得用パイプを開く
function OpenTsmemsegPipe(name,suffix)
  if WIN32 then
    return edcb.io.open(TsmemsegPipePath(name,suffix),'rb')
  end
  for retry=1,9 do
    local f=edcb.io.open(TsmemsegPipePath(name,suffix),'rb')
    if not f then break end
    --FIFOは同時に読めてしまうのでプロセス間でロックが必要
    if edcb.io._flock_nb(f) then
      --タイミングによっては途中から読んでしまう可能性があるので検証が必要
      local buf=f:read(suffix=='00' and 64 or 188)
      if buf and (suffix=='00' and #buf==64 and buf:find('^'..name) or
                  suffix~='00' and #buf==188 and buf:find('^....'..name)) then
        return f
      end
    end
    f:close()
    edcb.Sleep(10*retry)
  end
  return nil
end

--ソート済みリストを二分探索してlower(upper)境界のインデックスを返す
function BinarySearchBound(a,k,comp,upper)
  local n,i=#a,1
  while n~=i-1 do
    local j=i+math.floor((n-i+1)/2)
    if upper and (comp and not comp(k,a[j]) or not comp and not k<a[j]) or
       not upper and (comp and comp(a[j],k) or not comp and a[j]<k) then i=j+1 else n=j-1 end
  end
  return i
end

--ソート済みリストを二分探索して一致する要素を返す
function BinarySearch(a,k,comp)
  local i=BinarySearchBound(a,k,comp)
  if i<=#a and (comp and not comp(k,a[i]) or not comp and not k<a[i]) then return a[i] end
  return nil
end

--奇数番目の引数(偶数番目は降順か否かの真偽値)で指定した1つ以上のフィールドでテーブルを比較する関数を返す
function CompareFields(...)
  local args={...}
  local function comp(a,b,i)
    i=i or 1
    local k=args[i]
    local desc=i<#args and args[i+1]
    return desc and b[k]<a[k] or not desc and a[k]<b[k] or i+1<#args and a[k]==b[k] and comp(a,b,i+2)
  end
  return comp
end

--符号なし整数の時計算の差を計算する
function UintCounterDiff(a,b)
  return (a+0x100000000-b)%0x100000000
end

--TSパケットヘッダを解析する
function ParseTsPacket(ts,buf,i)
  i=i or 1
  if not buf or #buf<i+187 or buf:byte(i)~=0x47 then return false end
  local b=buf:byte(i+1)
  ts.err=b>127
  ts.unitStart=b%128>63
  ts.pid=b%32*256+buf:byte(i+2)
  ts.adaptation=math.floor(buf:byte(i+3)/16)%4
  return true
end

--PCR(45000Hz)があれば取得する
function GetPcrFromTsPacket(adaptation,buf,i)
  i=i or 1
  --adaptation_field_length and PCR_flag
  return adaptation>=2 and buf:byte(i+4)>=5 and buf:byte(i+5)%32>15 and
    ((buf:byte(i+6)*256+buf:byte(i+7))*256+buf:byte(i+8))*256+buf:byte(i+9)
end

--PCRまで読む
function ReadToPcr(f,pid)
  local ts={}
  for i=1,10000 do
    local buf=f:read(188)
    if not ParseTsPacket(ts,buf) then break end
    local pcr=GetPcrFromTsPacket(ts.adaptation,buf)
    if not ts.err and pcr and (not pid or pid==ts.pid) then
      return pcr,ts.pid,i*188
    end
  end
  return nil
end

--MPEG-2映像のIフレームを取得する
function GetIFrameVideoStream(f)
  local ts={}
  local exclude={}
  local priorPid=8192
  local videoPid=nil
  local stream,pesRemain,headerRemain,seqState
  local function findPictureCodingType(buf)
    for i=1,#buf do
      local b=buf:byte(i)
      if (seqState<=1 or seqState==3) and b==0 or seqState==4 then
        seqState=seqState+1
      elseif seqState==2 and b<=1 then
        if b==1 then
          seqState=seqState+1
        end
      elseif seqState==5 then
        seqState=-1
        return math.floor(b/8)%8
      else
        seqState=0
      end
    end
    return nil
  end
  for i=1,15000 do
    local buf=f:read(188)
    if not ParseTsPacket(ts,buf) then break end
    if not ts.err and (ts.pid==videoPid or ts.unitStart and not videoPid) then
      if ts.unitStart and videoPid then
        if pesRemain==0 then
          --PESがたまった
          if seqState<0 then return table.concat(stream) end
          exclude[ts.pid]=true
        end
        videoPid=nil
      end
      local adaptationLen=ts.adaptation==1 and -1 or ts.adaptation==3 and buf:byte(5) or 183
      if adaptationLen>183 then break end
      local pos=6+adaptationLen
      --H.262のpicture_coding_typeが見つからないものは除外。複数候補ある場合はPIDが小さいほう
      if not videoPid and not exclude[ts.pid] and ts.pid<=priorPid and pos<=180 and buf:find('^\0\0\1[\xE0-\xEF]',pos) then
        --H.262/264/265 PES
        videoPid=ts.pid
        stream={}
        pesRemain=buf:byte(pos+4)*256+buf:byte(pos+5)
        headerRemain=buf:byte(pos+8)
        seqState=0
        pos=pos+9
      end
      if videoPid and pos<=188 then
        local n=math.min(189-pos,headerRemain)
        headerRemain=headerRemain-n
        pos=pos+n
        if pos<=188 then
          n=pesRemain>0 and math.min(189-pos,pesRemain) or 189-pos
          stream[#stream+1]=buf:sub(pos,pos+n-1)
          if seqState>=0 and findPictureCodingType(stream[#stream])~=1 and seqState<0 then
            --Iフレームじゃない
            priorPid=ts.pid
            videoPid=nil
          elseif pesRemain>0 then
            pesRemain=pesRemain-n
            if pesRemain==0 then
              --PESがたまった
              if seqState<0 then return table.concat(stream) end
              exclude[ts.pid]=true
              videoPid=nil
            end
          end
        end
      end
    end
  end
  return nil
end

--PCRをもとにファイルの長さを概算する
function GetDurationSec(f)
  local fsize=f:seek('end') or 0
  if fsize>1880000 and f:seek('set') then
    local pcr,pid=ReadToPcr(f)
    if pcr and f:seek('set',(math.floor(fsize/188)-10000)*188) then
      local pcr2,pid2,n=ReadToPcr(f,pid)
      if pcr2 then
        --終端まで読む
        local range=1880000
        while true do
          local dur=math.floor(UintCounterDiff(pcr2,pcr)/45000)
          range=range-n
          pcr2,pid2,n=ReadToPcr(f,pid)
          if not pcr2 or range<0 then
            return dur,fsize
          end
        end
      end
      --TSデータが存在する境目を見つける
      local predicted,range=math.floor(fsize/2/188)*188,fsize
      while range>1880000 and f:seek('set',predicted) do
        local buf=f:read(189)
        local valid=buf and #buf==189 and buf:byte(1)==0x47 and buf:byte(189)==0x47
        predicted=math.floor((predicted+(valid and range/4 or -range/4))/188)*188
        range=range/2
      end
      predicted=predicted-1880000
      if predicted>0 and f:seek('set',predicted) then
        pcr2=ReadToPcr(f,pid)
        if pcr2 then
          return math.floor(UintCounterDiff(pcr2,pcr)/45000),predicted
        end
      end
    end
  end
  return 0,fsize
end

--ファイルの先頭からsec秒だけシークする
function SeekSec(f,sec,dur,fsize)
  if dur>0 and fsize>1880000 and f:seek('set') then
    local pcr,pid=ReadToPcr(f)
    if pcr then
      --最終目標の3秒手前を目標に6ループまたは誤差が±3秒未満になるまで動画レートから概算シーク
      local pos,diff,rate=0,math.min(math.max(sec-3,0),dur)*45000,fsize/dur
      for i=1,6 do
        if math.abs(diff)<45000*3 then break end
        local approx=math.floor(math.min(math.max(pos+rate*diff/45000,0),fsize-1880000)/188)*188
        if not f:seek('set',approx) then return false end
        local pcr2=ReadToPcr(f,pid)
        if not pcr2 then return false end
        --移動分を差し引く
        local diff2=diff+(UintCounterDiff(pcr2,pcr)<0x80000000 and -UintCounterDiff(pcr2,pcr) or UintCounterDiff(pcr,pcr2))
        if math.abs(diff2)>=45000*3 and ((diff<0 and diff2>-diff/2) or (diff>0 and diff2<-diff/2)) then
          --移動しすぎているのでレートを下げてやり直し
          rate=rate/1.5
        else
          if (diff<0 and diff2*2<diff) or (diff>0 and diff2*2>diff) then
            --あまり移動していないのでレートを上げる
            rate=rate*1.5
          end
          pos=approx
          pcr=pcr2
          diff=diff2
        end
      end
      if math.abs(diff)<45000*3 then
        --最終目標まで進む
        diff=diff+45000*3
        local diff2=diff
        while diff2>22500 do
          if diff2>45000*6 then return false end
          local pcr2=ReadToPcr(f,pid)
          if not pcr2 then return false end
          diff2=diff+(UintCounterDiff(pcr2,pcr)<0x80000000 and -UintCounterDiff(pcr2,pcr) or UintCounterDiff(pcr,pcr2))
        end
      end
      return true
    end
  end
  return false
end

--ファイルの先頭のTOT時刻とネットワークIDとサービスIDを取得する
function GetTotAndServiceID(f)
  if f:seek('set') then
    local pcr,pcrPid=ReadToPcr(f)
    if pcr then
      local ts,tot,nid,sid={},nil,nil,nil
      for i=1,400000 do
        local buf=f:read(188)
        if not ParseTsPacket(ts,buf) then break end
        local adaptationLen=ts.adaptation==1 and -1 or ts.adaptation==3 and buf:byte(5) or 183
        if not ts.err and ts.unitStart and adaptationLen<183 then
          local pointer=7+adaptationLen+buf:byte(6+adaptationLen)
          local id=pointer<=188 and buf:byte(pointer)
          if ts.pid==0 and pointer+13<=188 and id==0x00 then
            --PAT
            local sectionLen=buf:byte(pointer+2)
            sid=buf:byte(pointer+8)*256+buf:byte(pointer+9)
            if sectionLen>=17 and sid==0 then
              sid=buf:byte(pointer+12)*256+buf:byte(pointer+13)
            end
            if sectionLen<13 or sid==0 then
              sid=nil
            end
          elseif ts.pid==16 and pointer+4<=188 and id==0x40 then
            --NIT
            nid=buf:byte(pointer+3)*256+buf:byte(pointer+4)
          elseif ts.pid==20 and pointer+7<=188 and (id==0x70 or id==0x73) and not tot then
            --TDT,TOT
            local pcr2=ReadToPcr(f,pcrPid)
            if not pcr2 then break end
            local mjd=buf:byte(pointer+3)*256+buf:byte(pointer+4)
            local h=buf:byte(pointer+5)
            local m=buf:byte(pointer+6)
            local s=buf:byte(pointer+7)
            tot=((mjd*24+math.floor(h/16)*10+h%16)*60+math.floor(m/16)*10+m%16)*60+math.floor(s/16)*10+s%16-
                3506749200-math.floor(UintCounterDiff(pcr2,pcr)/45000)
          end
          if tot and nid and sid then
            return tot,nid,sid
          end
        end
      end
    end
  end
  return nil
end

--ライブ実況やjkrdlogの出力のチャンクを1つだけ読み取る
function ReadJikkyoChunk(f)
  local head=f:read(80)
  if not head or #head~=80 then return nil end
  local payload=''
  local payloadSize=tonumber(head:match('L=([0-9]+)'))
  if not payloadSize then return nil end
  if payloadSize>0 then
    payload=f:read(payloadSize)
    if not payload or #payload~=payloadSize then return nil end
  end
  return head..payload
end

--リトルエンディアンの値を取得する
function GetLeNumber(buf,pos,len)
  local n=0
  for i=pos+len-1,pos,-1 do n=n*256+buf:byte(i) end
  return n
end

DOCTYPE_HTML4_STRICT='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n'

--既定のHTMLヘッダの内容
function DefaultHeadContents()
  return [=[
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="initial-scale=1">
<link rel="stylesheet" type="text/css" href="default.css">
]=]..(COLOR_SCHEME~='dark' and COLOR_SCHEME~='light' and '' or
  '<style type="text/css">:root{color-scheme:'..(COLOR_SCHEME=='dark' and 'dark;--light: ;--dark' or 'light;--dark: ;--light')..':initial}</style>\n')
end

--HTTP日付の文字列を取得する
function ImfFixdate(t)
  return ('%s, %02d %s %d %02d:%02d:%02d GMT'):format(({'Sun','Mon','Tue','Wed','Thu','Fri','Sat'})[t.wday],t.day,
    ({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})[t.month],t.year,t.hour,t.min,t.sec)
end

--レスポンスを生成する
function Response(code,ctype,charset,cl,cz,maxage)
  return 'HTTP/1.1 '..code..' '..mg.get_response_code_text(code)
    ..'\r\nDate: '..ImfFixdate(os.date('!*t'))
    ..'\r\nX-Frame-Options: SAMEORIGIN'
    ..(ctype and '\r\nX-Content-Type-Options: nosniff\r\nContent-Type: '..ctype..(charset and '; charset='..charset or '') or '')
    ..(cl and mg.request_info.request_method~='HEAD' and '\r\nContent-Length: '..cl or '')
    ..(cz and '\r\nContent-Encoding: gzip' or '')
    ..'\r\nCache-Control: private, max-age='..(maxage or 0)
    ..(mg.keep_alive(not not cl) and '\r\n' or '\r\nConnection: close\r\n')
end

--コンテンツ(レスポンスボディ)を連結するオブジェクトを生成する
--※HEADリクエストでは何も追加されない
--※threshを省略すると圧縮は行われない
function CreateContentBuilder(thresh)
  local self={ct={''},len=0,thresh_=thresh}
  function self:Append(s)
    if mg.request_info.request_method=='HEAD' then
      return
    end
    if self.thresh_ and self.len+#s>=self.thresh_ and not self.stream_ then
      self.stream_=true
      --可能ならコンテンツをgzip圧縮する(lua-zlib(zlib.dll)が必要)
      for k,v in pairs(mg.request_info.http_headers) do
        if k:lower()=='accept-encoding' and v:lower():find('gzip') then
          local status,zlib=pcall(require,'zlib')
          if status then
            self.stream_=zlib.deflate(6,31)
            self.ct={'',(self.stream_(table.concat(self.ct)))}
            self.len=#self.ct[2]
            self.gzip=true
          end
          break
        end
      end
    end
    s=self.gzip and self.stream_(s) or s
    if #s>0 then
      self.ct[#self.ct+1]=s
      self.len=self.len+#s
    end
  end
  --コンテンツの連結を完了してlenを確定させる
  function self:Finish()
    if self.gzip and self.stream_ then
      self.ct[#self.ct+1]=self.stream_()
      self.len=self.len+#self.ct[#self.ct]
    end
    self.stream_=nil
  end
  --必要ならヘッダをつけて全体を取り出す
  function self:Pop(s)
    self:Finish()
    self.ct[1]=s or ''
    s=table.concat(self.ct)
    self.ct={''}
    self.len=0
    self.gzip=nil
    return s
  end
  return self
end

--POSTメッセージボディをすべて読む
function AssertPost()
  local post, s
  if mg.request_info.request_method=='POST' then
    post=''
    repeat
      s=mg.read()
      post=post..(s or '')
      assert(#post<POST_MAX_BYTE)
    until not s
    if #post~=mg.request_info.content_length then
      post=''
    end
    AssertCsrf(post)
  end
  return post
end

--クエリパラメータを整数チェックして取得する
function GetVarInt(qs,n,ge,le,occ)
  n=tonumber(mg.get_var(qs,n,occ))
  if n and n==math.floor(n) and n>=(ge or -2147483648) and n<=(le or 2147483647) then
    return n
  end
  return nil
end

--クエリパラメータからサービスのIDを取得する
function GetVarServiceID(qs,n,occ,leextra)
  local onid,tsid,sid,x=(mg.get_var(qs,n,occ) or ''):match('^([0-9]+)%-([0-9]+)%-([0-9]+)'..(leextra and '%-([0-9]+)' or '')..'$')
  onid=tonumber(onid)
  tsid=tonumber(tsid)
  sid=tonumber(sid)
  x=tonumber(x)
  if onid and onid==math.floor(onid) and onid>=0 and onid<=65535 and
     tsid and tsid==math.floor(tsid) and tsid>=0 and tsid<=65535 and
     sid and sid==math.floor(sid) and sid>=0 and sid<=65535 then
    if not leextra then
      return onid,tsid,sid,0
    elseif x and x==math.floor(x) and x>=0 and x<=leextra then
      return onid,tsid,sid,x
    end
  end
  --失敗
  return 0,0,0,0
end

--クエリパラメータから番組のIDを取得する
function GetVarEventID(qs,n,occ)
  return GetVarServiceID(qs,n,occ,65535)
end

--クエリパラメータから過去番組のIDを取得する
function GetVarPastEventID(qs,n,occ)
  return GetVarServiceID(qs,n,occ,4294967295)
end

--CSRFトークンを取得する
--※このトークンを含んだコンテンツを圧縮する場合はBREACH攻撃に少し気を配る
function CsrfToken(m,t)
  --メッセージに時刻をつける
  m=(m or mg.script_name:match('[^\\/]*$'):lower())..'/legacy/'..(math.floor(os.time()/3600/12)+(t or 0))
  local kip,kop=('\54'):rep(48),('\92'):rep(48)
  for k in edcb.serverRandom:sub(1,32):gmatch('..') do
    kip=string.char(bit32.bxor(tonumber(k,16),54))..kip
    kop=string.char(bit32.bxor(tonumber(k,16),92))..kop
  end
  --HMAC-MD5(hex)
  return mg.md5(kop..mg.md5(kip..m))
end

--CSRFトークンを検査する
--※サーバに変更を加える要求(POSTに限らない)を処理する前にこれを呼ぶべき
function AssertCsrf(qs)
  assert(mg.get_var(qs,'ctok')==CsrfToken() or mg.get_var(qs,'ctok')==CsrfToken(nil,-1))
end

--県域コード(1～50)に対応する緊急情報信号の地域符号を返す
function GetEwsRegionCode(prefecture)
  --地域符号(Hex3桁x50)
  local codes='16b16b4675d4758ac6e4c1aec69e3898b64b1c7aac56c4ce5396a692dd4a9d2a65a5a9662dcce459acb2674a93396d2331b2b5b31b98e629b419d2e362d959a2b8a7c8dd1cd45372aacd45'
  return tonumber(codes:sub(prefecture*3-2,prefecture*3),16)
end

if not WIN32 then
  INDEX_ENABLE_SUSPEND=false
  USE_LIVEJK=not not JKCNSL_PATH
end
