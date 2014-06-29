<html>

  <head>
   <link rel="stylesheet" type="text/css" href="${request.static_path('project:static/zaklad.css')}">
  
       <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
     <script type="text/javascript" src="${request.static_path('project:static/grafy.js')}"></script>
  <script type="text/javascript">

 $( document ).ready(function() {
    alert('aaa')
        $.ajax({
            type: "POST",
            url: "/jpie/vsetky/vsetky",
            success: function(d){
              alert(d)
            
        })};

   });
  </script>
  </head>
  <body>
  <div id = 'header'> 
    <div id = 'logo'> <img src = "${request.static_path('project:static/barometer.png')}"  width = 200></div>
    <div id = 'menu'> <a href= "${request.route_path('graf')}">Vývoj nalady </a></div>
    <div id = 'menu1'> <a href= "${request.route_path('home')}">Analizér textu </a></div>
    <div id = 'menu2'> <a href= ''> TOP 10</a></div>

  </div>
    <div style= "position: relative; "
    
   
<div id = "tool_vysledky">
<div class="terminal-poz">

 
    </div>
<div class="terminal-neg">
   
    </div>

    <div id="chart_div"></div>
     <fieldset>
<legend>Servers sentiment:</legend>
<input name="portal" value="sme.sk" type="checkbox" >sme.sk
<input name="portal" value="blog.sme.sk" type="checkbox">blog.sme.sk
<input name="portal" value="topky.sk" type="checkbox" >topky.sk
<input name="portal" value="vsetky" type="checkbox" checked="true">vsetky zdroje<br>
<input name="portal" value="ekonomika" type="checkbox" >ekonomika
<input name="portal" value="kultura" type="checkbox">kultura  
<input name="portal" value="diskusie" type="checkbox">diskusie na sme.sk 

</fieldset> 
  <div id = "baromter"></div>
  <div id = "piechart"></div>
</div>

  </body>
</html>