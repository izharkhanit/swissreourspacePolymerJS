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
	<link rel="stylesheet" href="<@resource.url value='/styles/jquery.Jcrop.css'/>" type="text/css" media="all" />

    <@resource.javascript file="/resources/scripts/jquery/jquery.Jcrop.js"/>	

    <#assign previewImg><#if mode="PROFILE">photo-preview<#else>avatar-preview</#if></#assign>
    <#assign editDivClass>jive-profile-images-edit</#assign>
    <#assign editDivId><#if mode="PROFILE">jive-profile-photo-crop<#else>jive-profile-avatar-crop</#if></#assign>
    <#assign selectDivClass><#if mode="PROFILE">jive-profile-photo-select<#else>jive-profile-avatar-select</#if></#assign>
    <#-- Swissre Theme migration  -->
    <#assign maxHeight><#if mode="PROFILE">625<#else>500</#if></#assign>
    <#assign actionName><#if mode="PROFILE">edit-profile-avatar<#else>avatar-userupload</#if></#assign>

    <@resource.javascript>

        function submitForm(actionUrl) {
            $j('#theForm').attr('action', actionUrl).submit();
        }

        function checkCrop(btn){
            if ($j('#cropWidth').val() == '0' || $j('#cropHeight').val() == '0') {
                $j('#jive-error-box')
                    .append($j('<div/>')
                        .text("<#if mode="PROFILE"><@s.text name="profile.img.invalid_crop_image.text" /><#else><@s.text name="profile.img.invalid_crop_avatar.text" /></#if>")
                        .prepend($j('<span/>').addClass('jive-icon-med jive-icon-redalert'))
                    );
                $j('#jive-error-box').show();
            } else {
                $j(btn).closest('form').submit();
            }
        }

        jQuery(window).load(function() {
            // max dimensions - cannot derive this because the height of the box will move to the size of the image
            var photoBoxWidth = 500;
            var photoBoxHeight = ${maxHeight};

            // actual dimensions of the image
            var imgWidth = jQuery('#cropbox').width();
            var imgHeight = jQuery('#cropbox').height();

            var selectSettings = [0, 0, photoBoxWidth, photoBoxHeight];
            if ( (imgWidth < photoBoxWidth) || (imgHeight < photoBoxHeight) ) {
                selectSettings = [0, 0, imgWidth, imgHeight];
            }

            jQuery('#cropbox').Jcrop({
                onChange: showPreview,
                onSelect: showPreview,
                setSelect: selectSettings,
                aspectRatio: photoBoxWidth / photoBoxHeight,
                borderOpacity: 1
            });

            function showPreview(coords) {
                var previewWidthInt = jQuery('#${previewImg}').width();
                var previewHeightInt = jQuery('#${previewImg}').height();

                var rx = previewWidthInt / coords.w;
                var ry = previewHeightInt / coords.h;   // these numbers are the width / height of the preview box
                $j('#cropX').val(coords.x);
                $j('#cropY').val(coords.y);
                $j('#cropWidth').val(coords.w);
                $j('#cropHeight').val(coords.h);

                jQuery('#preview').css({
                    width: Math.round(rx * imgWidth) + 'px',
                    height: Math.round(ry * imgHeight)  + 'px',
                    marginLeft: '-' + Math.round(rx * coords.x) + 'px',
                    marginTop: '-' + Math.round(ry * coords.y) + 'px'
                });
            }

        });

        // Our simple event handler, called from onChange and onSelect
        // event handlers, as per the Jcrop invocation above

	</@resource.javascript>



</head>
<body class="jive-body-formpage jive-body-formpage-photoavatar">


<header class="j-page-header">
    <h1>${title}</h1>
</header>


<!-- BEGIN layout -->
<div class="j-layout j-layout-l clearfix">

    <!-- BEGIN large column -->
    <div class="j-column-wrap-l">
        <div class="j-column j-column-l">

            <#include "/template/global/include/form-message.ftl"/>
            <div id="jive-error-box" class="jive-error-box" style="display:none;" aria-live="polite" aria-atomic="true"></div>

            <form action="<@s.url action='${actionName}' method="cropImage" />" method="post" id="theForm">
            <input type="hidden" name="cropX" id="cropX"/>
            <input type="hidden" name="cropY" id="cropY"/>
            <input type="hidden" name="cropWidth" id="cropWidth"/>
            <input type="hidden" name="cropHeight" id="cropHeight"/>
            <input type="hidden" name="imageFileName" value="${imageFileName?html}"/>
            <input type="hidden" name="cropBoxImageName" value="${cropBoxImageName?html}"/>
            <input type="hidden" name="tempImageName" value="${tempImageName?html}"/>
            <input type="hidden" name="imageIndex" value="${imageIndex?html}"/>
            <input type="hidden" name="targetUser" value="${targetUser.ID?c}" />
            <#assign editingSelf=true>
            <#if (user.ID!=targetUser.ID)><#assign editingSelf=false></#if>
            <#assign uploadPhotoStep2Text><#if (editingSelf)><@s.text name="photoavatar.upload.step2.photo" /><#else><@s.text name="photoavatar.upload.step2.photo.other_user"></@s.text></#if></#assign>
            <#assign uploadAvatarStep2Text><#if (editingSelf)><@s.text name="photoavatar.upload.step2.avatar" /><#else><@s.text name="photoavatar.upload.step2.avatar.other_user"></@s.text></#if></#assign>
            <#assign cropLabel><#if mode="PROFILE"><@s.text name="photoavatar.crop.button.submit.photo" /><#else><@s.text name="photoavatar.crop.button.submit.avatar" /></#if></#assign>

            <div id="${editDivId}" class="${editDivClass}">

				<ul class="font-color-meta">
					<li><#if mode="PROFILE"><@s.text name="photoavatar.upload.step1.photo" /><#else><@s.text name="photoavatar.upload.step1.avatar" /></#if></li>
					<li><strong class="font-color-normal"><#if mode="PROFILE">${uploadPhotoStep2Text}<#else>${uploadAvatarStep2Text}</#if></strong></li>
					<#if mode == "PROFILE"><li><@s.text name="photoavatar.upload.step3.photo" /></li></#if>
				</ul>


				<div class="j-box j-box-form">
					<p><#if mode="PROFILE">
					        <#if editingSelf>
                                <@s.text name="photoavatar.crop.desc.photo">
					                <@s.param>${jiveContext.communityManager.rootCommunity.name}</@s.param>
					            </@s.text>
                            <#else>
                                <@s.text name="photoavatar.crop.desc.photo.other_user">
                                    <@s.param>${jiveContext.communityManager.rootCommunity.name}</@s.param>
                                </@s.text>
                            </#if>
					    <#else>
					        <#if editingSelf><@s.text name="photoavatar.crop.desc.avatar"/><#else><@s.text name="photoavatar.crop.desc.avatar.other_user"/></#if>
					</#if></p>
					<div id="${selectDivClass}" class="clearfix">
							<div id="photo">
                                <img src="<@s.url action='crop-image-display'/>?tempImageName=${cropBoxImageName?html}" alt="${cropLabel}" id="cropbox" />
                            </div>
							<div id="${previewImg}">
                                <img src="<@s.url action='crop-image-display'/>?tempImageName=${cropBoxImageName?html}" alt="${cropLabel}" id="preview" />
							</div>
					</div>
                    <div class="jive-form-buttons clearfix">
						<button type="button"  class="j-btn-callout" onclick="checkCrop(this)">
                            ${cropLabel}
						</button>
						 <@s.text name="global.or" /> <a href="#" onclick="submitForm('<@s.url action='${actionName}' method="inputImage"/>'); return false;">
						    <#if mode="PROFILE">
						        <@s.text name="photoavatar.crop.link.cancel.photo" />
						    <#else>
						        <@s.text name="photoavatar.crop.link.cancel.avatar" />
						    </#if>
						 </a>
					</div>
				</div>


			</div>
                <input type="submit" class="j-508-label" tabindex="-1" value="<@s.text name='global.save'/>"/>

            </form>

        </div>
    </div>
    <!-- END large column -->


</div>
<!-- END layout -->


</body>
</html>
