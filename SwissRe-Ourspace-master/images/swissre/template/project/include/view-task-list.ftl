<!-- BEGIN task list -->
<div class="j-tasks clearfix">

<@resource.template file="/soy/project/tasks.soy" id="taskDeps" />
<@resource.javascript file="/resources/scripts/apps/project/task_list/main.js" id="taskDeps" />

<#-- For cases where this template is rendered on page load. -->
<@resource.javascript>
    require(['apps/project/task_list/main'], function(TaskList) {
        var taskList = new jive.project.TaskList('${mode?js_string}', '${filter?js_string}', ${user.ID?c}, '${action.getText("task.mark.com.confirm")?js_string}');
    });
</@resource.javascript>

<#-- For cases where this template is rendered during an ajax request. -->
<@resource.javascript id="taskDepsLoader">
    require(['apps/project/task_list/main'], function(TaskList) {
        var taskList = new jive.project.TaskList('${mode?js_string}', '${filter?js_string}', ${user.ID?c}, '${action.getText("task.mark.com.confirm")?js_string}');
    });
</@resource.javascript>

<#if !tasksExist>

    <div id="jive-community-empty" class="j-empty">
        <p class="font-color-meta">
            <#if (owner?exists && owner.ID == user.ID)>
            <@s.text name="task.list.self.empty" />
            <#else>
            <@s.text name="task.list.empty" />
            </#if>
            <#if (showControls)>
                <a href="<@s.url action="create-task" method="input"><#if project??><@s.param name="project">${project.ID?c}</@s.param></#if></@s.url>" class="font-color-link"><span class="jive-icon-sml jive-icon-task"></span><@s.text name="project.task.create.link"/></a>
            </#if>
        </p>
    </div>

<#else>

    <!-- BEGIN filters, sorts & pagination -->
    <div class="j-act-filter-bar j-sub-bar tasks clearfix">

        <#if project?exists>
            <#-- display assignee selector -->
            <form>
                <span class="jive-table-filter jive-table-filter-tasklist">

                    <label for="task-assignee">
                        <@s.text name="task.owner.gtitle"/>
                    </label>

                    <select id="task-assignee" name="ownerID">
                        <option value="0"<#if (ownerID == 0)> selected="selected"</#if>>
                            <@s.text name="task.owner.all.listitem"/>
                        </option>
                        <option value="${statics['com.jivesoftware.community.project.action.ViewTaskListAction'].UNASSIGNED}"
                            <#if (ownerID == statics['com.jivesoftware.community.project.action.ViewTaskListAction'].UNASSIGNED)> selected="selected"</#if>>
                            <@s.text name="task.owner.unassigned.listitem"/>
                        </option>
                        <#if !user.anonymous && !guest>
                        <option value="${user.ID?c}" <#if (ownerID == user.ID)> selected="selected"</#if>>
                            <@s.text name="task.owner.mine.listitem"/>
                        </option>
                        </#if>
                        <#list owners as owner>
                            <#if (user.ID != owner.ID)>
                                <option value="${owner.ID?c}"<#if (ownerID == owner.ID)> selected="selected"</#if>>
                                    <@jive.userDisplayNameLink user=owner/>
                                </option>
                            </#if>
                        </#list>
                    </select>

                </span>
                <input type="submit" class="j-508-label" tabindex="-1" value="<@s.text name='global.save'/>"/>

            </form>

        <#elseif owner?exists>
            <#-- display project selector -->
            <form>

                <span class="jive-table-filter jive-table-filter-tasklist">

                    <label for="task-project">
                        <@s.text name="task.project.gtitle"/>
                    </label>

                    <select id="task-project" name="projectID" class="j-tasks-project-select">
                        <option value="0"<#if (projectID == 0)>selected="selected"</#if>><@s.text name="task.project.all.listitem"/></option>
                        <#if user.ID == owner.ID>
                            <option value="${statics['com.jivesoftware.community.project.action.ViewTaskListAction'].PERSONAL}"
                                <#if (projectID == statics['com.jivesoftware.community.project.action.ViewTaskListAction'].PERSONAL)>selected="selected"</#if>><@s.text name="task.project.personal.listitem"/></option>
                        </#if>
                        <#list projects as project>
                            <option value="${project.ID?c}"
                                    <#if (projectID == project.ID)>selected="selected"</#if>>${project.name?html}</option>
                        </#list>
                    </select>

                </span>
                <input type="submit" class="j-508-label" tabindex="-1" value="<@s.text name='global.save'/>"/>

            </form>
        </#if>

        <#-- display tree/grouped view toggle -->
        <span id="jive-tasklist-view-toggles" class="j-task-viewtoggles">
            <span class="j-viewmode"><@s.text name="task.list.view"/></span>
            <span id="task-view-g" class="j-view-toggle">
                <a href="#" id="j-task-groupview-sel" class="j-link-hierarchy" title="<@s.text name="task.list.viewtoggle.grouped.link"/>" role="button">
                    <label id="task.list.viewtoggle.grouped.link" class="j-508-label"><@s.text name="task.list.viewtoggle.grouped.link"/></label>
                    <span class="j-ui-elem" aria-labelledby="task.list.viewtoggle.grouped.link"></span>
                </a>
                <strong style="display: none;" class="j-link-hierarchy j-active">
                    <label id="task.list.viewtoggle.grouped.selected" class="j-508-label"><@s.text name="task.list.viewtoggle.grouped.selected"/></label>
                    <span class="j-ui-elem" title="<@s.text name="task.list.viewtoggle.grouped.link"/>" tabindex="-1" aria-labelledby="task.list.viewtoggle.grouped.selected"></span>
                </strong>
            </span>

            <span id="task-view-f" class="j-view-toggle j-rc1">
                <a href="#" id="j-task-flatview-sel" class="j-link-details" title="<@s.text name="task.list.viewtoggle.flat.link"/>" role="button">
                    <label id="task.list.viewtoggle.flat.link" class="j-508-label"><@s.text name="task.list.viewtoggle.flat.link"/></label>
                    <span class="j-ui-elem" aria-labelledby="task.list.viewtoggle.flat.link"></span>
                </a>
                <strong style="display: none;" class="j-link-details j-active">
                    <label id="task.list.viewtoggle.flat.selected" class="j-508-label"><@s.text name="task.list.viewtoggle.flat.selected"/></label>
                    <span class="j-ui-elem" title="<@s.text name="task.list.viewtoggle.flat.link"/>" tabindex="-1" aria-labelledby="task.list.viewtoggle.grouped.selected"></span>
                </strong>
            </span>

            <span class="j-taskview-options font-color-meta" id="grouped-options" <#if (mode == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].MODE_FLAT)> style="display: none;"</#if> >
                <input type="checkbox" id="show-completed"
                    <#if (filter == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].FILTER_TASKS_COMPLETE)>
                        checked="checked"
                    </#if>
                    />
                <label for="show-completed"><@s.text name="task.list.viewtoggle.completed.label"/></label>
                 <input type="checkbox" id="show-overdue" checked="checked"/>
 <label for="show-overdue"><@s.text name="task.list.viewtoggle.overdue.label"/></label>
            </span>
            <span class="j-taskview-options font-color-meta" id="flat-options" <#if (mode == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].MODE_GROUPED)> style="display: none;"</#if> >
                <fieldset>
                    <legend class="j-508-label"><@s.text name="task.list.viewtoggle.flat.completion.toggle.legend"/></legend>
                    <input type="radio" name="task-state" id="task-state-incomplete"
                       <#if (filter == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].FILTER_TASKS_INCOMPLETE)>checked="checked"</#if>/>
                    <label for="task-state-incomplete"><@s.text name="task.list.viewtoggle.flat.incomplete"/></label>
                    <input type="radio" name="task-state" id="task-state-complete"
                       <#if (filter == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].FILTER_TASKS_COMPLETE)>checked="checked"</#if>/>
                    <label for="task-state-complete" ><@s.text name="task.list.viewtoggle.flat.complete"/></label>
                </fieldset>
            </span>

        </span>

        <!-- BEGIN pagination-->
        <#assign paginator = newPaginator>
        <#if (paginator.numPages > 1)>
        <span class="j-pagination">
            <#list paginator.getPages(3) as page>
                <#if (page?exists)>
                    <a href="#" data-start="${page.start?c}"
                       class="js-pagination<#if (page.start == start)> jive-pagination-current</#if>">${page.number}</a>
                <#else>
                    <span>&hellip;</span>
                </#if>
            </#list>
            <span class="j-pagination-prevnext">
                <#if (paginator.previousPage)>
                    <a href="#" data-start="${paginator.previousPageStart?c}"
                       title="<@s.text name="global.previous_page_title"/>"
                       class="js-pagination j-pagination-prev"><@s.text name="global.previous"/></a>
                <#else>
                    <span class="j-pagination-prev j-disabled font-color-meta"><@s.text name="global.previous"/></span>
                </#if>
                <#if (paginator.nextPage)>
                    <a href="#" data-start="${paginator.nextPageStart?c}"
                       title="<@s.text name="global.next_page_title"/>"
                       class="js-pagination j-pagination-next"><@s.text name="global.next"/></a>
                <#else>
                    <span class="j-pagination-next j-disabled font-color-meta"><@s.text name="global.next"/></span>
                </#if>
            </span>
        </span>
        </#if>
        <!-- END pagination -->

    </div>
    <!-- END filters, sorts & pagination -->

    <!-- BEGIN task list table -->
    <div id="jive-task-list" class="j-table jive-table-tasklist clearfix <#if (mode == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].MODE_GROUPED)>jive-tasks-nested</#if>">
        <#if (deliverables?has_content)>

            <table cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th class="font-color-meta"><@s.text name="task.subject.colhead"/></th>
                        <#if (!owner?exists)>
                            <th class="font-color-meta"><@s.text name="task.owner.colhead"/></th>
                        </#if>
                        <#if (!project?exists)>
                            <th class="font-color-meta"><@s.text name="task.project.colhead"/></th>
                        </#if>
                        <th class="font-color-meta"><@s.text name="task.duedate.colhead"/></th>
                    </tr>
                </thead>

                <#if task?exists>
                    <#assign currentTaskID = task.ID/>
                <#else>
                    <#assign currentTaskID = 0/>
                </#if>
                <#list deliverables as deliverable>
                    <#if (deliverable.objectType == JiveConstants.CHECKPOINT)>
                        <#if project?exists>
                            <#assign checkPoint = deliverable/>
                            <tr class="jive-checkpoint">
                                <td colspan="2">
                                    <strong>
                                        <span class="${SkinUtils.getJiveObjectCss(deliverable, 1)}"></span>
                                        <@s.text name="checkpoint.title"/>
                                    </strong>

                                    <span>${checkPoint.name?html}</span>
                                    <#if checkPoint.description?has_content>
                                        - ${checkPoint.description?html}
                                    </#if>
                                    <#if ProjectPermHelper.getCanManageProject(project)>

                                        <a class="font-color-meta-light" href="<@s.url action='edit-checkpoint' method='input'><@s.param name="project" value="${project.ID?c}L"/><@s.param name="checkPointID" value="${checkPoint.ID?c}L"/></@s.url>"><@s.text name="checkpoint.edit.link"/></a>
                                        <a class="font-color-meta-light" href="<@s.url action='delete-checkpoint' method='input'><@s.param name="project" value="${project.ID?c}L"/><@s.param name="checkPointID" value="${checkPoint.ID?c}L"/></@s.url>"><@s.text name="checkpoint.delete.link"/></a>

                                    </#if>
                                </td>
                                <td class="jive-table-cell-date font-color-meta">${statics["com.jivesoftware.util.DateUtils"].formatForUserDate(locale, checkPoint.dueDate, true)?html}</td>
                            </tr>
                        </#if>
                        <#elseif (deliverable.objectType == JiveConstants.TASK)>
                            <#assign task = deliverable/>
                            <#if task.dueDate?exists>
                                <#assign timeline = (task.dueDate.compareTo(today))/>
                            <#else>
                                <#assign timeline = 1/>
                            </#if>
                            <#assign overdue = (!task.completed && timeline < 0)/>
                            <#assign dueToday = (!task.completed && timeline == 0) />
                            <#assign editable = action.isEditable(task) />
                            <#assign taskOwner = action.getTaskOwner(task)!>
                            <tr id="jive-task-${task.ID?c}"
                                class="jive-task<#if overdue> jive-task-overdue</#if><#if (currentTaskID == task.ID)> jive-task-open</#if> jive-task-level-${action.getDepth(task)}  <#if task.completed>j-task-comp</#if>">
                                <td class="j-td-title">
                                    <div class="j-task-content">

                                        <a name="${task.ID?c}"></a>

                                        <!-- BEGIN checkbox (or icon) -->
                                        <#if showControls && editable>
                                            <input
                                                type="checkbox"
                                                name="jive-task-${task.ID?c}"
                                                id="jive-task-checkbox-${task.ID?c}"
                                                class="js-task-checkbox"
                                                title="<@s.text name="project.task.mark.complete"/>"
                                                value="true"
                                                data-id="${task.ID?c}"
                                                data-owner-id="<#if task.owner??>${taskOwner.ID?c}<#else>null</#if>"
                                                <#if task.completed>
                                                   checked="checked"
                                                </#if>
                                                <#if (task.jiveContainer.status != statics['com.jivesoftware.community.JiveContainer$Status'].ACTIVE)>disabled="true"</#if> />
                                        <#else>
                                            <span class="jive-icon-med jive-icon-task j-task-uneditable"></span>
                                        </#if>
                                        <!-- END checkbox (or icon) -->

										<#if task.completed>
											<strong class="font-color-okay">
												<@s.text name="task.complete"/>
											</strong>
										</#if>
										<#if overdue>
											<strong class="font-color-danger">
												<@s.text name="task.overdue.colon"/>
											</strong>
										</#if>
										<#if dueToday>
											<strong class="font-color-meta">
												<@s.text name="task.due_today.colon"/>
											</strong>
										</#if>
										<#if !editable>
											<em>${action.renderSubjectToText(task)}</em>
											<#else>
											${action.renderSubjectToText(task)}
										</#if>
                                        <span class="jive-task-showhide font-color-meta">
                                        (<a href="#"
                                                id="jive-task-${task.ID?c}-more"
                                                class="js-task-more"
                                                data-id="${task.ID?c}"
                                                <#if (currentTaskID == task.ID)>style="display:none;"</#if>>
                                                    <@s.text name="task.details.more.link" />
                                            </a>
                                            <a href="#"
                                                id="jive-task-${task.ID?c}-less"
                                                class="js-task-less"
                                                data-id="${task.ID?c}"
                                                <#if (currentTaskID != task.ID)>style="display:none;"</#if>>
                                                    <@s.text name="task.details.less.link" />
                                            </a>)
                                        </span>

                                        <!-- BEGIN Task details -->
                                        <div id="jive-task-body-${task.ID?c}" class="jive-task-open-details" <#if (currentTaskID != task.ID)>style="display: none;"</#if>>

                                            <#if task.body?has_content && task.body.documentElement.hasChildNodes()>
                                                <div class="jive-task-body-notes">
                                                ${action.renderToHtml(task)}
                                                </div>
                                            </#if>

                                            <#assign tags = jiveContext.tagManager.getTags(task)/>
                                            <#if (tags.hasNext())>
                                                <div class="jive-task-body-tags">
                                                    <strong class="font-color-meta"><@s.text name="task.details.tags.label" /></strong>
                                                    <#list tags as tag><#t>
                                                        <#if (project?exists)><#t>
                                                            <a href="<@s.url value='${JiveResourceResolver.getJiveObjectURL(project)}/tags#/?tags=${tag.name?url}'/>">${action.renderTagToHtml(tag)}</a><#t>
                                                            <#else><#t>
                                                            <a href="<@s.url value='/tags'/>#/?tags=${tag.name?url}">${action.renderTagToHtml(tag)}</a><#t>
                                                        </#if><#t>
                                                        <#if (tag_has_next)><@s.text name="global.comma"/>&nbsp;</#if><#t>
                                                    </#list>
                                                </div>
                                            </#if>

                                            <#if showControls && editable>
                                                <div class="jive-task-body-controls clearfix">
                                                    <#if (!user.anonymous)>
                                                        <#if (task.jiveContainer?exists && task.jiveContainer.status == statics['com.jivesoftware.community.JiveContainer$Status'].ACTIVE)>
                                                            <a href="<@s.url action='edit-task' method='input'><@s.param name='task' value='${task.ID?c}L'/></@s.url>"><span
                                                                    class="jive-icon-sml jive-icon-edit"></span><@s.text name="task.details.edit.link"/>
                                                            </a>
                                                            <#if  action.allowSubTask(task)>
                                                                <a href="<@s.url action='create-task' method='input'><@s.param name='parentTask' value='${task.ID?c}L'/></@s.url>"><span
                                                                        class="jive-icon-sml jive-icon-add"></span><@s.text name="task.details.addsubtask.link"/>
                                                                </a>
                                                            </#if>
                                                            <#assign deleteTaskTokenName = "delete-task-" + task.ID?c />
                                                            <a href="#"
                                                               class="js-delete-task"
                                                               data-jive.token.name="${deleteTaskTokenName}"
                                                               data-${deleteTaskTokenName}='<@jive.token name="${deleteTaskTokenName}" noform=true />'
                                                               data-id="${task.ID?c}"><span
                                                               class="jive-icon-sml jive-icon-delete"></span><@s.text name="task.details.delete.link"/>
                                                            </a>
                                                        </#if>
                                                        <#assign taskFollowed = action.isFollowed(task)/>
                                                        <#assign streamsAssociatedCount = action.getStreamsAssociatedCount(task)/>
                                                        <span class="j-js-follow-controls" data-location="task-list" data-streamsAssoc="${streamsAssociatedCount?c}" aria-live="polite" aria-atomic="true">
                                                            <span class="start-follow">
                                                                <a href="#" <#if taskFollowed>style="display:none;"</#if>
                                                                   id="jive-link-task-startFollowing" data-objectid=${task.ID?c}>
                                                                    <@s.text name="global.follow"/>
                                                                    <span class="jive-icon-glyph icon-pulse j-instreamicon"></span>
                                                                </a>
                                                            </span>
                                                            <span class="following">
                                                                <a href="#" <#if !taskFollowed>style="display:none;"</#if>
                                                                   id="jive-link-task-following" data-objectid=${task.ID?c}>
                                                                    <@s.text name="global.following"/>
                                                                    <span class="j-js-streams-assoc-count j-instream-count">
                                                                        <#if 0 < streamsAssociatedCount>
                                                                            <@s.text name="global.in"/>
                                                                            <span class="jive-icon-glyph icon-pulse j-instreamicon"></span> ${streamsAssociatedCount?c}
                                                                        </#if>
                                                                    </span>
                                                                </a>
                                                            </span>

                                                        </span>
                                                    </#if>
                                                </div>
                                            </#if>
                                        </div>
                                        <!-- END Task details -->

                                    </div>
                                </td>
                                <#if (!owner?exists)>
                                    <td class="j-td-person"><#if task.owner?exists><@jive.userDisplayNameLink user=taskOwner/><#else><@s.text name="task.owner.unassigned.text"/>
                                        <a href="#" class="js-take-task" id="task-${task.ID?c}" data-id="${task.ID?c}"
                                           >(<@s.text name="task.take.link"/>
                                            )</a></#if>
                                    </td>
                                </#if>
                                <#if (!project?exists)>
                                    <td class="j-td-place">
                                        <#if (task.containerType == JiveConstants.PROJECT)>
                                            <a href="<@s.url value='${JiveResourceResolver.getJiveObjectURL(task.jiveContainer)}'/>" class="font-color-meta">${task.jiveContainer.name?html}</a>
                                        <#else>
                                            <span class="font-color-meta"><@s.text name="task.personal"/></span>
                                        </#if>
                                    </td>
                                </#if>
                                <td class="j-td-date font-color-meta">
                                    <#if overdue><strong class="font-color-danger"></#if>
                                    <#if task.dueDate?exists>${statics["com.jivesoftware.util.DateUtils"].formatForUserDate(locale, task.dueDate, true)?html}</#if>
                                    <#if overdue></strong></#if>
                                </td>
                            </tr>

                    </#if>
                </#list>
            </table>

        <#else>

            <!-- START empty task list display message -->
            <div id="jive-community-empty" class="jive-community-empty-small clearfix">
                <h4>
                    <#if (owner?exists && projectID != 0) || (project?exists && ownerID != 0)>
                        <@s.text name="task.list.filtered.empty" />
                    <#else>
                        <#if (owner?exists && owner.ID == user.ID)>
                            <#if (filter == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].FILTER_TASKS_COMPLETE)>
                                <@s.text name="task.list.self.complete.none" />
                            <#else>
                                <@s.text name="task.list.self.incomplete.none" />
                            </#if>
                        <#else>
                            <#if (filter == statics["com.jivesoftware.community.project.action.ViewTaskListAction"].FILTER_TASKS_COMPLETE)>
                                <@s.text name="task.list.complete.none" />
                            <#else>
                                <@s.text name="task.list.incomplete.none" />
                            </#if>
                        </#if>
                    </#if>
                </h4>
            </div>
            <!-- END empty task list display message -->
        </#if>
    </div>

    <!-- BEGIN create action -->
    <#if (showControls)>
        <div class="j-create-task">
            <a href="<@s.url action="create-task" method="input"><#if project??><@s.param name="project">${project.ID?c}</@s.param></#if></@s.url>"><span class="jive-icon-med jive-icon-task"></span><@s.text name="project.task.create.link"/></a>
        </div>
    </#if>


    <!-- END task list table -->


    <div class="j-browse-sorts clearfix">
        <!-- END create action -->

        <#if (deliverables?has_content)>
            <#assign paginator = newPaginator>
            <#if (paginator.numPages > 1)>
                <!-- BEGIN pagination-->
                <span class="j-pagination">
                    <#list paginator.getPages(3) as page>
                        <#if (page?exists)>
                            <a href="#" data-start="${page.start?c}"
                                class="js-pagination<#if (page.start == start)> jive-pagination-current</#if>">${page.number}</a>
                        <#else>
                            <span>&hellip;</span>
                        </#if>
                    </#list>
                    <span class="j-pagination-prevnext">
                        <#if (paginator.previousPage)>
                            <a href="#" data-start="${paginator.previousPageStart?c}"
                               title="<@s.text name="global.previous_page_title"/>"
                               class="js-pagination j-pagination-prev"><@s.text name="global.previous"/></a>
                        <#else>
                            <span class="j-pagination-prev j-disabled font-color-meta"><@s.text name="global.previous"/></span>
                        </#if>
                        <#if (paginator.nextPage)>
                            <a href="#" data-start="${paginator.nextPageStart?c}"
                               title="<@s.text name="global.next_page_title"/>"
                               class="js-pagination j-pagination-next"><@s.text name="global.next"/></a>
                        <#else>
                            <span class="j-pagination-next j-disabled font-color-meta"><@s.text name="global.next"/></span>
                        </#if>
                    </span>

                </span>
                <!-- END pagination -->
            </#if>
        </#if>
    </div>




</#if>

</div>
<!-- END task list -->
<@resource.javascript id="taskDeps" asyncOutput="true" satisfies="apps/project/task_list/main" />
<@resource.javascript id="taskDepsLoader" ajaxOutput="true" />
