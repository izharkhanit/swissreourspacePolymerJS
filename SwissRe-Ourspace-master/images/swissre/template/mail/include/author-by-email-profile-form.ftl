<#if jiveContext.getEmailInteractionManager().getCanCreateProfileContent(user) && (!user.isPartner() || (user.isPartner && jiveContext.getSharedGroupManager().isEnabled())) >

    <#assign createableContentTypes = jiveContext.getEmailInteractionManager().getContentTypesCreateableInProfile(user) >
    
     <div id="vcard-modal-prompt">
         <p>
         <#assign emailDestInstanceName = jiveContext.communityManager.rootCommunity.name />
         <@s.text name="author.by.email.modal.profile.instr" ><@s.param>${emailDestInstanceName?html}</@s.param></@s.text>
         </p>

         <br>
         <strong><@s.text name="author.by.email.modal.profile.prompt" /></strong>
         <br>
         <br>
         <ul class="j-simple-list">
             <#list createableContentTypes as createableContent>
                 <li>
                 <#-- Swissre Theme migration  --> 
                 <#if "${createableContent.ID?c}" != "3227383"  &&  "${createableContent.ID?c}" != "1">
                 <input type="checkbox" name="vCardObjectTypes" id="vcard_status-${createableContent.ID?c}" value="${createableContent.ID?c}"/>
                     <label for="vcard_status-${createableContent.ID?c}">
                     <@s.text name="author.by.email.profile.${createableContent.code}.prompt" >
                        <@s.param>${action.getPersonalCreateContentEmail(createableContent.ID)}</@s.param>
                        <#if createableContent.ID == JiveConstants.BLOGPOST>
                                <@s.param>${personalBlog.name?html}</@s.param>
                        </#if>
                     </@s.text>
                     </label> 
                   <#-- Swissre Theme migration  -->
                   </#if>
                 </li>
             </#list>
         </ul>
         <br>
         
         <input type="submit" id="vcard-email-button" disabled="true" class="j-btn-callout" onclick="emailVCard('<@s.url action='email-inbox-vcards'><@s.param name='view'>profile</@s.param></@s.url>'); return false;" value="<@s.text name="author.by.email.modal.profile.email" />" />
         <input type="submit" class="close" onclick="return false;" value="<@s.text name='author.by.email.modal.close' />" align="right"/>

     </div>

     <div id="vcard-modal-results" style="display:none;"></div>

</#if>
