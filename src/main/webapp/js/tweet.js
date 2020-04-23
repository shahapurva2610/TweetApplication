var first_name;
var last_name;
var picture;

function callme(){
//This code will load and initialize the SDK.
window.fbAsyncInit = function() {
    FB.init({
      appId      : '2482035105440415', 
      cookie     : true,
      xfbml      : true,
      version    : 'v2.9'
    });
    //This will automatically log events
    FB.AppEvents.logPageView(); 
    loadsdk();
    //Function to check if app user is logged in
    checkLoginState();
};
}

//Once app user logs in, display greeting + their first name
function onLogin(response) {
	  if (response.status == 'connected') {
	    FB.api('/me?fields=first_name', function(data) {
	      var welcomeBlock = document.getElementById('fb-welcome');
	      welcomeBlock.innerHTML = 'Hello, ' + data.first_name + '!';
	      
	    });
	  }
};

//Function to load sdk
function loadsdk(){
(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
};


//Function to check login status of app user
function checkLoginState() {
  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });
};

var user_id;

function statusChangeCallback(response) { // Called with the results from FB.getLoginStatus()
    console.log('statusChangeCallback');
    console.log(response); // The current login status of app user.
    if (response.status === 'connected') {  // User is logged into app and Facebook.
      user_id = response.authResponse.userID;
      console.log(user_id);
      extractInfo();
      console.log("Already LoggedIn");
    } else { // Not logged into app or unable to tell.
      console.log("Please login");
      FB.login();
    }
  };

(function(d, s, id) { // Load the SDK asynchronously
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.9&appId=2482035105440415";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function shareTweet(){ //function to share tweet
	checkLoginState(); //check if user is logged in
	//  ui() is used to trigger Facebook created UI share dialog to be displayed on timeline
	FB.ui({method: 'share',
		href: document.getElementById("status").value,
		quote: document.getElementById('text_content').value,
		},function(response){
		if (!response || response.error)
		{
			console.log(response.error);
			alert('Posting error occured');
		} 
	}); 
	
};

function shareDirectTweet(){ //function to share tweet directly
	checkLoginState(); //check if user is logged in
	//  ui() is used to trigger Facebook created UI share dialog to share tweet directly in the form message
	FB.ui({method: 'share',
		href: "https://apps.facebook.com/2482035105440415",
		quote: "https://apps.facebook.com/2482035105440415",
		},function(response){
		if (!response || response.error)
		{
			console.log(response.error);
			alert('Posting error occured');
		} 
	});
}


//function to fetch/get id, first and last name along with picture and store to datastore and to cookies as well.
function extractInfo(){
	FB.api('/me', 
			'GET',
			{"fields":"id,first_name,last_name,picture.width(125).height(125)"},
			function(response){
				first_name = response.first_name;
				console.log(response);
				 document.cookie="user_id="+response.id;
				last_name = response.last_name;
				document.cookie="first_name="+first_name;
				localStorage.setItem('first_name',first_name);
				document.cookie="last_name="+last_name;
				localStorage.setItem('last_name',last_name);
				picture=response.picture.data.url;
				document.cookie="picture="+picture;
				localStorage.setItem('picture',picture);
				console.log(document.cookie);
			});
	
	 document.getElementById("user_ids").value    = getCookie('user_id');
	document.getElementById("user_id").value    = getCookie('user_id');
	document.getElementById("first_name").value = getCookie('first_name');
	document.getElementById("last_name").value  = getCookie('last_name');
	document.getElementById("picture").value    = getCookie('picture');
	//document.getElementById("toptweet").href   ="toptweet.jsp?id="+localStorage.getItem("first_name");
	console.log(document.getElementById("first_name").value);
	console.log(document.getElementById("last_name").value);
	console.log(document.getElementById("picture").value);
};

//return cookies when called
function getCookie(cname) {
	var re = new RegExp(cname + "=([^;]+)");
	var value = re.exec(document.cookie);
	return (value != null) ? unescape(value[1]) : null;
}


//  ui() is used to trigger Facebook created UI share dialog to share tweet directly in the form message
function sendDirectMsg(){
	checkLoginState();
	FB.ui({method:  'send',
		  link: document.getElementById("status").value,});
	console.log(document.getElementById("status"));
};


