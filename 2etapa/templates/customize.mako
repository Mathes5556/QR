

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
<script type="text/javascript">
$( document ).ready(function() {


$( "#add_new_employee_comparison").click(function() {
   $('#employee_comparison').removeClass('hide')

});


$( "#option1" ).change(function() {
   option1 = $(this).val()
});
$( "#option2" ).change(function() {
   option2 = $(this).val()
});
$( "#event_option1" ).change(function() {
   event_option1 = $(this).val()
});
$( "#event_option2" ).change(function() {
   event_option2 = $(this).val()
});


$( "#save_employee_comparison" ).click(function() {
    var url = 'add_comparison/employee/'+option1+'/'+option2;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log('ok')
        $('#employee_comparison').addClass('hide')
         var novy_riadok = '<tr>    <td >  <span class="bold">#'+option1+'</span> vs  <span class="bold">#'+option2+'</span> </td>'
          novy_riadok += ' <td ><a href="#" id="comparison/'+d.id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
        $('#employee_comparison_table').append(novy_riadok)
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
});

$( "#save_event_comparison" ).click(function() {
    var url = 'add_comparison/event/'+event_option1+'/'+event_option2;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log('ok')
        $('#employee_comparison').addClass('hide')
         var novy_riadok = '<tr>    <td >  <span class="bold">#'+event_option1+'</span> vs  <span class="bold">#'+event_option2+'</span> </td>'
          novy_riadok += ' <td ><a href="#" id="comparison/'+d.id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
        $('#event_comparison_table').append(novy_riadok)
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
});


$(document).on('click', '.delete', function() {
    koniec_url = $(this).attr('id');
    var url = 'delete/'+koniec_url;
    console.log(url)
    el = $(this)
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log('ok')
        el.parent().parent().hide()
        var meno_mazaneho_hashu = el.parent().siblings('.name-of-hash').text().slice(3,7)
        /*TODO domazaf meno_mazaneho_hashu z option1 a option2*/
        $('#option1 option').each(function(i)
          {     

              if(meno_mazaneho_hashu == $(this).text()){
                console.log('aaaa')
              }
              console.log(meno_mazaneho_hashu)
             console.log($(this).text()); 
          });

      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });

    return false;
      });

$( "#add_new_position" ).click(function() {
  $('#add_workposition').removeClass('hide')
  $(this).addClass('hide')
});

$( "#add_new_workplace" ).click(function() {
  $('#add_workplace').removeClass('hide')
  $(this).addClass('hide')
});

$( "#add_new_hashtag" ).click(function() {
  $('#adding_new_hashtag').removeClass('hide')
  $(this).addClass('hide')
});

$( "#save_new_hash_tag" ).click(function() {
  $('#adding_new_hashtag').addClass('hide')
  $( "#add_new_hashtag" ).removeClass('hide')
});

$( "#add_new_event_hashtag" ).click(function() {
  $('#adding_new_event_hashtag').removeClass('hide')
  $(this).addClass('hide')
});
$( "#save_new_event_hash_tag" ).click(function() {
  $('#adding_new_event_hashtag').addClass('hide')
  $('#add_new_event_hashtag').removeClass('hide')
});

$(document).on('click', '#save_workplace', function() {
    var city = $('#city').val();
    var address = $('#address').val();
    var koniec_url = city+'!'+address;
    console.log(koniec_url)
    var url = 'add/workplace/'+koniec_url;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log(d.status)
        if(d.status == 'ok'){
          var id = d.id;


          $('#add_workplace').addClass('hide')
          $( "#add_new_workplace" ).removeClass('hide');
          var novy_riadok = '<tr>    <td>  <span class="bold">'+city+',</span> '+address+' </td>'
          novy_riadok += ' <td ><a href="#" id="workplace/'+id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
          $('#workplaces').append(novy_riadok)
          $('#new_workposition').val('');
        }
        else{
          alert(d.status)
        }  
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
      });



$(document).on('click', '#save_workposition', function() {
    var workposition = $('#new_workposition').val();
    var url = 'add/workposition/'+workposition;
    console.log(url)
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log(d.status)
        if(d.status == 'ok'){
          var id = d.id;
          var name = d.name;
   /*       $('#add_workposition').hide();*/
          $('#add_workposition').addClass('hide')
          var novy_riadok = '<tr>    <td>  <span class="bold">'+name+'</span>  '
          novy_riadok += ' <td ><a href="#" id="workposition/'+id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
          $('#workpositions').append(novy_riadok)
          $('#new_workposition').val('');
          $( "#add_new_position" ).removeClass('hide')
        }
        else{
          alert(d.status)
        }  
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
      });


$(document).on('click', '#save_new_hash_tag', function() {
    var new_hashtag = $('#new_hash_tag').val();
    if( new_hashtag.length == 0){
      alert('The hash tag has to be length of one or more')
      return;
    }
    var url = 'add/hash_employee/'+new_hashtag;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
         
        if(d.status == 'ok'){
          var id = d.id;
          var name = d.name;
          var novy_riadok = '<tr>    <td class="name-of-hash">  <span class="bold">#'+new_hashtag+'</span>  '
          novy_riadok += ' <td ><a href="#" id="hash/'+id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
          $('#hash_employee').append(novy_riadok)
          $('#new_hash_tag').val('');
          /*este pridam hasth tag to moznosti porovanvaciek*/
          $("#option1").append('<option>'+name+'</option>')
          $("#option2").append('<option>'+name+'</option>')
        }
        else{
          alert(d.status)
        }  
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
});
  

  $(document).on('click', '#save_new_event_hash_tag', function() {

    var new_hashtag = $('#new_hash_event_tag').val();
    if( new_hashtag.length == 0){
      alert('The hash tag has to be length of one or more')
      return;
    }
    var url = 'add/hash_event/'+new_hashtag;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
         
        if(d.status == 'ok'){
          var id = d.id;
          var name = d.name;
          var novy_riadok = '<tr>    <td class="name-of-hash">  <span class="bold">#'+new_hashtag+'</span>  '
          novy_riadok += ' <td ><a href="#" id="hash/'+id+'"class="delete"><button type="button" class="btn btn-default">'
          novy_riadok += '<span class="glyphicon glyphicon-minus cervena"></button></span></td>  </a>'
          novy_riadok += ' <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">'
          novy_riadok +=  '</button></span></td> </tr>'
          $('#hash_event').append(novy_riadok)
          $('#new_hash_event_tag').val('');
          /*este pridam hasth tag to moznosti porovanvaciek*/
          $( "#event_option1" ).append('<option>'+name+'</option>')
          $( "#event_option2" ).append('<option>'+name+'</option>')
        }
        else{
          alert(d.status)
        }  
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
    return false;
});
});
</script>
  
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

       <%namespace  file="static.mako" import="menu"/>
      <aside>
        <div class="col-md-3">
          ${menu(part ='customize')}      
        </div>
      </aside>
    

       <div class="col-md-9">
               <br>
               <span class="font oranzova bold ">Customize your profile  </span>
          
          <br><br>  
          <div class="panel panel-default place">
            <div class="panel-heading">
               <div  class="row">
                  <div class="col-md-6 col-md-offset-0  right-border ">
                    <span class="bold">Work place </span><span class="oranzova" id="meno-analizy"></span>
                  </div>
                  <div class="col-md-6 col-md-offset-0">
                    <span class="bold">Work positions </span><span class="oranzova" id="meno-analizy"></span>
                  </div>
              </div>
            </div>
            
             <div  class="row">
                  <div class="col-md-6 col-md-offset-0 right-border">
    
                       <table class="table" id="workplaces"> 
                        % for workplace in workplaces:
                          <tr>
                            <td>  <span class="bold">${workplace.city}</span> <span class="">${workplace.address}</span> </td>
                            <td >
                              <a href="#" id="workplace/${workplace.id}"
                              class="delete">
                               <button type="button" class="btn btn-default">
                                  <span class="glyphicon glyphicon-minus cervena">
                                </button>
                              </a>
                            </span>
                          </td>
                      
                            <td > <td > 
                              <button type="button" class="btn btn-default">
                                  <span class="glyphicon glyphicon-cog oranzova">
                              </button>
                            </span>
                          </td>
                            
                          </tr>
                        % endfor
                      </table>
                      <div  class=" hide" id="add_workplace"> 
                           <div  class="row " >
                            <div class="col-md-6 col-md-offset-2">
                              <input  class="form-control" id="city" placeholder="City">
                            </div>
                           </div>

                            <div  class="row" id="add_workplace">
                              <div class="col-md-6 col-md-offset-2">
                              <input  class="form-control" id="address" placeholder="Address">
                            </div>
                            <div class="col-md-2">
                               <button type="button" class="btn btn-default " id="save_workplace" >
                                <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                                <span style="font-size: 1em"> Save</span>
                                </button>
                            </div>
                             
                            <br> <br> <br>
                          </div>
                      </div>
                      <div  class="row">
                          <div class="col-md-2 col-md-offset-4  right-border ">
                           <button type="button" class="btn btn-default " id="add_new_workplace" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Add wokplace</span>
                            </button>
                          </div>
                      </div>
                      <br>
                 </div>
                 <!-- zaciatok pravej strany(pozicie) -->
                <div class="col-md-6 col-md-offset-0  left-border ">
                       <table class="table" id="workpositions"> 
                           % for employee_type in employee_types:
                              <tr>
                                 <td>  <span class="bold">${employee_type.name}</span>  </td>
                                  <td >
                                 <a href="#" id="workposition/${employee_type.id}"
                                  class="delete">
                                 <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-minus cervena">
                                  </button>
                                </span></td>
                              </a>
                    
                          <td > <td > <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-cog oranzova">
                            </button>
                          </span></td>
                          
                              </tr>
                           % endfor
      
                      </table>

                      <div  class="row hide" id="add_workposition">
                        <div class="col-md-6 col-md-offset-2">
                          <input  class="form-control" id="new_workposition" placeholder="Name of work position">
                        </div>
                        <div class="col-md-2">
                           <button type="button" class="btn btn-default " id="save_workposition" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Save</span>
                            </button>
                        </div>
                         
                        <br> <br> <br>
                      </div>

                      <div  class="row">
                          <div class="col-md-2 col-md-offset-4  right-border ">
                           <button type="button" class="btn btn-default " id="add_new_position" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> New work position</span>
                            </button>
                          </div>
                      </div>
                      <br>
                 </div>
             <!--    koniec pravej strany -->
                </div>
            
             </div>
       

          <br>

<!--   tu zacinaju grafy -->
          

          <div class="panel panel-default place">
            <div class="panel-heading">
               <div  class="row">
                  <div class="col-md-6 col-md-offset-0  right-border ">
                    <span class="bold">Hash tags for events</span><span class="oranzova" id="meno-analizy"></span>
                  </div>
                  <div class="col-md-6 col-md-offset-0">
                    <span class="bold">Hash tags for employees</span><span class="oranzova" id="meno-analizy"></span>
                  </div>
              </div>
            </div>
            
             <div  class="row">
                <div class="col-md-6 col-md-offset-0 right-border ">
                      <table class="table" id="hash_event" > 
                      % for hash_tag in hash_tags_event:
                             <tr>
                          <td class="name-of-hash">  <span class="bold">#${hash_tag.name}</span> </td>
                          <td > 
                            <a href="#" id="hash/${hash_tag.id}" class="delete">
                            <button type="button" class="btn btn-default" >
                              <span class="glyphicon glyphicon-minus cervena">
                            </button>
                          </a>
                          </span>
                        </td>
                    
                          <td > <td > 
                            <button type="button" class="btn btn-default">
                                <span class="glyphicon glyphicon-cog oranzova">
                            </button>
                          </span>
                        </td>
                          
                          </tr>
                     % endfor

                      </tbody>
                      </table>
                           <div class="row hide" id="adding_new_event_hashtag">
                          <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5 
                          col-md-offset-2  col-lg-offset-2 ">
                               <input type="email" class="form-control" id="new_hash_event_tag" placeholder="Name of hash tags">
                          </div>
                           <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2   ">
                            <button type="button" class="btn btn-default " id="save_new_event_hash_tag" >
                              <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                              <span style="font-size: 1em"> Save</span>
                            </button>
                          </div>
                      </div>
                     
                      <div  class="row">
                          <div class="col-md-2 col-md-offset-3  right-border ">
                           <button type="button" class="btn btn-default " id="add_new_event_hashtag" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Add new hash tag</span>
                            </button>

                          </div>

                      </div>
                       <br>
                 </div>
















                 <!-- zaciatok pravej strany(pozicie) -->
                <div class="col-md-6 col-xs-6 col-md-offset-0  left-border ">
                   <table class="table" id="hash_employee" > 
                      % for hash_tag in hash_tags:
                             <tr>
                          <td class="name-of-hash">  <span class="bold">#${hash_tag.name}</span> </td>
                          <td > 
                            <a href="#" id="hash/${hash_tag.id}" class="delete">
                            <button type="button" class="btn btn-default" >
                              <span class="glyphicon glyphicon-minus cervena">
                            </button>
                          </a>
                          </span>
                        </td>
                    
                          <td > <td > 
                            <button type="button" class="btn btn-default">
                                <span class="glyphicon glyphicon-cog oranzova">
                            </button>
                          </span>
                        </td>
                          
                          </tr>
                     % endfor

                      </tbody>
                      </table>
                      <div class="row hide" id="adding_new_hashtag">
                          <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5
                          col-md-offset-2  col-lg-offset-2 ">
                               <input type="email" class="form-control" id="new_hash_tag" placeholder="Name of hash tags">
                          </div>
                           <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                            <button type="button" class="btn btn-default " id="save_new_hash_tag" >
                              <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                              <span style="font-size: 1em"> Save</span>
                            </button>
                          </div>
                      </div>
                      
                      <div  class="row">
                          <div class="col-md-2 col-md-offset-3 right-border ">
                           <button type="button" class="btn btn-default " id="add_new_hashtag" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Add new hash tag</span>
                            </button>
                          </div>
                      </div>
                      <br>
                 </div>
          
         
                 </div>
             <!--    koniec pravej strany -->
          </div>

          <div class="panel panel-default place">
            <div class="panel-heading">
               <div  class="row">
                  <div class="col-md-6 col-md-offset-0  right-border ">
                    <span class="bold">Custom comparison of events</span><span class="oranzova" id="meno-analizy"></span>
                  </div>
                  <div class="col-md-6 col-md-offset-0">
                    <span class="bold">Custom comparison of employees</span><span class="oranzova" id="meno-analizy"></span>
                  </div>
              </div>
            </div>
            
             <div  class="row">
                  <div class="col-md-6 col-md-offset-0 right-border ">
    
               <table class="table" id="event_comparison_table" > 
                          
                      </tbody>
                      </table>

                        <div class="row " id="employee_event_comparison">
                          <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 ">
                             <select class="form-control" id="event_option1">
                               <option>None</option>
                              % for hash_tag in hash_tags_event:
                               <option> ${hash_tag.name}</option>
                              % endfor
                            </select>
                          </div>
                          <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                            <bold>vs</bold>                          
                          </div>
                           <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                             <select class="form-control" id="event_option2">
                               <option>None</option>
                             % for hash_tag in hash_tags_event:
                               <option >${hash_tag.name}</option>
                              % endfor
                            </select>
                          </div>
                           <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                            <button type="button" class="btn btn-default " id="save_event_comparison" >
                              <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                              <span style="font-size: 1em"> Save</span>
                            </button>
                          </div>
                      </div>
                      <br>

                      <div  class="row">
                          <div class="col-md-2 col-md-offset-3 right-border ">
                           <button type="button" class="btn btn-default " id="want-new-user" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Add custom comparison of events</span>
                            </button>
                          </div>
                      </div>
                      <br>
                 </div>
                 <!-- zaciatok pravej strany(pozicie) -->
                <div class="col-md-6 col-md-offset-0  left-border ">
                   <table class="table" id="employee_comparison_table" > 
                           % for comparison in comparisons:
                             <tr>
                          <td>  <span class="bold">#${comparison.comp1.name}</span> vs <span class="bold">#${comparison.comp2.name}</span> </td>
                          <td > 
                            <a href="#" id="comparison/${comparison.id}" class="delete">
                            <button type="button" class="btn btn-default" >
                              <span class="glyphicon glyphicon-minus cervena">
                            </button>
                          </a>
                          </span>
                        </td>
                    
                          <td > <td > 
                            <button type="button" class="btn btn-default">
                                <span class="glyphicon glyphicon-cog oranzova">
                            </button>
                          </span>
                        </td>
                          
                          </tr>
                           % endfor
                      </tbody>
                      </table>
                      <div class="row hide" id="employee_comparison">
                          <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 ">
                             <select class="form-control" id="option1">
                               <option>None</option>
                              % for hash_tag in hash_tags:
                               <option> ${hash_tag.name}</option>
                              % endfor
                            </select>
                          </div>
                          <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                            <bold>vs</bold>                          
                          </div>
                           <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                             <select class="form-control" id="option2">
                               <option>None</option>
                             % for hash_tag in hash_tags:
                               <option >${hash_tag.name}</option>
                              % endfor
                            </select>
                          </div>
                           <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2">
                            <button type="button" class="btn btn-default " id="save_employee_comparison" >
                              <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                              <span style="font-size: 1em"> Save</span>
                            </button>
                          </div>
                      </div>
                      <br>
                      <div  class="row">
                          <div class="col-md-2 col-md-offset-2  right-border ">
                           <button type="button" class="btn btn-default " id="add_new_employee_comparison" >
                            <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                            <span style="font-size: 1em"> Add custom comparison of employees</span>
                            </button>
                          </div>
                      </div>
                      <br>
                 </div>
          
         
                 </div>
             <!--    koniec pravej strany -->
                </div>
            
             </div>
       

      
           
        

<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>