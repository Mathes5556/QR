
<html>

<head>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>


<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

<link href="${request.static_path('project:static/css/main.css')}" rel="stylesheet" type="text/css" />
<meta charset=utf-8 />
<title>Joucy solution | solution for your attenadnce system</title>
  
</head>
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
         <div class="col-md-offset-4 col-md-4 border-oranzovy">
            <div class="text-center">
                        <form role="form" action="${url}" method="post">
                          <input type="hidden" name="came_from" value="${came_from}"/>
                          <div class="form-group">
                          <label for="exampleInputEmail1">User Name</label>
                            <input class="form-control" type="text" name="login" value="${login}"/ placeholder="Login name"/><br/>
                          </div>
                           <div class="form-group">
                            <label for="exampleInputEmail1">Password</label>
                              <input class="form-control" type="password" name="password"
                                 value="${password}"  placeholder="Password"/ >
                           </div>
  
                          <input type="submit" name="form.submitted" value="Log In" class="btn btn-success"/>
                        </form>
               </div>
        </div>           
    </div>

      
           
        

<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>