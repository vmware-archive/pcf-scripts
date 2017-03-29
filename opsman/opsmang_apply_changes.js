// adapted from Azure login script
// which was itself adapted from: http://code-epicenter.com/how-to-login-amazon-using-phantomjs-working-example/
// which was itself adapted from: http://boards.4chan.org/b/

var system = require('system');
var webPage = require('webpage');

var steps=[];
var testindex = 0;
var loadInProgress = false; //This is set to true when a page is still loading

/*********SETTINGS*********************/
console.log("webPage.create()");
var page = webPage.create();
page.viewportSize = {
    width: 1920,
    height: 1080
};
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36';
page.settings.javascriptEnabled = true;
page.settings.loadImages = true; //Script is much faster with this field set to false
phantom.cookiesEnabled = true;
phantom.javascriptEnabled = true;
/*********SETTINGS END*****************/
/*********CONFIG*****************/
var configs = {};
configs.username = system.env['OPSMAN_USERNAME'];
configs.password = system.env['OPSMAN_PASSWORD'];
configs.environment = system.env['OS_TENANT_NAME'];
/*********CONFIG END*****************/
console.log('All settings loaded, start with execution');
page.onConsoleMessage = function(msg) {
    console.log(msg);
};
/**********DEFINE STEPS THAT FANTOM SHOULD DO***********************/
steps = [
    //Step 1 - Open OpsMan home page
    function(){
        console.log('Step 1 - Open opsman homepage');
        page.open(system.env['OPSMAN_URI'], function(status){
        page.render("./output/" + configs.environment + "/screen1.png");
        });
    },
    //Step 2 - Login
    function(){
        console.log('Step 2 - login');

        page.evaluate(function(configs){
            document.getElementsByName("username")[0].value = configs.username;
            document.getElementsByName("password")[0].value = configs.password;
            document.getElementsByClassName("island-button")[0].click();
        }, configs);
        page.render("./output/" + configs.environment + "/screen2.png");
    },
    //Step 3 - Click "Apply changes"
    function(){
        console.log('Step 3 - Click to apply changes');
        page.evaluate(function(configs){
            document.getElementById("install-action").click();
        }, configs);
        page.render("./output/" + configs.environment + "/screen3.png");
    },
    function(){
        console.log('Step 4 - Ignore errors if there are any');
        page.evaluate(function(configs){
            if (document.getElementById("ignore-install-action") != null) {
                document.getElementById("ignore-install-action").click();
                console.log("Ignoring errors... YOLO OPS");
            }
            else {
                console.log("No errors found, yeay!");
            }
        }, configs);
        page.render("./output/" + configs.environment + "/screen4.png");
    }
];
/**********END STEPS THAT PHANTOM SHOULD DO***********************/

//Execute steps one by one
interval = setInterval(executeRequestsStepByStep,6000);

function executeRequestsStepByStep(){
    if (loadInProgress == false && typeof steps[testindex] == "function") {
        steps[testindex]();
        testindex++;
    }
    if (typeof steps[testindex] != "function") {
        console.log("apply changes complete!");
        phantom.exit();
    }
}

/**
 * These listeners are very important in order to phantom work properly. Using these listeners, we control loadInProgress marker which controls, weather a page is fully loaded.
 * Without this, we will get content of the page, even a page is not fully loaded.
 */
page.onLoadStarted = function() {
    loadInProgress = true;
    console.log('Loading started');
};
page.onLoadFinished = function() {
    loadInProgress = false;
    console.log('Loading finished');
};
page.onConsoleMessage = function(msg) {
    console.log(msg);
};

