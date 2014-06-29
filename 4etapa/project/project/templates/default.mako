<!DOCTYPE HTML>
<html lang="sk-SK">
<head>
	<meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="${request.static_path('project:static/zaklad.css')}">
</head>
<body>
<div id = 'header'> 
  <div id = 'logo'> <img src = "${request.static_path('project:static/barometer.png')}"  width = 200  ></div>
  <div id = 'menu'> <a href= "${request.route_path('graf')}">Vývoj nalady </a></div>
  <div id = 'menu1'> <a href= "${request.route_path('home')}">Analizér textu </a></div>
    <div id = 'menu2'> <a href= "${request.route_path('home')}"> TOP 10</a></div>

</div>
        <div id='content'>
            <%block name="page_content">${content | n}</%block>
        </div>
    </div>
</body>
</html>

