$ ->
	socket = io.connect "/socket"
	stamp = (data) ->
		'<i>('+ (new Date data.timestamp).toLocaleTimeString() + ')</i> <b>'+data.name+'</b>'
	($ '.dice').click ->
		socket.emit 'roll', parseInt ($ this).text()
	($ 'form#login').submit ->
		socket.emit 'login', ($ 'form#login > input').val()
		($ '#header').hide()
		($ '#input').show()
		false
	($ 'form#say').submit ->
		socket.emit 'say', ($ 'form#say > input').val()
		($ 'form#say > input').val("")
		false
	socket.on 'roll', (data) ->
		($ '#chat').append (stamp data) + ' hat mit dem <span>'+data.dice+'</span> eine <span>'+data.result+'</span> gewürfelt.<br/>'
		($ '#chat').scrollTop 1000000
	socket.on 'msg', (data) ->
		($ '#chat').append (stamp data) + ': '+data.msg+'<br/>'
		($ '#chat').scrollTop 1000000
	socket.on 'nicks', (nicks) ->
		($ '#playerlist').empty()
		($ '#playerlist').append nick + '<br>' for nick in nicks
