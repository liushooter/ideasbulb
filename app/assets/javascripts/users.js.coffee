appendIdea = (target,idea) ->
 $("<li><a href='/ideas/"+idea.id+"'>"+idea.title+"</a></li>").appendTo(target)

appendIdeas = (target,form,ideas) ->
 appendIdea target,idea for idea in ideas
 $(form).replaceWith('已经全部显示') unless ideas.length > 0

addOffset = (target) ->
 "?offset="+$(target).children().length

jQuery ($) ->
 $("#user-more-ideas")
  .bind("ajax:beforeSend",(evt,xhr,settings) -> settings.url = settings.url+addOffset('#list-ideas'))
  .bind("ajax:success",(evt,data,status,xhr) -> appendIdeas('#list-ideas','#user-more-ideas',$.parseJSON(xhr.responseText)))
 $("#user-more-favor-ideas")
  .bind("ajax:beforeSend",(evt,xhr,settings) -> settings.url = settings.url+addOffset('#list-favor-ideas'))
  .bind("ajax:success",(evt,data,status,xhr) -> appendIdeas('#list-favor-ideas','#user-more-favor-ideas',$.parseJSON(xhr.responseText)))
