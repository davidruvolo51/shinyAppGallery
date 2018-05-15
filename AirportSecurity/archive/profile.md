<!--- PROFILE BUILDER RMD FILE TO SHIP WITH SHINY APP --->


<!---MANUALLY MAKE LEGEND -->
<center>

    <svg height="80" width="90">
        <circle cx="50" cy="80" r="15" fill="#3288bd" />
    </svg> Low (< 150 cases)

    <svg height="80" width="90">
        <circle cx="50" cy="80" r="15" fill="#fdae61" /> 
    </svg> Medium (150 to 300 cases)

    <svg height="80" width="90">
        <circle cx="50" cy="80" r="15" fill="#9e0142" />
    </svg> High (> 300 cases)

</center>
<!---=======================================================================--->

<hr style = "border-bottom: dotted 1px;"/>

<h3>Airport: Denver International Airport</h3>
<h4>Location: Denver, Colorado</h4>
<br><br>

<!---=======================================================================--->
<center><h4>How many violations were recorded?</h4></center>
<!---=======================================================================--->
<!--TABLE: For displaying allegations data. 
        - 3 Cols:
                - 1: Info section on plot itemized list of top 5
                - 2: spacing column set to 5%
                - 3: plotly plot
--> 
<table width = "100%", border = "0">
<!---COLUMN 1: INFO-->
<tr valign = "top">
<td width = "40%">
<br><br>
Between 2002 through 2012, 220 allegations were recorded at the field office at Denver International Airport.

<br><br>
The top five allegations are listed below. 
<br><br>

<ol>
<li>Missed Mission: 38 cases.</li>
<li>Loss of Equipment: 29 cases.</li>
<li>Unprofressional Conduct: 26 cases.</li>
<li>Failure to Follow Procedure: 24 cases.</li>
<li>Failure to Honor Just Debts: 18 cases.</li>
</ol>

</td>
<!---=======================================================================--->
<!---COL2: BLANK FOR SPACING--->
<td width = "5%"></td>
<!---=======================================================================--->
<!---COL3: Plotly output--->
<td width = "55%">

<!--html_preserve--><div id="htmlwidget-4318" style="width:576px;height:504px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-4318">{"x":{"data":[{"type":"bar","inherit":false,"y":["Absent Wit ...","Abuse of P ...","Alcohol Po ...","Criminal A ...","Criminal C ...","Dress Code ...","Failure to ...","Failure to ...","Failure to ...","Falsificat ...","Fighting,  ...","Hostile Wo ...","Internatio ...","Loss of Eq ...","Making Mis ...","Management ...","Miscellane ...","Missed Mis ...","Misuse of  ...","Misuse of  ...","Neglect of ...","Sexual Has ...","Sick Leave ...","SSI/Classi ...","Unexcused  ...","Unintentio ...","Unprofress ...","Victim Cas ..."],"x":[6,6,1,13,1,2,2,24,18,8,8,1,1,29,1,3,9,38,1,11,1,1,1,1,1,4,26,2],"orientation":"h","hoverinfo":"text","marker":{"color":"rgb(1,108,89)"},"text":["DEN <br> Allegation:  Absent Without Leave <br> Cases:  6  ( 2.73 %)","DEN <br> Allegation:  Abuse of Position/Authority <br> Cases:  6  ( 2.73 %)","DEN <br> Allegation:  Alcohol Policy Violation <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Criminal Arrest <br> Cases:  13  ( 5.91 %)","DEN <br> Allegation:  Criminal Conduct <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Dress Code Violation <br> Cases:  2  ( 0.91 %)","DEN <br> Allegation:  Failure to Follow Instruction <br> Cases:  2  ( 0.91 %)","DEN <br> Allegation:  Failure to Follow Procedure <br> Cases:  24  ( 10.91 %)","DEN <br> Allegation:  Failure to Honor Just Debts <br> Cases:  18  ( 8.18 %)","DEN <br> Allegation:  Falsification of Records <br> Cases:  8  ( 3.64 %)","DEN <br> Allegation:  Fighting, Threatening, or Intimidating <br> Cases:  8  ( 3.64 %)","DEN <br> Allegation:  Hostile Work Environment <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  International Security Screening <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Loss of Equipment <br> Cases:  29  ( 13.18 %)","DEN <br> Allegation:  Making Misstatments/FALSE <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Management Inquiry <br> Cases:  3  ( 1.36 %)","DEN <br> Allegation:  Miscellaneous <br> Cases:  9  ( 4.09 %)","DEN <br> Allegation:  Missed Mission <br> Cases:  38  ( 17.27 %)","DEN <br> Allegation:  Misuse of Government Property <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Misuse of Government Travel Card <br> Cases:  11  ( 5 %)","DEN <br> Allegation:  Neglect of Duty <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Sexual Hassassment <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Sick Leave Violation <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  SSI/Classified Material Violation <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Unexcused Tardiness <br> Cases:  1  ( 0.45 %)","DEN <br> Allegation:  Unintentional Discharge of Firearm <br> Cases:  4  ( 1.82 %)","DEN <br> Allegation:  Unprofressional Conduct <br> Cases:  26  ( 11.82 %)","DEN <br> Allegation:  Victim Case <br> Cases:  2  ( 0.91 %)"]}],"layout":{"hovermode":"closest","xaxis":{"title":"No. of Allegations"},"yaxis":{"title":"","tickfont":{"size":6}},"margin":{"b":40,"l":60,"t":25,"r":10}},"url":null,"width":null,"height":null,"source":"A","config":{"displayModeBar":false,"modeBarButtonsToRemove":["sendDataToCloud"]},"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

</td></tr> 
<!---=======================================================================--->
<!---END TABLE--->
</table>
<!---=======================================================================--->
<hr style = "border-bottom: dotted 1px;"/>
<!---=======================================================================--->
<!--TABLE: For displaying resolutions data. 
        - 3 Cols:
                - 1: Info section on plot itemized list of top 5
                - 2: spacing column set to 5%
                - 3: plotly plot
--> 


<!---=======================================================================--->
<center><h4>How were violations resolved?</h4></center>
<!---=======================================================================--->
<table width = "100%", border = "0">
<!---COLUMN 1: INFO-->
<tr valign = "top">
<td width = "55%">


<!--html_preserve--><div id="htmlwidget-5525" style="width:576px;height:504px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-5525">{"x":{"data":[{"type":"bar","inherit":false,"y":["Decea ...","Lette ...","Lette ...","No Fu ...","Remov ...","Resig ...","Suspe ...","Suspe ...","Suspe ...","Suspe ...","Suspe ...","Suspe ...","Suspe ...","Suspe ...","Verba ..."],"x":[3,48,26,30,10,39,8,7,11,1,1,1,9,8,18],"orientation":"h","hoverinfo":"text","marker":{"color":"rgb(208,209,230)"},"text":["DEN <br> Resolution:  Deceased <br> Cases:  3  ( 1.36 %)","DEN <br> Resolution:  Letter of Counsel <br> Cases:  48  ( 21.82 %)","DEN <br> Resolution:  Letter of Reprimand  <br> Cases:  26  ( 11.82 %)","DEN <br> Resolution:  No Further Action <br> Cases:  30  ( 13.64 %)","DEN <br> Resolution:  Removal <br> Cases:  10  ( 4.55 %)","DEN <br> Resolution:  Resignation <br> Cases:  39  ( 17.73 %)","DEN <br> Resolution:  Suspension 1 Day <br> Cases:  8  ( 3.64 %)","DEN <br> Resolution:  Suspension 14 Day <br> Cases:  7  ( 3.18 %)","DEN <br> Resolution:  Suspension 2 Day <br> Cases:  11  ( 5 %)","DEN <br> Resolution:  Suspension 3 Day <br> Cases:  1  ( 0.45 %)","DEN <br> Resolution:  Suspension 30 Day <br> Cases:  1  ( 0.45 %)","DEN <br> Resolution:  Suspension 4 Day <br> Cases:  1  ( 0.45 %)","DEN <br> Resolution:  Suspension 5 Day <br> Cases:  9  ( 4.09 %)","DEN <br> Resolution:  Suspension 7 Day <br> Cases:  8  ( 3.64 %)","DEN <br> Resolution:  Verbal Counsel <br> Cases:  18  ( 8.18 %)"]}],"layout":{"hovermode":"closest","xaxis":{"title":""},"yaxis":{"title":"","tickfont":{"size":9}},"margin":{"b":40,"l":60,"t":25,"r":10}},"url":null,"width":null,"height":null,"source":"A","config":{"displayModeBar":false,"modeBarButtonsToRemove":["sendDataToCloud"]},"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

<!---=======================================================================--->
<!---COL2: BLANK FOR SPACING--->
<td width = "5%"></td>
<!---=======================================================================--->
<!---COL3: Plotly output--->
<td width = "40%">
<br><br>
Of the 220 allegations recorded at the field office at Denver International Airport. The most 
frequent resolution was 'Letter of Counsel'. The top five allegation 
resolutions are listed below. 
<br><br>

<ol>
<li>Letter of Counsel: 48 cases.</li>
<li>Resignation: 39 cases.</li>
<li>No Further Action: 30 cases.</li>
<li>Letter of Reprimand : 26 cases.</li>
<li>Verbal Counsel: 18 cases.</li>
</ol>

</td></tr>
</table>
<!---=======================================================================--->
<hr style = "border-bottom: dotted 1px;"/>

<center><h4>How many suspensions were given and what was the range of days assigned?</h4></center>
