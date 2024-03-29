﻿ <!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.
Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.
Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.
However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.
In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:
Your custom code
• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.
	/admin/
	/core/
	/Application.cfc
	/index.cfm
You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.
For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfparam name="objectparams._p" default="1" >
<cfset objectParams.render = "server" />
<cfset objectParams.async = "true"/>

<cfif len(arguments.objectid)>
	<cfif IsValid('uuid', arguments.objectid)>
		<cfset local.formBean = $.getBean('content').loadBy( contentid=arguments.objectid ) />
	<cfelse>
		<cfset local.formBean = $.getBean('content').loadBy( title=arguments.objectid, type='Form') />
	</cfif>
	<cfset $.event('formBean',local.formBean)>
	<cfset variables.formOutput=application.pluginManager.renderEvent("onForm#local.formBean.getSubType()#BodyRender",variables.event)>
	<cfset safesubtype=REReplace(local.formBean.getSubType(), "[^a-zA-Z0-9_]", "", "ALL")>
	<cfif not len(variables.formOutput)>
		<cfset variables.formOutput=$.dspObject_include(theFile='extensions/dsp_Form_' & safesubtype & ".cfm",throwError=false)>
	</cfif>
	<cfif not len(variables.formOutput)>
		<cfset filePath=$.siteConfig().lookupContentTypeFilePath('form/index.cfm')>
		<cfif len(filePath)>
			<cfsavecontent variable="variables.formOutput">
				<cfinclude template="#filepath#">
			</cfsavecontent>
			<cfset variables.formOutput=trim(variables.formOutput)>
		</cfif>
	</cfif>
	<cfif not len(variables.formOutput)>
		<cfset filePath=$.siteConfig().lookupContentTypeFilePath(lcase('form_#safesubtype#/index.cfm'))>
		<cfif len(filePath)>
			<cfsavecontent variable="variables.formOutput">
				<cfinclude template="#filepath#">
			</cfsavecontent>
			<cfset variables.formOutput=trim(variables.formOutput)>
		</cfif>
	</cfif>
	<cfif len(variables.formOutput)>
		<cfoutput>#variables.formOutput#</cfoutput>
	<cfelse>
		<cfif isJSON( local.formBean.getBody())>
			<cfset objectparams.objectid=local.formBean.getContentID()>

			<cfset local.formJSON = deserializeJSON( local.formBean.getBody() )>

			<cftry>
			<!---<cfif structKeyExists(local.formJSON.form.formattributes,"muraormentities") and local.formJSON.form.formattributes.muraormentities eq true>--->
			<cfset objectParams.render = "client" />
			<cfset objectParams.async = "true"/>
			<cfparam name="objectParams.view" default="form"/>

			<cfif len($.event('saveform'))>
					<cfset $.event('fields','')>

					<cfset objectParams.errors=$.getBean('dataCollectionBean')
						.set($.event().getAllValues())
						.submit($).getErrors()>

					<cfif not structCount(objectParams.errors)>
						<cfset objectParams.responsemessage=$.renderEvent(eventName="onFormSubmitResponseRender",objectid=local.formBean.getContentID())>
					<cfif not len(objectParams.responsemessage)>
						<cfset objectParams.responsemessage=$.renderEvent(eventName="onSubmitResponseRender",objectid=local.formBean.getContentID())>
					</cfif>

					<cfif len($.event('redirect_url'))>
						<cfset $.event('redirect_url',variables.$.getBean('utility').sanitizeHref($.event('redirect_url')))>
						<cfif request.muraFrontEndRequest>
							<cflocation addtoken="false" url="#$.event('redirect_url')#">
						<cfelse>
							<cfset request.muraJSONRedirectURL=$.event('redirect_url')>
						</cfif>
					</cfif>



					<cfif not len(objectParams.responsemessage)>
						<cfif local.formBean.getResponseChart()>
							<cfset objectParams.responsemessage=trim($.dspObject_Include(thefile='datacollection/dsp_poll.cfm'))>
						</cfif>
						<cfset objectParams.responsemessage=objectParams.responsemessage & $.setDynamicContent(local.formBean.getResponseMessage())>
					</cfif>
				</cfif>

				<cfloop collection="#objectParams#" item="local.param">
      		<cfif listLast(local.param,'_') eq 'attachment' and not isValid('uuid',objectParams[local.param])>
						<cfset structDelete(objectParams,local.param)>
					</cfif>
				</cfloop>

			<cfelseif len($.event('validateform'))>
				<cfparam name="objectparams.fields" default="">
				<cfset objectParams.errors=$.getBean('dataCollectionBean')
				.set($.event().getAllValues())
				.validate($,$.event('fields')).getErrors()>
			<cfelseif request.muraApiRequest>
				<cfscript>
						objectParams.render = "client";
				 		objectParams.async = "true";

						 if(not arguments.RenderingAsRegion){
							if(isdefined('local.formJSON.form.fields')){
								for(b in local.formJSON.form.fields){
										field=local.formJSON.form.fields[b];
										if(structKeyExists(field,'value')){
											local.formJSON.form.fields[b].value=$.setDynamicContent(field.value);
										}

										if(isDefined('field.fieldtype.isdata') && field.fieldtype.isdata==1){
											local.formJSON.datasets['#field.datasetid#']=$.getBean('formBuilderManager').processDataset( $, local.formJSON.datasets['#field.datasetid#'] );
										}
									}
							}

							request.cffpJS=true;
							
							objectParams.def=serializeJSON(local.formJSON);

							objectParams.ishuman=$.dspObject_Include(thefile='form/dsp_form_protect.cfm');
					 	}

						if(!this.layoutmanager && local.formBean.getDisplayTitle() > 0){
						 	objectParams.label=local.formBean.get('title');
					 	}

   						objectParams.filename=local.formBean.get('filename');
					 	objectParams.name=local.formBean.get('title');
   					 	objectParams.responsemessage=local.formBean.get('responseMessage');
						objectParams.responsechart=local.formBean.get('responsechart');
   				 </cfscript>
			</cfif>
			<cfcatch>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset objectParams.render = "server" />
			<cfoutput>#$.dspObject_include(thefile='datacollection/index.cfm',objectid=arguments.objectid,params=objectparams)#</cfoutput>
		</cfif>
	</cfif>
<cfelse>
	<cfset objectParams.render = "server" />
	<cfset objectParams.async = "true"/>
</cfif>
