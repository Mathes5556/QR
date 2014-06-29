<!doctype html> 
<html lang="sk-SK">
<head>
  <meta charset="utf-8" />
  <title>Daily Evaluation</title>
  <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
  <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css" />
  <script>
  $(function() {
  $( "#datepicker" ).datepicker({ dateFormat: "yy-mm-dd" });
  $( "#xx" ).datepicker({ dateFormat: "yy-mm-dd" });    
  });
  </script>
</head>
<div>
<form name="text" action="${request.route_path('daily_evaluation')}" method="POST">
<body>
<p>Date: <input type="text" id="datepicker" name="textarea" /></p>
<p>Date: <input type="text" id="xx" name="t" /></p>
<input type="checkbox" name="type" value="Sme">Sme.sk<br>
<input type="checkbox" name="type" value="Topky">Topky.sk<br>
<input type="submit" value="Submit">
</form>



% if text:
Priemer: ${text}
% endif
</body>
</div>
</html>
