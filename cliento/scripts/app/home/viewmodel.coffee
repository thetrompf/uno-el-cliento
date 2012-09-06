define [
	'base/viewmodel'
	], (ViewModel) ->
	'use strict'
	class HomeViewModel extends ViewModel

		properties: () ->
			template: @observable 'app/home/index.jshtml'
			test: @observable 'bla'

		constructor: () ->
			log 'init HomeViewModel'
			super
