      <%def name="menu(part = None)">
      <% active = '' %>
         <div class="list-group">
             % if part   == 'QR':
             <% active = 'active' %>
            % else:
              <% active = 'non-active' %>
            % endif
             <a class="list-group-item  ${active}" href="${request.route_path('qr-checker')}">
            <div  >
           QR-checker<span class="glyphicon glyphicon-home pull-right"></span>
            </div>
          </a>

            % if part   == 'employees':
             <% active = 'active' %>
            % else:
              <% active = 'non-active' %>
            % endif
           <a class="list-group-item ${active}" href="${request.route_path('employees')}">
          Employess<span class="glyphicon glyphicon-user pull-right"></span>
            </a>

            % if part   == 'events':
             <% active = 'active' %>
            % else:
              <% active = 'non-active' %>
            % endif
            <a class="list-group-item  ${active}" href="${request.route_path('events')}">
          Events<span class="glyphicon glyphicon-lock pull-right"></span>
            </a>

             % if part   == 'stats':
             <% active = 'active' %>
            % else:
              <% active = 'non-active' %>
            % endif
           <a class="list-group-item  ${active}"  href="${request.route_path('stats')}">
          Stats<span class="glyphicon glyphicon-stats pull-right"></span>
            </a>

            % if part   == 'customize':
             <% active = 'active' %>
            % else:
              <% active = 'non-active' %>
            % endif
             <a class="list-group-item  ${active}" href="${request.route_path('customize')}">
          Customize<span class="glyphicon glyphicon-cog pull-right"></span>
            </a>
            
 
          </div>
          <br><br>
           <div class="list-group">

        <a class="list-group-item " href="help.html">
          Help<span class="  glyphicon glyphicon-info-sign pull-right"></span>
            </a>
          </div>
      </%def>