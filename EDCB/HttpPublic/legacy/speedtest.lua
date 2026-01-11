-- スピードテストページのためのヘルパースクリプト
dofile(mg.script_name:gsub('[^\\/]*$','')..'util.lua')

if mg.get_var(mg.request_info.query_string,'q')=='getip' then
  -- リモートIP情報を返す
  ct=CreateContentBuilder()
  ct:Append('{"processedString":"'..mg.request_info.remote_addr..'"}')
  ct:Finish()
  mg.write(ct:Pop(Response(200,'application/json','utf-8',ct.len)..'\r\n'))
elseif mg.get_var(mg.request_info.query_string,'q')=='empty' then
  -- データを受け取って無視する
  if mg.request_info.request_method=='POST' then
    n=0
    repeat
      s=mg.read()
      n=n+(s and #s or 0)
      assert(n<1024*1024*1024)
    until not s
  end
  mg.write(Response(200,nil,nil,0)..'\r\n')
elseif mg.request_info.request_method=='HEAD' then
  mg.write(Response(200,'application/octet-stream',nil,0)..'\r\n')
else
  -- 適当なデータを返す(garbage)
  data1MB={}
  for i=1,32768,2 do
    a=math.random(0,255)
    b=math.random(0,255)
    c=math.random(0,255)
    d=math.random(0,255)
    data1MB[i]=string.char(a,b,c,d,(a+i)%256,(d+a)%256,(c+i)%256,(a+b)%256,(b+i)%256,(c+d)%256,(d+i)%256,(b+c)%256,d,b,c,a)
    data1MB[i+1]=nil
  end
  for i=1,32768,2 do
    data1MB[i+1]=data1MB[32768-i]
  end
  data1MB=table.concat(data1MB)
  data1MB=data1MB..data1MB:reverse()

  chunks=GetVarInt(mg.request_info.query_string,'ckSize',1,1024) or 4
  mg.write(Response(200,'application/octet-stream',nil,chunks*1024*1024)..'\r\n')
  for i=1,chunks do
    mg.write(data1MB)
  end
end
