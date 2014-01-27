

<html>

<head>
   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>


<link href="http://getbootstrap.com/dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<script src="http://getbootstrap.com/dist/js/bootstrap.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

<link href="css/main.css" rel="stylesheet" type="text/css" />
<meta charset=utf-8 />
<title>Joucy solution | solution for your attenadnce system</title>
<script type="text/javascript">
$( document ).ready(function() {


function hoursChart (kam) {
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
            categories: [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35],
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
            data: [32,32,32,32,32,32,26],
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
        /*    vysledok = response.rows[0].elements[0].distance.text;
            console.log(response.rows[0].elements[0].distance.text);*/
            console.log(response.rows[0].elements[0].distance.text)
            $( "#vzdialenost" ).text(response.rows[0].elements[0].distance.text)
    /*        orig.value = response.destinationAddresses[0];
            dest.value = response.originAddresses[0];
            dist.value = response.rows[0].elements[0].distance.text;*/
        } else {
            return 'Error 404';
        }
    }

}
function performanceChart (kam) {
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
            categories: [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35],
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
          //prichody
            data: [95, 90, 97, 85, 64, 95, 94, 92, 93, 91, 98, 96],
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




vyrataj_vzdialenost("Senec", "Bratislava, Kadnarová 20");
pieChart('pie');
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


});
</script>
<style type="text/css">

.list-group-item .active{
  background-color: red;
}
.bold{
  font-weight: bold;
}
.seducka {
  background-color: #eaeaea;
}
.zelena {
  color: #00a810;
}
.cervena {
  color: #ff0000;
}
.cierna {
 background-color: #6a6363
}
.font-velky{
  font-size: 28;
}
.border-sedy{
  border: 1px solid red;
}
.ziadny-padding{
  padding-bottom: 0px;
  padding-top : 0px;
}
.max {
  display: none;
}
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
      <a class="brand" href="#">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img width ="228" src="img/logo2.png"></a>
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

      <div class="col-md-3">
                 <div class="list-group">
             <a class="list-group-item " href="admin.html">
            <div  >
           Dashboard<span class="glyphicon glyphicon-home pull-right"></span>
            </div>
          </a>
           <a class="list-group-item" href="empolyee.html">
          Employess<span class="glyphicon glyphicon-user pull-right"></span>
            </a>
            <a class="list-group-item" href="events.html">
          Events<span class="glyphicon glyphicon-lock pull-right"></span>
            </a>
               <a class="list-group-item" href="stats.html">
          Stats<span class="glyphicon glyphicon-stats pull-right"></span>
            </a>
             <a class="list-group-item" href="stats.html">
          Customize<span class="glyphicon glyphicon-cog pull-right"></span>
            </a>
            
 
          </div>
          <br><br>
           <div class="list-group">

        <a class="list-group-item" href="help.html">
          Help<span class="  glyphicon glyphicon-info-sign pull-right"></span>
            </a>
          </div>
      </div>

       <div class="col-md-9">
                <a href="empolyee.html">
              <span class="seda glyphicon glyphicon-user"></span><h6 class="glyphicon glyphicon-user seda"> all empolyees</h6>
               </a>
               <br>
               <span class="font seda bold">Profile of employee : </span> <span class="font oranzova bold ">Mark Huge</span>
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
                  <span class="bold">Name:</span> Mark Huge
                   <br> 
                 <span class="bold">Sex:</span> Men 
                  <br> 
                 <span class="bold">Age:</span> 21 
                 <br> 
                 <span class="bold">Custum type:</span> #junior #low-sallary   <span class="glyphicon glyphicon-plus oranzova"> </span>
                 <br> 
                 <span class="bold">Residence:</span> Bratislava, Kadnarova 20
                  <br> 
               <span class="bold">Distance from work-place:</span> <span class="oranzova" id="vzdialenost"></span>
                  <br> 
                 <span class="bold">Marital status:</span> Married
                  <br>  <br> 
             
              </div>
              <div class="col-md-4 col-md-offset-1  ">
                <br> 
                  <span class="bold">Position:</span> Picker
                  <br> 
                 <span class="bold">In corporation from:</span> 2009 
                 <br> 
                 <span class="bold">Residence:</span> Bratislava
                  <br> 
                 <span class="bold">Sallary:</span> 700 
                 <br> 
                 <span class="bold">Mobile:</span> +421902XXXXXXXX 
                <br> 
                 <span class="bold">Sallary:</span> example@gmail.com 



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
                        <div id="pie" style="min-width: 110px; height: 400px; margin: 0 auto"></div>
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
                            <td >26</td>
              
                          </tr>
                          <tr>
                          
                            <td >Worked hours this month:</td>
                            <td >120</td>
                         
                          </tr>
                          <tr>
                           
                            <td>Worked hours total:</td>
                            <td >850</td>
                           
                          </tr>
                        </tbody>
                      </table>

         

                   </div>
                   <div class="col-md-6 col-md-offset-0 left-border">
                   <div id="hodiny" style="min-width: 110px; height: 400px; margin: 0 auto"></div>
                        
                   </div>
                </div>
            
             </div>
               

               <div class="panel panel-default tasks">
              <div class="panel-heading">
                <span class="bold">Upcoming tasks</span>
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
                          <tr>
                            <td> 1</td>
                            <td ><a href="#">Daily routine</a></td>
                            <td >12.12.2013</td>
                             <td>8:00 - 16:00</td>
                          </tr>
                          <tr>
                            <td>2</td>
                            <td ><a href="#">Service of car in Petrzalka</a></td>
                            <td >12.12.2013</td>
                            <td> 16:00 - 18:00</td>
                          </tr>
                          <tr>
                            <td>3</td>
                            <td><a href="#">Daily routine</a></td>
                            <td >13.12.2013</td>
                            <td>8:00 - 16:00 </a></td>
                          </tr>
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
                    <img class="img-responsive" src="img/qr.jpg">
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
               </div>
              </div>
           



<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>