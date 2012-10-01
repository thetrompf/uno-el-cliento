define [
	'base/viewmodel'
], (ViewModel) ->
	'use strict'
	class TodoViewModel extends ViewModel

		properties: () ->
			_template : @observable 'app/todo/index.jshtml'
			template  : () => @_template()

		constructor: () ->
			super
			log 'init TodoViewModel'