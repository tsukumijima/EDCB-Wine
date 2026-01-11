"use strict";

function runCCInfoScript(uri,withProgress,seekVideo,seekTarget){
  var halfMap={
    "　":" ","，":",","．":".","：":":","；":";",
    "？":"?","！":"!","＾":"^","＿":"_","／":"/",
    "｜":"|","（":"(","）":")","［":"[","］":"]",
    "｛":"{","｝":"}","＋":"+","－":"-","＝":"=",
    "＜":"<","＞":">","＄":"$","％":"%","＃":"#",
    "＆":"&","＊":"*","＠":"@"
  };
  function toHalf(s){
    return s.replace(/[　，．：；？！＾＿／｜（）［］｛｝＋－＝＜＞＄％＃＆＊＠０-９Ａ-Ｚａ-ｚ]/g,function(c){
      return /[０-９Ａ-Ｚａ-ｚ]/.test(c)?String.fromCharCode(c.charCodeAt(0)-0xfee0):halfMap[c];
    });
  }
  function extractReadableText(s,f){
    var ctrl=0;
    var ssz=false;
    for(var i=0;i<s.length;i++){
      if(s[i]=="<"){
        //Ignore tags
        i++;
        if(s[i]=="c"&&(s[i+1]==" "||s[i+1]==">")){
          //<c>
          ctrl++;
        }else if(s[i]=="/"&&s[i+1]=="c"&&(s[i+2]==" "||s[i+2]==">")){
          //</c>
          ctrl--;
        }
        i=s.indexOf(">",i);
        if(i<0)i=s.length-1;
      }else if(ctrl<=0){
        //readable
        var j=s.indexOf("<",i);
        if(j<0)j=s.length;
        var t=s.substring(i,j).replace(/&(?:amp|lt|gt|quot|apos);/g,function(m){
          return m=="&amp;"?"&":m=="&lt;"?"<":m=="&gt;"?">":m=="&quot;"?'"':"'";
        });
        t=toHalf(t);
        //TODO: Draw DRCS
        t=t.replace(/[\uec00-\uefff]/g,"");
        if(t)f(t,ssz);
        i=j-1;
      }else if(s[i]=="%"&&s[i+1]=="^"&&s[i+2]=="H"){
        //SSZ
        ssz=true;
      }else if(s[i]=="%"&&s[i+1]=="^"&&(s[i+2]=="I"||s[i+2]=="J"||s[i+2]=="K")){
        //MSZ,NSZ,SZX
        ssz=false;
      }
    }
  }

  var cb=document.getElementById("cb-ccinfo");
  cb.checked=false;
  cb.parentElement.parentElement.style.display=null;
  var dummyVideo=null;
  cb.onclick=function(){
    var desc=document.getElementById("ccinfo-desc");
    desc.style.display=cb.checked?null:"none";
    if(!cb.checked||dummyVideo)return;
    dummyVideo=document.createElement("video");
    desc.innerText="Loading...";
    function parseCue(uri,download){
      var track=document.createElement("track");
      dummyVideo.append(track);
      track.kind="metadata";
      track.src=uri;
      track.type="text/vtt";
      track=track.track;
      track.mode="hidden";
      var to=50;
      var waitForCue=function(){
        if(track.cues.length==0){
          if(--to<0){
            desc.innerText="Error!";
            dummyVideo=null;
          }else{
            setTimeout(waitForCue,100);
          }
          return;
        }
        if(typeof withProgress=="function"){
          //Callback with an object URL
          withProgress(uri);
        }
        var a=document.createElement("a");
        a.download=download;
        a.href=uri;
        a.innerText="(DL)";
        desc.innerText="";
        desc.parentElement.insertBefore(a,desc);

        var re=/<v b24caption[1-8]>(.*?)<\/v>/g;
        for(var i=0;i<track.cues.length;i++){
          re.lastIndex=0;
          var cueText=track.cues[i].text.replace(/\r?\n/g,"");
          var src;
          while((src=re.exec(cueText))!==null){
            var appended=false;
            extractReadableText(src[1],function(s,ssz){
              if(!appended){
                appended=true;
                var sec=track.cues[i].startTime;
                var a=document.createElement("a");
                if(seekVideo){
                  a.onclick=function(){seekVideo(Math.max(sec-1,0));};
                  a.href=seekTarget;
                }
                a.innerText=(sec<600?"0":"")+Math.floor(sec/60)+"m"+String(Math.floor(100+sec%60)).substring(1)+"s";
                desc.appendChild(a);
                desc.appendChild(document.createTextNode(" "));
              }
              if(ssz){
                var small=document.createElement("small");
                small.innerText=s;
                desc.appendChild(small);
              }else{
                desc.appendChild(document.createTextNode(s));
              }
            });
            if(appended)desc.appendChild(document.createElement("br"));
          }
        }
      };
      waitForCue();
    }
    if(withProgress){
      var xhr=new XMLHttpRequest();
      xhr.open("GET",uri);
      xhr.onloadend=function(){
        if(xhr.status==200&&xhr.response){
          var s=xhr.response.replace(/\r?\n/g,"\n").replace(/\nNOTE msec=[0-9]{8}\n/g,"");
          //Validate
          if(/^WEBVTT\n[\s\S]* --> /.test(s)){
            var m=(xhr.getResponseHeader("Content-Disposition")||"").match(/filename=([0-9A-Za-z_-]+\.vtt)/);
            parseCue(URL.createObjectURL(new Blob(["\ufeff",s],{endings:"native",type:"text/vtt"})),m?m[1]:"a.vtt");
          }else{
            desc.innerText="";
          }
        }else{
          desc.innerText="Error! ("+xhr.status+")";
          dummyVideo=null;
        }
      };
      xhr.onprogress=function(){
        if(xhr.status==200&&xhr.response){
          var s=xhr.response.replace(/\r?\n/g,"\n");
          var i=s.lastIndexOf("\n\nNOTE msec=",s.length-20);
          if(i>=0){
            var sec=Math.floor(s.substring(i+12,i+20)/1000);
            var count=0;
            for(i=0;(i=s.indexOf(" --> ",i+5))>=0;count++);
            desc.innerText="Loading... ("+Math.floor(sec/60)+"m"+String(100+sec%60).substring(1)+"s|count="+count+")";
          }
        }
      };
      xhr.send();
    }else{
      parseCue(uri,"");
    }
  };
}

function seekVideoByFormSelect(sec){
  var vselect=document.querySelector('#vid-form select[name="offset"]');
  if(vselect){
    for(var i=1;;i++){
      if(i==100||(vselect.options[i].dataset.sec||-1)>=sec){
        vselect.options[i-1].selected=true;
        break;
      }
    }
  }
}
