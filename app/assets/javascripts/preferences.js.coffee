authorityUserForm = (id,admin) ->
 $("#admin").val(admin)
 $('#authority-user-form').attr("action","/users/"+id+"/authority").submit()

jQuery ($) ->
 $('.admin_radio_yes').change -> authorityUserForm(this.value,true)
 $('.admin_radio_no').change -> authorityUserForm(this.value,false)
