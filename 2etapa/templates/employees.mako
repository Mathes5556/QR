

<html>

<head>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>


<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<link href="${request.static_path('project:static/css/main.css')}" rel="stylesheet" type="text/css" />
<meta charset=utf-8 />
<meta charset=utf-8 />
<title>Joucy solution | solution for your attenadnce system</title>
<script type="text/javascript">

$( document ).ready(function() {


function isNormalInteger(str) {
    var n = ~~Number(str);
    return String(n) === str && n >= 0;
}

    $( "#save_new_employee" ).click(function() {
      vek = $( "#age_employee" ).val();
      if(vek === ""){
        alert('Age havent been filled')
        return false;   
      }
      if (!isNormalInteger(vek)){
        alert('Age has to be positive hole number')
        return false;   
      }

    });


    $( "#want_new_user" ).click(function() {
      $(this).addClass('hide')
      $('#new_employee_form').removeClass('hide')
    });

    $('#close-ew-employee-widndow').hover(
      function() { 
        $(this).css('opacity', '0.2');
    }, function () {
           $(this).css('opacity', '1');
         });

    $('#close-ew-employee-widndow').click( function() {
        $('#want_new_user').removeClass('hide')
        $('#new_employee_form').addClass('hide')
        //
    })



$(document).on('click', '.check_out', function() {

    id_of_employee = $(this).attr('id')
    performance = $('#performance'+id_of_employee).val()

    console.log(performance)
    console.log(id_of_employee)
    if(performance == ''){
      performance = '-1'
      /* -1 ak nebol zadany  */
    }
    var url = 'checkout/'+id_of_employee+'/'+performance
    console.log(url)
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
/*          console.log(d.chyba)*/
        console.log('ok')
       
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });
     var check_in = '<a href="#" id="'+id_of_employee+'" class="check_in"><button type="button" class="btn btn-success">Check-in &nbsp</button></a>';

        $(this).parent().next().html('<td></td>');
        $(this).parent().removeClass('is-in');
        $(this).parent().addClass('is-out')
        $(this).parent().html(check_in);
    return false;
      });

  $(document).on('click', '.check_in', function() {
    id_of_employee = $(this).attr('id')
    var url = 'checkin/'+id_of_employee
     console.log(url)
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log(d.chyba)
   
      },
      failure: function(errMsg) {
                alert(errMsg);
            },

       dataType: 'json'
         });
        var check_out= ' <a href="#" id="'+id_of_employee+'" class="check_out"><button type="button" class="btn btn-danger">  Check-out</button></a>';
         check_out_value = ' <td>   <input type="email" class="form-control" id="performance'+id_of_employee+'" placeholder="Value of performance"></td>';
           $(this).parent().removeClass('is-out');
        $(this).parent().addClass('is-in')
         $(this).parent().next().html(check_out_value)
        $(this).parent().html(check_out)

    return false;
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
      /*riesenie paginacie UX active classa + ked stlaci all secko zobrazi*/
      $( "ul.pagination li" ).each(function( index ) {
          $(this).removeClass('active')
      });
      $(this).parent().addClass('active');
      if($(this).text() == "All"){
           $( ".pozicia" ).each(function( index ) {
            $( this ).parent().show();
      });
      }
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

    
    /*$( ".pozicie" ).each(function( index ) {
        $( this ).hide();
        });*/
     
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


/*idem riesit ked zaskrtne pri nejakom zamestnancovi */
var is_checked = 0;

$('#select-all').click( function() {
    var pocet_poloziek  = 0;
    $('.zaskrtnute:checkbox').each(function(index) {
        if(($( this ).parent().parent().is(":visible")) && (!$(this).is(':checked')) ){ 
            $(this).prop('checked', true);
            pocet_poloziek++;
          }
    });
    $('.option-menu').removeClass('hide')
    is_checked += pocet_poloziek;
  });

  $('#unselect-all').click( function() {
    var pocet_poloziek  = 0;
    $('.zaskrtnute:checkbox').each(function(index) {
        if(($( this ).parent().parent().is(":visible")) && ($(this).is(':checked')) ){

            $(this).prop('checked', false);
            pocet_poloziek++;
          }
    });
    is_checked -= pocet_poloziek;
    if (is_checked == 0) {
       $('.option-menu').addClass('hide')
    }
  });

/*teraz check in pre vsetkych oznacenych employees*/
$('#check-in-selected').click( function() {
    var reached_check_in = 0;
    $('.zaskrtnute:checkbox').each(function(el) {
        if ($(this).parent().siblings( "td.is-out" ).length) {
               reached_check_in++;
             }
        if( $(this).is(':checked') ){
            $(this).parent().siblings( "td.is-out" ).children('.check_in').trigger('click'); 
        }
        
    });
     if(reached_check_in === 0){
      alert('There is no employee to check in')
    }
});

$('#check-out-selected').click( function() {
  //najprv si dam honoty s ceck out pre vsetky
  // 
  var reached_check_out = 0;
  var check_out_value_for_selected =  $('#check-out-selected-value').val();

     $('.zaskrtnute:checkbox').each(function(index, el) {
        if( $(this).is(':checked') )
          $(this).parent().siblings( "td.value-for-check-out" ).children('.value').val(check_out_value_for_selected)
    });

     // a klikni na vsetky
    $('.zaskrtnute:checkbox').each(function(index, el) {
        if( $(this).is(':checked') ) {
            if ($(this).parent().siblings( "td.is-in" ).length) {
               reached_check_out++;
             }
            $(this).parent().siblings( "td.is-in" ).children('.check_out').trigger('click');
        }
       
    });
    if(reached_check_out === 0){
      alert('There is no employee to check out')
    }
});

$('.zaskrtnute:checkbox').change(function() {
    if($(this).is(':checked')){
      is_checked++;
      if (is_checked == 1) {
        $('.option-menu').removeClass('hide')
      }
    }
    else{
      is_checked--;
      $(this).prop('checked', false);
      if (is_checked == 0) {
        $('.option-menu').addClass('hide')

      };
    }
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
          ${menu(part ='employees')}      
        </div>
      </aside>
    
       <div class="col-md-9">
               <span class="font seda bold">Empolyees</span><br><br>
      
               
          <div class="panel panel-default">
            <div class="panel-heading"><span class="bold">LIst of employees</span></div>

         <!--    form pre noveho usra -->
           <div class="row ">
                 <br>

                <div class="col-md-8 col-md-offset-2 border-oranzovy hide okruhle_rohy text-center" id="new_employee_form">
                   <div class="col-xs-11 col-sm-11 col-md-11 col-lg-11">
                       <p style="font-weight: bold">&nbsp&nbsp&nbsp&nbsp Add new employee form</p>
                  </div>
                  <div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
                      <span class="cervena glyphicon glyphicon-remove" id="close-ew-employee-widndow"></span>
                  </div>                  
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                  <br>
                   <form role="form" action="${request.route_path('add_employee')}" method="POST">
                      <div class="form-group">
                        <label for="name">Name</label>
                        <input  name="name" class="form-control"  placeholder="Name">
                      </div>
                       <div class="form-group">
                        <label for="surname">Surname</label>
                        <input name="surname" class="form-control"  placeholder="Surname">
                      </div>
                       <div class="form-group">
                        <label for="age">Age</label>
                        <input name="age" class="form-control"  placeholder="Age" id="age_employee">
                      </div>  
                        <div class="form-group">
                        <label for="addresse">Addresse</label>
                        <input name="addresse" class="form-control"  placeholder="Addresse" id="age_employee">
                      </div>  
                      <label for="age">Marital status</label>
                      <select name="merital_status" class="form-control">
                        <option>Single</option>
                        <option>Married</option>
                      </select>
                      <label for="age">Sex</label>
                      <select name="sex" class="form-control" >
                        <option>Male</option>
                        <option>Female</option>
                      </select>
                       <label for="age">Positions (you can add new position in Customize)</label>
                        <select name="position" class="form-control" >
                <!--              <option>Undefined</option> -->
                            % for position in positions:
                             <option> ${position.name}</option>
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
            <div class="row">
             <!--  row nad listom empolye tj vyhldavanie + filtrovanie -->
               <div class="col-md-7 ">
                <br>
                  <div class="input-group">
                    <span class="input-group-addon">Search</span>
                    <input id="meno" type="text" class="form-control" placeholder="Username">
                  </div>
                 </div>
                  <div class="col-md-5">
                            <br>
                           <button type="button" class="btn btn-default" id="want_new_user">
                                <span class="glyphicon glyphicon-plus oranzova"> </span>&nbsp
                               <span style="font-size: 1em"> Add new employee</span>
                            </button>
              <!-- form na pridanie noveho usra -->
                 </div>
              </div>


            <div class="row">
                <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3 ">
                  <br>
                      <button type="button" class="btn btn-default" id="select-all">
                            Select all
                      </button>
                       <button type="button" class="btn btn-default" id="unselect-all">
                            Unselect all
                      </button>
                    </div>
                <div class="col-md-9">
                      
                     <ul class="pagination">  
                         <li class="active"><a class="pozicie" href="#">All</a></li>
                         % for position in positions:
                              <li><a class="pozicie" href="#">${position.name}</a></li>
                         % endfor
                      </ul>
                 </div>
              </div>
                  <div class="row">
                    
                    <div class="option-menu hide col-xs-12 col-sm-7 col-md-12 col-lg-7  ">
                        <!-- <span class="glyphicon  glyphicon-cog oranzova"></span>&nbsp -->
                        <button type="button" class="btn btn-success" id="check-in-selected">
                              Check in selected
                        </button>
                         <button type="button" class="btn btn-danger" id="check-out-selected">
                              Check out selected

                        </button>
                        <input type="email" class="" id="check-out-selected-value" placeholder="with value">

                    </div>

                  </div>
                


            <table class="table table-hover">
        <thead>
          <tr>
            <th></th>
            <th>#</th>
            
              <th>Name</th>
              <th>Position</th>
               <th>Options</th>
           
          </tr>
        </thead>
        <tbody>
            % if employees==[]:
              
                <span class="red" id = "no_employee">
                  You have no employee, you can add new above.
                </span>
          % endif

            <% index = 0 %>
            % for employee in employees:
              <% index += 1 %>
                <tr>
                     <td> <input class="zaskrtnute" value ="${index}" type="checkbox"></td>
                    <td> ${index}</td>
                    <td class="name_of_employee"><a href="${request.route_path('employee', employee_id = employee.id)}" class=""> ${str(employee.name)} ${str(employee.surname)}</a></td>
                    <td class="pozicia">${str(employee.position.name)}</td>
                      % if in_work[index-1] :
                        <td class="is-in"><a href="#"
                         id="${str(employee.id)}" class="check_out"><button type="button" class="btn btn-danger">  Check-out</button></a></td>
                      <td class="value-for-check-out">   <input type="email" class="form-control value" id="performance${str(employee.id)}" placeholder="Value of performance"></td>
                      % else:
                       <td class="is-out"><a href="${request.route_path('checkin', employee_id = employee.id)}"
                        id="${str(employee.id)}" class="check_in"><button type="button" class="btn btn-success">  Check-in &nbsp</button></a></td>
                          <td>  </td>
                      % endif
                </tr>
            % endfor
          
        </tbody>
      </table>



     
      </div><!-- koniec celeho borderu imaginarneho -->
  


</div>

</body>
</html>