<%inherit file="default.mako" />

<%block name="page_content">

<div id = 'pozitivne'>
<H1>TOP 10 pozitivnych za den: </H1><br>
   % for clanok in pozitivne:
        ${clanok.title}  <br>

        
      % endfor
    </div>
</div>

    <img  id = 'sipky' src = "${request.static_path('project:static/sipky.gif')}"  width = 200  >

<div id = 'negativne'>
<H1>TOP 10 negativnych za den:</H1>
   % for clanok in negativne: 

        ${clanok.title}  <br>

        
      % endfor
    </div>
</div>
</%block>
