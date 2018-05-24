<@resource.javascript file="/resources/scripts/apps/shared/views/abstract_view.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/views/container_search_view.js"/>
<@resource.javascript file="resources/scripts/jquery/jquery.endless-scroll-1.3.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/views/container_browse_view.js" />
<@resource.template file="/soy/placepicker/placepicker.soy" />
<@resource.javascript file="/resources/scripts/apps/placepicker/models/browse_containers_source.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/models/search_containers_source.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/models/place_picker_source.js" />
<@resource.javascript file="/resources/scripts/apps/placepicker/main.js" />
<@resource.javascript file="/resources/scripts/apps/projectpicker/main.js" />
<@resource.javascript file="/resources/scripts/apps/shared/views/date_picker_view.js" />
<#import "/template/global/include/jive-form-elements.ftl" as jiveform/>

<html>
<head>
    <!-- begin header -->
<#if task??>
    <title><@s.text name="task.edit.title.colon" /> ${action.renderSubjectToHtml(task)?html}</title>
    <meta name="titleEscaped" content="true"/>
<#else>
    <#if parentTask??>
        <title><@s.text name="task.subtask.create.title.colon" /> <#if project??>${project.name}</#if></title>
    <#else>
        <title><@s.text name="task.create.title.colon" /> <#if project??>${project.name}</#if></title>
    </#if>
</#if>

    <meta name="nosidebar" content="true"/>

<#-- used for simple editor -->
<@resource.javascript>
    var _jive_video_picker__url = "?container=${container.ID?c}&containerType=${container.objectType?c}"
    var _editor_lang = "${displayLanguage}";
    var _jive_spell_check_enabled = "false";
    var _jive_tables_enabled = "false";
    var _jive_tables_enabled = "false";
    var _jive_images_enabled = "false";
</@resource.javascript>
<@resource.javascript file="/resources/scripts/post.js" />
<@resource.template file="/soy/userpicker/userpicker.soy" />

<#if legacyBreadcrumb>
    <#if project??>
        <content tag="breadcrumb">
        <@s.action name="legacy-breadcrumb" executeResult="true" ignoreContextParams="true">
            <@s.param name="container" value="${project.ID?c}L" />
            <@s.param name="containerType" value="${project.objectType?c}" />
        </@s.action>
        </content>
    <#else>
        <content tag="breadcrumb"></content>
    </#if>
</#if>

    <script type="text/javascript">
        function setDueDate(date){
            $j('#create-duedate').val(new Date(date).print(Zapatec.Calendar._TT["DEF_DATE_FORMAT"]));
        }
    </script>

    <link rel="stylesheet" href="<@resource.url value='/styles/jive-compose.css'/>" type="text/css" media="all"/>
    <link rel="stylesheet" href="<@resource.url value='/styles/jive-project.css'/>" type="text/css" media="all"/>

    <style type="text/css" media="all">
        #wysiwygtext {
            height: 100px;
        }
    </style>
</head>
<body class="jive-body-formpage jive-body-formpage-task">

        <#include "/template/global/include/form-message.ftl"/>

        <!-- BEGIN checkpoint create form block -->
        <#if task??>
        <form action="<@s.url action='edit-task'/>" method="post" id="jivetaskform" name="jivetaskform" class="j-form">
        <#else>
        <form action="<@s.url action='create-task'/>" method="post" id="jivetaskform" name="jivetaskform" class="j-form">
        </#if>
            <div class="jive-create-large jive-content j-task clearfix">

                <header>
                    <#if task??>
                        <h2><@s.text name="task.edit.title" /></h2>
                    <#else>
                        <#if parentTask??>
                            <h2><@s.text name="task.subtask.create.title" /></h2>
                                <p>In task: ${parentTask.subject?html}</p>
                            <#else>
                                <h2><@s.text name="task.create.title" /></h2>
                                <p><@s.text name="task.create.info" /></p>
                        </#if>
                    </#if>
                </header>


                    <#if task??>
                        <@jive.token name="task.edit.${task.ID?c}" />
                        <input type="hidden" name="task" value="${task.ID?c}"/>
                    <#else>
                        <@jive.token name="task.create.${user.ID?c}" />
                    </#if>
                    <#if parentTask??>
                        <@jive.token name="task.edit.${parentTask.ID?c}" />
                        <input type="hidden" name="parentTask" value="${parentTask.ID?c}"/>
                    </#if>

                    <div class="jive-form-task-assignee">
                        <label for="jive-user-chooser"><@s.text name="task.form.owner.label" /></label>
                        <input type="text" name='owner' id="jive-user-chooser" class="jive-task-create-owner jive-autocomplete" role="combobox"/>
                        <@macroFieldErrors name="owner"/>
                    </div>


                    <span class="jive-form-task-desc">
                        <label for="create-desc">
                            <@s.text name="task.form.description.label.required">
                                <@s.param><strong class="required"></@s.param>
                                <@s.param></strong></@s.param>
                            </@s.text>
                        </label>
                        <input type="text" id="create-desc" name="subject" maxlength="255"
                                       class="jive-form-element-text jive-task-create-desc" value="${subject!?html}" aria-required="true" required />
                        <@macroFieldErrors name="subject"/>
                    </span>
                    <span class="jive-form-task-project">
                        <label for="create-project"><@s.text name="task.form.project.label" /></label>
                        <#assign showPersonal = privateContentConfiguration.isTaskEnabled()>
                        <@jiveform.projectchooser project=project projects=userTrackedProjects showPersonal=showPersonal disabled=(task?? || parentTask??) user=user />
                    </span>

                    <span class="jive-form-task-duedate">
                        <label for="create-duedate"><@s.text name="task.form.duedate.label" /></label>
                        <input type="text" id="create-duedate" name="dueDate" />
                        <@macroFieldErrors name="dueDate"/>
                    </span>




                    <span class="jive-form-task-notes">

                            <label for="wysiwygtext"><@s.text name="task.form.notes"/></label>

                        <#-- Div containing the body textarea and controls -->
                        <div class="jive-editor-panel">
                            <textarea id='wysiwygtext' name="body" rows="15" cols="30">${body!?html}</textarea>
                        </div>
                    </span>
            </div>
            <!-- END form container block -->
            <div class="j-publishbar">
                <section>
                    <@macroFieldErrors name="tags"/>
                    <div id="jive-compose-tags" class="j-form">
                        <@soy.render template="jive.tags.autocomplete.tags" data={"tags": "${tags?default('')}"} />
                        <ul class="autocomplete" id="jive-tag-choices"></ul>
                            <#if (popularTags?size > 0)>
                                <div id="jive-populartags-container">
                                    <span>
                                        <strong><@s.text name="msg.post.popular_tags.gtitle" /></strong>
                                        <#if project??><@s.text name="task.form.wstags.populr.instruc" /><#else><@s.text name="task.form.tags.popular.instruc" /></#if>
                                    </span>

                                    <div>
                                        <#list popularTags as tag>
                                            <a name="populartag" rel="nofollow" href="#"
                                               onclick="swapTag(this); return false;"
                                                <#if (tags?? && ((tags.indexOf(' ' + tag + ' ') > -1) || (tags.startsWith(tag + ' ')) || (tags.endsWith(' ' + tag))))>
                                               class="jive-tagname-${tag?html} jive-tag-selected"
                                                <#else>
                                               class="jive-tagname-${tag?html} jive-tag-unselected"
                                                </#if>
                                                    >${action.renderTagToHtml(tag)}</a>&nbsp;
                                        </#list>
                                    </div>
                                </div>
                            </#if>
                            <script type="text/javascript">
                                $j(document).ready(function () {
                                    populateTags()
                                })
                            </script>
                            <!-- NOTE: this include MUST come after the 'tags' input element -->
                        <@resource.javascript file="/resources/scripts/apps/tags/tag-selector.js" parseDependencies="true"/>
                    </div>
                </section>
            </div>

                <@soy.render template="jive.content.comment.rte_message" data={'externallyVisible': (project?? && project.visibleToPartner && !user.partner)}/>
                <div class="jive-composebuttons">
                    <#if task??>
                        <input type="submit" name="save" class="j-btn-callout" value="<@s.text name="task.form.edit.button" />"/>
                    <#else>
                        <#if parentTask??>
                        <input type="submit" name="add" class="j-btn-callout" value="<@s.text name="task.form.add.button" />"/>
                            <input type="submit" name="method:addAnotherSubTask" value="<@s.text name="task.form.add_subtask.button" />"/>
                        <#else>
                        <input type="button" id="task-submit-add-form-button" name="add" class="j-btn-callout" value="<@s.text name="task.form.add.button" />"/>

                            <input type="submit" name="method:addAnother" value="<@s.text name="task.form.add_another.button" />"/>
                        </#if>
                    </#if>
                        <input type="submit" name="method:cancel" value="<@s.text name="global.cancel" />" formnovalidate />
                </div>

        </form>

        <@resource.javascript ajaxOutput="true" />


            <script type="text/javascript" language="JavaScript">
                $j('#create-desc').focus();
            </script>





<#include "/template/global/include/jive-macros.ftl" />
<script type="text/javascript">
    $j(document).ready(function() {
        <#if !rteDisabledBrowser>
        $j('#jivetaskform').bind('submit', function() {
            validateTask();
        });
        </#if>
   // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
    $j('#task-submit-add-form-button').click(function() {
	jiveSubmitTaskForm();
    });

    var datePicker = new jive.shared.DatePicker.View({"locale": _jive_locale});
    datePicker.addDatePicker("#create-duedate", new Date());

    var autocompleteOwner = $j('#jive-user-chooser');
    var startingUsers = <@userAutocompleteUsers user=ownerUser />;
    var autocomplete = new jive.UserPicker.Main({
    	startingUsers: startingUsers,
        multiple : true,  // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
        listAllowed: false,
        canInvitePartners : <#if project?? && project.visibleToPartner>true<#else>false</#if>,
        disabled: <#if !project??>true<#else>false</#if>,
        $input : autocompleteOwner
    });
	    $j("#jive-project-chooser").change(function(){
        	if($j(this).val() == ""){
                    // set disabled
                    // reset to owner
                    autocomplete.setDisabled(true);
                    autocomplete.reset();
                }else{
                    // set enabled
                    autocomplete.setDisabled(false);
                }
        });


        function validateTask() {
            var body = window.editor.get('wysiwygtext').getHTML();
            $j('#wysiwygtext').val(body);
            // safari 1.x and 2.x bug: http://lists.apple.com/archives/Web-dev/2005/Feb/msg00106.html
            if (window.editor.get('wysiwygtext').isTextOnly()) {
                $j('#wysiwygtext').show().text(body).hide();
            }

            return true;
        }

 // Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
        function getPlaceID(projectid){
            var placeidUrl=document.location.origin+"/api/core/v3/places?filter=entityDescriptor("+600+","+projectid+")";
            var placeIDdata = JSON.parse($j.ajax({type: "GET", url: placeidUrl, async: false}).responseText.replace(/^throw [^;]*;/, ''));
            var placeid=(placeIDdata.list[0].placeID);
            return placeid;
        }

	    function jiveSubmitTaskForm() {
	        var url = "";
            var projectid = $j('#jivetaskform').find('[name=project]').val();
            var ownerValueArray = $j('#jivetaskform').find('[name=owner]').val().split(",");
            if(projectid>0){
	         url =document.location.origin+ "/api/core/v3/places/" + getPlaceID(projectid) + "/tasks";
	        } else {
	          url =document.location.origin+ "/api/core/v3/people/" +ownerValueArray + "/tasks";
	        }
            var body = window.editor.get('wysiwygtext').getHTML();
            var tags = $j('#jivetaskform').find('[name=tags]').val() ;
            var subject = $j('#jivetaskform').find('[name=subject]').val();
            var dueDate = $j('#jivetaskform').find('[name=dueDate]').val();
            var dateString = dueDate.split('/');
                dateString = dateString[2] + "-" +dateString[1] +"-"+ dateString[0];
            dueDate =  dateString + "T23:59:00.000+0000";
            var JsonData = {
               "content" : {
                    "type" : "text/html",
                    "text" : body
                 },
                "subject" : subject,
                "project" : projectid,
                "dueDate":dueDate,
                "type" : "task"
            }
            if(tags.length > 0) {
                JsonData.tags = [tags];
            }
            var jiveTaskFormArray = $j('#jivetaskform').serializeArray();
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
		            success: function(successResponse) {
                       if(eachOwner==(ownerValueArray.length-1)){
                           var dataUrlAfter = successResponse.resources.html.ref;
                           window.location.assign(dataUrlAfter);
			               <#assign taskFormSuccessMessage><@s.text name="task.form.success.message"/></#assign>
                           $j('<p>${taskFormSuccessMessage?html?js_string}</p>').message();
                       }
		            },
	                error: function(xhr, ajaxOptions, thrownError) {
                          var jsonparse = JSON.parse(xhr.responseText);
                          alert("unable to create tasks due to : " + jsonparse.error.message);
		            }
                });
            });
	    }
 // Ends here Collab : Enhancement of projects . Assigning Tasks to mulitple people INC007505857 CR00160520
        function buildRTE(){
			<#assign toggleDisplay><@s.text name="rte.toggle_display" /></#assign>
			<#assign editDisabled><@s.text name="rte.edit.disabled" /></#assign>
			<#assign editDisabledSummary><@s.text name="rte.edit.disabled.desc" /></#assign>
			<#assign alwaysUse><@s.text name="post.alwaysUseThisEditor.tab" /></#assign>
            var rte = new jive.rte.RTEWrap({
                $element      : $j("#wysiwygtext"),
                preset        : "task",
                preferredMode : "${preferredEditorMode}",
                startMode     : "${preferredEditorMode}",
                mobileUI      : <#if rteDisabledBrowser>true<#else>false</#if>,
                toggleText    : '${toggleDisplay?js_string}',
                alwaysUseTabText  : '${alwaysUse?js_string}',
                editDisabledText : '${editDisabled?js_string}',
                editDisabledSummary : '${editDisabledSummary?js_string}',
                communityName : '${SkinUtils.getCommunityName()?js_string}',
                isEditing     : <#if task??>true<#else>false</#if>,
                images_enabled: true,
                minHeight     : 442
            });

            $j("#create-desc").focus();
        }
        $j(buildRTE);
        $j("#create-duedate").attr("value", "${dueDate!?js_string?html}");
    });
</script>


</body>
</html>
