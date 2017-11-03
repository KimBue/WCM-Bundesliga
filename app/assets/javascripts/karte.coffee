# Определим свои функции добавления/удаления класса, так как те, что в jQuery не работают для SVG

jQuery.fn.myAddClass = (classTitle) ->
  @each ->
    oldClass = jQuery(this).attr('class')
    oldClass = if oldClass then oldClass else ''
    jQuery(this).attr 'class', (oldClass + ' ' + classTitle).trim()
    return

jQuery.fn.myRemoveClass = (classTitle) ->
  @each ->
    oldClassString = ' ' + jQuery(this).attr('class') + ' '
    newClassString = oldClassString.replace(new RegExp(' ' + classTitle + ' ', 'g'), ' ').trim()
    if !newClassString
      jQuery(this).removeAttr 'class'
    else
      jQuery(this).attr 'class', newClassString
    return

# Начинаем работу когда страница полностью загружена (включая графику)
$(window).load ->
# Получаем доступ к SVG DOM
  svgobject = document.getElementById('imap')
  if 'contentDocument' of svgobject
    svgdom = svgobject.contentDocument
  # Хак для WebKit (чтобы правильно масштабировал нашу карту)
  viewBox = svgdom.rootElement.getAttribute('viewBox').split(' ')
  aspectRatio = viewBox[2] / viewBox[3]
  svgobject.height = parseInt(svgobject.offsetWidth / aspectRatio)
  # Взаимодействие карты и таблички регионов
  $('#lands input[type=checkbox]').change ->
    row = $(this).parent().parent()
    id = row.attr('id')
    if @checked
      row.addClass 'selected'
      $('#' + id, svgdom).myAddClass 'selected'
    else
      row.removeClass 'selected'
      $('#' + id, svgdom).myRemoveClass 'selected'
    return
  # Подсвечиваем регион на карте при наведении мыши на соотв. строку таблицы.
  $('#lands tr').hover (->
    id = $(this).attr('id')
    $('#' + id, svgdom).myAddClass 'highlight'
    return
  ), ->
    id = $(this).attr('id')
    $('#' + id, svgdom).myRemoveClass 'highlight'
    return
  # Подсвечиваем строку в таблице при наведении мыши на соотв. регион на карте
  $(svgdom.getElementsByClassName('land')).hover (->
    id = $(this).attr('id')
    $('#lands #' + id).addClass 'highlight'
    return
  ), ->
    id = $(this).attr('id')
    $('#lands #' + id).removeClass 'highlight'
    return
  # Всплывающие подсказки
  $(svgdom.getElementsByClassName('land')).tooltip
    track: true
    delay: 0
    showURL: false
    fade: 250
    bodyHandler: ->
      id = $(this).attr('id')
      area = $('#lands #' + id + ' td:nth-child(2)').text()
      result = $('<p>').append($('<strong>').text(area))
      $('#lands #' + id + ' td:nth-child(2)').nextAll().each ->
        pos = $(this).prevAll().length + 1
        title = $('#lands thead th:nth-child(' + pos + ')').text()
        value = $(this).text()
        result.append $('<p>').text(title + ': ' + value)
        return
      result
  return

# ---
# generated by js2coffee 2.2.0