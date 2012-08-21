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
					]

			namesCount: @computed () ->
				return @names().length

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

