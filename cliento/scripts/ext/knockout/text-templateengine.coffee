define ['stock-knockout', 'ext/knockout/text-templatesource'], (ko, tts) ->
	TextTemplateEngine = () ->
		engine = new ko.nativeTemplateEngine()

		engine.tts = tts

		engine.makeTemplateSource = (template, bindingContext, options) ->
			if (typeof template) == 'string'
				elem = document.getElementById(template)
				if elem?
					return new ko.templateSources.domElement elem
				else
					tmplSource = engine.tts::templates[template]
					unless tmplSource?
						tmplSource = new engine.tts(template, options)

					return tmplSource
			else if (template.nodeType == 1) || (template.nodeType == 8)
				# Anonymous template
				return new ko.templateSources.anonymousTemplate(template)

		engine.renderTemplate = (template, bindingContext, options) ->
			tmplSource = engine.makeTemplateSource template, bindingContext, options

			return engine.renderTemplateSource(tmplSource, bindingContext, options)

		return engine

	engine = new TextTemplateEngine

	console.log "Setting template engine!"
	ko.setTemplateEngine(engine)

	return null