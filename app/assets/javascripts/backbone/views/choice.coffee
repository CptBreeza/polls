class App.Views.Choice extends Backbone.View
  tagName: 'div'
  className: "choice",
  template: App.Templates.Choice

  events:
    'click .js-remove-choice': 'removeChoice'

  render: () ->
    @listenTo(@model, 'remove', @remove)

    @$el.html @template(@model.attributes)

    @$title = @$('.title input')
    @$title.change () =>
      @model.set title: @$title.val().trim()

    @$limit = @$('.limit input')
    @$limit.change () =>
      @model.set limit: (parseInt(@$limit.val().trim()) or -1)

    @model.validate = @_validate

    @

  # Events
  removeChoice: (e) ->
    e.stopPropagation()

    @model.collection.remove(@model)

  # Private

  _validate: (attrs, options) =>
    hasError = false
    $title = @$el.children('.title').children('input')
    $limit = @$el.children('.limit').children('input')
    $question = @$el.parent().parent()

    options.complete?()

    if !attrs.title.trim()
      $title.addClass('error')
      hasError = true

    if attrs.limit && !((/^[1-9]+[0-9]*]*$/).test(attrs.limit))
      $limit.addClass('error').attr('placeholder', '限额非法').val('')
      hasError = true

    if hasError
      $question.addClass('error')
      return 'error'
    else
      if $title.hasClass('error')
        $title.removeClass('error')
      if $limit.hasClass('error')
        $limit.removeClass('error')
      return undefined
