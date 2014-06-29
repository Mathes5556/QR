

<html>

<head>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>


<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript" src="${request.static_path('project:static/js/typeahead.min.js')}"></script>

<link href="${request.static_path('project:static/css/main.css')}" rel="stylesheet" type="text/css" />
<meta charset=utf-8 />
<title>Joucy solution | solution for your attenadnce system</title>
<script type="text/javascript">
$( document ).ready(function() {

  function prijmy_zoznam_mien () {
    var fi="a";
    $.ajax({
        type: "GET",
        url: "/all_employee",
        async: false, 
        success: function(d){
          fi = d.names_of_employee  
        },
        failure: function(errMsg) {
                  alert(errMsg);
              },
        complete: function(d){
          var r =  d.mena;
        },
         dataType: 'json'
           });
  return fi;
  }

  var a = prijmy_zoznam_mien();

function pieChart(kam) {
  var chart = new Highcharts.Chart({

          chart: {
             renderTo: kam,
   
          },
          title: {
             style: {
                       color: 'black',
                    },
              text: 'Percentage delay'
          },
          tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
          },
          plotOptions: {
              pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                      enabled: true,
                      color: '#000000',
                      connectorColor: '#000000',
                      format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                  }
              }
          },
          series: [{
              type: 'pie',
              name: 'Browser share',
              data: [
                  {
                      name: 'Delay',
                      y: ${on_time},
                      sliced: true,
                      selected: true,
                      color: '#fea312'
                  },
                  {
                      name: 'On time',
                      y: ${on_time},
                      color: '#ffdba2'
                  }
              ]
          }]
      });
}





pieChart('pie');


/*nabindujem vsetky zminiaturnovania a zmaxiolizovania*/
$( ".min" ).click(function() {
/*  $('html, body').animate({scrollTop: $(this).parent().parent().siblings().offset().top - 50}, 100);*/
  $(this).hide();
  $(this).siblings().show();
  $(this).parent().parent().siblings().hide();

  return false;
});


$( ".max" ).click(function() {
  $(this).hide();
  $(this).siblings().show();
  $(this).parent().parent().siblings().show();
  return false;
});

/*nabidnudjem scrool down na polozky vedla mena*/
$( "#toUsers" ).click(function() {
 $('html, body').animate({scrollTop: $('.listUser').offset().top}, 1000);
return false;
});

$( "#toReview" ).click(function() {
 $('html, body').animate({scrollTop: $('.review').offset().top}, 1000);
return false;
});
$( "#toNote" ).click(function() {
 $('html, body').animate({scrollTop: $('.note').offset().top}, 2500);
return false;
});

/*pridavanie usera*/  
$('.typeahead').typeahead({
    name: 'Some name',
    local: prijmy_zoznam_mien()
});
$( "#moze-pridat" ).click(function() {
  var new_employee = $( "#input-new-employee" ).val();
  var id_event = "${event.id}";
  var url = "/add_task/".concat(id_event).concat('/').concat(new_employee)
  console.log(url)
  var el = $(this)
  /*console.log(url)*/
  $.get( url, function( d ) {
    if(d.status == "ok"){
       var text = '<tr><td></td><td>'.concat(new_employee).concat('</td><td>?</td><td>?</td><td>?</td></tr>')
        $('#list-users').append(text);
        $('#input-new-employee').val('');
        $("#alert-place-new-user").html('<div class="alert alert-success">uzivatel bol uspesne pridany</div>').fadeOut( 2000 );
        el.addClass('hidden');
    }
    else{
      alert(d.status)
    }
  }, "json" );

 
});

$( "#want-new-user" ).click(function() {
  $('#input-new-employee').fadeIn().removeClass('hidden');
  $(this).hide()
  });
$('.typeahead').bind('typeahead:selected', function(obj, datum, name) {      
        $('#moze-pridat').fadeIn().removeClass('hidden');
});


$( ".delete_employee" ).click(function() {
  var id_employee = $(this).attr('id');
  var url = "delete_employee_from_task/${event.id}/".concat(id_employee)
  var el = $(this)
  $.get( url, function( d ) {
    if(d.status === "ok"){
       el.parent().hide()
    }
    else{
      alert(d.status)
    }
  }, "json" );

return false;
});

// //save chenges to description of event..
function change_task_for_user (task_id, performance, delay) {
    var url= "http://0.0.0.0:6543/change_task/" + task_id + '/' + performance + '/' + delay;
    $.ajax({
        type: "GET",
        url: url,
        success: function(d){
          console.log(d)
        },
        failure: function(errMsg) {
                  alert(errMsg);
              },
         dataType: 'json'
           });
  };

  $( ".save_user").click(function() {
    var task_id = $(this).parent().parent().attr('id');
    var performnce = $( "#performnce" + task_id).val(); 
    var delay = $( "#delay" + task_id ).val();
    change_task_for_user(task_id, performnce, delay);
  });

// $( "#save_all_changes" ).click(function() {

//   return false;
// });

// $(".save_user_info").click(function() {
//   alert('ok')
// });
$( "#save_hash_tag" ).click(function() {
    var id = $("#option_hash_tag").val();
    alert(id)
   var hash_tag = $("#option_hash_tag option[value="+id+"]").text();
   el = $( "#save_hash_tag" );
   $( "#add_new_hash_tag" ).removeClass('hide');  
       var url = 'http://0.0.0.0:6543/event/add_hash_event/${event.id}/'+id;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log(d);
        if (d.status == "ok"){
          text = '<span><a href="" id="${event.id}/'+id+'" class="glyphicon glyphicon-minus cervena delete-hash"></a>#';
          text += hash_tag;
          text += '</span>';
          $('#list_of_hash').append(text);
          $('#adding_new_hashtag').addClass('hide');
        }
        else{
          alert(d.status)
        }
        console.log(d.status)
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
});

});
</script>
<style type="text/css">


</style>
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
          ${menu()}      
        </div>
      </aside>

       <div class="col-md-9">
                <a href="empolyee.html">
              <span class="seda glyphicon glyphicon-lock"></span><h6 class=" glyphicon glyphicon-lock seda"> all events</h6>
               </a>
               <br>
               <span class="font seda bold">Profile of event : </span> <span class="font oranzova bold ">${str(event.nazov)}</span>
               &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
                 <span class=" ">
                    <a id="toUsers" href = "#">
                      <span class="glyphicon glyphicon-hand-up oranzova"></span>
                       <span class="seda">Users</span>
                   </a>
                 </span>
                 &nbsp
                  <span class=" ">
                    <a id="toReview" href = "#">
                      <span class="glyphicon glyphicon-hand-up oranzova"></span>
                       <span class="seda">Review of event</span>
                   </a>
                 </span>
                   &nbsp
                  <span class=" ">
                    <a id="toNote" href = "#">
                      <span class="glyphicon glyphicon-hand-up oranzova"></span>
                       <span class="seda">Notes</span>
                   </a>
                 </span>
                 
                 
          <br><br>
          <div class="panel panel-default">
            <div class="panel-heading">
              <span class="bold">Global infomation</span>&nbsp&nbsp&nbsp
          
                 <button type="button" class="btn btn-sm btn-default">
                  <span class="glyphicon glyphicon-link oranzova"> </span>&nbsp
                  <span style="font-size: 1em"> Clone</span>
                </button>
              <span class="pull-right ">
                <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
              </span>
            </div>
            
             <div  class="row">
              <div class="col-md-5 col-md-offset-1 right-border ">
                <br> 
                  <span class="bold">Name of event :</span> 
                          <input type="text" class="form-control input-normal" 
                            id="name" value="${str(event.nazov)}" /> 
                   <br>  
                      <span class="bold">Goal:</span>  
                      <input type="text" class="form-control input-normal" id="goal" value="${str(event.goal)}" /> 
                 <br> 
                  <span class="bold">Begin:</span> <span class="oranzova">  ${str(event.begin).split(' ')[1].split(':')[0]}:${str(event.begin).split(' ')[1].split(':')[1]}</span> 
                 <br> <span class="bold">End:</span> <span class="oranzova"> ${str(event.end).split(' ')[1].split(':')[0]}:${str(event.end).split(' ')[1].split(':')[1]} </span>  
                 <br> 
                 <span class="bold">Workplace:</span>   <input type="text" class="form-control input-normal" value="${str(event.workplace)}" />  
                 <br> 
                 <span class="bold">Leader:</span> <a href="${request.route_path('employee', employee_id= event.leader.id)}">${str(event.leader.name)} ${str(event.leader.surname)}</a>
                 <br> 
                  <span class="bold">Type of event:</span>  
                  % for hash_tag in hash_tags:
                    #${hash_tag.name}
                  % endfor
                                  
                 <br> 
                 
                     <div  class="row " id="adding_new_hashtag">
                      <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                        <select class="form-control" id="option_hash_tag">
                                  % for hash_tag in all_possible_hash_tags:
                                   <option value="${hash_tag.id}"> ${hash_tag.name}</option>
                                  % endfor
             
                       </select>
                      </div>
                      <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                       <button type="button" class="btn btn-default " id="save_hash_tag" >
                                  <span class="glyphicon glyphicon-plus oranzova"> </span>
                                  <span style="font-size: 1em"> Add hash tag</span>
                      </button>
                    </div>
                      
                  </div>
                 <span class="bold">Finished:</span>
                                       &nbsp<span class="glyphicon glyphicon-ok zelena"></span> 
                                      <span class="glyphicon glyphicon-remove cervena"></span> 
                 
                 <br> 
                 <span class="bold">Related events:</span> <a href="event-report.html">Daily routine #1712</a>
                 <br> 

                 <br>

           
              </div>
              <div class="col-md-4 col-md-offset-1  ">
                <br> 
                  <span class="bold"> Description:</span>  <input type="text" class="form-control input-normal" 
                            id="name" value="${str(event.description)}" /> 
                  <br>
                  <button type="button" class="btn s btn-success" id="save_all_changes" >
                    Save
                  </button>



              </div>
             </div>
               </div><!-- koniec celeho borderu imaginarneho -->






<!--              koniec jedneho odstavca(obdlznika) zacaitok druheho  -->

               <div class="panel panel-default listUser">
              <div class="panel-heading">
                <span class="bold">List of employee participate in event </span>&nbsp&nbsp&nbsp
                <button type="button" class="btn btn-sm btn-default " id="want-new-user" >
                  <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                  <span style="font-size: 1em"> Add user</span>

                </button>
                <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
                <div class="row">
                   <div class="col-md-12" id="alert-place-new-user"></div><!--  place for alert abou new user -->
                  <div class="col-md-5 col-md-offset-4 novy-user">
                   <!--  pridavanie nove usera -->
                   <br>
                  <input type="text" class="typeahead form-control hidden" id="input-new-employee" placeholder="Add new user"/>
                      <div class="row">
                         <div class="col-md-offset-3 ">
                       <h2 id="moze-pridat" class="hidden oranzova glyphicon glyphicon-plus"></h2>
                       </div>
                      </div>
                  </div>
                  <div class="col-md-12">
                     
                         <div class="row">
                             <div class="col-md-1 col-md-offset-5">
                                
                              </div>
                        </div>

                       <%index = 0  %>
                      <table class="table table-hover" id="list-users">
                           <thead>
                              <tr>
                                <th>#</th>
                                <th>Name of employee</th>
                                 <th>Delete</th>
                                <th>Delay</th>
                                 <th>Performance</th>
                                 <th>Count of hours</th>
                              </tr>
                            </thead>
                        <tbody id="users">
                      <% index = 0 %>
                    % for participiant in participiants2:
                      <% index += 1 %>
                        <tr id="${participiant.id}" class="participiant">
                          <td> ${index}</td>
                         
                          <td class="name_of_employee" > <a href="${request.route_path('employee', employee_id=participiant.id)}"> ${str(participiant.employee.name)}  ${str(participiant.employee.surname)}</a></td>
                            <td id="${str(participiant.id)}" class="delete_employee"> 
                              <a href="#"><span  class="glyphicon glyphicon-minus cervena"></span></a>
                            </td>
                            <td > 
                              <input id="delay${str(participiant.id)}" type="text" class="form-control" placeholder="Minutes of delay" value="${str(participiant.delay)}">

                            </td> 
                           <td>
                              <input id="performnce${str(participiant.id)}" type="text" class="form-control" placeholder="Performance(%)" value="${str(participiant.performance)}">
                           </td>
                           <td> ${length_of_event}</td>
                           <td>
                            <button type="button" class="pull-right btn btn-success save_user" >Save </button> </td>
                        </tr>
                    % endfor
                        </tbody>
                      </table>

                   </div>
                  
                </div>
            
             </div>
    
              <!-- koniec jedneho panelu -->
   
              <!-- grafy -->
    
             <div class="panel panel-default review">
              <div class="panel-heading">
                <span class="bold">Review of event</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>

                <div class="row">
                  <div class="col-md-6 col-md-offset-0 right-border ">
                        <div id="pie" style="min-width: 110px; height: 400px; margin: 0 auto"></div>
                   </div>
                   <div class="col-md-6 col-md-offset-0 ">
                    <table class="table table-hover" id="list-users">
                           <thead>
                      
                        <tbody id="users">
                          <tr>
                            <td> Goal achieved</td>
                            <td ><span class="glyphicon glyphicon-remove cervena"></span></td>
                          </tr>
                          <tr>
                            <td> Average performance</td>
                            <td >${avg_performance}</td>

                          </tr>

            
                          <tr>
                            <td>Best performnace</td>
                            <td ><a href="#">

                              ${participiants2[0].employee.name} 
                              ${participiants2[0].employee.surname}</a></td>
                      
                            
                          </tr>
                          <tr>
                            <td>Worst performance</td>
                              <td><a href="#">${participiants2[-1].employee.name} 
                              ${participiants2[-1].employee.surname}</a></td>
                       
                           
                          </tr>
                        </tbody>
                      </table>
                       
                   </div>
                </div>
            
             </div>
                <!-- add task -->
                <br>
            <div class="panel panel-default note">
              <div class="panel-heading">
                <span class="bold">Notes about event</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
              <div class="row">
                  <div class="col-md-12 ">
                     <div class="input-group input-group-lg"  >
                      <span class="input-group-addon"></span>
                      <input type="text" class="form-control" placeholder="Notes about event">
                      </div>
                      <br>
                      <button type="button" class="pull-right btn btn-success">Save </button>
                      <br> <br>
                  </div>

                     <br>
                  </div>
               </div>
              </div>
           
<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>