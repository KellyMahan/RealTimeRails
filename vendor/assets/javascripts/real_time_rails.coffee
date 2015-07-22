#= require cable

@App = {}
App.cable = Cable.createConsumer 'ws://127.0.0.1:28080'

App.messages = App.cable.subscriptions.create 'RealTimeRailsChannel',
  received: (data) ->
    alert(JSON.stringify(data))