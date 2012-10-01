define [
	'knockout'
	'underscore'
], (ko, _) ->
	'use strict'
	class ViewModelBase
		constructor: () ->
			_.extend @, @properties(arguments...)
			_.extend @, @computedProperties(arguments...)

		observable: (val) ->
			return ko.observableArray val if _.isArray val
			return ko.observable val

		computed: (fn, opts = {}) -> ko.computed fn, @, opts

		computedProperties: () -> {}

		properties: () -> {}