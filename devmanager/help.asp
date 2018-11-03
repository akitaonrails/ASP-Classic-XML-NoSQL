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
<title>Help</title><body onload="Expand( initialOpen )">
<p class="maintitle">HELP &gt; Content Manager Explorer for Developers</p>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divConcepts' )">&gt;&gt; 
      Concepts</a></td>
  </tr>
</table>
<div id="divConcepts" style="display:none">
  <p>This is the main room to make any changes to the XML platform. The &quot;Explorer&quot; 
    idea is intended to present an easy way to navigate thru complex structures. 
    Visually it&acute;s a usual file system navigation, but underneath this rather 
    simple interface relies a complex VBScript class called TXMLSynchro. This 
    component tries to encapsulate file system operations and, at the same time, 
    maintains a mirror based on Oracle tables. </p>
  <p>The raw navigation is based entirely in the native support of the file system, 
    so information as file size, last modified date record, nested sub-folders 
    realization are all built-in. When an operation as creating a Shortcut or 
    making Associations is requested, the operation is executed transparently 
    in both the file system and the database table. This is necessary because 
    the file must have some special properties not supported by a file system. 
    And in the future this will allow new modules as a search engine, a bookmark 
    system, and other special features that can take advantage of this extended 
    architecture.</p>
</div>

  <table width="100%" border="0" cellspacing="2" cellpadding="0">
    <tr> 
      <td class="helptitle"><a href="javascript:Expand( 'divRoot' )">&gt;&gt; 
        Root Manager</a></td>
    </tr>
  </table>
  <div id="divRoot" style="display:none"> 
    <p>Before using the Content Manager for the first time, the developer must 
      define at least one special folder that is called the &quot;root folder&quot;.</p>
    <p>This folder has one requirement: it must be visible thru the same webserver 
      as this tool. For example, if we want to define a folder like this:</p>
    
  <p class="commands">c:\inetpub\wwwroot\xmldata\folder1</p>
    <p>So we must have a URL that points that as</p>
    
  <p><span class="commands">http://yourserver/folder1 </span><br>
      or<br>
    <span class="commands">http://yourserver/xmldata/folder1</span></p>
    <p>Or any other variation that allows a 2 way convertion between the physical 
      root folder and the virtual root URL.</p>
    
  <p>When adding a new root folder you will have to fill in the complete physical 
    path as shown above. Then you will need to fill in the root URL, but instead 
    of writing down as above you will have to input as follows:</p>
    <p>&quot;/folder1&quot;, for the first example above or &quot;/xmldata/folder1&quot; 
      for the second one. </p>
    
  <p>This is necessary because the client part of this tool have to load the files 
    from the same server where it is, so you should not provide another webserver 
    name or the tool will possibly fail down.</p>
  <p>This root folder is the starting point for the Content Manager Explorer navigator. 
    It&acute;s a good idea to have one root folder for each language and a global 
    language-free root for data that can be shared between different websites 
    with different languages. </p>
  <p>This mix is useful in a scenario where you will have a XML file that can 
    be shared between several websites (tables with numeric values and people 
    names are not dependent of language). Then each website would have it&acute;s 
    own XSL style file that have the correct languages. Those XSL files would 
    read from the same XML file and mask it correctly. </p>
  <p>This means that updating a single XML file would be enough to feed all websites. 
    The XSL files are static and need to be build up only once. This is the main 
    idea of this platform.</p>
  </div>


<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divTools' )">&gt;&gt; Basic 
      Tools</a></td>
  </tr>
</table>
<div id="divTools" style="display:none">
  <p>While all the complex operations are encapsulated in the TXMLSynchro class, 
    it&acute;s user interface is very simple and is sort of intuitive to anyone 
    that has used any kind of file system navigation as Windows Explorer os Mac 
    Finder.</p>
<p>The basic idea is that every object has some methods that can be applied to 
  it. For instance, folders have a method that allows opening it and revealing 
  it&acute;s contents; files have methods as opening it for edition or erasing 
  it. Every single click in every object will open a small context box with it&acute;s 
  available operations.</p>
<p>Each navigational page state reflects the content of a folder. If it&acute;s 
  not the root folder you can go back to the parent folder by clicking on it&acute;s 
  name at the top, where it&acute;s name is between brackets.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divEditing' )">&gt;&gt; 
      Editing Files</a></td>
  </tr>
</table>
<div id="divEditing" style="display:none">
  <p>Both folders and files have a common &quot;Open&quot; method. This method 
    has a different meaning for each one. &quot;Opening&quot; a folder means revealing 
    it&acute;s nested folders and files. &quot;Opening&quot; a file means editing 
    it&acute;s text content. When a file is opened, it will reveals another floating 
    window where it&acute;s content will be shown. As this is an interface for 
    developers, the raw content of each file will be shown and it&acute;s a task 
    of the developer himself to edit it without damaging it&acute;s integrity 
    (forgetting to close a xml node, for example, or leaving erroneous node inside).</p>
  <p>The files will be edited following some pre-prepared pattern based on the module 
    that the developer wants the user to use. For example, the Simple Table Module 
    requires some special nodes inside the XML file (more in the Simple Table 
    Module documentation) and also requires a special XSL and Schema file, and 
    these files must be associated (more on Association below).</p>
  <p>This feature requires the developer to be well aware about how to use XML. 
    If a module fails to open a created file the first option is that the syntax 
    of the XML is wrong, so be careful when editing source code of a file.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divFolder' )">&gt;&gt; 
      Add Folder</a></td>
  </tr>
</table>
<div id="divFolder" style="display:none">
  <p>This is a simple operation. Simply input a description, fill in the path 
    with a valid folder name (the system will filter and convert some things but 
    it&acute;s important to follow some consistent standards). The system will 
    only allow lowercase names, all spaces will be converted to underlines and 
    it will now allow strange characters as &quot;#&quot; or &quot;%&quot;. </p>
<p>You can create a hidden folder (hidden for the User Explorer) using a dot before 
  the name of the folder. This is useful when you want to hide implementation 
  details from the user.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divFile' )">&gt;&gt; Add 
      File</a></td>
  </tr>
</table>
<div id="divFile" style="display:none">
<p>This is as simple as creating a folder, although it has a few more options. 
  First, fill in the description box, then the filename following the same consistent 
  rules as the folder name and don&acute;t place any extention to it (as &quot;.txt&quot; 
  or something like that, simply put a name), choose between the filetypes (XML, 
  XSL and Schema). Fill in your name in the Author field (it&acute;s important 
  to know who make this file so maintainability becomes easier) and, optionally, 
  an assigned Responsible name in the last field it someone else is responsible 
  in the maintanance of this particular file.</p>
  <p>And, as the folder name rule, you can make a hidden file for the user by 
    placing a dot before it&acute;s name. It&acute;s better to hide details from 
    the final user, so you should create Schema file and Style files prepending 
    them with a dot so they don&acute;t show up in the Content Manager for Content 
    Staff. </p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divAssociation' )">&gt;&gt; 
      Make Association</a></td>
  </tr>
</table>
<div id="divAssociation" style="display:none"> 
  <p>This is one of the reasons why there&acute;s a database based mirror of the 
    file system. An XML file can have 2 default associations to other files: a 
    style file and a schema file. The style field has not use for the time being 
    so concentrate on the XML and Schema fields. </p>
  <p>The only module that requires an Association is the Simple Table. In this 
    case you will associate an XML data file with an XML Schema file. Be careful 
    to not do the opposite: read the XML and Schema fields carefully.</p>
  <p>This is interesting because you can have a single Schema file associated 
    to many XML data files. The Schema servers as a mask, a guideline so the Simple 
    Table Module &quot;understands&quot; the contents of the XML data files.</p>
  <p>If the Simple Table Module fails to recognize the data file there are 3 possibilities:</p>

<ol>
  <li>the XML data file has wrong XML syntax;</li>
  <li>the Schema file has wrong XML syntax;</li>
  <li>the Association is inverted or wrong.</li>
</ol>
<p>So be very careful with these 3 points.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divShortcut' )">&gt;&gt; 
      Add Shortcut</a></td>
  </tr>
</table>
<div id="divShortcut" style="display:none">
  <p>This is the last step when creating a file. After making all association 
    you can make an external link between an XML file and the final front-end 
    XSL-T file. This XSL-T is intended to merge with the final website and contains 
    the HTML (XHTML, actually) that gives the XML&acute;s data the correct &quot;face&quot;.</p>
  <p>This shortcut is optional, but by using it and instantiating the TXMLFront 
    class in the front-end ASP files (the txmlfront.asp global dyninc), a single 
    pair of lines will load both XML and XSL files, merging them and rendering 
    it in the final page, making maintanance of the website&acute;s codes easier 
    for the developers as it will save dozens of lines of code.</p>
  <p>The concept of this &quot;shortcut&quot; is sort of similar to that of Windows&acute; 
    shortcuts: it&acute;s a static link to a file. So, if a file is renamed or 
    erased, the shortcut will still remain intact but now pointing to nowhere, 
    and any operation that uses this shortcut will fail. So, delete operation 
    must be used carefully.</p>
  <p>One benefit of the shortcut is that you can make 2 shortcuts with the same 
    label but 2 different languages. For example, a shortcut called &quot;event_calendar&quot; 
    for portuguese and &quot;event_calendar&quot; for spanish. The first one links 
    the common XML data file &quot;calendar.xml&quot; with the correct style &quot;portuguese_calendar.xsl&quot; 
    and the second shortcut links the same XML file &quot;calendar.xml&quot; with 
    the correct &quot;spanish_calendar.xsl&quot; file.</p>
</div>

<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="helptitle"><a href="javascript:Expand( 'divDelete' )">&gt;&gt; 
      Deleting</a></td>
  </tr>
</table>
<div id="divDelete" style="display:none">
  <p>The developer must understand that the delete operation will not commit a 
    physical erasing. It will rename the file or folder placing a &quot;_deleted&quot; 
    string after it&acute;s name and then assign a flag in it&acute;s database 
    record. So not the file nor it&acute;s database record will be permanently 
    thrown away.</p>
  <p>When you try to create a new file with the same name as a previously deleted 
    one it will not create a new blank file, instead it will perform a &quot;recycle&quot; 
    operation and rename the deleted file to it&acute;s original name by re-assigning 
    it&acute;s flag in the database so it becomes active again. So, it&acute;s 
    possible to &quot;undelete&quot; a file or folder by trying to create it again. 
    And any undeleted folder will still have it&acute;s inner folders and files.</p>
<p>But as files and folders are renamed, any shortcut that used them will fail 
  to perform it&acute;s rendering operations as it&acute;s not a dynamic link. 
</p>
<p>So, usually this operation will be used when a file is created with the wrong 
  name, right before using it for any other association or shortcut operation. 
</p>
</div>
</body>
</html>