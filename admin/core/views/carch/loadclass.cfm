 <!--- This file is part of Mura CMS.

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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent>
	<cfset request.layout=false>
	<cfparam name="rc.layoutmanager" default="false">
	<cfparam name="rc.contentid" default="">
	<cfparam name="rc.parentid" default="">
	<cfparam name="rc.contenthistid" default="">
	<cfparam name="rc.objectid" default=""/>

	<cfif rc.layoutmanager>
		<cffunction name="renderClassOption" output="false">
			<cfargument name="object">
			<cfargument name="objectid" default="">
			<cfargument name="objectname" default="">
			<cfargument name="objectlabel">

			<cfif not isDefined('arguments.objectlabel')>
				<cfset arguments.objectlabel=arguments.objectname>
			</cfif>

			<cfreturn '<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="#esapiEncode('html_attr',arguments.object)#" data-objectid="#esapiEncode('html_attr',arguments.objectid)#" data-objectname="#esapiEncode('html_attr',arguments.objectname)#">#esapiEncode('html',arguments.objectlabel)#</div>'>
		</cffunction>
	</cfif>
</cfsilent>

<cfset dirPrefix="objectclass/">

<cfswitch expression="#rc.classid#">
	<cfcase value="component">
		<cfinclude template="#dirPrefix#dsp_components.cfm">
	</cfcase>
	<cfcase value="mailingList">
		<cfinclude template="#dirPrefix#dsp_mailinglists.cfm">
	</cfcase>
	<cfcase value="system">
		<cfinclude template="#dirPrefix#dsp_system.cfm">
	</cfcase>
	<cfcase value="navigation">
		<cfinclude template="#dirPrefix#dsp_navigation.cfm">
	</cfcase>
	<cfcase value="form">
		<cfinclude template="#dirPrefix#dsp_forms.cfm">
	</cfcase>
	<cfcase value="adzone">
		<cfinclude template="#dirPrefix#dsp_adzones.cfm">
	</cfcase>
	<cfcase value="Folder">
		<cfinclude template="#dirPrefix#dsp_Folders.cfm">
	</cfcase>
	<cfcase value="calendar">
		<cfinclude template="#dirPrefix#dsp_calendars.cfm">
	</cfcase>
	<cfcase value="gallery">
		<cfinclude template="#dirPrefix#dsp_galleries.cfm">
	</cfcase>
	<cfcase value="localFeed">
		<cfinclude template="#dirPrefix#dsp_localfeeds.cfm">
	</cfcase>
	<cfcase value="slideshow">
		<cfinclude template="#dirPrefix#dsp_slideshows.cfm">
	</cfcase>
	<cfcase value="remoteFeed">
		<cfinclude template="#dirPrefix#dsp_remotefeeds.cfm">
	</cfcase>
	<cfcase value="plugins">
		<cfinclude template="#dirPrefix#dsp_plugins.cfm">
	</cfcase>
</cfswitch>

<cfif not rc.layoutmanager>
	<cfif fileExists("#application.configBean.getWebRoot()#/#rc.siteid#/includes/display_objects/custom/admin/dsp_objectClass.cfm")>
		<cfinclude template="/#application.configBean.getWebRootMap()#/#rc.siteID#/includes/display_objects/custom/admin/dsp_objectClass.cfm">
	</cfif>
</cfif>

