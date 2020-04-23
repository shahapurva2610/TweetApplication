<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" href="/css/tweet.css">
	<!--Code for client side google analytics tracking -->
	<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-164340621-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-164340621-1');
</script>
	
	<script type="text/javascript" src="/js/tweet.js"></script>
	<script type="text/javascript">callme();</script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Friends Tweet Page</title>
</head>

<body>

	<!-- Top Navigation Bar -->
	<div class="topnav">
  		<a href="my_tweet_list.jsp">Tweet</a>
  		<a href="friends_tweets_list.jsp">Friends</a>
  		<a id=toptweet href="top_tweet_list.jsp">Top Tweets</a>

  		<div id="fb-root"></div>
  		<div align="right">
  			<div class="fb-login-button" data-max-rows="1" data-size="large" 
  	 			data-button-type="login_with" data-show-faces="false" 
  	 			data-auto-logout-link="true" data-use-continue-as="true" 
  	 			scope="public_profile,email" onlogin="checkLoginState();">
  	 		</div>
  		</div>
	</div>
	<h1><center>List of your friend's Tweets</center></h1>
	<br><br>
	
	<script>
		document.getElementById("user_id").value = getCookie('user_id');
		document.getElementById("first_name").value= getCookie('first_name');
	</script>
	
<%
DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
Entity e = new Entity("tweet");
Query q = new Query("tweet");
PreparedQuery pq = ds.prepare(q);
int count = 0;
String uid=null;
String fname=null;
Cookie cookie = null;
Cookie[] cookies = null;
cookies = request.getCookies();
for (int i = 0; i < cookies.length; i++) {
if(cookies[i].getName().compareTo("user_id")==0){
	uid=cookies[i].getValue();
}
if(cookies[i].getName().compareTo("first_name")==0){
	fname=cookies[i].getValue();
}
}
for (Entity result : pq.asIterable()) {
	if (result.getProperty("user_id") != null && result.getProperty("user_id") != ""
			&& !((result.getProperty("user_id")).equals(uid))) {
		//out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
		
		String first_name = (String) result.getProperty("first_name");
		count++;
		String last_name = (String) result.getProperty("last_name");
		String user_id = (String) result.getProperty("user_id");
		String picture = (String) result.getProperty("profile_pic");
		String status = (String) result.getProperty("status");
		Long id = (Long) result.getKey().getId();
		String time = (String) result.getProperty("timestamp");
		Long visited_count = (Long) ((result.getProperty("visited_count")));
	%>
	          
			  <br>
			  <p><strong>User:</strong> <%= first_name %> <%= last_name %> </p>
			  <p><strong>Status:</strong> <%= status %> </p>
			  <p><strong> Posted Date:</strong> <%= time %> </p>
			  <p><strong>Views:</strong> <%= visited_count %></p><br>	  
			  <hr>
	<%  
			
		}
	}
%>						

</body>
</html>