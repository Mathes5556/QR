<html>
  <head>
  	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
       var data = new google.visualization.DataTable();
       
		 $.ajax({
            type: "POST",
            url: "/jpie",
            success: function(d){
            	console.log(d)
                data.addColumn('string', 'Nalada');
  				data.addColumn('number', 'Sentiment'); 
  				data.addRows([['Happy',d.Happy]]); 
                data.addRows([['Bad',d.Bad]]);
                
                one_chart.draw(data, options);
                
                data.setCell(0,1,d.Happy_feed);
                data.setCell(1,1,d.Bad_feed)

                two_chart.draw(data,ops);
            },
            dataType: "json"
        });
              
        var options = {
          title: 'Sentiment of articles',
        };
        var ops = {
          title: 'Sentiment of feedbacks',
        };
        var one_chart = new google.visualization.PieChart(document.getElementById('one_chart_div'));
        one_chart.draw(data, options);
        var two_chart = new google.visualization.PieChart(document.getElementById('two_chart_div'));
        two_chart.draw(data, ops);
      }
    </script>
  </head>
  <body>
  
    <div id="one_chart_div" style="width: 1200px; height: 500px;"></div>
    <div id="two_chart_div" style="width: 1200px; height: 500px;"></div>
  </body>
</html>