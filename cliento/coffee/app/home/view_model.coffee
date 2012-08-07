define [
	'knockout'
	'text!/tmpl/persons.html'
	'text!/tmpl/person.html'
], (ko, personsTemplate, personTemplate) ->
	'use strict'
	HomeViewModel = () ->
		model =
			names: ko.observableArray([
				{
					name: 'erik'
					lastName: 'eriksen'
				}
				{
					name: 'hans'
					lastName: 'hansen'
				}
				{
					name: 'michael'
					lastName: 'michaelsen'
				}
			])

			newName: ko.observable('')
			newLastName: ko.observable('')

			selectedTemplate: ko.observable('personTemplate')

		model.namesCount = ko.computed(() ->
			return @names().length
		, model)

		return (() ->
			@addName = () ->
				@names.push
					name: @newName()
					lastName: @newLastName()

				@newName('')
				@newLastName('')

			@removeName = (name) =>
				@names.remove name

			result = {
				viewModel: @
				templates:
					personTemplate: personTemplate
					template: personsTemplate
			}

			@getTemplate = (person) => @selectedTemplate()

			@changeTemplate = () =>
				require ['text!/tmpl/person2.html'], (tmpl) =>
					result.templates.personTemplate2 = tmpl
					value = if @selectedTemplate() == 'personTemplate' then 'personTemplate2' else 'personTemplate'
					@selectedTemplate(value)

			return result
		).call model