<!--
	General Document Applet
	akita@psntv.com
	16/08/2001
	alpha candidate release .1
-->
<html>
<head>
<title>General Document Editor</title>
<link rel="stylesheet" href="../../styles.css">
<link rel="stylesheet" href="editor.css">
<script language="JScript">
var sXMLPath = '<%=Request( "xmlfile" )%>';
<!-- #include file="editor.js"-->
</script>
</head>

<body unselectable="on" onload="refreshEditor()">
<form name="formEditor">
<table>
	<tr><td>Title: </td><td><input type="text" name="title" size="30"></td>
		<td>Subtitle: </td><td><input type="text" name="subtitle" size="30"></td></tr>
	<tr><td>Author: </td><td><input type="text" name="author" size="30"></td>
		<td>Date: </td><td><input type="text" name="date" size="11" disabled>
		<button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="OpenCalendar( formEditor.date )"><img src="imgs/props.gif" alt="Choose date"></button></td></tr>
</table>

<div class="tbToolbar">
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Bold' )"><img src="imgs/bold.gif" alt="Bold"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Italic' )"><img src="imgs/italic.gif" alt="Italic"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Underline' )"><img src="imgs/under.gif" alt="Underline"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Cut' )"><img src="imgs/cut.gif" alt="Cut Text"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Copy' )"><img src="imgs/copy.gif" alt="Copy Text"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Paste' )"><img src="imgs/paste.gif" alt="Paste Text"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Indent' )"><img src="imgs/indent.gif" alt="Indent Block"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Outdent' )"><img src="imgs/outdent.gif" alt="Outdent Block"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'InsertOrderedList' )"><img src="imgs/orderedlist.gif" alt="Insert Ordered List"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'InsertUnorderedList' )"><img src="imgs/unorderedlist.gif" alt="Insert Unordered List"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'JustifyLeft' )"><img src="imgs/left.gif" alt="Justify Left"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'JustifyCenter' )"><img src="imgs/center.gif" alt="Justify Centered"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'JustifyRight' )"><img src="imgs/right.gif" alt="Justify Right"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'InsertImage' )"><img src="imgs/image.gif" alt="Add Image"></button></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'CreateLink' )"><img src="imgs/link.gif" alt="Add Link"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'Print' )"><img src="imgs/print.gif" alt="Print this document"></button></td>
<td><div class="tbSeparator"></div></td>
<td><button class="tbButton" onmouseup="HandleEvent( this, 'up' )" onmousedown="HandleEvent( this, 'down' )" onmouseover="HandleEvent( this, 'over' )" onmouseout="HandleEvent( this, 'out' )" onclick="Toggle( 'source' )" style="width: 50px"> source </button></td></tr>
</table>
</div>

<div id="divEdit" contentEditable="true"></div>
<textarea name="buffer" style="position: absolute; top:-300px; left:-300px"></textarea>

<p>&nbsp;</p>
<div id="divSource" style="display: none"></div>

</form>
</body>
</html>