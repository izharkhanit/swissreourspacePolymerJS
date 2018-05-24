<@resource.javascript file="/resources/scripts/apps/shared/views/abstract_view.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/views/container_search_view.js" />
<@resource.javascript file="resources/scripts/jquery/jquery.endless-scroll-1.3.js" />
<@resource.template file="/soy/placepicker/placepicker.soy" />
<@resource.javascript file="/resources/scripts/apps/placepicker/views/container_browse_view.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/models/browse_containers_source.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/models/search_containers_source.js"/>
<@resource.javascript file="/resources/scripts/apps/placepicker/models/place_picker_source.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/main.js" />
<@resource.javascript file="/resources/scripts/apps/projectpicker/main.js" />
<@resource.javascript file="/resources/scripts/apps/shared/views/date_picker_view.js" />
<@resource.javascript ajaxOutput="true" />
<#import "/template/global/include/jive-form-elements.ftl" as jiveform/>

<div id="jiveTaskCreateContainer" data-title="<@s.text name="nav.bar.create.heading.task"/>">
    <div id="jive-quicktaskcreate-form">
        <#if success>
            <div class="jive-task-create-success"><strong><@s.text name="task.form.success.message" /></strong></div>
        <#else>

            <#include "/template/global/include/form-message.ftl"/>

            <form method="post" id="jivequicktaskform" name="jivequicktaskform" class="j-form" >
                <@jive.token name="task.create.quick.${user.ID?c}" />

                    <div class="j-form-row">
                        <label for="create-desc-quick">
                            <@s.text name="task.form.description.label.required">
                                <@s.param><span class="required"></@s.param>
                                <@s.param></span></@s.param>
                            </@s.text>
                        </label>
                        <input type="text" id="create-desc-quick" name="subject" class="jive-form-element-text jive-task-create-desc" value="${subject!?html}" aria-required="true" required/>
                        <@macroFieldErrors name="subject"/>
                    </div>
                    <div class="j-form-row">
                        <label for="create-project-quick"><@s.text name="task.form.project.label" /></label>
                        <#assign showPersonal = privateContentConfiguration.isTaskEnabled()>
                        <@jiveform.projectchooser project=project projects=userTrackedProjects id="create-project-quick" showPersonal=showPersonal user=user />
                    </div>
                    <div class="j-form-row ie-zindex-fix">
                        <label for="create-owner-quick"><@s.text name="task.form.owner.label" /></label>
                        <input type="text" name="owner" id="create-owner-quick" class="jive-task-create-owner j-user-autocomplete j-autocomplete-input j-ui-elem" role="combobox" />
                        <@macroFieldErrors name="owner"/>
                    </div>
                    <div class="j-form-row">
                        <label for="create-duedate-quick"><@s.text name="task.form.duedate.label" /></label>
                        <input type="text" id="create-duedate-quick" name="dueDate" />
                        <@macroFieldErrors name="dueDate"/>
                    </div>

                    <div class="j-form-row">
                        <input type="button" id="task-submit-button" name="add" class="j-btn-callout" value="<@s.text name="task.form.add.button" />"/>
                        <input type="button" name="Close" class="close" value="<@s.text name="global.close" />" formnovalidate />
                        <a href="#" onclick="jiveSendToAdvancedTaskForm('<@s.url action="create-task" method="input"/>'); return false;" class="font-color-meta-light"><@s.text name="global.advanced"/></a>
                    </div>
            </form>

            <#include "/template/global/include/jive-macros.ftl" />
            <script type="text/javascript">
                var ownerSynced = true;
                var autocompleteOwner;

                var datePicker = new jive.shared.DatePicker.View({"locale": _jive_locale});
                datePicker.addDatePicker("#create-duedate-quick", new Date());
         // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
                function jiveSubmitQuickTaskForm(url) {
                         var ownerValueArray = $j('#jivequicktaskform').find('[name=owner]').val().split(",");
                         var subject = $j('#jivequicktaskform').find('[name=subject]').val();
                         var project =  $j('#jivequicktaskform').find('[name=project]').val();
                         var dueDate = $j('#jivequicktaskform').find('[name=dueDate]').val();
                         var dateString = dueDate.split('/');
                            dateString = dateString[2] + "-" +dateString[1] +"-"+ dateString[0]
                         dueDate =  dateString + "T22:59:00.000+0000";
                         var JsonData = {
                            "subject" : subject,
                            "project" : project,
                            "dueDate":dueDate,
                            "type" : "task"
                         }
                         if(project>0){
                             url =document.location.origin+ "/api/core/v3/places/" + getPlaceID(project) + "/tasks";
                         } else {
                             url =document.location.origin+ "/api/core/v3/people/" +ownerValueArray + "/tasks";
                         }

                         var jiveQuickTaskFormArray = $j('#jivequicktaskform').serializeArray();

                         $j.each(ownerValueArray,function(eachOwner){
                             JsonData.owner = document.location.origin+"/api/core/v3/people/"+ownerValueArray[eachOwner];
                                $j.ajax({
                                    url: url,
                                    type: "POST",
                                    headers: {
                                        'Accept': 'application/json',
                                        'Content-Type': 'application/json'
                                    },
                                    data: JSON.stringify(JsonData),
                                    success:function(successResponse) {
                                        <#assign taskFormSuccessMessage><@s.text name="task.form.success.message"/></#assign>
                                         $j('<p>${taskFormSuccessMessage?html?js_string}</p>').message();
                                         $j('#jiveTaskCreateContainer').closest('.jive-modal-quickcreate').trigger('close');
                                    },error: function(xhr, ajaxOptions, thrownError) {
                                         var jsonparse = JSON.parse(xhr.responseText);
                                         alert("unable to create tasks due to : " + jsonparse.error.message);
                                    }
                                });
                         });
                    }

                    function getPlaceID(projectid){
                        var placeidUrl=document.location.origin+"/api/core/v3/places?filter=entityDescriptor("+600+","+projectid+")";
                        var placeIDdata = JSON.parse($j.ajax({type: "GET", url: placeidUrl, async: false}).responseText.replace(/^throw [^;]*;/, ''));
                        var placeid=(placeIDdata.list[0].placeID);
                        return placeid;
                    }
           // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
                function jiveSendToAdvancedTaskForm(url) {
                    var form = $j('#jivequicktaskform');
                    var params = $j.param({
                        subject: form.find('[name=subject]').val(),
                        project: form.find('[name=project]').val(),
                        owner: form.find('[name=owner]').val(),
                        dueDate: form.find('[name=dueDate]').val()
                    });
                    parent.location.href = url + (url.match(/\?/) ? '&' : '?') + params;
                }

                $j(function() {
                    $j('#task-submit-button').click(function() {
                        jiveSubmitQuickTaskForm('<@s.url action="create-quick-task"><@s.param name='sr'>cmenu</@s.param></@s.url>');
                        return false;
                    });

                    var startingUsers = <@userAutocompleteUsers user=ownerUser />;
                    var autocompleteOwner = $j('#create-owner-quick');
                    var autocomplete = new jive.UserPicker.Main({
                        startingUsers: startingUsers,
                        multiple:true, // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
                        canInvitePartners: $j("#create-project-quick option:selected").attr("visibletopartner"),
                        disabled: <#if !project??>true<#else>false</#if>,
                        $input : autocompleteOwner
                    });

                    $j("#create-project-quick").change(function(){
                        if($j(this).val() == ""){
                            // set disabled
                            // reset to owner
                            autocomplete.setDisabled(true);
                            autocomplete.reset();
                        }else{
                            // set enabled
                            autocomplete.setDisabled(false);
                            autocomplete.setCanInvitePartners($j("#create-project-quick option:selected").attr("visibletopartner"));
                        }
                    });
                    // fix for user picker list that overflows the slidedown panel
                    $j('#create-owner-quick').keyup(function() {
                       $j('#jiveContentCreatePanel').css('overflow' , 'visible');
                        return false;
                    });
                    $j('#create-owner-quick').blur(function() {
                       $j('#jiveContentCreatePanel').css('overflow' , 'hidden');
                        return false;
                    });
                    $j("#create-duedate-quick").attr("value", "${dueDate!?js_string}");
//					window.setTimeout(function(){$j("#create-desc-quick").focus()},301);
                });
            </script>
        </#if>
    </div>
</div>
