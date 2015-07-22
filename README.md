About
=====

RealTimeRails gem to make actioncable as simple as a render call.


Purpose
=======

RealTimeRails gem to make actioncable as simple as a render call. This was an idea I had 4 years ago (check out the branch "old_final"). However making rails/websockets/servers/browsers/etc all work together seamlessly was a little too daunting and I didn't have the time for it. Now that actioncable is here I plan on resurrecting my idea by making it so people don't even have to know how actioncable works to enable real time updates for rails models. With most of the hard work done now with actioncable, I just need to write the helpers and hooks that make it possible.


Beta Usage
----------

Add to your Gemfile

`gem "real_time_rails"`

in your models that you want real time updates

`include RealTimeRails::ActiveRecord`

Add this to your application.js file just above require_tree .

`//= require real_time_rails`

then in your view that you want a real time update. At this point partial paths must be full view paths.

`render_real_time partial: '/test/test', locals: {chats: @chats}`

History
----------

New work starts with 0.1.0

---------------------- old_final ------------------------

0.0.73 Added a config file option so the gem can be deployed on a server.

0.0.6 Firefox changed socket name to MozWebSocket, added code to handle this.

0.0.5 Added delete updates

0.0.4 Adding RealTimeRails server executable. start it with "real\_time_rails"