"use strict";

function runThumbnailScript(mod,streams,n,fname){
  var flipTimer=0;
  var pushed=null;
  var thumbs=document.getElementById("vid-thumbs");
  var div=document.createElement("div");
  div.style.display="none";
  thumbs.appendChild(div);
  for(var i=0;i<streams.length;i++){
    var b=atob(streams[i][0]);
    var u=new Uint8Array(b.length);
    for(var j=0;j<b.length;j++){
      u[j]=b.charCodeAt(j);
    }
    var buffer=mod.getGrabberInputBuffer(u.length);
    buffer.set(u);
    var frame=mod.grabFirstFrame(u.length);
    if(!frame)continue;
    (function(){
      var canvas=document.createElement("canvas");
      if(fname){
        var sec=streams[i][1];
        function flip(){
          var myTimer=flipTimer;
          var xhr=new XMLHttpRequest();
          xhr.open("GET","grabber.lua?fname="+fname+"&ofssec="+(sec+5));
          xhr.responseType="arraybuffer";
          xhr.onloadend=function(){
            if(xhr.status!=200||!xhr.response){
              if(flipTimer==myTimer)flipTimer=setTimeout(flip,3000);
              return;
            }
            var buffer=mod.getGrabberInputBuffer(xhr.response.byteLength);
            buffer.set(new Uint8Array(xhr.response));
            var frame=mod.grabFirstFrame(xhr.response.byteLength);
            if(frame){
              canvas.width=frame.width;
              canvas.height=frame.height;
              canvas.getContext("2d").putImageData(new ImageData(new Uint8ClampedArray(frame.buffer),frame.width,frame.height),0,0);
            }
            sec+=5;
            if(flipTimer==myTimer){
              div.innerText=Math.floor(sec/60)+"m"+String(100+sec%60).substring(1)+"s";
              flipTimer=setTimeout(flip,500);
            }
          };
          xhr.send();
        }
        canvas.onmouseenter=function(){
          var ra=canvas.getBoundingClientRect();
          var rb=thumbs.getBoundingClientRect();
          div.style.left=ra.x-rb.x+"px";
          div.style.bottom=rb.bottom-ra.bottom+"px";
          div.innerText=Math.floor(sec/60)+"m"+String(100+sec%60).substring(1)+"s";
          div.style.display=null;
          clearTimeout(flipTimer);
          flipTimer=setTimeout(flip,1000);
        };
        canvas.onmouseleave=function(){
          clearTimeout(flipTimer);
          flipTimer=0;
          div.style.display="none";
          pushed=null;
        };
        canvas.onclick=function(){
          pushed=pushed==canvas?null:canvas;
          if(pushed)canvas.onmouseenter();
          else canvas.onmouseleave();
        };
      }
      canvas.width=frame.width;
      canvas.height=frame.height;
      canvas.getContext("2d").putImageData(new ImageData(new Uint8ClampedArray(frame.buffer),frame.width,frame.height),0,0);
      canvas.className="thumb-"+n;
      thumbs.appendChild(canvas);
    })();
  }
}
