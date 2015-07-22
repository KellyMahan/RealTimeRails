#= require cable

@App = {}
App.cable = Cable.createConsumer 'ws://127.0.0.1:28080'

App.messages = App.cable.subscriptions.create 'RealTimeRailsChannel',
  received: (data) ->
    #alert(JSON.stringify(data))
    action = data.action
    classname = data.classname
    objid = data.objectid
    single_objs_to_update = $(".real_time_wrapper[data-real-time-name$='"+classname+"'][data-real-time-type$='single'][data-real-time-ids$='"+objid+"']")
    array_objs_to_update = $(".real_time_wrapper[data-real-time-name$='"+classname+"'][data-real-time-type$='array']")
      .filter ->
        $(this).attr("data-real-time-ids").match(new RegExp("(^"+objid+"$|^"+objid+",|,"+objid+"$|,"+objid+",)"))
    rel_objs_to_update = $(".real_time_wrapper[data-real-time-name$='"+classname+"'][data-real-time-type$='relation']")
      
          
    console.log([action,classname,objid])
    console.log(single_objs_to_update)
    console.log(array_objs_to_update)
    console.log(rel_objs_to_update)
    
    all_updates = single_objs_to_update.add(array_objs_to_update)
    all_updates = all_updates.add(rel_objs_to_update)
    
    $.each all_updates, (index,value) ->
      console.log(value)
      $.ajax
        url: "/real_time_rails",
        data:{"id":$(value).attr("id")},
        type: 'GET',
        success: (data) ->
          $(value).html(data)
    true