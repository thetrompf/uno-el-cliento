define [
	'base/viewmodel'
	'app/application'
], (ViewModel, app) ->
	class TodoViewModel extends ViewModel

		name: 'todo'

		properties: () ->
			gotoHome: () ->
				app.url('/home')