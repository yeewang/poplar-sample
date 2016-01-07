
function alertDismissed() {
    // do something
}

function showAlert() {
    cordova.require("cordova/plugin/notification").alert(
                                                         'You are the winner!',  // message
                                                         alertDismissed,         // callback
                                                         'Game Over',            // title
                                                         'Done'                  // buttonName
                                                         );
}

//XHR.nativeFunction("print",['HelloWorld'],
//                           function(result) {
//                           // alert("Success: \r\n"+result);
//                           },
//                           function(error) {
//                           // alert("Error: \r\n"+error);
//                           }
//                           );

XHR.abort();