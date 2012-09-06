define [
	'knockout'
	'jquery'
	'sammy'
	'base/viewmodel'
	'app/topmenu/viewmodel'
], (ko, $, Sammy, ViewModel, TopmenuViewModel) ->
	'use strict'
	class Application extends ViewModel

		app = null

		properties: () ->
			url: @observable @getRoute()
			topmenu: @observable new TopmenuViewModel
			page: @observable null

		constructor: () ->
			super
			log 'init Application'
			
			app = @

			@initRouter()
			@bindRouter()

			@urlHandler()
			@initLinkHandling()

			@topmenu().delegateUrl @url

			ko.applyBindings @

		initLinkHandling: () ->
			$('body').delegate 'a[data-href]', 'click', (event) =>
				event.preventDefault()
				@url($(event.currentTarget).data('href'))
				return false

		urlHandler: () ->
			@url.subscribe (newUrl) =>
				@router.setLocation(newUrl)

		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy () ->
				@get '/', () ->
					@app.runRoute 'get', '/home'
				@get '/home', () ->
					require ['app/home/viewmodel'], (VM) ->
						app.page(new VM)
				@get '/todo', () ->
					require ['app/todo/viewmodel'], (VM) ->
						app.page(new VM)

		bindRouter: () ->
			log 'bind router'
			@router.run()

		getRoute: () ->
			path = window.location.pathname
			return path