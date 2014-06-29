<html>


  <head>
    <link rel="stylesheet" type="text/css" href="${request.static_path('project:static/zaklad.css')}">
 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
    
    
    alert('aaa')
        $.ajax({
            type: "POST",
            url: "/jpie/vsetky/vsetky",
            success: function(d){
              alert(d)
            
        });
    function ukaz_text() {

      $("#zadaj_text").show("slow");
      $("#polohoha_textu").hide("slow");

    }
        function prehod_na_stupne(hodnota){
        return (Math.round(hodnota * 30 * 100) / 100);
      }    
      function nakresli_piechart(pocet_kladnych, pocet_zapornych){
        console.log('kreslim pieeeeeeeeeeeeeeeeeeeeeeeeeee');
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawpieChart);
      function drawpieChart() {
       var data = new google.visualization.DataTable();
       
     $.ajax({
            type: "POST",
            url: "/jpie/vsetky/vsetky",
            success: function(d){
              console.log(d)
                data.addColumn('string', 'Nalada');
          data.addColumn('number', 'Sentiment'); 
          data.addRows([['dobré', pocet_kladnych]]); 
                data.addRows([['zle', pocet_zapornych]]);
                
                one_chart.draw(data, options);
                
             /*   data.setCell(0,1,d.Happy_feed);
                data.setCell(1,1,d.Bad_feed)*/

               /* two_chart.draw(data,ops);*/
            },
            dataType: "json"
        });
              
        var options = {
          title: 'kladne verzus negativne naladene slova',
          width: 400, height: 400,
          colors:['green','red']
        };
       
        var one_chart = new google.visualization.PieChart(document.getElementById('piechart'));
         console.log('prvy pie')
         console.log(data)
  function selectHandler() 
     {
   var selectedItem = chart.getSelection()[0];

       if (selectedItem) 
       {
         var topping = data.getValue(selectedItem.row, 0);
         alert('The user selected ' + topping);
       }
     } 


    google.visualization.events.addListener(chart, 'select', selectHandler);  
        one_chart.draw(data, options);
        /*var two_chart = new google.visualization.PieChart(document.getElementById('two_chart_div'));
        two_chart.draw(data, ops);*/
      }





      } /*koniec nakrelsi pi chart*/
     function nakresli_barometer(hodnota) {
          google.load('visualization', '1', {packages:['gauge']});
          google.setOnLoadCallback(drawChart2);
        function drawChart2() {
          console.log('barometer');

                                data_pre_bar = google.visualization.arrayToDataTable([
                        ['Label', 'Value'],
                        ['Nalada', hodnota],]);

                      options_bar = {
                        title: 'celková nálada textu',
                        width: 400, height: 250,
                        greenFrom: 0, greenTo: 30,
                        redFrom: -30, redTo: 0,
                        minorTicks: 5,
                        min: -30, max : 30,
                      };

                      barometer = new google.visualization.Gauge(document.getElementById('baromter'));
                      barometer.draw(data_pre_bar, options_bar);
                      


       
              }
      } 
      console.log('juhuuu');


      function nakrelsi_graf(list_kuskov) {

google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
       function drawChart() {
        
      data = new google.visualization.DataTable();
            data.addColumn('number', 'datum');
            data.addColumn('number', 'kolko');
            console.log('tuto zacina graf')
       console.log(list_kuskov[0]);
        console.log(typeof(list_kuskov));
      for (var i = 0; i < list_kuskov.length; i++) {
        console.log(list_kuskov[i]);
        console.log(i);
         data.addRow([i, prehod_na_stupne(list_kuskov[i])]);
       };
              
         
          
                        
        
        options = {
          title: 'Vyvoj nalady po jednotlivych castiach',
          hAxis: {title: 'Časť'},
          vAxis: {title: 'Nálada'},
          animation: {duration: 1000, easing: 'in',},
          width: 900,
          height: 500,
          pointSize : 10,
      
          
        };
chart = new google.visualization.LineChart(document.getElementById('chart_div')); 
 google.visualization.events.addListener(chart, 'select', selectHandler);
 chart.draw(data, options);
       
           

         }
       }
/*$( "#baromter" ).html('nalada dnešného dňa: <br><br>');dsa
        $( "#baromter" ).append(nakresli_barometer(5));  */
 function selectHandler() {
                            var message;
                       
                        

             
                  
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
                           
                       
                            
                            alert(item.row);  

                    }
</script>

<head>

<%block name="page_content">
<div id = 'header'> 
  <div id = 'logo'> <img src = "${request.static_path('project:static/barometer.png')}"  width = 200  ></div>
  <div id = 'menu'> <a href= "${request.route_path('graf')}">Vývoj nalady </a></div>
  <div id = 'menu1'> <a href= "${request.route_path('home')}">Analizér textu </a></div>
    <div id = 'menu2'> <a href= "${request.route_path('home')}"> TOP 10</a></div>

</div>
<div id = "zadaj_text">
<div style="text-align:center">
<form name="text" action="${request.route_path('home')}" method="POST">
<textarea cols="90" rows="15" name="textarea">
% if text:
${text}
% else:
Sem vlož text
% endif
</textarea>
<br />
<input type="radio" name="diac" value="withDiac" 
%if typ == 'withDiac':
 checked="checked" 
%endif
/>s diakritikou
<input type="radio" name="diac" value="withoutDiac" 
%if typ == 'withoutDiac':
 checked="checked" 
%endif
/>bez diakritiky
<input type="radio" name="diac" value="both" 
%if typ == 'both': 
 checked="checked" 
 %endif
  />aj s aj bez diakritiky (?)
<br /><br />
<input type="submit" value="Nájdi sentiment">
<br /><br />
</form>
</div></div>
% if vysledok:
<script type="text/javascript">
$("#zadaj_text").hide();

var hodnota = ${vysledok};
$( "#baromter" ).html('nalada dnešného dňa: <br><br>');
        $( "#baromter" ).append(nakresli_barometer(prehod_na_stupne(hodnota)));  
var list = ${kusky}

nakrelsi_graf(list);
nakresli_piechart(${pocet_kladnych}, ${pocet_zapornych});

</script>
% endif


<div id = "tool_vysledky">
% if vysledok:
<a id ='polohoha_textu' href ='#'  onclick="ukaz_text();return false;" > editovat text</a>
% endif
  <div id = "chart_div"></div>
  <div id = "piechart"></div>
  <div id = 'baromter'></div>

</div>
<div id = 'hlbsia_analiza'>

</div>
</%block>
