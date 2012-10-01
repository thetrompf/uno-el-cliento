define [
	'stock-knockout'
], (ko) ->
	class TextTemplateSource

		templates: {}

		constructor: (@name, options) ->
			defaultOptions =
				loadingTemplate: null
			@options = ko.utils.extend defaultOptions, options
			@templateLoaded = ko.observable(false)
			@templateLoaded()
			@templateLoading = false
			@templateSource = ko.observable ''

			if @options.loadingTemplate?
				unless TextTemplateSource::templates[@options.loadingTemplate]?
					TextTemplateSource::templates[@options.loadingTemplate] = new TextTemplateSource @options.loadingTemplate

			@template = ko.computed (() ->
					if @templateLoaded()
						@templateSource()
					else if @options.loadingTemplate?
						TextTemplateSource::templates[@options.loadingTemplate].template()
					else
						@templateSource()
				), @

			TextTemplateSource::templates[@name] = @

			@template.data = {}

		data: (key, value) ->
			if arguments.length == 1
				if key == 'precompiled'
					@template()
				else
					@template.data[key]
			else
				@template.data[key] = value

		text: () ->
			if !@templateLoaded() && !@templateLoading
				@getTemplate()

			@template()

		getTemplate: () ->
			@templateLoading = true
			require ['text!'+@name], (txt) =>
				@data('precompiled', null)
				@templateSource(txt)
				@templateLoading = false
				@templateLoaded(true)
	window.tts = TextTemplateSource