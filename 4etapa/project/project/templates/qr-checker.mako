<script type="text/javascript" src="${request.static_path('project:static/js-qr/grid.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/version.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/detector.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/formatinf.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/errorlevel.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/bitmat.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/datablock.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/bmparser.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/datamask.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/rsdecoder.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/gf256poly.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/gf256.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/decoder.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/qrcode.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/findpat.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/alignpat.js')}"></script>
<script type="text/javascript" src="${request.static_path('project:static/js-qr/databr.js')}"></script>
<link href="${request.static_path('project:static/css/main.css')}" rel="stylesheet" type="text/css" />
<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script type="text/javascript">



//state 1 in state 2 OUT
state = 0;    
var gCtx = null;
var gCanvas = null;
var c=0;
var stype=0;
var gUM=false;
var webkit=false;
var moz=false;
var v=null;


var imghtml='<div id="qrfile"><canvas id="out-canvas" width="320" height="240"></canvas>'+
    '<div id="imghelp">drag and drop a QRCode here'+
    '<br>or select a file'+
    '<input type="file" onchange="handleFiles(this.files)"/>'+
    '</div>'+
'</div>';

var vidhtml = '<video id="v" autoplay></video>';

function dragenter(e) {
  e.stopPropagation();
  e.preventDefault();
}

function dragover(e) {
  e.stopPropagation();
  e.preventDefault();
}
function drop(e) {
  e.stopPropagation();
  e.preventDefault();

  var dt = e.dataTransfer;
  var files = dt.files;
  if(files.length>0)
  {
    handleFiles(files);
  }
  else
  if(dt.getData('URL'))
  {
    qrcode.decode(dt.getData('URL'));
  }
}

function handleFiles(f)
{
    var o=[];
    
    for(var i =0;i<f.length;i++)
    {
        var reader = new FileReader();
        reader.onload = (function(theFile) {
        return function(e) {
            gCtx.clearRect(0, 0, gCanvas.width, gCanvas.height);

            qrcode.decode(e.target.result);
        };
        })(f[i]);
        reader.readAsDataURL(f[i]); 
    }
}

function initCanvas(w,h)
{
    gCanvas = document.getElementById("qr-canvas");
    gCanvas.style.width = w + "px";
    gCanvas.style.height = h + "px";
    gCanvas.width = w;
    gCanvas.height = h;
    gCtx = gCanvas.getContext("2d");
    gCtx.clearRect(0, 0, w, h);
}


function captureToCanvas() {
    if(stype!=1)
        return;
    if(gUM)
    {
        try{
            gCtx.drawImage(v,0,0);
            try{
                qrcode.decode();
            }
            catch(e){       
                console.log(e);
                setTimeout(captureToCanvas, 500);
            };
        }
        catch(e){       
                console.log(e);
                setTimeout(captureToCanvas, 500);
        };
    }
}

function htmlEntities(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function send_check_in (employee_id) {
    var url = '/checkin/' + employee_id
      $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        if(d.chyba){
          alert(d.chyba)
        }
        else{
          console.log(d);
          alert('prichod do roboty ');
        }
       
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
}

function send_check_out (employee_id) {
    var performance = $('#checkout-input').val();
    var url = '/checkout/' + employee_id + '/' + performance;

      $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        alert('odchod z roboty ');
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
}

function read(a)
{ 
    var html="<br>";
    if(a.indexOf("http://") === 0 || a.indexOf("https://") === 0)
        html+="<a target='_blank' href='"+a+"'>"+a+"</a><br>";
    html+="<b>"+htmlEntities(a)+"</b><br><br>";
    document.getElementById("result").innerHTML=html;
    // alert(a);
    if (state === 1) {
        send_check_in(a);
    }
    else{
        send_check_out(a);
    };
    
}   

function isCanvasSupported(){
  var elem = document.createElement('canvas');
  return !!(elem.getContext && elem.getContext('2d'));
}
function success(stream) {
    if(webkit)
        v.src = window.webkitURL.createObjectURL(stream);
    else
    if(moz)
    {
        v.mozSrcObject = stream;
        v.play();
    }
    else
        v.src = stream;
    gUM=true;
    setTimeout(captureToCanvas, 500);
}
        
function error(error) {
    gUM=false;
    return;
}

function load()
{
    if(isCanvasSupported() && window.File && window.FileReader)
    {
        initCanvas(800, 600);
        qrcode.callback = read;
        document.getElementById("mainbody").style.display="inline";
        setwebcam();
    }
    else
    {
        document.getElementById("mainbody").style.display="inline";
        document.getElementById("mainbody").innerHTML='<p id="mp1">QR code scanner for HTML5 capable browsers</p><br>'+
        '<br><p id="mp2">sorry your browser is not supported</p><br><br>'+
        '<p id="mp1">try <a href="http://www.mozilla.com/firefox"><img src="firefox.png"/></a> or <a href="http://chrome.google.com"><img src="chrome_logo.gif"/></a> or <a href="http://www.opera.com"><img src="Opera-logo.png"/></a></p>';
    }
}

function setwebcam()
{
    document.getElementById("result").innerHTML="- scanning -";
    if(stype==1)
    {
        setTimeout(captureToCanvas, 500);    
        return;
    }
    var n=navigator;
    document.getElementById("outdiv").innerHTML = vidhtml;
    v=document.getElementById("v");

    if(n.getUserMedia)
        n.getUserMedia({video: true, audio: false}, success, error);
    else
    if(n.webkitGetUserMedia)
    {
        webkit=true;
        n.webkitGetUserMedia({video: true, audio: false}, success, error);
    }
    else
    if(n.mozGetUserMedia)
    {
        moz=true;
        n.mozGetUserMedia({video: true, audio: false}, success, error);
    }

    //document.getElementById("qrimg").src="qrimg2.png";
    //document.getElementById("webcamimg").src="webcam.png";
    document.getElementById("qrimg").style.opacity=0.2;
    document.getElementById("webcamimg").style.opacity=1.0;

    stype=1;
    setTimeout(captureToCanvas, 500);
}
function setimg()
{   
    document.getElementById("result").innerHTML="";
    if(stype==2)
        return;
    document.getElementById("outdiv").innerHTML = imghtml;
    //document.getElementById("qrimg").src="qrimg.png";
    //document.getElementById("webcamimg").src="webcam2.png";
    document.getElementById("qrimg").style.opacity=1.0;
    document.getElementById("webcamimg").style.opacity=0.2;
    var qrfile = document.getElementById("qrfile");
    qrfile.addEventListener("dragenter", dragenter, false);  
    qrfile.addEventListener("dragover", dragover, false);  
    qrfile.addEventListener("drop", drop, false);
    stype=2;
}

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-24451557-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    // $('').click(function(event) {
       
    // });
    
    

    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  $( document ).ready(function() {
    $( ".want-check-in" ).click(function() {
        state = 1;
        load();
        $('#options').addClass('hidden');
        $('#webcam').removeClass('hidden');
    });

    $( "#want-check-out" ).click(function() {
         state = 2;
        load();
        $('#options').addClass('hidden');
        $('#checkout-input').removeClass('hidden');
        $('#webcam').removeClass('hidden');
    });

  });
</script>


<html>
<head>
  <meta name="description" content="QR Code scanner" />
  <meta name="keywords" content="qrcode,qr code,scanner,barcode,javascript" />
  <meta name="language" content="English" />
  <meta name="copyright" content="Lazar Laszlo (c) 2011" />
  <meta name="Revisit-After" content="1 Days"/>
  <meta name="robots" content="index, follow"/>
  <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>

<body>



<body>

<div class="navbar navbar-default">

  <div class="container">
    <div class="navbar-header">

      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    <div class="navbar-inner">
      <a class="brand" href="#">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img width ="228" src="${request.static_path('project:static/img/logo2.png')}"></a>
     </div>
    </div>
    <div class="collapse navbar-collapse pull-right">
      <ul class="nav navbar-nav">
        <li ><a href="index.html"<span class= "font">Home</span></a></li>
        <li ><a href="about.html"<span class= "font">About</span></a></li>
        <li class="active"><a href="admin.html"><span class= "font">Admin</span></a></li>
      </ul>
    </div><!--/.nav-collapse -->
  
  </div>
  </div>
</div>

<div class="container">
  <div class="row">
  <%namespace  file="static.mako" import="menu"/>
      <div class="col-md-3">
          ${menu(part = 'stats')}          
      </div>
       
       <div class="col-md-9">
          <div class="row">
   

          <br>

<!--   tu zacinaju grafy -->

          <div class="panel panel-default">
            <div class="panel-heading">
              <span class="bold">Check with your QR code </span><span class="oranzova" id="meno-analizy"></span>
              <span class="pull-right ">
                <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
              </span>
            </div>
            
             <div  class="row hidden"  id="webcam">
                <div>
                    <div id="main">
                    <div id="header">
                     
                    <p id="mp1">
                    </p>
                    
                    </div>
                    <div id="mainbody">
                    <table class="tsel" border="0" width="100%">
                    <tr>
                    <td valign="top" align="center" width="50%">
                    <table class="tsel" border="0">
                    <tr>
                    <td><img class="selector" id="webcamimg" onclick="setwebcam()" align="left" /></td>
                    <td><img class="selector" id="qrimg" onclick="setimg()" align="right"/></td></tr>
                    <tr><td colspan="2" align="center">
                    <div id="outdiv">
                    </div></td></tr>
                    </table>
                    </td>
                    </tr>
                    <tr><td colspan="3" align="center">
                    <img src="down.png"/>
                    </td></tr>
                    <tr><td colspan="3" align="center">
                    <div id="result"></div>
                    <input  class="form-control hidden "id="checkout-input" placeholder="Enter perfomnce" value="100">
                    </td></tr>
                    </table>
                    </div>&nbsp;
           
                    </div>
                    <canvas id="qr-canvas" width="800" height="600"></canvas>
             </div>  </div>
            <div  class="row" id="options">
                <br>
                <div class="col-md-offset-3">
                    <button type="button" class="btn btn-success btn-lg want-check-in" id="want-check-in">Check-in</button>
                    <button type="button" class="btn btn-danger btn-lg" id="want-check-out">Check-out</button>
                </div>
            </div>
                  
<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>
<script type="text/javascript">//load(); </script>
</body>

</html>