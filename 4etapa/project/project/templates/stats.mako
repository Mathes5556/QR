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


function hoursChart (kam, last_weeks, hours_group1, hours_group2) {
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
            categories: last_weeks,
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
                text: 'Hours peer week',
                  
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
            data: hours_group1,
            name: 'Group1',
            color: '#fea312'

            
        },
        {
          //g1
            data: hours_group2,
            name: 'Group2',
            color: '#ffdba2'

            
        }]

  });

}



function performanceChart (kam, last_weeks, performance1, performance2) {
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
            categories: last_weeks,
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
            data: performance1,
            name: 'Group1',
            color: '#fea312'

            
        },
        {
          //vykon
            data: performance2,
            name: 'Group2',
            color: '#ffdba2'

            
        }]

  });

}

function pieChart(kam, delayed1, delayed2) {
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
                      name: 'Delayed group 1',
                      y: delayed1,
                      sliced: true,
                      selected: true,
                      color: '#fea312'
                  },
                  {
                      name: 'Delayed group 2',
                      y: delayed2,
                      color: '#ffdba2'
                  }
              ]
          }]
      });
}



// pieChart('pie');
/*vyrataj_vzdialenost("Senec", "Bratislava, Kadnarová 20");
*/
// performanceChart('performance');


/*nabindujem vsetky zmeny*/
$( ".zmen" ).click(function() {
  // url ulzena v id elemtoch.. blee
  var url = $(this).attr('id');

   $.ajax({
      type: "GET",
      url: url,
      success: function(d){
        console.log(d);
        performanceChart('performance', d.last_five_weeks, d.weeks_of_performance[1], d.weeks_of_performance[2]);
        hoursChart('worked-hours', d.last_five_weeks, d.weeks_for_hour[1], d.weeks_for_hour[2]);
        //piechart iba stats evetnts..
        if(d.delay){
          $('#pie').removeClass('hidden');
          console.log(d.delay[1][1], d.delay[2][1]);
          pieChart('pie', d.delay[1][1], d.delay[2][1]);
        }
        else{
          // not show pe cahrt of delay..
          $('#pie').addClass('hidden');
        }
      },
      failure: function(errMsg) {
                alert(errMsg);
            },
       dataType: 'json'
       });

  
    $( ".zmen" ).each(function( index ) {
       $( this ).removeClass('active');
    });
    $( this ).addClass('active');
    
    // performanceChart('performance');
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
     <%namespace  file="static.mako" import="menu"/>

      <div class="col-md-3">
              
          ${menu(part = 'stats')}      


 
          
      </div>

       <div class="col-md-9">
               <br>
               <span class="font oranzova bold ">Statistic  </span>
          
          <br><br>  
          
          <div class="row">
              <!--   <div class="col-md-6 right-border">
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
                 </div> -->
                 <div class="col-md-6">
                  <!--   tu zacinaju custom porovnavacky -->
                  <span class="bold">Custom modes:</span>&nbsp<span class="glyphicon glyphicon-cog oranzova"> </span><br>
                   <span class="bold">Employee by: </span>
                    % for comparison in comparisons:
                         <button type="button" class="btn btn-default zmen" 
                                 id="comparison_employee/${comparison.comp_1_id}/${comparison.comp_2_id}">
                            #${ comparison.comp1.name} vs #${comparison.comp2.name} 
                         </button>
                    % endfor

              <br> <br>
              <span class="bold">Events by: </span>
                % for comparison in comparisons_event:
                         <button type="button" class="btn btn-default zmen"
                          id="comparison_events/${comparison.comp_1_id}/${comparison.comp_2_id}">
                            #${comparison.comp1.name}  vs #${comparison.comp2.name} 
                       
                         </button>
                % endfor
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
                   <div id="worked-hours" style="min-width: 110px; height: 400px; margin: 0 auto"></div>   <br>
                    <div id="pie" style="min-width: 110px; height: 400px; margin: 0 auto"></div>    
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