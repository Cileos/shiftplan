# FIXME i18n for title
$gimmicks = $('<div></div>')
  .addClass('gimmicks')
  .append(
    $('<a></a>')
      .attr('title', 'Kommentare')
      .text('0')
      .attr('data-remote', true)
  )

buildGimmicks = ($scheduling) ->
  comments_count = $scheduling.data('comments_count')
  url = $scheduling.closest('table').data('new_url').replace(/new$/, "#{$scheduling.data('cid')}/comments")
  $gimmicks.clone()
    .find('a')
      .addClass(if comments_count > 0 then 'comments' else 'no-comments')
      .text(comments_count)
      .attr('href', url)
    .end()

Clockwork.appendGimmicks = ($scheduling) ->
  if $scheduling.find('div.gimmicks').length is 0
    $scheduling.append buildGimmicks($scheduling)
