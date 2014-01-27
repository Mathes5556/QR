
prehod_na_stupne = (hodnota) ->  Math.round(hodnota * 30 * 100) / 100     
class Piechart
  constructor: ->     
    alert data = @make_data
    alert option = @set_options
  drawpieChart: -> 
    alert ('som cez')
    one_chart = new google.visualization.PieChart(document.getElementById('piechart'));
    one_chart.draw(data, options);
  make_date: ->
    alert 'lol'    
  set_options: ->
      options = 
          title: 'pomer nalady',
          width: 400,
          height: 400,
          colors:['green','red']
  sprav_ajax_dotaz: (data) ->
      $.ajax 
          type: "POST",
          url: "/jpie/vsetky/vsetky",
          success: @uspesny_ajax(d, data),
          dataType: "json"  
      alert $.ajax ["success"]
      return $.ajax ["success"]
  uspesny_ajax: (data_zo_servra, data_pre_graf) ->
      uspech = (data_zo_servra, data) ->
          data_pre_graf.addColumn('string', 'Nalada');
          data_pre_graf.addColumn('number', 'Sentiment'); 
          data_pre_graf.addRows([['dobré',data_zo_servra.Happy]]); 
          data_pre_graf.addRows([['zle',data_zo_servra.Bad]]);
      return  data_pre_graf
            

pie = new Piechart 







`



function prijmi_text_a_hodnotu(den, zdroj) {
                    /*funckia vypise pozitvne a negativne clanky za jedniltive media a den */
                    /* x_os je den, zdroje je zrdroj */
                    
                    defealt_json_source = "/json_den_clanky/"
                    var url = defealt_json_source.concat(den).concat('/').concat(zdroj)

                    console.log(url)
                    $.ajax({
                          type: "POST",
                          url: url,
                          success: function(d) {
                                                $( ".terminal-poz" ).show();
                                                $( ".terminal-neg" ).show();
                                                $( ".terminal-poz" ).html('')
                                                $( ".terminal-poz" ).append('co zlepsilo naladu v ' + zdroj + '  dna  ' + den)
                                                $( ".terminal-poz" ).append('<br>');
                                                for (var i = 0; i < d.pozitivne.length; i++) {
                                                  
                                                  $( ".terminal-poz" ).append(d.pozitivne[i][1] + '  (');
                                                  $( ".terminal-poz" ).append(prehod_na_stupne(d.pozitivne[i][0]) + '  °C)  ');
                                                  $( ".terminal-poz" ).append('<br>');

                                                }
                                                $( ".terminal-neg" ).append('co zhorsilo naladu v ' + zdroj + '  dna  ' + den)
                                                $( ".terminal-neg" ).append('<br>');
                                                for (var i = 0; i < d.negativne.length; i++) {
                                                 
                                                  $( ".terminal-neg" ).append(d.negativne[i][1] + ' (');
                                                   $( ".terminal-neg" ).append(prehod_na_stupne(d.negativne[i][0]) + ' °C)    ');
                                                  $( ".terminal-neg" ).append('<br>');

                                                }
                                                
                                                
                                              


                                                },
                          dataType: "json"
                          });
                  }
                                     
             

  




      function nakresli_barometer(kategoria, den) {
          google.load('visualization', '1', {packages:['gauge']});
          google.setOnLoadCallback(drawChart2);
        function drawChart2() {
          console.log('barometer');

             var defealt_json_bar = "/jbar/"
                    var url_bar = defealt_json_bar.concat(den).concat('/').concat(kategoria);
                    var hodnota;
                    console.log(url_bar);
                 
                   $.ajax({
                          type: "POST",
                          url: url_bar,
                          success: function(d){
                            console.log('uaaaaaaaaaaaaaaa')
                            
                            hodnota = prehod_na_stupne(d.skore[0])
                            console.log(hodnota)
                                data_pre_bar = google.visualization.arrayToDataTable([
                        ['Label', 'Value'],
                        ['Nalada', hodnota],]);

                      options_bar = {
                        width: 400, height: 250,
                        greenFrom: 0, greenTo: 30,
                        redFrom: -30, redTo: 0,
                        minorTicks: 5,
                        min: -30, max : 30,
                      };

                      barometer = new google.visualization.Gauge(document.getElementById('baromter'));
                      barometer.draw(data_pre_bar, options_bar);
                          },
                          dataType: "json"
                      });


       
              }
      }



        $( "#baromter" ).html('nalada dnešného dňa: <br><br>');
        $( "#baromter" ).append(nakresli_barometer('vsetky', 'vsetky'));  
        $( "#piechart" ).html('nalada dnešného dňa: <br><br>');
         
      poradie_selec_prvkov = [];
      x_os = [];
      y_os = [];
      zdroje = [];
      google.load("visualization", "1", {packages:["corechart", "gauge"]});
      google.setOnLoadCallback(drawChart);


      function drawChart() {
        function prijmi_udaje(odkial, information) {
         var defealt_json_source = "/json/"
          var url = defealt_json_source.concat(odkial)
          console.log(url)
          $.ajax({
              type: "POST",
            url: url,
            success: function(d){
                for (var i = 0; i < d.vysledky.length; i++) {
                                 console.log(d.vysledky[i][0]);
                                x_os.push(d.vysledky[i][0]);
                                y_os.push(d.vysledky[i][1]);
                               
                             }
                             zdroje.push(odkial)
                             console.log(zdroje);
                             console.log(x_os);
                             console.log(y_os);

                if (information === undefined) {
                        console.log('prvy');

                       poradie_selec_prvkov.push(odkial);
                       var data = new google.visualization.DataTable();
                      data.addColumn('string', 'datum');
                        data.addColumn('number', odkial);
                         
                        for (var i = 0; i < d.vysledky.length; i++) {
                                 data.addRow([d.vysledky[i][0], prehod_na_stupne(d.vysledky[i][1])]);
                                
                               
                             }
                        schvaleny = data;

                    } 
              else {
                 /* alert(information.getNumberOfColumns()-1)*/
                          var pole_rozsahu = []
                      for (var k = 1; k <= information.getNumberOfColumns()-1; k++)
                          {
                                 pole_rozsahu.push(k)
                          }
                     /* alert(pole_rozsahu) */
                      
                console.log('2+')
                  var novy  = new google.visualization.DataTable();
                      novy.addColumn('string', 'datum');
                        novy.addColumn('number', odkial);

                  
                          for (var i = 0; i < d.vysledky.length; i++) {
                  

                                   novy.addRow([d.vysledky[i][0], prehod_na_stupne(d.vysledky[i][1])]);
                  
                  
                              }
                       poradie_selec_prvkov.push(odkial);
                       
                       schvaleny = google.visualization.data.join(information, novy, 'full', [[0,0]], pole_rozsahu, [1]);     

              }
               chart.draw(schvaleny, options);
              console.log(schvaleny)
            },
            dataType: "json"
            }); 
          }
         
        prijmi_udaje('vsetky')
        options = {
          title: 'Barometer slovenskeho internetu',
          hAxis: {title: 'Datum'},
          vAxis: {title: 'Nalada'},
          animation: {duration: 1000, easing: 'in',},
          width: 900,
          height: 500,
          pointSize : 10,
          trendlines: {
            0: {
          
            visibleInLegend: true,
            }
        }

          
        };

        chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        
        google.visualization.events.addListener(chart, 'select', selectHandler);
        /* funckiac seleHanlder reaguje na kliknutie jednotliych nodov v grafe */
        function selectHandler() {
                var message;
           
           

 
                console.log(typeof(nakresli_barometer(100)))
                var selection = chart.getSelection();


                  for (var i = 0; i < selection.length; i++) {
                    item = selection[i];
                    if (item.row != null && item.column != null) {
                      message += '{row:' + item.row + ',column:' + item.column + '}';
                    } else if (item.row != null) {
                      message += '{row:' + item.row + '}';
                    } else if (item.column != null) {
                      message += '{column:' + item.column + '}';
                    }
                  }
                  if (message == '') {
                    message = 'nothing';
                  }

                  $( ".terminal-neg" ).html('');
                  $( ".terminal-poz" ).html('')

                     $( ".terminal" ).append(zdroje[item.column])
                  $( ".terminal" ).append('den' +  x_os[item.row]);
                  $( ".terminal" ).append('zdroj' +  zdroje[item.column - 1]);

             
                  /*posielam ajax poziadavku na jedniltivy den + medium

                  x_os[item.row] -> den
                  zdroje[item.column - 1] -> medium
                  */
                  prijmi_text_a_hodnotu(x_os[item.row], zdroje[item.column - 1] );
                  draw_pie(zdroje[item.column - 1], x_os[item.row]);
                  draw_bar(zdroje[item.column - 1], x_os[item.row]);

                  /*console.log(item.row);console.log(item.column);console.log(item.column);console.log(item.column);console.log(item.column);console.log(item.column);*/
                  function draw_pie(kategoria, datum) {
                     var defealt_json_pie = "/jpie/"
                    var url_pie = defealt_json_pie.concat(datum).concat('/').concat(kategoria)

                  console.log('tuto bude pie');
                  console.log(url_pie);
                   var data = new google.visualization.DataTable();
       
                   $.ajax({
                          type: "POST",
                          url: url_pie,
                          success: function(d){
                            console.log(d)
                              data.addColumn('string', 'Nalada');
                        data.addColumn('number', 'Sentiment'); 
                        data.addRows([['dobré',d.Happy]]); 
                              data.addRows([['zle',d.Bad]]);
                              
                              
                              
                            /*  data.setCell(0,1,d.Happy_feed);
                              data.setCell(1,1,d.Bad_feed)*/

                      var options = {
                        title: 'pomer nalady',
                        width: 400, height: 400,
                        colors:['green','red']
                      };
                      console.log('data 4 druhy')
                       var wrapper = new google.visualization.ChartWrapper({
                                     dataTable: data,

                                  chartType: 'PieChart',
                                  containerId: 'piechart',
                                  options: options
                                });
                                wrapper.draw();
                              

                             /* two_chart.draw(data,ops);*/
                          },
                          dataType: "json"
                      });



                  } /*koniec drawPie*/

                      function draw_bar(kategoria, den) {
            /* TODO dokoncit json pozidavku na server(quryy) -> kategoriua  a den uz jsu korektne vvybrane len dokoncit */
                    var defealt_json_bar = "/jbar/"
                    var url_bar = defealt_json_bar.concat(den).concat('/').concat(kategoria);
                   $.ajax({
                          type: "POST",
                          url: url_bar,
                          success: function(d){
                            console.log(d.skore[1])

                            
                                  data_pre_bar = google.visualization.arrayToDataTable([
                                    ['Label', 'Value'],
                                    ['Nalada', prehod_na_stupne(d.skore[1])],
                          
                                      
                                  ]);
                              
                              
                                  options_bar = {
                                    width: 400, height: 250,
                                    greenFrom: 0, greenTo: 30,
                                    redFrom: -30, redTo: 0,
                                    minorTicks: 5,
                                    min: -30, max : 30,
                                  };
                              
                        
                                var barometer = new google.visualization.ChartWrapper({
                                     dataTable: data_pre_bar,

                                  chartType: 'Gauge',
                                  containerId: 'baromter',
                                  options: options_bar
                                });
                                barometer.draw();
                          },
                          dataType: "json"
                      });



               



                              



                  } /*koniec draw_bar*/

                    } /*koniec selectHandler*/

                  


  
             console.log('aaa')
    $("input:checkbox").change(function(){
        if($(this).is(':checked'))
        {
          aktualne_vybraty = this.value;
         console.log(this.value);
         console.log(this.value);
         console.log(this.value);
         console.log(this.value);
         prijmi_udaje(this.value, schvaleny);
     
  
        }
        else
        {  
         /*TODO zistit podporu prehlaiddaoc indexof */
         var mazane_id = poradie_selec_prvkov.indexOf(this.value)
          /*odstrnim z oli ktore potrebujem*/
          poradie_selec_prvkov.splice(mazane_id, 1)
          x_os.splice(mazane_id, 1);
          y_os.splice(mazane_id, 1);
          zdroje.splice(mazane_id, 1);

        schvaleny.removeColumn(mazane_id + 1);
        chart.draw(schvaleny, options);
          

          }
    });



      }`
