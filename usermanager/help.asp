<%
sItem = "divConcepts"
If Not IsNull( Request( "item" ) ) Then
	sItem = Request( "item"  )
End If
%>
<html>
<link rel="stylesheet" href="../styles.css">
<script language="JScript">
var initialOpen = '<%=sItem%>';

function Expand( sLayer ) {
	var oLayer = document.all( sLayer );
	if ( oLayer ) {
		oLayer.style.display = ( oLayer.style.display == 'none' ) ? '' : 'none';
	}
}
</script>
<body onload="Expand( initialOpen )">
<p class="maintitle">HELP &gt; Content Manager Explorer for Content Staff</p>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divConcepts' )">&gt;&gt; 
      Concepts</a></td>
  </tr>
</table>
<div id="divConcepts" style="display:none">
  <p>This is the main room to make content changings.</p>
  <p>The navigation thru this software is supposed to be intuitive to anyone that 
    had any contact with other file system navigation software as Windows Explorer 
    or Mac OS Finder. Basically, you click on a folder and dives into it, you 
    click on a file and you open a menu box where you can choose an Editor module 
    to manage this file, and to navigate back to the parent folder you can click 
    in the top folder where it&acute;s name is between brackets (as '[ parent 
    folder\.. ]&quot;, for example).</p>
  </div>

  <table width="100%" border="0" cellspacing="2" cellpadding="0">
    <tr> 
      
    <td class="helptitle"><a href="javascript:Expand( 'divModules' )">&gt;&gt; Modules 
      Menu </a></td>
    </tr>
  </table>
  <div id="divModules" style="display:none"> 
    
  <p>The idea of the modules menu is fairly simple: you click on a file and a 
    menu shows up so you can choose the right editor.</p>
  <p>Usually the developer will take care of preparing this file with the correct 
    settings and he will tell you which editor to use. Which means that you must 
    know which one is the correct editor for the particular file you want to edit.</p>
  <p>Be careful when opening files with a wrong editor. When you do that you will 
    usually see the editor without any content, as it was a blank file. If you 
    don&acute;t save it, nothing harmful will happen, but if you do save it, then 
    the file will be overwritten and it&acute;s previous content will be lost. 
    So be careful, if you have any doubt call your system administrator.</p>
  <p>If you have doubts about what a particular 
  editor does, you can select it and click on the &quot;Info&quot; button instead 
  of the &quot;Open&quot; button. It should give you a few informations regarding 
  the use of it.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divTemplate' )">&gt;&gt; 
      New Event (thru Templates)</a></td>
  </tr>
</table>
<div id="divTemplate" style="display:none">
  <p>This feature let´s you create a new event based on the current template.
  For example: you can use the template named "soccer" to create an event named
  "Calcio Italiano". This command will use the pages and structures defined in 
  the "soccer" template and create the event with it. The pages will all be left
  ready to use in all sites.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divEvents' )">&gt;&gt; 
      Events Manager</a></td>
  </tr>
</table>
<div id="divEvents" style="display:none">
  <p>This module allows you to assign available Events (created thru the 
  <a href="javascript:Expand( 'divTemplate' )">Templates System</a>) to
  "categories". You can create a new category (not recommended for 
  non-developers) or simply choose a Root (site) and click "Search" so
  a list of already available categories will be listed so you can choose
  one with a single click. After selecting a category Label and a Root hit
  "Search" again and this time 2 lists will show up: the left one is the
  list of events already associated to the chosen category, and the right
  side list displays all the available events. You can now select and 
  deselect them as you wish.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divTrouble' )">&gt;&gt; 
      Troubleshooting</a></td>
  </tr>
</table>
<div id="divTrouble" style="display:none">
  <p>If you´re having javascript errors or any other error message the
	very FIRST thing to try is clicking on the "Check Compatibility" link at
	the end of the page. It will open up a pop-up window. Things that can cause
	problems is:
	<li> You´re not using a Intel-compatible PC machine;
	<li> You´re not using a Microsoft Internet Explorer 5.0 or newer;
	<li> You don´t have JScript enabled in your browser (report you local administrator);
	<li> You don´t have the required component installed (if that´s the case wait until
	the pop-up stops loading: it´s already downloading the component for you. Just accept
	if after the download and don´t interrupt this process.</p>
  <p>If this doesn´t help then send a very detailed e-mail to the developer 
	<a href="mailto:akita@psntv.com">Fabio Akita</a> with complete report of the steps
	that leads to the error, the transcription of the error and any other thing you 
	think is important. Simply "it´s buggy" will not help, so be clear and direct.</p>
  </div>

</body>
</html>