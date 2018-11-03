<SCRIPT LANGUAGE="JScript">
<!-- Original:  Nick Korosi (nfk2000@hotmail.com) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var dDate = new Date();
var dCurMonth = dDate.getMonth();
var dCurDayOfMonth = dDate.getDate();
var dCurYear = dDate.getFullYear();
var objPrevElement = new Object();
var objCalendarPointer = null;

function fToggleColor(myElement) {
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText") {
		if (myElement.color == toggleColor) {
			myElement.color = "";
		} else {
			myElement.color = toggleColor;
		}
	} else if (myElement.id == "calCell") {
		for (var i in myElement.children) {
			if (myElement.children[i].id == "calDateText") {
				if (myElement.children[i].color == toggleColor) {
					myElement.children[i].color = "";
				} else {
					myElement.children[i].color = toggleColor;
				}
			}
		}
	}
}
function fSetSelectedDay(myElement){
	if (myElement.id == "calCell") {
		if (!isNaN(parseInt(myElement.children["calDateText"].innerText))) {
			myElement.bgColor = "#c0c0c0";
			objPrevElement.bgColor = "";
			document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerText);
			objPrevElement = myElement;
			
			// customized
			CalendarHide();
			if ( document.all.calSelectedDate.value < 10 ) {
				document.all.calSelectedDate.value = '0' + document.all.calSelectedDate.value;
			}
			document.all.calSelectedDate.value = document.all.tbSelMonth.value + '/' + document.all.calSelectedDate.value + '/' + document.all.tbSelYear.value;
			try {
				objCalendarPointer.value = document.all.calSelectedDate.value;
			} catch( e ) {
			}
		}
	}
}
function fGetDaysInMonth(iMonth, iYear) {
	var dPrevDate = new Date(iYear, iMonth, 0);
	return dPrevDate.getDate();
}
function fBuildCal(iYear, iMonth, iDayStyle) {
	var aMonth = new Array(7);
	for( i = 0; i < aMonth.length; i++ )
		aMonth[i] = new Array(7);
	var dCalDate = new Date(iYear, iMonth-1, 1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
	var iVarDate = 1;
	var i, d, w;
	if (iDayStyle == 2) {
		aMonth[0] = new Array( "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" );
	} else if (iDayStyle == 1) {
		aMonth[0] = new Array( "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" );
	} else {
		aMonth[0] = new Array( "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" );
	}
	for (d = iDayOfFirst; d < 7; d++) {
		aMonth[1][d] = iVarDate;
		iVarDate++;
	}
	for (w = 2; w < 7; w++) {
		for (d = 0; d < 7; d++) {
			if (iVarDate <= iDaysInMonth) {
				aMonth[w][d] = iVarDate;
				iVarDate++;
			}
		}
	}
	return aMonth;
}
function fDrawCal(iYear, iMonth, iCellWidth, iCellHeight, sDateTextSize, sDateTextWeight, iDayStyle) {
	var myMonth;
	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	document.write("<table border='1' cellpadding='1' cellspacing='0'>")
	document.write("<tr>");
	for( i = 0; i < myMonth[0].length; i++ )
		document.write("<td align='center' style='FONT-FAMILY:Arial;FONT-SIZE:12px;FONT-WEIGHT: bold'>" + myMonth[0][i] + "</td>");
	document.write("</tr>");
	for (w = 1; w < 7; w++) {
		document.write("<tr>")
		for (d = 0; d < 7; d++) {
			document.write("<td align='left' valign='top' width='" + iCellWidth + "' height='" + iCellHeight + "' id=calCell style='CURSOR:Hand' onMouseOver='fToggleColor(this)' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>");
			if (!isNaN(myMonth[w][d])) {
				document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)>" + myMonth[w][d] + "</font>");
			} else {
				document.write("<font id=calDateText onMouseOver='fToggleColor(this)' style='CURSOR:Hand;FONT-FAMILY:Arial;FONT-SIZE:" + sDateTextSize + ";FONT-WEIGHT:" + sDateTextWeight + "' onMouseOut='fToggleColor(this)' onclick=fSetSelectedDay(this)> </font>");
			}
			document.write("</td>")
		}
		document.write("</tr>");
	}
	document.write("</table>")
}
function fUpdateCal(iYear, iMonth) {
	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	document.all.calSelectedDate.value = "";
	for (w = 1; w < 7; w++) {
		for (d = 0; d < 7; d++) {
			if (!isNaN(myMonth[w][d])) {
				document.all( 'calDateText' )[((7*w)+d)-7].innerText = myMonth[w][d];
			} else {
				document.all( 'calDateText' )[((7*w)+d)-7].innerText = " ";
			}
		}
	}
}
// End -->
</script>

<script language="JavaScript" for=window event=onload>
var dCurDate = new Date();
frmCalendarSample.tbSelMonth.selectedIndex = dCurDate.getMonth();
frmCalendarSample.tbSelYear.selectedIndex = dCurDate.getFullYear() - 1998;
</script>
<input type="hidden" name="calSelectedDate" value="">

<div id="divGadgetCalendar" style="position: absolute; background-color: #CCCCCC; z-index: 400; visibility: hidden">
	<table border="1">
	<form name="frmCalendarSample">
	<tr>
	<td>
	<select name="tbSelMonth" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
	<option value="01">January</option>
	<option value="02">February</option>
	<option value="03">March</option>
	<option value="04">April</option>
	<option value="05">May</option>
	<option value="06">June</option>
	<option value="07">July</option>
	<option value="08">August</option>
	<option value="09">September</option>
	<option value="10">October</option>
	<option value="11">November</option>
	<option value="12">December</option>
	</select>
	  
	<select name="tbSelYear" onchange='fUpdateCal(frmCalendarSample.tbSelYear.value, frmCalendarSample.tbSelMonth.value)'>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2004">2005</option>
	</select>
	</td>
	</tr>
	<tr>
	<td>
	<script language="JavaScript">
		var dCurDate = new Date();
		fDrawCal(dCurDate.getFullYear(), dCurDate.getMonth()+1, 30, 30, "12px", "bold", 1);

		function CalendarShow() {
			document.all( 'divGadgetCalendar' ).style.visibility = 'visible';
			document.all( 'divGadgetCalendar' ).style.left = window.event.x + document.body.scrollLeft;
			document.all( 'divGadgetCalendar' ).style.top = window.event.y + document.body.scrollTop;
		}
		
		function CalendarHide() {
			document.all( 'divGadgetCalendar' ).style.visibility = 'hidden';
		}
	</script>
	</td>
	</tr>
	</form>
	</table>
</div>