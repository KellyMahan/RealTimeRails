About
=====

RealTimeRails gem to enable seamless websocket integration with rails.


Purpose
=======

Implement a gem that will add a new render method that sets up a connection to a websocket server and notifies the server it's waiting for updates to content related to the specific partial. 

During an update to an active record object, the websocket server gets a notice from the server to send updates to the connected clients for the content they are listening for.


Disclaimer
----------

All source code at this point is to portray ideas to further cooperative design. It is not ready for use nor tested for validity.

Beta Usage
----------

The gem is now loading and running correctly in the project. Still some bugs to iron out.

To start the websocket server just run the "real\_time_rails" executable. There is not any configuration options yet, but they should be added soon.

Add to your Gemfile

`gem "real_time_rails"`

in your models that you want real time updates

`include RealTimeRails:AR`

then in your view that you want a real time update. At this point partial paths must be full view paths.

`render_real_time partial: '/test/test', locals: {chats: @chats}`


History
----------

0.0.5 Added delete updates

0.0.4 Adding RealTimeRails server executable. start it with "real\_time_rails"