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

root.insertSolution = (html,target,action,animate) ->
 solution = $(html)
 solution.find('.edit-solution-link').click -> showEditForm('solution',this)
 solution.find('ul.solution-actions').tooltip selector: "a.tip-link"
 if(action == "before" ) 
  solution.insertBefore(target)
 else if(action == "after" )
  solution.insertAfter(target)
 else if(action == "replace" )
  $(target).replaceWith(solution)
 $(solution[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500) if animate

root.insertComment = (html,target,action,animate) ->
 comment = $(html)
 comment.find('.edit-comment-link').click -> showEditForm('comment',this)
 if(action == "before" ) 
  comment.insertBefore(target)
 else if(action == "after" )
  comment.insertAfter(target)
 else if(action == "replace" )
  $(target).replaceWith(comment)
 $(comment[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500) if animate

showEditForm = (type,target) ->
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
 $("#action-button-"+addBtn.data('idea')).hide()
 formDiv = $(type+addBtn.data('idea')).show()
 formDiv.find('a.close').click ->
  closeX = $(this)
  form = closeX.parent()
  form.parent().hide()
  form[0].reset()
  form.prev().remove()
  $("#action-button-"+closeX.data('idea')).show()
 $.scrollTo(formDiv,500,{offset:-100}) if(type == "#add-comment-")

showMore = (target) ->
 $(target).parent().parent().empty().append("<div class='indicator'></div>")

showIndicator = (target) ->
 $(target).empty().append("<div class='indicator'></div>")

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
   showIndicator('#ideas-main')
   activeLinkParam = getActiveLinkParam('#nav-owner-ideas')
   settings.url = settings.url+"&"+(activeLinkParam or= getActiveLinkParam('#nav-topic-ideas'))+"&sort="+$('#ideas-sort-select').val()
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initRightNav = ->
 $('#nav-owner-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   showIndicator('#ideas-main')
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')+"&sort="+$('#ideas-sort-select').val()
   $('#nav-topic-ideas').children().removeClass("active").find("i").removeClass("icon-white")
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))
 $('#nav-topic-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   showIndicator('#ideas-main')
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')+"&sort="+$('#ideas-sort-select').val()
   $('#nav-owner-ideas').children().removeClass("active")
   activeIcon(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initSortSelect = ->
 sortForm = $('#ideas-sort-form')
 $('#ideas-sort-select').change -> sortForm.submit()
 sortForm
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   showIndicator('#ideas-main')
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

initIdea = (html) ->
 fillIdea(html) if html
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.edit-idea-link').click -> showEditIdeaForm(this)
 $('.edit-comment-link').click -> showEditForm('comment',this)
 $('.edit-solution-link').click -> showEditForm('solution',this)
 $('ul.solution-actions').tooltip selector: "a.tip-link"
 $('ul.user-info').tooltip selector: "a[rel=tooltip]"

jQuery ($) ->
 $("a[rel=popover]").popover({template:'<div class="popover"><div class="arrow"></div><div class="popover-inner" style="width:400px"><h3 class="popover-title" style="font-size:13px;text-align:right"></h3><div class="popover-content" style="font-size:13px;"><p></p></div></div></div>'}).click -> $(this).popover('toggle')
 initIdeas() if $('#ideas-main').length > 0
 initIdea() if $('#idea-main').length > 0
 $('#modal-add-idea').on('show', -> $('#add-idea-title-input').val($('#nav-idea-title-input').val()))
 $('#nav-idea-title-input').autocomplete({serviceUrl:'/ideas/promotion',width:400,onSelect :(value, data) -> location.href="/ideas/"+data })
