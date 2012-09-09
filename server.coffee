express = require 'express'
app = express()
server = (require 'http').createServer app
io = (require 'socket.io').listen server
fs = require 'fs'
coffee = require 'coffee-script'

app.set 'view engine','jade'
app.set 'views', __dirname + '/views'
app.get '/', (req, res) -> 
	res.render 'player'
app.get '/coffee-script/:filename', (req, res) ->
	fs.readFile __dirname+'/public/coffee-script/'+req.params.filename+'.coffee', (err, contents) ->
		res.set 'Content-Type', 'text/javascript'
		res.send coffee.compile contents.toString()
app.use express.static 'public'

get_random = (min, max) ->
	return (Math.floor Math.random() * (1+max-min))+min

socket = io.of('/socket')

nicks = []
update_nicks = ->
	socket.emit 'nicks', nicks

socket.on 'connection', (client) ->
	client.emit 'nicks', nicks
	name = 'Zufälliger Zuschauer'
	client.on 'login', (loginname) ->
		name = loginname
		nicks.push name
		update_nicks()

	client.on 'roll', (dice) ->
		socket.emit 'roll',	
			name: name
			result: get_random(1, dice)
			dice: '1W' + dice
			timestamp: (new Date()).getTime()
	client.on 'say', (text) ->
		socket.emit 'msg', 	
			name: name
			msg: text
			timestamp: (new Date()).getTime()
	client.on 'disconnect', ->
		nicks = (nick for nick in nicks when nick isnt name)
		update_nicks()

server.listen 3000 
console.log 'Listening on port 3000'
