# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#
#

$ ->
  $photo_cb = $('#photos_cb')
  $mutual_friend_cb = $('#mutual_friends_cb')
  $group_cb = $('#groups_cb')
  $like_cb = $('#likes_cb')
  $event_cb = $('#events_cb')
 
  $photo = $('#photos')
  $mutual_friend = $('#mutual_friends')
  $group = $('#groups')
  $like = $('#likes')
  $event = $('#events')
 
  checkbox = [$photo_cb,$mutual_friend_cb,$group_cb,$like_cb,$event_cb]
  div = [$photo,$mutual_friend,$group,$like,$event]
  $.each checkbox, (index) ->
    $(this).on "click", (event) ->
      $.each div, (index) ->
        $(this).addClass("hide")
      $.each checkbox,(xbox) ->
        if $(this).is ":checked"
          div[xbox].removeClass("hide")

