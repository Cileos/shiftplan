# FIXME i18n for title
$gimmicks = $('<div></div>')
  .addClass('gimmicks')
  .append(
    $('<a></a>')
      .attr('title', 'Kommentare')
      .text('0')
      .attr('data-remote', true)
  )

Clockwork.buildGimmicks = ($scheduling) ->
  comments_count = $scheduling.data('comments_count')
  url = $scheduling.closest('table').data('new_url').replace(/new$/, "#{$scheduling.data('cid')}/comments")
  $gimmicks.clone()
    .find('a')
      .addClass(if comments_count > 0 then 'comments' else 'no-comments')
      .text(comments_count)
      .attr('href', url)
    .end()
