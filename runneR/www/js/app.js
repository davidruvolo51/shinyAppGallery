
// define a short hand function that replaced innerHTML by id
let setInnerHTML = function(id, value){ 
	document.getElementById(id).innerHTML = value;
}


// create session handlers for each element output
Shiny.addCustomMessageHandler("distanceTotal",(value) => setInnerHTML("distance-tot", value));
Shiny.addCustomMessageHandler("distanceAvg", (value) => setInnerHTML("distance-avg", value));
Shiny.addCustomMessageHandler("daysTraining",(value) => setInnerHTML("days-total", value));
Shiny.addCustomMessageHandler("runDays", (value) => setInnerHTML("days-run-total", value));
Shiny.addCustomMessageHandler("runWeeks", (value) => setInnerHTML("days-run-week", value));
Shiny.addCustomMessageHandler("runMonths", (value) => setInnerHTML("days-run-month", value));
Shiny.addCustomMessageHandler("chartTitle",(value) => setInnerHTML("distance-by-caption", value));


// show forms
let title = document.getElementById("title");
let viz = document.getElementById("viz");
let forms = document.getElementById("log");
let form_question = document.getElementById("msg-question");
let form_logged = document.getElementById("msg-logged");
let form_yes = document.getElementById("form-yes");
let form_no = document.getElementById("form-no");
let newEntryBtn = document.getElementById("newEntry");

forms.style.display = "none"; // by default hide form blocks
// viz.style.display = "none";  // extra code for going straight to forms [optional]
// form_question.style.display = "none";
// form_logged.style.display = "none";

function showForms(value){

	// always hide viz; always show forms
	title.style.display = "none";
	viz.style.display = "none";
	forms.style.display = "block";

	// logic for showing forms
	if(value == "status-logged"){

		// if entry for present day exists, show already logged form
		form_question.style.display = "none";
		form_logged.style.display = "block";
		form_yes.style.display = "none";
		form_no.style.display = "none";

	} else if(value == "status-yes-run") {

		// if no entry for present day exists and yes button clicked, so yes entry form
		form_question.style.display = "none";
		form_logged.style.display = "none";
		form_yes.style.display = "block";
		form_no.style.display = "none";

		
	} else if(value == "status-no-run"){

		// if no entry for present day exists and no button clicked, so no entry form	
		form_question.style.display = "none";
		form_logged.style.display = "none";
		form_yes.style.display = "none";
		form_no.style.display = "block";	

	} else {

		// default option: show question
		form_question.style.display = "block";
		form_logged.style.display = "none";
		form_yes.style.display = "none";
		form_no.style.display = "none";
	}
}


// handlers for showing forms
Shiny.addCustomMessageHandler("firstformshow",showForms);
Shiny.addCustomMessageHandler("newYesEntryForm",showForms);
Shiny.addCustomMessageHandler("newNoEntryForm",showForms);


// cancel forms
function closeForms(value){

	title.style.display = "block";
	viz.style.display = "block";
	forms.style.display = "none";

	window.scrollTo(0,0);

}

// shiny handlers
Shiny.addCustomMessageHandler("cancel-yes-form",closeForms);
Shiny.addCustomMessageHandler("cancel-no-form",closeForms);


// process img click
document.getElementById("home").addEventListener("click",closeForms);



// script for processing time inputs

timeInput = document.getElementById("timeRunStarted");

timeInput.addEventListener("keyup",function(e){
	
	console.log(timeInput.value.toString());

})





