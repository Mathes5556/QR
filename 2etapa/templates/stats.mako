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

function random_array (dlzka_pola) {
  list = [];
  
  for (var i = 0; i <= dlzka_pola; i++) {
    list.push(Math.round(Math.random()*100))
  };
  return list;
}
function random_array_pie () {
  list = [];
  var prva = Math.round(Math.random()*100)
  var druha = 100-prva;
  list.push(prva, druha);
  return list;
}

function random_hours (dlzka_pola) {
    list = [];
  
  for (var i = 0; i <= dlzka_pola; i++) {
    list.push(random_pod_32())
  };
  return list;
}

function random_pod_32 () {
  var vysledok = Math.round(Math.random()*100);
  if (vysledok < 32){
    return vysledok;
  } 
  else{
    return random_pod_32()
  }
}

console.log(random_hours(8))
console.log(random_array (10))
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
            renderTo: kam
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
          //g2
            data: random_hours(7),
            name: 'Group1',
            color: '#fea312'

            
        },
        {
          //g1
            data: random_hours(7),
            name: 'Group2',
            color: '#ffdba2'

            
        }]

  });

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
          //vykon
            data: random_array (12),
            name: 'Group1',
            color: '#fea312'

            
        },
        {
          //vykon
            data: random_array (12),
            name: 'Group2',
            color: '#ffdba2'

            
        }]

  });

}

function pieChart(kam) {
  var random_array =  random_array_pie();
  var chart = new Highcharts.Chart({

          chart: {
             renderTo: kam,
   
          },
          title: {
             style: {
                       color: 'black',
                    },
              text: 'Percentage of delay'
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
                      name: 'Group2 ',
                      y: random_array[0],
                      sliced: true,
                      selected: true,
                      color: '#fea312'
                  },
                  {
                      name: 'Group1',
                      y: random_array[1],
                      color: '#ffdba2'
                  }
              ]
          }]
      });
}



pieChart('pie');
/*vyrataj_vzdialenost("Senec", "Bratislava, Kadnarová 20");
*/
performanceChart('performance');
hoursChart('worked-hours');

/*nabindujem vsetky zmeny*/

$( ".zmen" ).click(function() {
  console.log('zmena')
    $( ".zmen" ).each(function( index ) {
       $( this ).removeClass('active');
    });
    $( this ).addClass('active');
    pieChart('pie');
    performanceChart('performance');
    $( "#meno-analizy" ).html($( this ).text())
   
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
               <a class="list-group-item active" href="stats.html">
          Stats<span class="glyphicon glyphicon-stats pull-right"></span>
            </a>
             <a class="list-group-item" href="customize.html">
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
               <br>
               <span class="font oranzova bold ">Statistic  </span>
          
          <br><br>  
          
          <div class="row">
                <div class="col-md-6 right-border">
                  <span class="bold">Default modes:</span><br>
                    <span class="bold">Employee by: </span>
              <button type="button" class="btn btn-default active zmen">Sallary</button>
              <button type="button" class="btn btn-default zmen">Men vs Women</button>
               <button type="button" class="btn btn-default zmen">Age</button>
              <button type="button" class="btn btn-default zmen">Marital status</button>
              <button type="button" class="btn btn-default zmen">Distance from work-place</button>
               <button type="button" class="btn btn-default zmen">Positions</button>
               <button type="button" class="btn btn-default zmen">Performance</button>
             
                 <br> <br>
                
                <span class="bold">Events by: </span>
              <button type="button" class="btn btn-default zmen">Workplace</button>
              <button type="button" class="btn btn-default zmen">Leaders</button>
              <button type="button" class="btn btn-default zmen">Goal achieved(y/n)</button>
               <button type="button" class="btn btn-default zmen">Goal complited(%)</button>
                <button type="button" class="btn btn-default zmen">Marital status</button>
                 </div>
                 <div class="col-md-6">
                  <!--   tu zacinaju custom porovnavacky -->
                  <span class="bold">Custom modes:</span>&nbsp<span class="glyphicon glyphicon-cog oranzova"> </span><br>
                   <span class="bold">Employee by: </span>
              <button type="button" class="btn btn-default zmen">#Juniors vs #Seniors</button>
              <button type="button" class="btn btn-default zmen">#TPP vs #brigada</button>
             
              <br> <br>
              <span class="bold">Events by: </span>
              <button type="button" class="btn btn-default zmen">#Daily vs #Night-time
</button>
              <button type="button" class="btn btn-default zmen">#Rain vs #Snow vs #Sunny</button>
              <button type="button" class="btn btn-default zmen">#Our employee vs #Outsourcing</button>

                 </div>
          </div>

          <br>

<!--   tu zacinaju grafy -->

          <div class="panel panel-default">
            <div class="panel-heading">
              <span class="bold">Analize </span><span class="oranzova" id="meno-analizy"></span>
              <span class="pull-right ">
                <a class="glyphicon glyphicon-chevron-up min" href="#"> </a>
                <a class="glyphicon glyphicon-chevron-down max" href="#"> </a>
              </span>
            </div>
            
             <div  class="row">
                  <div class="col-md-6  right-border ">
                   <div id="pie" style="min-width: 110px; height: 400px; margin: 0 auto"></div>   <br>
                    <div id="worked-hours" style="min-width: 110px; height: 400px; margin: 0 auto"></div>    
                 </div>
                 <div class="col-md-6   ">
                   <div id="performance" style="min-width: 110px; height: 400px; margin: 0 auto"></div>     
                 </div>
                </div>
            
             </div>
               



      
           
        

<br> <br> <br> <br> <br> <br> <br> <br> <br> 
      


</div>

</body>
</html>