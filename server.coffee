express = require 'express'

app = module.exports = express.createServer()

app.configure () ->
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser()
	app.use express.session
		secret: '&8d@dsg562#nv+='
	app.set 'view engine', 'html'
	app.set 'views', __dirname + '/public/tmpl'
	app.set 'view options', layout: false
	app.use express.static __dirname + '/public'
	app.register '.html',
		compile: (str, options) ->
			return (locals) ->
				return str

app.configure 'development', () ->
	app.use express.errorHandler
		dumpExceptions: true
		showStack: true

app.configure 'production', () ->
	app.use express.errorHandler()

app.get '/', (req,res) ->
	res.render 'index.html'

app.listen 8080, () ->
	console.log "Express server listen on port %d in %s mode", app.address().port, app.settings.env