require.config
	baseUrl: '/js'
	paths:
		jquery: 'vendor/jquery/jquery-1.7.2'
		knockout: 'vendor/knockout/knockout-2.1.0'
		sammy: 'vendor/sammy/sammy-0.7.1'
		bootstrap: 'vendor/bootstrap/bootstrap-all'

requirejs.config
	shim:
		sammy:
			deps: ['jquery']
			exports: 'Sammy'

require [
	'app/application'
], (Application) ->
	app = new Application
	app.initialize()