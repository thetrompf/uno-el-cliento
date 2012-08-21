require.config
	baseUrl: '/js'
	paths:
		jquery: 'vendor/jquery/jquery-1.7.2'
		'jquery-ui': 'vendor/jquery/jquery-ui-1.8.23.custom'
		knockout: 'ext/knockout/knockout'
		'stock-knockout': 'vendor/knockout/knockout-2.1.0'
		sammy: 'vendor/sammy/sammy-0.7.1'
		bootstrap: 'vendor/bootstrap/bootstrap-all'
		text: 'vendor/require/require-text'
		underscore: 'vendor/underscore/underscore'

requirejs.config
	shim:
		sammy:
			deps: ['jquery']
			exports: 'Sammy'
		underscore:
			exports: '_'
require [
	'app/application'
], (Application) ->
	Application.initialize()