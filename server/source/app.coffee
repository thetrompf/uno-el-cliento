express = require 'express'

app = express.createServer()

#Configuration
app.configure () ->
  app.set 'views', __dirname + '/../../public/scripts/app'
  app.set 'view engine', 'jshtml'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
  	secret: 'D#$JOr38ad&$29'
  app.use app.router
  app.use express.static __dirname + '/../../public'

app.configure 'development', () ->
  app.use express.errorHandler
  	dumpExceptions: true
  	showStack: true

app.configure 'production', () ->
  app.use express.errorHandler()

#Routes
app.get /^\/((?!rest)(?!scripts)(?!styles)(?!images).)*$/, (req, res, next) ->
	res.render 'home/index'



app.listen 8080, () ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
