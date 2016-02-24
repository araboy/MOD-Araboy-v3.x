var system = require('system');
var chatInput = "";
system.args.forEach(function (arg, i) {
	if(i > 0) chatInput += arg + " ";
});

var page = require('webpage').create();

page.open('http://www.simsimi.com/', function(status) {
	if (status !== 'success') {
		console.log('No response');
	} else {
		page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", function() {
			page.evaluate(function(chatInput) {
				$("#chatInput").val(chatInput);
			}, chatInput);
			page.evaluate(function(){
				$("#send").trigger("click");
			});
			
			var interval = setInterval(function(){
				var d = page.evaluate(function(){
					var cArea = $("#chatArea");
					if(typeof cArea === "undefined" || cArea === null || cArea.length === 0) return "undefined";
					cArea = cArea.html();
					if(typeof cArea !== "string" || cArea === null) return "undefined";
					cArea = cArea.split("<br>");
					if(typeof cArea === "undefined" || cArea === null || cArea.length === 0) return "undefined";
					return typeof cArea[2];
				});
				if(d !== "undefined"){
					clearInterval(interval);
					setTimeout(function(){
						var resp = page.evaluate(function(){
							return $("#chatArea").html().split("<br>")[2].trim();
						});
						console.log(resp);
						phantom.exit();
					}, 2000);
				}
			}, 500);
		});
	}
});
