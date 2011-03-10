About
=====

RealTimeRails gem to enable seamless websocket integration with rails.


Purpose
=======

Implement a gem that will add a new render method that sets up a connection to a websocket server and notifies the server it's waiting for updates to content related to the specific partial. 

During an update to an active record object, the websocket server gets a notice from the server to send updates to the connected clients for the content they are listening for.

Ideas
-----

What I know will work

* render :real\_time, :locals => {:users=>@users, :user => @user}, :listen\_for => [{:user => :all}, {:user => @user.id}], :url => {:action => :action\_name, :controller => :controller\_name, :id => @user.id, :other\_param => value}

  This syntax will still likely be included for developers to tweak settings, if not required without being able to accomplish the examples below.

What I'd like to accomplish

* render :real_time => 'partial', :locals => {:user => @user}
	
	This would look at the @user variable, recognize what active record object it is, and listen for updates to that specific record for that object.


* render :real_time => 'partial', :locals => {:users => @users}
	
	This would recognize that @users is an array of User objects, somehow get the query used to determine the list and then listen to any update to any User data to requery the db for the @users list.


* The render :real\_time would wrap the content in a div with a unique id and include javascript needed to open the websocket connection and add a listener.

* Updates sent to the websocket server with on save, on destroy events for active record objects.

*	The gem would also include a server based on em-websocket that can be started with a simple command.

Disclaimer
----------

All source code at this point is to portray ideas to further cooperative design. It is not ready for use nor tested for validity.