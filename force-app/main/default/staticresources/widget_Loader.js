// alert("hello hiii");

var i, w, f, j, y, d, s;

// Create an iframe element for the chat widget
i = document.createElement("iframe");
i.id = "yabbr-frame";
i.classList.add("yabbr-frame");
i.width = "80";
i.height = "80";
console.log(document.getElementById("framtags"));

document.getElementById("framtags").appendChild(i);
// console.log('I :-' , i.contentWindow);
// alert('1' ,document.getElementById("yabbr-frame"));
// Add styles for the iframe positioning
s = document.createElement("style");
s.innerHTML = `
    #yabbr-frame {
        position: absolute;
        bottom: 5px;
        right: 5px;
        display: block;
        border: 0;
        z-index:9999;
    }
`;
document.head.appendChild(s);
// alert('2');
// Set iframe window context and yabbr object
w = i.contentWindow;
// console.log('w :-' , w);
window.yabbr = window.yabbr || {};
y = w.yabbr = window.yabbr._ || {};
// console.log('y :-' , y);
y.frame = i;
// console.log('3');
// Define default host, CDN, and API settings
y.host = y.host || "https://my.airwaves360.com";
y.cdn = y.cdn || y.host;
y.api = y.api || "https://api.airwaves360.com/2019-01-23/";
// console.log('4' , i);
var iframe = document.getElementById("yabbr-frame");
// console.log("iframe",iframe);
var event = new Event('load');
i.dispatchEvent(event); 
// Load the chat-bundle.js inside the iframe
i.onload = function() {
   
    // alert("7");
};
// alert("5");
f = w.document;
if (!f.body.hasChildNodes()) {
    // alert("6");
    f.body.style.backgroundColor = "transparent";
    j = f.createElement("script");
    j.src = y.cdn + "/js/chat-bundle.js"; // Load chat-bundle.js
    // alert('77');
    // console.log(j);
    f.body.appendChild(j);
}
// Second console.log after iframe and script creation
// alert("hello");
