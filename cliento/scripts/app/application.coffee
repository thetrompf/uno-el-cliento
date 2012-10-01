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
		_popstate: false

		properties: () ->
			url: @observable window.location.pathname
			topmenu: @observable new TopmenuViewModel
				url: @url
			
			viewModel: @observable new ViewModel
				template: () -> null
			
			page:      @observable null
			action:    @observable null
			id:        @observable null

		constructor: () ->
			@initGlobals()
			super
			log 'init Application'
			
			app = @

			@initRouter()
			@bindRouter()

			@topmenu().delegateUrl @url

			@urlHandler()
			@initLinkHandling()

			ko.applyBindings @

		initLinkHandling: () ->
			$('body').delegate 'a[data-href]', 'click', (event) =>
				event.preventDefault()
				url = $(event.currentTarget).data('href');
				@url url
				return false

			window.onpopstate = (event) =>
				# if on the first state, then event.state is null
				# so only do stuff there is something to do
				if event.state?
					@_popstate = true
					@url event.state.path

		urlHandler: () ->
			@url.subscribe (newUrl) =>
				window.history.pushState({path: newUrl}, '', newUrl) unless @_popstate
				@router.setLocation(newUrl)
				@_popstate = false

		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy () ->
				@get '/', () ->
					@app.runRoute 'get', '/home'
				@get '/:page/:action/:id', () ->
					params = @params
					require ["app/#{params.page}/viewmodel"], (ViewModel) ->
						app.viewModel new ViewModel
							page   : app.page
							action : app.action
							id     : app.id
							url    : app.url
						app.page params.page
						app.action params.action
						app.id params.id
				@get '/:page/:action', () ->
					params = @params
					require ["app/#{params.page}/viewmodel"], (ViewModel) ->
						app.viewModel new ViewModel
							page   : app.page
							action : app.action
							id     : app.id
							url    : app.url
						app.page params.page
						app.action params.action
						app.id null
				@get '/:page', () ->
					params = @params
					require ["app/#{params.page}/viewmodel"], (ViewModel) ->
						app.viewModel new ViewModel
							page   : app.page
							action : app.action
							id     : app.id
							url    : app.url
						app.page params.page
						app.action null
						app.id null

		bindRouter: () ->
			log 'bind router'
			@router.run()


		initGlobals: () ->
			window.DEBUG = true
			window.log = () ->
				if window.DEBUG
					console.log arguments...


		getRoute: () ->
			path = window.location.pathname
			return path

	return new Application