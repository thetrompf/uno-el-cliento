define [
	'knockout'
	'jquery'
	'sammy'
	'base/viewmodel'
], (ko, $, Sammy, ViewModel) ->
	'use strict'
	class Application extends ViewModel

		properties: () ->

			editor1: @observable null

			activeEditor1: @computed () -> @editor1()?.name
			homeActive: @computed () ->
				@activeEditor1() == 'home'
			todoActive: @computed () ->
				@activeEditor1() == 'todo'


			url: @observable @getRoute()

		initialize: () ->

			console.log 'init Application'

			@initRouter()

			ko.applyBindings @

			@url.subscribe (value) =>
				if @router.getLocation() != value
					@router.setLocation value

			@router.run()
			@router.bind 'location-changed', () =>
				@url @router.getLocation()


		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy () ->
				@get '/', () =>
					@runRoute 'get', '/home'
				@get '/home', () =>
					require ['app/home/view_model'], (VM) ->
						self.editor1(new VM)
				@get '/todos', () =>
					require ['app/todo/view_model'], (VM) ->
						self.editor1(new VM)

		getRoute: () ->
			path = window.location.pathname
			return path

	return new Application