$ ->
	socket = io.connect "/socket"
	stamp = (data) ->
		'<i>('+ (new Date data.timestamp).toLocaleTimeString() + ')</i><b style="color:'+data.nick.color+'">'+data.nick.name+'</b>'
	($ '.dice').click ->
		socket.emit 'roll', parseInt ($ this).text()
	($ 'form#login > input[name="color"]').miniColors()
	($ 'form#login').submit ->
		socket.emit 'login',
			name: ($ 'form#login > input[name="name"]').val()
			color: ($ 'form#login > input[name="color"]').val() 
		($ '#header').hide()
		($ '#input').show()
		false
	($ 'form#say').submit ->
		socket.emit 'say', ($ 'form#say > input').val()
		($ 'form#say > input').val("")
		false
	socket.on 'roll', (data) ->
		($ '#chat').append (stamp data) + ' hat mit dem <span>'+data.dice+'</span> eine <span>'+data.result+'</span> gewürfelt.<br/>'
		($ 'body').scrollTop 1000000
	socket.on 'msg', (data) ->
		($ '#chat').append (stamp data) + ': '+data.msg+'<br/>'
		($ 'body').scrollTop 1000000
	socket.on 'nicks', (nicks) ->
		($ '#playerlist').empty()
		($ '#playerlist').append '<b style="color:'+nick.color+'">'+nick.name+'</b><br>' for nick in nicks
