<html>
<title>Help - mod_treetable</title>
<link rel="stylesheet" href="../../styles.css">
<script language="JScript">
function OpenSource() {
	var oLayer = document.all('divSource');
	oLayer.innerText = document.all('divExample').innerHTML;
	oLayer.style.display = oLayer.style.display = ( oLayer.style.display == 'none' ) ? '' : 'none';
}
</script>
<body>
<p class="maintitle">Simple Tree Module (MOD_TREETABLE)<br>
  Documentation for Developers </p>
<p class="helptitle">Content</p>
<ol>
  <li><a href="#introduction">Introduction</a></li>
  <li><a href="#xml">The XML Structure</a></li>
  <li><a href="#xsl">The XSL Structure</a></li>
  <li><a href="#final">Final Considerations</a></li>
</ol>
<p class="helptitle"><a name="introduction"></a>Introduction</p>
<p>First, take a look at the <a href="../mod_simpletable/help_developers.asp"><b>Simple 
  Table Module Documentation</b></a>. There are several rules and tips that applies 
  here too. Only go on if you&acute;re sure you read it all before going on.</p>
<p>This module deals with one of the most visually complex tables ever: 90 degree 
  tree-like table. Here&acute;s a simple example:</p>
<div id="divExample">
<table width="300" height="200" border="0" cellspacing="2" cellpadding="0" bgcolor="#FFFFFF">
  <tr> 
    <td valign="middle" rowid="1" colid=""> 
      <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">A</td>
        </tr>
      </table>
    </td>
    <td rowspan="2" valign="middle" align="center"> 
      <table border="0" cellspacing="0" cellpadding="0" height="100%" background="imgs/back.gif" width="16">
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
        <tr valign="top"> 
          <td height="10%"><img src="imgs/up.gif" width="16" height="8"></td>
        </tr>
        <tr> 
          <td height="30%"><img src="imgs/middle.gif" width="16" height="20"></td>
        </tr>
        <tr valign="bottom"> 
          <td height="10%"><img src="imgs/bottom.gif"></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
      </table>
    </td>
    <td rowspan="2" valign="middle"> 
      <table width="100%" height="100%" border="1" cellspacing="2" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">A</td>
        </tr>
      </table>
    </td>
    <td rowspan="4" valign="middle" align="center"> 
      <table border="0" cellspacing="0" cellpadding="0" height="100%" background="imgs/back.gif" width="16">
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
        <tr valign="top"> 
          <td height="10%"><img src="imgs/up.gif" width="16" height="8"></td>
        </tr>
        <tr> 
          <td height="30%"><img src="imgs/middle.gif" width="16" height="20"></td>
        </tr>
        <tr valign="bottom"> 
          <td height="10%"><img src="imgs/bottom.gif"></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
      </table>
    </td>
    <td rowspan="4" valign="middle"> 
      <table width="100%" height="100%" border="1" cellspacing="2" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">C</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td valign="middle" rowid="2" colid=""> 
      <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">B</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td valign="middle" rowid="3" colid=""> 
      <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">C</td>
        </tr>
      </table>
    </td>
    <td rowspan="2" valign="middle" align="center"> 
      <table border="0" cellspacing="0" cellpadding="0" height="100%" background="imgs/back.gif" width="16">
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
        <tr valign="top"> 
          <td height="10%"><img src="imgs/up.gif" width="16" height="8"></td>
        </tr>
        <tr> 
          <td height="30%"><img src="imgs/middle.gif" width="16" height="20"></td>
        </tr>
        <tr valign="bottom"> 
          <td height="10%"><img src="imgs/bottom.gif"></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF" height="25%"><img src="imgs/blank.gif" width="4" height="2"></td>
        </tr>
      </table>
    </td>
    <td rowspan="2" valign="middle"> 
      <table width="100%" height="100%" border="1" cellspacing="2" cellpadding="0" bordercolor="#66CC66" bordercolorlight="#66CC66" bordercolordark="#66CC66">
        <tr align="center"> 
          <td class="result_item">C</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td valign="middle" rowid="4" colid=""> 
      <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#66CC66">
        <tr align="center"> 
          <td class="result_item">D</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
<p><button onclick="OpenSource()">Click here to see the HTML source code</button></p>
<div id="divSource" style="display:none;border: 1px #000000"></div>

<p>For developers, the first to notice is: although it visually looks like the 
  classical &quot;Tree&quot; data structure it actually don&acute;t behaves like 
  one, so the first mistake to avoid is not to think about it as nodes with parent/2 
  children relationship.</p>
<p>The easiest way to think about it is exactly like the HTML is build: a base 
  2 exponential series of columns and rowspans. Although this is not always the 
  case, the XML will mimic the HTML.</p>
<p class="helptitle"><a name="xml"></a>The XML Structure</p>
<p>Here&acute;s the XML of the above example:</p>
<p class="code">&lt;?xml version="1.0" encoding=&quot;iso-8859-1&quot;?&gt; <br>
  &lt;root&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;node&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;name&gt;A&lt;/name&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;subnode&gt;A&lt;/subnode&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;subnode&gt;C&lt;/subnode&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;/node&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;node&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;name&gt;B&lt;/name&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;/node&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;node&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;name&gt;C&lt;/name&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;subnode&gt;C&lt;/subnode&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;/node&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;node&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;name&gt;D&lt;/name&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;/node&gt; <br>
  &lt;/root&gt; </p>
<p>As you see, this time it&acute;s not easy to write it by hand, the same way 
  it&acute;s not easy to write the HTML for this kind of tables with so many rowspans. 
  The important things to notice is that the first column of the tree is defined 
  by the tag &lt;name/&gt;, the first element inside the tag &lt;node/&gt;. So 
  every &lt;node/&gt; will always have a &lt;name/&gt;. Then each following column 
  is defined by the &lt;subnode/&gt; elements. </p>
<p>So, when you first create a table, do the same way as when you do HTML: get 
  the visual editor, in this case, go directly to the Simple Tree Module. And 
  this time you don&acute;t have to create a schema file as the structure of this 
  XML is fixed and can&acute;t be changed anyway. </p>
<p class="helptitle"><a name="xsl"></a>The XSL File</p>
<p>The biggest problem this time is to assemble the XSL file. Actually it&acute;s 
  not difficult, you only have to understand how it gets build. The easiest way 
  to start is going directly to the code:</p>
<p class="code">&lt;?xml version="1.0" encoding="ISO-8859-1"?&gt; <br>
  &lt;xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
  exclude-result-prefixes="msxsl #default user #default" xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
  xmlns:user="http://www.psn.com"&gt; <br>
  &lt;xsl:output method="html" encoding="iso-8859-1" indent="yes"/&gt; </p>
<p class="code"> <b>&lt;msxsl:script language="JScript" implements-prefix="user"&gt; 
  </b><br>
  <font color="#666666">&lt;![CDATA[ <br>
  var intCurrent = 0;<br>
  function GetPow( i ) { <br>
  &nbsp;&nbsp;&nbsp;&nbsp;intCurrent = Math.pow( 2, i );<br>
  &nbsp;&nbsp;&nbsp;&nbsp;return intCurrent; <br>
  } <br>
  function GetCurrent() {<br>
  &nbsp;&nbsp;&nbsp;&nbsp;return intCurrent;<br>
  } <br>
  ]]&gt; </font><br>
  <b>&lt;/msxsl:script&gt; </b></p>
<p class="code"> <b>&lt;xsl:template match="/root"&gt; </b><br>
  &lt;html&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;table width="500" height="500" border="0" cellspacing="0" 
  cellpadding="0"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#660000">&lt;xsl:apply-templates 
  select="node"/&gt; </font><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;/table&gt; <br>
  &lt;/html&gt; <br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code"> <b>&lt;xsl:template match="node"&gt; </b><br>
  &lt;tr valign="middle"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;td&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;table width="100" border="1" 
  cellspacing="0" cellpadding="0"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  align="center"&gt;<font color="#660000">&lt;xsl:value-of select="name"/&gt;</font>&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/table&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;/td&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;<font color="#660000">&lt;xsl:apply-templates select="subnode"/&gt; 
  </font><br>
  &lt;/tr&gt; <br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code"> <b>&lt;xsl:template match="subnode"&gt; </b><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;td rowspan="<font color="#006633">{user:GetPow( 
  position() )}</font>" align=&quot;center&quot;&gt; <br>
  <font color="#666600">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;table 
  border="0" cellspacing="0" cellpadding="0" height="100%" background="back.gif"&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  height="25%"&gt;&lt;img src="blank.gif" width="4" height="2"/&gt;&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr valign="top"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  height="10%"&gt;&lt;img src="up.gif" height="8" width="16"/&gt;&lt;/td&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  height="30%"&gt;&lt;img src="middle.gif" width="16" height="19"/&gt;&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr valign="bottom"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  height="10%"&gt;&lt;img src="bottom.gif" height="8" width="16"/&gt;&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  height="25%"&gt;&lt;img src="blank.gif" width="4" height="2"/&gt;&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/table&gt; </font><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;/td&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;td rowspan="<font color="#006633">{user:GetCurrent()}</font>"&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;table width="50" border="1" 
  cellspacing="0" cellpadding="0"&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td 
  align="center"&gt;<font color="#660000">&lt;xsl:value-of select="."/&gt;</font>&lt;/td&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/table&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;/td&gt; <br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code"> &lt;/xsl:stylesheet&gt;</p>
<p>Now let&acute;s start the explanation in parts (each paragraph above is a separated 
  logic block): </p>
<ol>
  <li>the header is simple and default: just copy and paste it;</li>
  <li>then comes a JScript block. it&acute;s just a matter of copying and pasting 
    as well. It deals with the correct rowspan calculations;</li>
  <li>the first block of layout masks the &lt;root/&gt; element. The important 
    thing here is to define the width and height of the table, no matter if it&acute;s 
    small then it is supposed to be;</li>
  <li>the second layout block defines each node, or better: each HTML table row. 
    As I told before the first column &lt;td/&gt; is always fixed and based on 
    the &lt;name/&gt; element of the &lt;node/&gt;, then comes the columns with 
    rowspans;</li>
  <li>this is the 3rd block, which deals with the rowspans and remaining cells: 
    notice that each block has the &quot;}&quot; illustration. This table has 
    5 rows with the following height raios: 25%, 10%, 30%, 10%, 25%; 
    <ul>
      <li>the first 25% has nothing but a blank image</li>
      <li>the first 10% cell is aligned to the top and that the top of the &quot;}&quot;</li>
      <li>the middle 30% cell has the middle part of the &quot;}&quot;</li>
      <li>the second 10% cell is aligned to the bottom and has the last part of 
        the &quot;}&quot;</li>
      <li>the last 25% has more blank space</li>
    </ul>
    And don&acute;t forget that this cell uses the JScript function GetRow() that 
    calculates the correct rowspan, same thing for the second cell which calls 
    the GetCurrent() (actually it could be GetRow() but this other one don&acute;t 
    recalculates the rowspan, it just uses the cached result from the first call 
    to GetRow);</li>
</ol>
<p>The easiest way to start an XSL like this is to use this one as a model and 
  then build the desired layout overwriting what is needed.</p>
<p class="helptitle"><a name="final"></a>Considerations</p>
<p>As mentioned before, read the Simple Table Documentation, there&acute;s important 
  tips to create and organize the files and shortcuts. The same general rules 
  apply here too.</p>
<p>Another thing not mentioned before is when you need to have more than a line 
  per cell. This is still not defined in this framework model, so you&acute;ll 
  have to use a workaround for the time being. Use the AddReplacer method available 
  in the PSNXML.TXMLFront component. This method replaces strings in the final 
  rendered (XML + XSL) XHTML source. For example: input the data as:</p>
<p class="code">01/01/1900 | Test</p>
<p>And use the method this way:</p>
<p class="code"><font color="#660000">oFront.AddReplacer( &quot;|&quot;, &quot;&lt;br/&gt;&quot; 
  )</font><br>
  If oFront.Load( &quot;shortcut&quot; ) Then<br>
  &nbsp;&nbsp;&nbsp;&nbsp;oFront.Render<br>
  End If</p>
<p>This will replace every &quot;|&quot; (pipe) character for a breakline and 
  the result will be:</p>
<p class="code">01/01/1900 &lt;br/&gt; Test</p>
<p>Use this method wisely. Anything that touches the last source obviously impacts 
  in performance and the bigger the table more it will cost in terms of processing. 
  The impact is the same as the Replace method of VBScript.</p>
<p>As usual, bugs: <a href="mailto:akita@psntv.com">akita@psntv.com</a></p>
</body>
</html>