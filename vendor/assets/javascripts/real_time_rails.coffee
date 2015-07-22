#= require cable

@RealTimerails = {}
RealTimerails.cable = Cable.createConsumer 'ws://127.0.0.1:28080'

RealTimerails.messages = RealTimerails.cable.subscriptions.create 'RealTimeRailsChannel',
  received: (data) ->
    alert(JSON.stringify(data))