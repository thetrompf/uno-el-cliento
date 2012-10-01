define [
	'base/viewmodel'
], (ViewModel) ->
	'use strict'
	class HomeViewModel extends ViewModel

		name: 'home'

		properties: () ->
			pageUrl: '/home'

			names: @observable [
						{
							name: @observable 'erik'
							lastName: @observable 'eriksen'
						}
						{
							name: @observable 'hans'
							lastName: @observable 'hansen'
						}
						{
							name: @observable 'michael'
							lastName: @observable 'michaelsen'
						}
					]


			addName: () ->
				@names.push
					name: @newName()
					lastName: @newLastName()

				@newName ''
				@newLastName ''

			removeName: (name) => @names.remove name

			getTemplate: (it) => @tmpl()

			toggleTemplate: () =>
				@tmpl(if @tmpl() == '/tmpl/person.html' then '/tmpl/person2.html' else '/tmpl/person.html')


			newName: @observable ''
			newLastName: @observable ''

			tmpl: @observable '/tmpl/person.html'

		computedProperties: () ->
			namesCount: @computed () ->
				return @names().length


