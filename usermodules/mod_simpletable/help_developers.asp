<html> 
<link rel="stylesheet" href="../../styles.css">
<title>Help - mod_simpletable</title>
<body>
<p class="maintitle">Simple Table Module (MOD_SIMPLETABLE)<br>
  Documentation for Developers</p>
<p class="helptitle">Content</p>
<ol>
  <li><a href="#introduction">Introduction</a></li>
  <li><a href="#xml">The Data File Structure</a></li>
  <li><a href="#schema">The Schema File Structure</a></li>
  <li><a href="#work">Working Example</a></li>
  <li><a href="#xsl">The XSL Style File</a></li>
  <li><a href="#organize">Ways to Organize the Files</a></li>
  <li><a href="final">Final Considerations</a></li>
</ol>
<p class="helptitle"><a name="introduction"></a>Introduction</p>
<p>This tool was intended to build plain 2D tables, which means the basic &quot;lines 
  x columns&quot; concept plus an optional header and footer surrounding it. This 
  type of table covers almost all possible tables for this system. </p>
<p>It requires 2 XML files, both have a pre-defined structure that I will come 
  into soon. The first file is called &quot;XML data file&quot; and the second 
  one is the &quot;Schema file&quot;. Once created they must be associated. There&acute;s 
  3 things to keep in mind while creating them:</p>
<ol>
  <li>create short names but clear enough for a user to understand. For example, 
    avoid &quot;res_jun_01.xml&quot;, try &quot;results_june_2001.xml&quot; instead; 
    it&acute;s not that long and anyone can understand;</li>
  <li>the same rule applies to schema file but in this case always prepend the 
    filename with a dot. For example: &quot;.results_schema.xml&quot;. A prepending 
    dot makes the file invisible when using the Content Explorer for Content Staff, 
    which means that the users will not see those hidden files;</li>
  <li>be very careful while creating Associations. You must pay attention to the 
    fact that the Association dialog box have 2 fields: one for the XML data and 
    another for the Schema file. It&acute;s not rare to invert this order when 
    in a rush. The module will fail to load the files as it will try to load the 
    Schema as it was the data file.</li>
</ol>
<p class="helptitle"><a name="xml"></a>The Data file Structure</p>
<p>The main squeleton of a data file is as follows:</p>
<p class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;iso-8859-1&quot;?&gt;<br>
  &lt;root&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;table&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ 
  ... columns ...]</font><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ 
  ... columns ...]</font> <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ ... more items ... 
  ]</font><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ 
  ... columns ...]</font> <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;/table&gt;<br>
  &nbsp;&nbsp;&nbsp;<font color="#009900">[ ... more tables ...]</font> <br>
  &lt;/root&gt; </p>
<p>All Simple Table data files will have a structure like this one. The columns 
  are defined in the Schema file. Just to make it clear:</p>
<ol>
  <li>don&acute;t forget to put the encoding parameter in the xml header, iso-8859-1 
    is the charset code that allows for accents and other international characters;</li>
  <li>the document top element is always the &lt;root/&gt;;</li>
  <li>you can have many &lt;table/&gt; inside the &lt;root/&gt; block;</li>
  <li>every &lt;table/&gt; element can have 0 or 1 &lt;header/&gt; element, 0 
    or more &lt;item/&gt; elements and 0 or 1 &lt;footer/&gt; element.</li>
</ol>
<p class="helptitle"><a name="schema"></a>The Schema File Structure</p>
<p>This is the file that defines the columns of the header, item and footer. The 
  squeleton is as follows:</p>
<p class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;iso-8859-1&quot;?&gt;<br>
  &lt;root&gt;<br>
  &lt;table&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<font color="#009900">[ ... name 
  of the column ... ]</font>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ ... more col ... 
  ]</font><br>
  &nbsp;&nbsp;&nbsp;&lt;/header&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<font color="#009900">[ ... name 
  of the column ... ]</font>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ ... more col ... 
  ]</font><br>
  &nbsp;&nbsp;&nbsp;&lt;/item&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<font color="#009900">[ ... name 
  of the column ... ]</font>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#009900">[ ... more col ... 
  ]</font><br>
  &nbsp;&nbsp;&nbsp;&lt;/footer&gt; <br>
  &lt;/table&gt; <br>
  &lt;/root&gt;</p>
<p>You will notice that the xml data file and the schema file are very similar. 
  The Schema file have the same header, item and footer tags and inside them you 
  can define which columns you desire to have using the &lt;col&gt; element. So, 
  to clarify:</p>
<ol>
  <li>same rule for the xml header: don&acute;t forget the encoding property;</li>
  <li>there&acute;s always one root element, called &lt;root/&gt; and only one 
    &lt;table/&gt;;</li>
  <li>inside a &lt;table/&gt;, you can have 0 or 1 &lt;header/&gt;, 0 or 1 &lt;item/&gt; 
    and 0 or 1 &lt;footer/&gt;;</li>
  <li>each of those 3 elements can only have 0 or more &lt;col/&gt; elements</li>
</ol>
<p class="helptitle"><a name="work"></a>Working Example</p>
<p>Take a look at this working example of a Schema file:</p>
<p class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;iso-8859-1&quot;?&gt;<br>
  &lt;root&gt;<br>
  &lt;table&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<b>title</b>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;/header&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<b>date</b>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<b>name</b>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<b>message</b>&lt;/col&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;/item&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;col&gt;<b>caption</b>&lt;/col&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;/footer&gt; <br>
  &lt;/table&gt; <br>
  &lt;/root&gt;</p>
<p>And now see a data file based on the previous Schema:</p>
<p class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;iso-8859-1&quot;?&gt;<br>
  &lt;root&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;table&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>title</b>&gt;<i>Test 
  Table</i>&lt;/<b>title</b>&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/header&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>date</b>&gt;<i>01/01/1900</i>&lt;/<b>date</b>&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>name</b>&gt;<i>Joseph</i>&lt;/<b>name</b>&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>message</b>&gt;<i>This 
  is a test ...</i>&lt;/<b>message</b>&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;item&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>date</b>&gt;<i>01/02/1900</i>&lt;/<b>date</b>&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>name</b>&gt;<i>Jonathan</i>&lt;/<b>name</b>&gt; 
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>message</b>&gt;<i>Hello 
  World</i>&lt;/<b>message</b>&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/item&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<b>caption</b>&gt;<i>this 
  is a footer test</i>&lt;/<b>caption</b>&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/footer&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;/table&gt;<br>
  &lt;/root&gt;</p>
<p>Don&acute;t forget to create the Schema file with a prepending dot and to associate 
  it correctly to the data file.</p>
<p class="helptitle"><a name="xsl"></a>The XSL Style file</p>
<p>And last, but not least, let me try to give an example of an xsl file. This 
  one can be done by many ways but just to have a start poing let&acute;s try 
  a very simple one. First, this is how the final HTML should looks like:</p>
<p class="code">&lt;p&gt;&lt;b&gt;<b>Test Table</b>&lt;/b&gt;&lt;/p&gt;<br>
  &lt;br&gt;<br>
  &lt;table border=&quot;1&quot;&gt; <br>
  &lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;td&gt;&lt;b&gt;<b>Date</b>&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;<b>Name</b>&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;<b>Message</b>&lt;/b&gt;&lt;/td&gt;<br>
  &lt;/tr&gt;<br>
  &lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;td&gt;<b>01/01/1900</b>&lt;/td&gt;&lt;td&gt;<b>Joseph</b>&lt;/td&gt;&lt;td&gt;<b>This 
  is a test ...</b>&lt;/td&gt;<br>
  &lt;/tr&gt; <br>
  &lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;td&gt;<b>01/02/1900</b>&lt;/td&gt;&lt;td&gt;<b>Jonathan</b>&lt;/td&gt;&lt;td&gt;<b>Hello 
  World</b>&lt;/td&gt;<br>
  &lt;/tr&gt; <br>
  &lt;/table&gt;<br>
  &lt;br&gt; <br>
  &lt;p&gt;<b>this is a footer test</b>&lt;/p&gt;</p>
<p>You see this is very simple. The very first thing to do is know exactly what 
  you want and how to fit the layout to the data. So let&acute;s organize it. 
  First, the header block:</p>
<p class="code">&lt;p&gt;&lt;b&gt;Test Table&lt;/b&gt;&lt;/p&gt;<br>
  &lt;br&gt;<br>
</p>
<p>Then the table body block (notice that we define the table&acute;s layout header 
  here, hardcoded):</p>
<p class="code">&lt;table border=&quot;1&quot;&gt; <br>
  &lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;td&gt;&lt;b&gt;Date&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Name&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Message&lt;/b&gt;&lt;/td&gt;<br>
  &lt;/tr&gt;<br>
  &lt;/table&gt;</p>
<p>Each item block:</p>
<p class="code">&lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;td&gt;01/02/1900&lt;/td&gt;&lt;td&gt;Jonathan&lt;/td&gt;&lt;td&gt;Hello 
  World &lt;/td&gt;<br>
  &lt;/tr&gt; <br>
</p>
<p>And last, the footer block:</p>
<p class="code">&lt;br&gt; <br>
  &lt;p&gt;this is a footer test&lt;/p&gt;</p>
<p>Finally, here&acute;s the complete XSL file:</p>
<p class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;iso-8859-1&quot;?&gt;<br>
  &lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform" version="1.0"></p>
<p class="code"><b>&lt;xsl:template match=&quot;/root&quot;&gt;</b><br>
  &nbsp;&nbsp;&nbsp;<font color="#660000">&lt;xsl:apply-templates select=&quot;header&quot;/&gt;</font><br>
  &nbsp;&nbsp;&nbsp;&lt;table border=&quot;1&quot;&gt; <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;td&gt;&lt;b&gt;Date&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Name&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Message&lt;/b&gt;&lt;/td&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;/tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#660000">&lt;xsl:apply-templates 
  select=&quot;item&quot;/&gt; </font><br>
  &nbsp;&nbsp;&nbsp;&lt;/table&gt;<br>
  &nbsp;&nbsp;&nbsp;<font color="#660000">&lt;xsl:apply-templates select=&quot;footer&quot;/&gt; 
  </font><br>
  <b>&lt;/xsl:template&gt;</b></p>
<p class="code"><b>&lt;xsl:template match=&quot;header&quot;&gt;</b><br>
  &nbsp;&nbsp;&nbsp;&lt;p&gt;&lt;b&gt;<font color="#660000">&lt;xsl:value-of select=&quot;title&quot;/&gt;</font>&lt;/b&gt;&lt;/p&gt;<br>
  &nbsp;&nbsp;&nbsp;&lt;br/&gt;<br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code"><b>&lt;xsl:template match=&quot;footer&quot;&gt;</b><br>
  &nbsp;&nbsp;&nbsp;&lt;br/&gt; <br>
  &nbsp;&nbsp;&nbsp;&lt;p&gt;<font color="#660000">&lt;xsl:value-of select=&quot;caption&quot;/&gt;</font>&lt;/p&gt;<br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code"><b>&lt;xsl:template match=&quot;item&quot;&gt;</b><br>
  &lt;tr&gt;<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&lt;td&gt;<font color="#660000">&lt;xsl:value-of select=&quot;date&quot;/&gt;</font>&lt;/td&gt;<br>
  &nbsp;&nbsp; &nbsp;&lt;td&gt;<font color="#660000">&lt;xsl:value-of select=&quot;name&quot;/&gt;</font>&lt;/td&gt;<br>
  &nbsp;&nbsp;&nbsp; &lt;td&gt;<font color="#660000">&lt;xsl:value-of select=&quot;message&quot;/&gt;</font>&lt;/td&gt;<br>
  &lt;/tr&gt;<br>
  <b>&lt;/xsl:template&gt; </b></p>
<p class="code">&lt;/xsl:stylesheet&gt;</p>
<p>As a last tip: remember that this is an XML file to all XML rules apply, including 
  the HTML tags, that must follow the same rules. Notice the &lt;br&gt; tag, it&acute;s 
  closed as &lt;br/&gt; to comply to the XHTML rules (XML based HTML).</p>
<p class="helptitle"><a name="organize"></a>Ways to organize the files</p>
<p>Let&acute;s make some practical examples. Let&acute;s say there&acute;s a site 
  that requires tables in two different languages. This site will have 4 tables 
  that uses the exact same layout. The first language is portuguese and the second 
  is spanish.</p>
<p>The main structure predicts 3 root folders, like that:</p>
<p class="code">/br<br>
  /common<br>
  /int</p>
<p>These 3 folders will have a subfolder for this site, let&acute;s call it &quot;eventsite&quot;, 
  like this:</p>
<p class="code">/br/eventsite<br>
  /common/eventsite<br>
  /int/eventsite</p>
<p>Now let&acute;s take a look at an example of the data this site will have:</p>
<table width="400" border="0" cellspacing="0" cellpadding="3">
  <tr> 
    <td><b>Time</b></td>
    <td align="right"><b>JJ</b></td>
    <td align="right"><b>V</b></td>
    <td align="right"><b>D</b></td>
    <td align="right"><b>E</b></td>
    <td align="right"><b>Pts.</b></td>
  </tr>
  <tr> 
    <td>Corinthians</td>
    <td align="right">10</td>
    <td align="right">5</td>
    <td align="right">5</td>
    <td align="right">0</td>
    <td align="right">15</td>
  </tr>
  <tr> 
    <td>Cruzeiro</td>
    <td align="right">10</td>
    <td align="right">5</td>
    <td align="right">5</td>
    <td align="right">0</td>
    <td align="right">15</td>
  </tr>
</table>
<p>The first thing to have in mind is: the less work the final user (content staff) 
  the better. So the first thing to notice is that the data (not the table header) 
  is language-free, which means that it doesn&acute;t need translation of any 
  kind. The second thing to notice is that only the header depends on language. 
  So the conclusion is: the data is language-free and the style is language-dependent, 
  which means, basically, 1 kind of data file and 2 different style files. Like 
  that:</p>
<p class="code">/br/eventsite/.results.xsl<br>
  /common/eventsite/.results_schema.xml <br>
  /common/eventsite/results_1.xml <br>
  /common/eventsite/results_2.xml <br>
  /common/eventsite/results_3.xml <br>
  /common/eventsite/results_4.xml <br>
  /int/eventsite/.results.xsl </p>
<p>The associations go between <font color="#660033">.results_schema.xml</font> 
  and the other 4 files as described above. And last we create shortcuts based 
  on language:</p>
<p>Language 2 (portuguese):</p>
<p class="code">event_results_1 = /br/eventsite/.results.xsl + /common/eventsite/results_1.xml<br>
  event_results_2 = /br/eventsite/.results.xsl + /common/eventsite/results_2.xml 
  <br>
  event_results_3 = /br/eventsite/.results.xsl + /common/eventsite/results_3.xml 
  <br>
  event_results_4 = /br/eventsite/.results.xsl + /common/eventsite/results_4.xml 
</p>
<p>Language 3 (spanish):</p>
<p class="code">event_results_1 = /int/eventsite/.results.xsl + /common/eventsite/results_1.xml<br>
  event_results_2 = /int/eventsite/.results.xsl + /common/eventsite/results_2.xml 
  <br>
  event_results_3 = /int/eventsite/.results.xsl + /common/eventsite/results_3.xml 
  <br>
  event_results_4 = /int/eventsite/.results.xsl + /common/eventsite/results_4.xml 
</p>
<p>And in the front-end we have something like this (using the TXMLFront component):</p>
<p class="code"><b>Set </b>oFront = Server.CreateObject( &quot;PSNXML.TXMLFront&quot; 
  )<br>
  oFront.LanguageID = cfg_language_id<br>
  <b>If</b> oFront.Load( &quot;event_results_&quot; &amp; intTableNumber ) <b>Then</b><br>
  &nbsp;&nbsp;&nbsp;&nbsp;oFront.Render <br>
  <b>End If<br>
  Set </b>oFront = <b>Nothing</b></p>
<p>This is the general way to use this framework: in the end you have very well 
  organized files and a very easy way to access them in the front-end. There are 
  many variations, for example: </p>
<ul>
  <li>if the layout is language-free then the XSL style file goes together with 
    the schema and data files;</li>
  <li>if the data is language-dependent (rare) then the data file goes separated 
    in the country folders but the schema still goes in the common folder; </li>
</ul>
<p class="helptitle"><a name="final"></a>Considerations</p>
<p>You can try many other variations but always keep in mind easy of use for everybody: 
  both final users and other developers, so naming conventions are always a good 
  thing to keep in mind. Also don&acute;t left trash files behind: don&acute;t 
  be afraid to delete files, if you delete something by mistake you can always 
  get it back by recreating it using the same filename and the file will be undeleted 
  with all it&acute;s contents intact. Organization is the key to make this work 
  properly. </p>
<p>Bugs: <a href="mailto:akita@psntv.com">akita@psntv.com</a></p>
</body>
</html>