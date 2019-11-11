////////////////////////////////////////////////////////////////////////////////
// FILE: index.js
// AUTHOR: David Ruvolo
// CREATED: 2019-11-08
// MODIFIED: 2019-11-08
// PURPOSE: all js code for app
// DEPENDENCIES: clipboard.js
// STATUS: in.progress
// COMMENTS: NA
////////////////////////////////////////////////////////////////////////////////
// BEGIN

// init clip board
new ClipboardJS('#copy');

// functions for handlers
const utils = (function () {

    ////////////////////////////////////////

    // CSS MANIPULATION 

    // function: add css class
    function addCSS(elem, css) {
        document.querySelector(elem).classList.add(css);
    }

    // function: remove css
    function removeCSS(elem, css) {
        document.querySelector(elem).classList.remove(css);
    }

    // function: toggle css
    function toggleCSS(elem, css) {
        document.querySelector(elem).classList.toggle(css);
    }

    ////////////////////////////////////////
    // HTML MANIPULATION

    // function: inner html
    function innerHTML(elem, string) {
        document.querySelector(elem).innerHTML = string;
    }

    // function: update element attribute
    function setElementAttribute(elem, attr, value) {
        document.querySelector(elem).setAttribute(attr, value);
    }

    // function: refresh page
    function refreshPage() {
        history.go(0);
    }

    // function: close window
    function closeWindow(){
        close();
    }

    // function: open / close element
    function toggleElem(elem) {
        const el = document.querySelector(elem);
        if (el.getAttribute("aria-expanded")) {
            el.classList.remove("expanded");
            el.setAttribute("aria-expanded", false);
            el.setAttribute("hidden", true);
        } else {
            el.classList.add("expanded");
            el.setAttribute("aria-expanded", true);
            el.removeAttribute("hidden");
        }
    }

    ////////////////////////////////////////
    // DEBUGGING
    function consoleLog(value, asDir) {
        if (asDir) {
            console.dir(value);
        } else {
            console.log(value);
        }
    }

    // return
    return {
        addCSS      : addCSS,
        closeWindow : closeWindow,
        consoleLog  : consoleLog,
        innerHTML   : innerHTML,
        refreshPage : refreshPage,
        removeCSS   : removeCSS,
        toggleCSS   : toggleCSS,
        toggleElem  : toggleElem,
        setElementAttribute: setElementAttribute,
    }
})();

// register handlers
Shiny.addCustomMessageHandler("addCSS", function (value) { 
    utils.addCSS(value[0], value[1]);
});

Shiny.addCustomMessageHandler("closeWindow", function(event){
    utils.closeWindow();
});

Shiny.addCustomMessageHandler("consoleLog", function (value) { 
    utils.consoleLog(value[0], value[1]);
});

Shiny.addCustomMessageHandler("innerHTML", function (value) { 
    utils.innerHTML(value[0], value[1]) 
});

Shiny.addCustomMessageHandler("refreshPage", function (event) { 
    utils.refreshPage();
});

Shiny.addCustomMessageHandler("removeCSS", function (value) { 
    utils.removeCSS(value[0], value[1]);
});

Shiny.addCustomMessageHandler("setElementAttribute", function (value) { 
    utils.setElementAttribute(value[0], value[1], value[2]);
});

Shiny.addCustomMessageHandler("toggleCSS", function (value) { 
    utils.toggleCSS(value[0], value[1]);
});

Shiny.addCustomMessageHandler("toggleElem", function (value) { 
    utils.toggleElem(value[0], value[1]);
});


