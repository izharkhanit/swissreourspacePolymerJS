<!DOCTYPE html>
<html>
<head>
    <title><@s.text name="vidpicker.insert_video.title" /></title>
	<link rel="stylesheet" href="<@resource.url value='/styles/jive-base.css'/>" type="text/css" media="all" />
	<link rel="stylesheet" href="<@resource.url value='/styles/jive.css'/>" type="text/css" media="all" />
	<link rel="stylesheet" href="<@resource.url value='/styles/jive-popup.css'/>" type="text/css" media="all" />
	<link rel="stylesheet" href="<@resource.url value='/styles/tiny_mce3/plugins/jivevideo/css/video.css'/>" type="text/css" media="all" />

    <@soy.render template="jive.skin.template.javascript.header" />
    <@resource.javascript header="true" output="true" />

    <@soy.render template="jive.skin.template.javascript.amdSupport" id="core" />
    <@resource.javascript file="/resources/scripts/jive/namespace.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/jive/app.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/jive/ext/x/x_core.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/jive/ext/x/x_event.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/utils.js" header="true" id="core"/>

    <@resource.javascript file="/resources/scripts/jquery/jquery.oo.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/jive.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/tiny_mce3/tiny_mce_popup.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/tiny_mce3/utils/form_utils.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/tiny_mce3/utils/validate.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/tiny_mce3/utils/editable_selects.js" header="true" id="core"/>
    <@resource.javascript file="/resources/scripts/tiny_mce3/plugins/jivevideo/js/video.js" header="true" id="core" />
    <@resource.javascript file="/resources/scripts/lib/jiverscripts/src/compat/array.js" header="true" id="core" />

    <@resource.javascript header="true" id="core" output="true" />




    <script type="text/javascript">
        function adjustForTabs() {
            var t = this, vp = t.dom.getViewPort(window), dw, dh;

            dw = t.getWindowArg('mce_width') - vp.w + 80;
            dh = t.getWindowArg('mce_height') - vp.h;

            if (t.isWindow)
                window.resizeBy(dw, dh);
            else
                t.editor.windowManager.resizeBy(dw, dh, t.id);

        }

        tinyMCEPopup.resizeToInnerSize = adjustForTabs;

          function validateVideoUpload() {

            if (arguments.length > 0) {
                window.onbeforeunload = null;
            }

            if (!__postSubmitted) {
                __postSubmitted = true;
                return true;
            }
            return false;
        }
    </script>
</head>

<#assign videoEnabled=false/>

<body id="video" class="jive-body-popup jive-body-popup-video">
    <!-- BEGIN main body popup container -->
    <div id="jive-body-popup-container">
        <!-- BEGIN jive body popup -->
        <div id="jive-body-popup">
            <#assign component = UIComponents.getUIComponent('video-picker-tabs') />

            <!-- BEGIN tabs -->
            <nav class="jive-body-tabbar j-tab-nav">
                <ul class="j-tabbar">
                    <@jive.displayTabs component ; tab>
                        <#assign firstTab = true />
                        <li id="jive-${tab.id}-tab" class="jive-body-tab<#if view == tab.id> active j-ui-elem</#if>">
                            <a title="<@s.text name="${tab.description}"/>" href="#" onclick="jiveToggleTab('jive-${tab.id}', new Array(<#list component.tabs as nextTab><#if nextTab.id != tab.id><#if (nextTab_index > 0 && !firstTab)>, </#if>'jive-${nextTab.id}'<#assign firstTab = false /></#if></#list>)); return false;"><span class="${tab.CSSClass!}<#if view == tab.id> j-ui-elem</#if>"></span><@s.text name="${tab.name}" /></a>
                        </li>
                    </@jive.displayTabs>
                </ul>
            </nav>
            <!-- END tabs -->

            <!-- BEGIN web video tab -->
            <div id="jive-web" <#if videoEnabled>style="display:none;"</#if> class="jive-tab-content clearfix">
                <div class="jive-tab-content-padding">
                    <form onsubmit="insertVideo();return false;" action="#" name="webform" id="webform">
                        <input type="hidden" name="sourceDomain" id="sourceDomain" value="">
                        <input type="hidden" name="site" id="site" value="">
                        <input type="hidden" name="videoId" id="videoId" value="">
                        <input type="hidden" name="container" value="${container.ID?c}">
                        <input type="hidden" name="containerType" value="${container.objectType?c}"">
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                            <tr>
                                <td>
                                    <label id="embed_lbl" for="embed"><@s.text name="vidpicker.embed_title" /></label><br />
                                    <@s.text name="vidpicker.embed_example" />
                                </td>
                            </tr>
                            <tr id="width_row">
                                <td valign="top" class="jive-web-video-textarea">
                                    <textarea name='embed' id="embed" style="width: 100%; height: 150px;"></textarea>
                                    <@s.text name="vidpicker.site_list.label" /> <span id="sourceList"></span>
                                </td>
                            </tr>
                         </table>

                        <!-- BEGIN selection bar -->
                        <div class="jive-selection-bar clearfix">
                            <div class="jive-selection-bar-padding">
                                <span id="invalid">{#jivevideo.embed_error}</span>
                                <div class="jive-selection-buttons">
                                     <input type="submit" id="insert" name="insert" value="<@s.text name="vidpicker.insert_video.gtitle" />" disabled="disabled" />
                                </div>
                            </div>
                        </div>
                        <!-- END selection bar -->
                    </form>
                </div>
            </div>
            <!-- END web video tab -->

        </div>
    </div>

    <span id="jive-attach-maxfiles" style="display:none;"></span>

</body>
</html>
