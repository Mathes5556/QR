

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


function fromStringToList(string){
  string = string.slice(1,-1);
  var list = []
  var iterate = string.split(',')
  for(i in iterate){
    list.push(parseFloat(iterate[i]));
  }
  return list
}

var pole = [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35];
console.log( typeof pole)
var performances = '${performances}';
performances = fromStringToList(performances);

function hoursChart (kam) {
  var groups_of_week = '${groups_of_week}';
  groups_of_week = fromStringToList(groups_of_week);
  var last_five_weeks = '${last_five_weeks}';
  last_five_weeks = fromStringToList(last_five_weeks);
  console.log(last_five_weeks);
  console.log(groups_of_week);
  
  var chart = new Highcharts.Chart({

   title: {
            style: {
                       color: 'black',
                    },
            text: 'Worked hours per weeks',
                
            },
    chart: {
            type: 'column',
            renderTo: 'hodiny'
        },
        xAxis: {
            categories: last_five_weeks,
             title: {
               style: {
                       color: '#fea312;',
                    },
                text: 'Week'
            },

        },
        yAxis: [{

        
            title: {
              style: {
                       color: '#fea312;',
                    },
                text: 'Hours per week',
                  
            },
            gridLineWidth: 1
        }, {
            title: {
                text: ''
            },
            opposite: true
        }], 
        
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.x +': '+ this.y;
            }
        },
        plotOptions: {
        },
         plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                    }
                }
            },
        series: [{
          //prichody
            data: groups_of_week,
            name: 'Worked hours per week',
            color: '#fea312'

            
        }]

  });

}

  /*prvy chart o prichdooch/odchodoc*/
function vyrataj_vzdialenost(odkial, kam){
    var origin = odkial,
    destination = kam,
    service = new google.maps.DistanceMatrixService();

    service.getDistanceMatrix(
        {
            origins: [origin],
            destinations: [destination],
            travelMode: google.maps.TravelMode.DRIVING,
            avoidHighways: false,
            avoidTolls: false
        }, 
        callback
    );

    function callback(response, status) {

        var orig = document.getElementById("orig"),
            dest = document.getElementById("dest"),
            dist = document.getElementById("vzdialenost");

        if(status=="OK") {
            
            $( "#vzdialenost" ).text(response.rows[0].elements[0].distance.text)
        } else {
            return 'Error 404';
        }
    }

}
function performanceChart (kam) {
  var performances = '${performances}';
  performances = fromStringToList(performances);
  console.log(performances)
  var chart = new Highcharts.Chart({
   title: {
            style: {
                       color: 'black',
                    },
            text: 'Perferomnce of employee',
                
            },
    chart: {
            //alignTicks: false,

            type: 'line',
    renderTo: 'performance'
        },
        xAxis: {
            categories: [],
             title: {
                 style: {
                       color: '#fea312;',
                    },
                text: 'last 9 work'
            },

        },
        yAxis: [{

           
       
         
            title: {
              style: {
                       color: '#fea312;',
                    },
              text: 'Percentage of task',
                  
            },
            gridLineWidth: 1
        }, {
            title: {
                text: ''
            },
            opposite: true
        }], 
        
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    this.x +': '+ this.y;
            }
        },
        plotOptions: {
        },
        series: [{
          //perceta
            data: performances,
            name: 'Arrivals',
            color: '#fea312'

            
        }]

  });

}

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
                      y: 5,
                      sliced: true,
                      selected: true,
                      color: '#fea312'
                  },
                  {
                      name: 'On time',
                      y: 95,
                      color: '#ffdba2'
                  }
              ]
          }]
      });
}


vyrataj_vzdialenost("Senec", '${str(employee.residence)}');
// pieChart('pie');
performanceChart('performance');
hoursChart('hodiny');

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
$( "#toPerformance" ).click(function() {
 $('html, body').animate({scrollTop: $('.performance').offset().top}, 1000);
return false;
});
$( "#toFacts" ).click(function() {
 $('html, body').animate({scrollTop: $('.facts').offset().top}, 2000);
return false;
});
$( "#toTasks" ).click(function() {
 $('html, body').animate({scrollTop: $('.tasks').offset().top}, 2500);
return false;
});
$( "#toQr" ).click(function() {
 $('html, body').animate({scrollTop: $('.qr').offset().top}, 2500);
return false;
});
$( "#toHoliday" ).click(function() {
 $('html, body').animate({scrollTop: $('.holiday').offset().top}, 2500);
return false;
});
$( "#toNote" ).click(function() {
 $('html, body').animate({scrollTop: $('.note').offset().top}, 2500);
return false;
});

/*pri delete hashu tau zminzne a posle requste na vymazani*/
$(document).on('click', '.delete-hash', function() {
    koniec_url = $(this).attr('id');
    var url = 'delete_hash_employee/'+koniec_url;
    console.log(url)
    el = $(this)
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        el.parent().hide()
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
         });

    return false;
      });

 
$( "#add_new_hash_tag" ).click(function() {

   $(this).addClass('hide');
   $('#adding_new_hashtag').removeClass('hide');
   return false;
});

$( "#save_hash_tag" ).click(function() {
   // alert('ok')
    var id = $("#option_hash_tag").val();

   var hash_tag = $("#option_hash_tag option[value="+id+"]").text();
   el = $( "#save_hash_tag" );
   $( "#add_new_hash_tag" ).removeClass('hide');  
       var url = 'add_hash_employee/${employee.id}/'+id;
    $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        if (d.status == "ok"){
          text = '<span><a href="" id="${employee.id}/'+id+'" class="glyphicon glyphicon-minus cervena delete-hash"></a>#';
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

heslo_zamestnanca = '${str(employee.residence)}';

 

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


    
  <%namespace  file="static.mako" import="menu"/>
      <aside>
        <div class="col-md-3">
          ${menu()}      
        </div>
      </aside>

       <div class="col-md-9">
                <a href="empolyee.html">
              <span class="seda glyphicon glyphicon-user"></span><h6 class="glyphicon glyphicon-user seda"> all empolyees</h6>
               </a>
               <br>
               <span class="font seda bold">Profile of employee : </span> <span class="font oranzova bold ">${str(employee.name)} ${str(employee.surname)}</span>
               &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
                 <span class=" ">
                    <a id="toPerformance" href = "#">
                      <span class="glyphicon glyphicon-hand-up oranzova"></span>
                       <span class="seda">Performance</span>
                   </a>
                     &nbsp&nbsp
                      <a id="toFacts" href = "#">
                    <span class="glyphicon glyphicon-hand-up oranzova"></span>
                     <span class="   seda">Facts</span>
                   </a>
                    &nbsp&nbsp
                      <a id="toTasks" href = "#">
                    <span class="glyphicon glyphicon-hand-up oranzova"></span>
                     <span class="   seda">Tasks</span>
                   </a>
                   &nbsp&nbsp
                      <a id="toQr" href = "#">
                    <span class="glyphicon glyphicon-qrcode oranzova"></span>
                     <span class="   seda">QR code</span>
                   </a>
                    &nbsp&nbsp
                      <a id="toHoliday" href = "#">
                    <span class="glyphicon glyphicon-hand-up oranzova"></span>
                     <span class="   seda">Holiday</span>
                   </a>
                     &nbsp&nbsp
                      <a id="toNote" href = "#">
                    <span class="glyphicon glyphicon-hand-up oranzova"></span>
                     <span class="   seda">Note</span>
                   </a>
                 </span>
          <br><br>
          <div class="panel panel-default">
            <div class="panel-heading">
              <span class="bold">Global infomation</span>
              <span class="pull-right ">
                <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
              </span>
            </div>
            
             <div  class="row">
              <div class="col-md-5 col-md-offset-1 right-border ">
                <br> 
                  <span class="bold">Name:</span>${str(employee.name)} ${str(employee.surname)}
                   <br> 
                 <span class="bold">Sex:</span> ${str(employee.sex)}
                  <br> 
                 <span class="bold">Age:</span>${str(employee.age)}
                 <br> 
                 <span class="bold" id="list_of_hash">Custum type:
                    % for hash_tag in hash_tags:
                       <span  > 
                          <a href="" id="${employee.id}/${hash_tag.id}" class="glyphicon glyphicon-minus cervena delete-hash"></a>#${str(hash_tag.name)}&nbsp
                        </span>
                    % endfor
                  </span>

                    <a href="#" class="glyphicon glyphicon-plus oranzova" id="add_new_hash_tag">New</a>
          
                 <br> 
                 <div  class="row hide" id="adding_new_hashtag">
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
                 <span class="bold">Residence:</span> ${str(employee.residence)}
                  <br> 
               <span class="bold">Distance from work-place:</span> <span class="oranzova" id="vzdialenost"></span>
                  <br> 
                 <span class="bold">Marital status:</span> ${str(employee.merital_status)}
                  <br>  <br> 
             
              </div>
              <div class="col-md-4 col-md-offset-1  ">
                <br> 
                  <span class="bold">Position:</span> ${str(employee.position.name)}
                  <br> 
                 <span class="bold">In corporation from:</span> 2009 
                 <br> 
                 <span class="bold">Residence:</span>${str(employee.residence)}
                  <br> 
                 <span class="bold">Sallary:</span> 700 
                 <br> 
                 <span class="bold">Mobile:</span> +421902XXXXXXXX 
                <br> 
                 <span class="bold">Mail:</span> example@gmail.com 



              </div>
             </div>
               </div><!-- koniec celeho borderu imaginarneho -->

<!--              koniec jedneho odstavca(obdlznika) zacaitok druheho  -->

              <!-- grafy -->
              <br>
             <div class="panel panel-default performance">
              <div class="panel-heading">
                <span class="bold">Perferomnce and Quality information</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>

                <div class="row">
                  <div class="col-md-6 col-md-offset-0 right-border ">
                        <div id="hodiny" style="min-width: 110px; height: 400px; margin: 0 auto"></div>
                   </div>
                   <div class="col-md-6 col-md-offset-0 ">
                        <div id="performance" style="min-width: 110px; height: 400px; margin: 0 auto"></div>
                   </div>
                </div>
            
             </div>
                <!-- add task -->
                <br>
             <div class="panel panel-default facts">
              <div class="panel-heading">
                <span class="bold">Facts</span>
                <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
                <div class="row">
                  <div class="col-md-5 col-md-offset-0">
                                  <table class="table table-hover">
               
                        <tbody>
                          <tr>
                     
                            <td >Worked hours this week:</td>
                            <td >${str(groups_of_week[-1])}</td>
              
                          </tr>
                          <tr>
                          
                            <td >Worked hours this month:</td>
                            <td >${str(sum(groups_of_week))}</td>
                         
                          </tr>
                          <tr>
                           
                            <td>Worked hours total:</td>
                            <td >850</td>
                           
                          </tr>
                        </tbody>
                      </table>

         

                   </div>
                   <div class="col-md-6 col-md-offset-0 left-border">
                  
                        
                   </div>
                </div>
            
             </div>
               

               <div class="panel panel-default tasks">
              <div class="panel-heading">
                <span class="bold">Upcoming tasks (zatial vsetky!)</span>
                <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
                <div class="row">
                  <div class="col-md-12">
                    <br> 
                      <table class="table table-hover">
                           <thead>
                              <tr>
                                <th>#</th>
                                
                                  <th>Name of task</th>
                                  <th>Date</th>
                                   <th>Time</th>
                               
                              </tr>
                            </thead>
                        <tbody>
                          <% index = 0 %>
                          % for user_task in user_tasks:
                            <% index += 1 %>
                              <tr>
                                    <td> ${index}</td>
                                    <td ><a href="${request.route_path('event', event_id= user_task.event.id)}">${user_task.event.nazov}</a></td>
                                    <td>  ${str(user_task.event.begin).split(' ')[0]} </td>
                                    <td> 
                                    ${str(user_task.event.begin).split(' ')[1].split(':')[0]}:${str(user_task.event.begin).split(' ')[1].split(':')[1]} -
                                    ${str(user_task.event.end).split(' ')[1].split(':')[0]}:${str(user_task.event.end).split(' ')[1].split(':')[1]} 
                                    </td>
                              </tr>
                          % endfor
                        </tbody>
                      </table>

                   </div>
                  
                </div>
            
             </div>
               
           <br>

             <div class="panel panel-default qr">
              <div class="panel-heading">
                <span class="bold">QR code</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
              <div class="row">
                  <div class="col-md-4 col-md-offset-1">
                      <img class="img-responsive" src="${request.static_path('project:static/jelen.png')}">
                  </div>
                  <div class="col-md-6 col-md-offset-1">
                    <br>
                    <span class="seda">This unique QR code unique and it's can be use for your autentification.</span>
                    <br>
                    <h2><span class="glyphicon glyphicon-print"></span> &nbsp <a href="#">PRINT</a></h2>
                  </div>
                </div>
             </div>

             <br>


             <div class="panel panel-default holiday">
              <div class="panel-heading">
                <span class="bold">Holiday break</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
              <div class="row">
                  <div class="col-md-8 col-md-offset-1">
                     <h2></span> &nbsp No Holiday break on the plane</h2>
                     <br>

                  </div>
               </div>
              </div>
           
           <br>

              <div class="panel panel-default note">
              <div class="panel-heading">
                <span class="bold">Notes</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
              <div class="row">
                  <div class="col-md-12 ">
                     <div class="input-group input-group-lg"  >
                      <span class="input-group-addon"></span>
                      <input type="text" class="form-control" placeholder="Personal employee to employee(employee dont see it)">
                      </div>
                      <br>
                      <button type="button" class="pull-right btn btn-success">Save </button>
                      <br> <br>
                  </div>
                  


                     <br>
                  </div>




              <div class="panel panel-default note">
              <div class="panel-heading">
                <span class="bold">Public url</span>
                 <span class="pull-right ">
                   <a class="glyphicon glyphicon-chevron-up min " href="#"> </a>
                   <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
                 </span>
              </div>
              <div class="row">
                  <div class="col-md-12 ">
                    &nbsp;&nbsp;&nbsp;
                     <a href="http://0.0.0.0:6543/employee-public/${employee.id}">link</a>
                     <br>
                       &nbsp;&nbsp;&nbsp;
                    <strong>password</strong>: ${employee.lock_for_public}
                  
                     <br>
                  </div>
               </div>
              </div>
           



<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>