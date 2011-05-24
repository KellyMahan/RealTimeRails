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

So far i haven't tested this code as a gem, but it did work in a sample project. I'll be testing and tweaking soon.

To start the websocket server just run the websocket_server.rb ruby script.

in your models that you want real time updates

`include RealTimeRails:AR`

then in your view that you want a real time update. At this point partial paths must be full view paths.

`render_real_time partial: '/test/test', locals: {chats: @chats}`

I still have a lot of debugging stuff in the view and javascript wrapper so ignore those for now.
