<#--
  ~ $Revision$
  ~ $Date$
  ~
  ~ Copyright (C) 1999-2008 Jive Software. All rights reserved.
  ~
  ~ This software is the proprietary information of Jive Software. Use is subject to license terms.
  -->

<!-- BEGIN document -->
<@soy.render template="jive.outcomes.badge.headerBadgeContainer" data={
'objectType': '${document.objectType?c}',
'objectId': '${document.ID?c}',
'extraClasses': 'j-outcome-summary-container clearfix',
'allowedOutcomeTypes': 'List("finalized", "outdated", "official", "wip")'
} />

<!-- BEGIN guided nav -->
<@soy.render template="jive.guided_navigation.main" />
<!-- END guided nav -->

<#macro renderOnBehalf onBehalfUser>
    <#if onBehalfUser.jiveUser?exists>
        <@jive.userDisplayNameLink user=onBehalfUser.jiveUser/>
    <#else>
        <#if onBehalfUser.unknownUserUrl?exists>
            <a href="${onBehalfUser.unknownUserUrl}">${onBehalfUser.unknownUserName}</a>
        <#else>
            <#if onBehalfUser.unknownUserName?exists>
                ${onBehalfUser.unknownUserName}
            <#else>
                <@s.text name="prsntr.created.guest.text"/>
            </#if>
        </#if>
    </#if>
</#macro>

<#macro renderUser onBehalfVia user>
    <#if onBehalfVia != "">
        <#if onBehalfVia.applicationUrl?exists>
            <a href="<@s.url value='${onBehalfVia.applicationUrl}'/>">${onBehalfVia.applicationName}</a>
        <#else>
            <span style="font-weight: bold">${onBehalfVia.applicationName}</span>
        </#if>
    <#else>
        <#if !user.anonymous><@jive.userDisplayNameLink user=user/><#else><@s.text name="prsntr.created.guest.text"/></#if>
    </#if>
</#macro>

<div class="jive-content clearfix doc-page js-tlo js-ed-${document.objectType?c}-${document.ID?c}" role="main" aria-labelledby="main-doc-header" data-object-type="${document.objectType?c}" data-object-id="${document.ID?c}">
    <header>
        <h1><label id="main-doc-header"><span role='img' title='<@s.text name="global.document"/>' class="${SkinUtils.getJiveObjectCss(document, 2)}"></span>${action.renderSubjectToText(document)}</label></h1>

        <#assign docVersion = document.versionManager.getDocumentVersion(version)/>
        <#assign docAuthor = action.getAuthor(document)/>
        <#assign onBehalfCreator = action.getDocumentOnBehalfCreateUser(document)!/>
        <#assign docVersionAuthor = action.getDocumentVersionAuthor(docVersion)/>
        <#assign onBehalfModifier = action.getDocumentVersionOnBehalfModifiedUser(docVersion)!/>

        <#if (ActionUtils.previousVersionExists(document, action.user) && document.textBody && !user.anonymous)>
            <a class="j-version" href="<@s.url value='/docs/${document.documentID}/diff?secondVersionNumber=${document.documentVersion.versionNumber?c}'/>">
                <span class="jive-icon-glyph icon-stack"></span> <@s.text name="prsntr.default.version.label" /> ${version}
            </a>
        <#else>
            <span class="j-version">
                <span class="jive-icon-glyph icon-stack"></span> <@s.text name="prsntr.default.version.label" /> ${version}
            </span>
        </#if>

        <div class="j-byline font-color-meta">
            <#if (onBehalfCreator!="" || onBehalfModifier!="")>
                <#assign onBehalfVia = action.getDocumentOnBehalfOfVia(document)!/>
                <#if onBehalfCreator!="" && onBehalfModifier!="">
                    <@s.text name="doc.created_by.created_behalf_modified_behalf">
                        <@s.param><@renderOnBehalf onBehalfUser=onBehalfCreator /></@s.param>
                        <@s.param><@renderUser onBehalfVia=onBehalfVia user=docAuthor /></@s.param>
                        <@s.param>${document.creationDate?datetime?string.medium_short}</@s.param>
                        <@s.param><@renderOnBehalf onBehalfUser=onBehalfModifier /></@s.param>
                        <@s.param><@renderUser onBehalfVia=onBehalfVia user=docVersionAuthor /></@s.param>
                        <@s.param>${docVersion.modificationDate?datetime?string.medium_short}</@s.param>
                    </@s.text>
                <#elseif onBehalfCreator!="" && onBehalfModifier=="">
                    <@s.text name="doc.created_by.created_behalf_modified_by">
                        <@s.param><@renderOnBehalf onBehalfUser=onBehalfCreator /></@s.param>
                        <@s.param><@renderUser onBehalfVia=onBehalfVia user=docAuthor /></@s.param>
                        <@s.param>${document.creationDate?datetime?string.medium_short}</@s.param>
                        <@s.param><#if docVersionAuthor?exists><@jive.userDisplayNameLink user=docVersionAuthor/><#else><@s.text name="prsntr.modified.guest.text" /></#if></@s.param>
                        <@s.param>${docVersion.modificationDate?datetime?string.medium_short}</@s.param>
                    </@s.text>
                <#elseif onBehalfCreator=="" && onBehalfModifier!="">
                    <@s.text name="doc.created_by.created_by_modified_behalf">
                        <@s.param><#if !docAuthor.anonymous><@jive.userDisplayNameLink user=docAuthor/><#else><@s.text name="prsntr.created.guest.text"/></#if></@s.param>
                        <@s.param>${document.creationDate?datetime?string.medium_short}</@s.param>
                        <@s.param><@renderOnBehalf onBehalfUser=onBehalfModifier /></@s.param>
                        <@s.param><@renderUser onBehalfVia=onBehalfVia user=docVersionAuthor /></@s.param>
                        <@s.param>${docVersion.modificationDate?datetime?string.medium_short}</@s.param>
                    </@s.text>
                </#if>
            <#else> <#--uses default created_by text-->
                <@s.text name="doc.created_by.created_by_modified_by">
                    <@s.param><#if !docAuthor.anonymous><@jive.userDisplayNameLink user=docAuthor/><#else><@s.text name="prsntr.created.guest.text"/></#if></@s.param>
                    <@s.param>${document.creationDate?datetime?string.medium_short}</@s.param>
                    <@s.param><#if docVersionAuthor?exists><@jive.userDisplayNameLink user=docVersionAuthor/><#else><@s.text name="prsntr.modified.guest.text" /></#if></@s.param>
                    <@s.param>${docVersion.modificationDate?datetime?string.medium_short}</@s.param>
                </@s.text>
            </#if>
        </div>

        <#if action.isUserContainer() >
        <div class="jive-content-personal font-color-meta">
            <strong class="font-color-meta"><@s.text name="global.visibility"/></strong>
            <#if action.getVisibilityPolicy(action.user, document) == enums['com.jivesoftware.visibility.VisibilityPolicy'].owner>
            <!-- visible only to you, the author -->
            <span>
                <img src="<@s.url value='/images/transparent.png' />" title="" class="jive-icon-sml jive-icon-bookmark-private" alt=""/>
                <@s.text name="doc.visibility.owner.radio"/>
            </span>
            </#if>
            <#if action.getVisibilityPolicy(action.user, document) == enums['com.jivesoftware.visibility.VisibilityPolicy'].open>
            <!-- visible to anyone -->
            <span>
                <@s.text name="doc.visibility.open.radio"/>
            </span>
            </#if>
            <#if action.getVisibilityPolicy(action.user, document) == enums['com.jivesoftware.visibility.VisibilityPolicy'].restricted>
                <@jive.viewersList action.removeOwner(action.getViewers(document), document) />
            </#if>
        </div>
        </#if>
        <@soy.render template="jive.outcomes.badge.badgeContainer" data={
        'objectType': '${document.objectType?c}',
        'objectId': '${document.ID?c}',
        'extraClasses': 'j-outcome-tlo-badge-container',
        'allowedOutcomeTypes': 'List("decision", "success", "pending", "helpful", "resolved")'
        } />
    </header>


    <section class="jive-content-body">
        <!-- Swiss Re cusotmization for PRB000590767 to supports third party urls -->
        <script type="text/javascript">
            $j(document).ready(function() {
                var searchElements = document.querySelectorAll("a[href*='://search.swissre.com']");
                for (var i = 0, searchLength = searchElements.length; i < searchLength; i++) {
                    var searchElement = searchElements[i];
                    searchElement.removeAttribute('target');
                    searchElement.setAttribute("rel", "noopener");
                }
            });
        </script>
        <!-- Swiss Re customization ends here -->
        <#include "/template/docs/presenter/presenter-body.ftl" />
        <#include "/template/docs/presenter/presenter-attachments.ftl" />
    </section>

    <footer class="jive-content-footer clearfix font-color-meta">
        <@jive.displayViewCount viewCount=TotalViews containerClass='jive-content-footer-item'/>

        <#include "/template/docs/presenter/presenter-tags.ftl" />

    </footer>
</div>


<!-- END document -->
