define [
	'base/viewmodel'
], (ViewModel) ->
	'use strict'
	class HomeViewModel extends ViewModel

		properties: () ->
			test      : @observable 'bla'
			_template : @observable 'app/home/index.jshtml'
			template  : () => @_template()

		constructor: () ->
			log 'init HomeViewModel'
			super
