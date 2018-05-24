<#--
  - $Revision$
  - $Date$
  -
  - Copyright (C) 1999-2008 Jive Software. All rights reserved.
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
-->

<html>
<head>

    <#if mode="PROFILE">
        <#assign title><@s.text name="photoavatar.edit.profile_photo.title" /></#assign>
    <#else>
        <#assign title><@s.text name="photoavatar.edit.avatar.title" /></#assign>
    </#if>

    <title>${title}</title>

	<link rel="stylesheet" href="<@resource.url value='/styles/jive-profileconfig.css'/>" type="text/css" media="all" />

</head>
<body class="jive-body-formpage">


<header class="j-page-header">
    <h1>${title}</h1>
</header>


<!-- BEGIN layout -->
<div class="j-layout j-layout-l clearfix">

    <!-- BEGIN large column -->
    <div class="j-column-wrap-l">
        <div class="j-column j-column-l">
            <#if fieldErrors?has_content >
            <div id="jive-error-box" class="jive-error-box" aria-live="polite" aria-atomic="true" tabindex="-1">
                <div>
                    <span class="jive-icon-med jive-icon-redalert"></span>
                <@s.text name="error.field_error.text"/>
                </div>
            </div>
            </#if>

            <#assign actionName><#if mode="PROFILE">edit-profile-avatar<#else>avatar-userupload</#if></#assign>
            <#assign editingSelf=true>
            <#if (user.ID!=targetUser.ID)><#assign editingSelf=false></#if>
            <#assign uploadPhotoStep2Text><#if (editingSelf)><@s.text name="photoavatar.upload.step2.photo" /><#else><@s.text name="photoavatar.upload.step2.photo.other_user"></@s.text></#if></#assign>
            <#assign uploadAvatarStep2Text><#if (editingSelf)><@s.text name="photoavatar.upload.step2.avatar" /><#else><@s.text name="photoavatar.upload.step2.avatar.other_user"></@s.text></#if></#assign>          

            <div id="jive-profile-images-select" class="jive-profile-images-edit">

			    <ul class="font-color-meta">
					<li><strong class="font-color-normal"><#if mode="PROFILE"><@s.text name="photoavatar.upload.step1.photo" /><#else><@s.text name="photoavatar.upload.step1.avatar" /></#if></strong></li>
					<li><#if mode="PROFILE">${uploadPhotoStep2Text}<#else>${uploadAvatarStep2Text}</#if></li>
					<#if mode == "PROFILE"><li><@s.text name="photoavatar.upload.step3.photo" /></li></#if>
				</ul>


				<div class="j-box j-box-form">
				<form action="<@s.url action='${actionName}' method="uploadImage" />" method="post" enctype="multipart/form-data"  class="j-form j-form-profilephoto">
                    <@jive.token name="upload.image"/>
                    <input type="hidden" name="imageIndex" value="${imageIndex}" />
                    <input type="hidden" name="targetUser" value="${targetUser.ID?c}" />
                    <div class="j-form-row">
                        <span>
                            <label id="photoupload-help-desc" for="photoupload-form-filechooser">
                                <@uploadInstructionText mode=mode/>
                                <#if fieldErrors?has_content >
                                    <#if fieldErrors['image']?exists >
                                        <div>
                                            <span class="jive-error-message">${fieldErrors['image'][0]}</span>
                                        </div>
                                        <@changeFocusToInvalidInputElement/>
                                    <#elseif fieldErrors['imageType']?exists>
                                        <div>
                                            <span class="jive-error-message">
                                            <@s.text name="photoavatar.upload.desc.photo.error.message">
                                                <@s.param>${statics['com.jivesoftware.util.ByteFormat'].getInstance().formatKB(jiveContext.attachmentManager.maxAttachmentSize)}</@s.param>
                                            </@s.text>
                                            </span>
                                        </div>
                                        <@changeFocusToInvalidInputElement/>
                                    </#if>
                                </#if>
                            </label>
                        </span>

                        <input type="file" name="image" class="jive-form-element-file" id="photoupload-form-filechooser" aria-label="<@s.text name='post.attach_files.gtitle'/>"/>
                        <#--  Swissre Theme migration  -->
                        <div style="font-size:12px">Do not attach / upload copyrighted information.</div>
                    </div>
                    <div class="j-form-row j-form-buttons clearfix">
                        <button type="submit" class="j-btn-callout"><@s.text name="photoavatar.upload.button.submit" /></button>
                        <a href="<@s.url value="/${actionName}!cancel.jspa?targetUser=${targetUser.ID?c}"/>" class="j-btn-global"><@s.text name="global.cancel" /></a>
                    </div>
                </form>
                </div>

			</div>

        </div>
    </div>
    <!-- END large column -->


</div>
<!-- END layout -->


</body>
</html>

<#macro uploadInstructionText mode>
    <#if mode="PROFILE">
        <@s.text name="photoavatar.upload.desc.photo">
            <@s.param>${statics['com.jivesoftware.util.ByteFormat'].getInstance().formatKB(jiveContext.imageManager.maxImageSize)}</@s.param>
        </@s.text>
    <#else>
        <@s.text name="photoavatar.upload.desc.avatar">
            <@s.param>${statics['com.jivesoftware.util.ByteFormat'].getInstance().formatKB(jiveContext.imageManager.maxImageSize)}</@s.param>
        </@s.text>
    </#if>
</#macro>

<#macro changeFocusToInvalidInputElement>
    <@resource.javascript>
        $j(function() {
            var errInputElems = $j("#photoupload-form-filechooser");
            errInputElems.attr("aria-invalid", "true");
            errInputElems.focus();
        });
    </@resource.javascript>
</#macro>
