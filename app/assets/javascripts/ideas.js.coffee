root = exports ? this
root.showEditIdeaForm = (target) ->
 editLink = $(target)
 $("#idea-"+editLink.data('idea')).hide()
 $("#edit-idea-"+editLink.data('idea')).show().find('a.close').click ->
  closeX = $(this)
  form = closeX.parent()
  form.parent().parent().hide()
  form.prev().remove()
  $("#idea-"+closeX.data('idea')).show()

root.showEditForm = (type,target) ->
 editLink = $(target)
 $("#"+type+"-"+editLink.data(type)).hide()
 $("#edit-"+type+"-"+editLink.data(type)).show().find('a.close').click ->
  closeX = $(this)
  form = closeX.parent()
  form.parent().parent().hide()
  form.prev().remove()
  $("#"+type+"-"+closeX.data(type)).show()

showForm = (type,target) ->
 addBtn = $(target)
 addBtn.parent().parent().hide()
 $(type+addBtn.data('idea')).show().find('a.close').click ->
  closeX = $(this)
  form = closeX.parent()
  form.parent().hide()
  form[0].reset()
  form.prev().remove()
  $("#action-button-"+closeX.data('idea')).show()

showMore = (target) ->
 link = $(target)
 more = link.data("more")
 row=link.parent().parent()
 row.prev().remove()
 current = row.next()
 for i in [1..more]
  do ->
   current.show('blind','','fast')
   current=current.next()
 row.remove()

active = (target) -> $(target).parent().addClass("active").siblings().removeClass("active")
activeIcon = (target) ->
 li = $(target).parent().addClass("active")
 li.siblings().removeClass("active").find("i").removeClass("icon-white")
 li.find("i").addClass("icon-white")

getActiveLinkParam = (id) ->
 url=$(id).children(".active").find("a").attr("href")
 url.substring(url.indexOf("?")+1) if url

fillIdeas = (html) -> $("#ideas-main").html(html)
fillIdea = (html) -> $("#idea-main").html(html)

initStatusTab = ->
 $('#nav-status a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   activeLinkParam = getActiveLinkParam('#nav-owner-ideas')
   settings.url = settings.url+"&"+(activeLinkParam or= getActiveLinkParam('#nav-topic-ideas'))+"&sort="+$('#ideas-sort-select').val()
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initRightNav = ->
 $('#nav-owner-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')+"&sort="+$('#ideas-sort-select').val()
   $('#nav-topic-ideas').children().removeClass("active").find("i").removeClass("icon-white")
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))
 $('#nav-topic-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')+"&sort="+$('#ideas-sort-select').val()
   $('#nav-owner-ideas').children().removeClass("active")
   activeIcon(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initSortSelect = ->
 sortForm = $('#ideas-sort-form')
 $('#ideas-sort-select').change -> sortForm.submit()
 sortForm
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')
   activeLinkParam = getActiveLinkParam('#nav-owner-ideas')
   settings.url = settings.url+"&"+(activeLinkParam or= getActiveLinkParam('#nav-topic-ideas')))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initIdeas = (html) ->
 if html
  fillIdeas(html)
 else
  initStatusTab()
  initRightNav()
  initSortSelect()
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.show-more > a').click -> showMore(this)
 $('.edit-idea-link').click -> showEditIdeaForm(this)
 $('.edit-comment-link').click -> showEditForm('comment',this)
 $('.edit-solution-link').click -> showEditForm('solution',this)
 $('#ideas-pagination li:not(.disabled,.active) a').attr('data-remote','true').bind('ajax:complete',(evt, xhr, status) -> initIdeas(xhr.responseText))
 $('ul.solution-actions').tooltip selector: "a.tip-link"
 $('ul.user-info').tooltip selector: "a[rel=tooltip]"

pickSolution = (target) ->
 checkbox = $(target)
 if checkbox.attr("checked")
  checkbox.parent().parent().parent().parent().addClass("pick").prev().addClass("pick")
 else
  checkbox.parent().parent().parent().parent().removeClass("pick").prev().removeClass("pick")

changeLaunchedButtonLink = (target) ->
 link = $(target)
 solutionIds = ''
 $('.solution-pick:checked').each ->
  solutionIds += "&solutionIds[]="+this.value
 link.attr('href',link.attr('href')+solutionIds)

initIdea = (html) ->
 fillIdea(html) if html
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.edit-idea-link').click -> showEditIdeaForm(this)
 $('.edit-comment-link').click -> showEditForm('comment',this)
 $('.edit-solution-link').click -> showEditForm('solution',this)
 $('.solution-pick').change -> pickSolution(this)
 $('#launched-buton').click -> changeLaunchedButtonLink(this)
 $('ul.solution-actions').tooltip selector: "a.tip-link"
 $('ul.user-info').tooltip selector: "a[rel=tooltip]"

jQuery ($) ->
 $("a[rel=popover]").popover({template:'<div class="popover"><div class="arrow"></div><div class="popover-inner" style="width:400px"><h3 class="popover-title" style="font-size:13px;text-align:right"></h3><div class="popover-content" style="font-size:13px;"><p></p></div></div></div>'}).click -> $(this).popover('toggle')
 initIdeas() if $('#ideas-main').length > 0
 initIdea() if $('#idea-main').length > 0
 $('#modal-add-idea').on('show', -> $('#add-idea-title-input').val($('#nav-idea-title-input').val()))
