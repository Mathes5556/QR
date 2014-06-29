  

<html>

<head>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>


<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link href="${request.static_path('project:static/css/main.css')}" rel="stylesheet" type="text/css" />
<meta charset=utf-8 />
<title>Joucy solution 3| solution for your attenadnce system</title>
<script type="text/javascript">

$( document ).ready(function() {
 /* pre kalendar!*/

    $( "#datepicker" ).datepicker();
    $( "#datepicker2" ).datepicker();

    $( "#from" ).datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#to" ).datepicker( "option", "minDate", selectedDate );
      }
    });
    
    $( "#to" ).datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      numberOfMonths: 1,
      onClose: function( selectedDate ) {
        $( "#from" ).datepicker( "option", "maxDate", selectedDate );
      }
    });


  /*Select podla pozicie po kliknuti*/
  $('.pozicie').click( function() {
    /*najprv zobrazim vsetky ak uz bolo predtym daco ien dane..*/
      $( ".name_of_employee" ).each(function( index ) {
           $( this ).parent().show();
      });
     var vybrana_pozicia = $(this).text();  
     $( ".pozicia" ).each(function( index ) {
        if($( this ).text() !== vybrana_pozicia){
          $( this ).parent().hide();
        }
      });
       
    return false; 
  });

/*
  pomocna funkcia*/
  function stringContains(inputString, stringToFind) 
{
    return (inputString.indexOf(stringToFind) != -1);
}

/*teraz hladam zhodu mien pri klkinuti do inputu..*/


var posledna_dlzka_hladaneho_slova = 0;

  $('#meno').bind('input', function() { 
   var hladany_retazec = $(this).val().toLowerCase();
   if(posledna_dlzka_hladaneho_slova > hladany_retazec.length){
          $( ".name_of_employee" ).each(function( index ) {
               $( this ).parent().show();
          });
      }
    $( ".name_of_employee" ).each(function( index ) {
        if (hladany_retazec !==''){
            if(!stringContains($( this ).text().toLowerCase(),hladany_retazec)){
            $( this ).parent().hide();
            }
        }
        else{
          $( this ).parent().show();
        }

      posledna_dlzka_hladaneho_slova = hladany_retazec.length;
    
    });

});

$('#new_event').click(function(event) {
  $(this).addClass('hide')
  $('#new_events_form').removeClass('hide')
});

  $('#close-new-event-widndow').hover(
      function() { 
        $(this).css('opacity', '0.2');
    }, function () {
           $(this).css('opacity', '1');
         });

    $('#close-new-event-widndow').click( function() {
        $('#new_event').removeClass('hide')
        $('#new_events_form').addClass('hide')
    })



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
          ${menu(part = 'events')}      
        </div>
      </aside>

       <div class="col-md-9">
               <span class="font seda bold">Events</span><br><br>
      
               
          <div class="panel panel-default">
            <div class="panel-heading"><span class="bold">List of events</span></div>
                <!--   pridanie noveho eventu -->
                <div class="row ">
                 <br>
                <div class=" hide col-md-8 col-md-offset-2 border-oranzovy  okruhle_rohy text-center" id="new_events_form">
                
                   <div class="col-xs-11 col-sm-11 col-md-11 col-lg-11">
                       <p style="font-weight: bold">&nbsp&nbsp&nbsp&nbsp Add new employee form</p>
                  </div>
                  <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                      <span class="cervena glyphicon glyphicon-remove" id="close-new-event-widndow"></span>
                  </div>                  
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                  <br>


                   <form role="form" action="${request.route_path('add_event')}" method="POST">
                      <div class="form-group">
                        <label for="name">Name</label>
                        <input  name="name" class="form-control"  placeholder="Name">
                      </div>
              
     
                          <label for="from">Date of begin</label>
                              <input type="text" id="from" name="date_begin"  class="form-control"  placeholder="begin date">
                         <label for="from">Time of begin</label>
                              <input type="text" id="from" name="time_begin"  class="form-control"  placeholder="time of begin ">
                          <label for="to">to</label>
                              <input type="text" id="to" name="date_end" class="form-control "  placeholder="end date">
                           <label for="from">Time of end</label>
                              <input type="text" id="from" name="time_end"  class="form-control"  placeholder="time of end">
                          <label for="name">Leader</label>
                          <select name="id_leader" class="form-control"  placeholder="leader" >
                              % for avaliable_leader in avaliable_leaders:
                               <option value=" ${avaliable_leader.id}"> ${avaliable_leader.name} ${avaliable_leader.surname}</option>
                              % endfor
                          </select>
                          <br>
                        <div class="row ">
                          <div class="col-md-1 col-md-offset-5 ">
                             <button  type="submit" class="btn btn-default " id="save_new_employee" >
                                  <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                                  <span style="font-size: 1em"> Save</span>
                             </button>
                          </div>
                        </div>
                  </form>
                 </div>
                </div>
              </div>

           <!--  row pod listom empolye tj vyhldavanie + filtrovanie -->
            <div class="row">
            
               <div class="col-md-7 ">
                <br>
                  <div class="input-group">
                    <span class="input-group-addon">Search</span>
                    <input id="meno" type="text" class="form-control" placeholder="Name of events">
                  </div>
                 </div>
                  <div class="col-md-3  col-md-offset-2">
                    <br>
                   <button type="button" class="btn btn-default" id="new_event">
                      <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                     <span style="font-size: 1em"> Add event</span>
                   </button>
                 </div>

              </div>
               <br>

           
              <table class="table table-hover"> 
                 <thead>
                    <tr>
                      <th>#</th>
                      
                        <th>Name of task</th>
                        <th>Date</th>
                         <th>Time</th>
                         <th>Finished</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      index = 0
                    %>

                    
                      % for event in events:
                      <% index += 1 %>
                        <tr>
                          <td> ${index}</td>
                          <td class="name_of_employee" ><a href="${request.route_path('event', event_id=event.id)}">${str(event.nazov)}</a></td>
                          <td>  ${str(event.begin).split(' ')[0]} </td>
                          <td> 
                                ${str(event.begin).split(' ')[1].split(':')[0]}:${str(event.begin).split(' ')[1].split(':')[1]} -
                                ${str(event.end).split(' ')[1].split(':')[0]}:${str(event.end).split(' ')[1].split(':')[1]} 
                           </td>
                           <td> <span class="glyphicon glyphicon-remove cervena"></span> </td>
                        </tr>
                    % endfor
                  </tbody>
                </table>

        </tbody>
      </table>



     
      </div><!-- koniec celeho borderu imaginarneho -->
  


</div>

</body>
</html>