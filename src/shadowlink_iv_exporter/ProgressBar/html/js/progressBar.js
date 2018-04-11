// Create namespaces
if (typeof Squall == 'undefined') {
  Squall = {};
}

// Init
Squall.progressBar = function() {
	// Private
	var oldScreenTop = window.screenTop;
	var oldScreenLeft = window.screenLeft;
	var index = 5;
	
	// Private functions
	function timer() {
		if ((window.screenTop == oldScreenTop) && (window.screenLeft == oldScreenLeft)) {
			if (index == 0) {
				window.location = "skp:timer";
			} else {
				index = index - 1;
				setTimeout(timer, 100);
			}
		} else {
			index = 5;
			oldScreenTop = window.screenTop;
			oldScreenLeft = window.screenLeft;
			setTimeout(timer, 100);
		}
	}
	
	// public
	return {
		waitingMessages: function (messages) {
			if (messages && messages.length > 0) {
				// Determinate a random index
				var index = parseInt(Math.random()*messages.length);
				
				// Show the messages block
				$("#messages").css({
					display: "block"
				});
				$("#messages").html(messages[index]);
				
				// Launch the loop
				setInterval(function(){
					// Set the new index
					index += 1;
					if (index >= messages.length) {
						index = 0;
					}
					
					// Show the new messages block
					$("#messages").html(messages[index]);
				}, 5000);
			}
		},
		// Actualize the progress bar
		actualize: function(pourcent) {
			$("#progressBar").progressbar({
				value: ((pourcent==0)?(0.1):pourcent)
			});
			$("#progressBarText").html(pourcent + "%");
		},
		// Send screen size
		screen: function(pourcent) {
			window.location = "skp:screen@[" + screen.width + ", " + screen.height + "]";
		},
		timeoutOnTimer: function() {
			setTimeout(timer, 100);
		}
	};
}();