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
app.get /^\/((?!rest)(?!scripts)(?!styles)(?!images).)*$/, (req, res) ->
	res.render 'home/index'

app.get '/rest/forum', (req, res) ->
	res.send
		categories: [
			{
				name: 'Test Category 1'
				forums: [
					{
						name: 'Test Forum 1'
						description: 'This is a small description of Test Forum 1'
						topics: 24
						posts: 139
						lastpost:
							date: (new Date().getTime()) / 1000
							profile:
								id: 34
								username: 'thetrompf'
								posts: 11
					}
				]
			}
		]

app.listen 8080, () ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
