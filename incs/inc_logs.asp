<script language="JScript">
function OpenLog() {
	document.all( 'divLog' ).style.display = document.all( 'divLog' ).style.display == 'none' ? '' : 'none';
}
</script>
<a href="javascript:OpenLog()"><img src="../imgs/icon_log.gif" border="0" alt="Log Point (for Developers only)"></a>
<div id="divLog" style="position:relative;display:none;background-color: #DDDDDD">
<pre>Logs:
<%
Response.Write sErrors & vbCRLF & vbCRLF
Response.Write oSynchro.Log & vbCRLF & vbCRLF
%>
</pre>
</div>