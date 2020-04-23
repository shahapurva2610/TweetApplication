
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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="/css/tweet.css">
<!--Code for client side google analytics tracking -->
<!-- Global site tag (gtag.js) - Google Analytics -->
<style>
tr:nth-child(even){background-color: #f2f2f2}
</style>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-164340621-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-164340621-1');
</script>
</head>
<body>
 <script type="text/javascript" src="/js/tweet.js"></script>
 <script> callme();</script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
<div class="topnav">
  <a href="my_tweet_list.jsp">TWEET</a>
  <a href="friends_tweets_list.jsp">FRIENDS</a>
  <a  id=toptweet href="top_tweet_list.jsp">TOP-TWEET</a>
  <a href="#about"></a>
  <div id="fb-root"></div>
  <div align="right">
  <div class="fb-login-button" data-max-rows="1" style="margin:1.1%"   data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="true"  data-use-continue-as="true" scope="public_profile,email" onlogin="checkLoginState();"></div>
  </div>
</div>
<div class = "header">Top 10 tweets!!</div>
<table class="table table-striped">
<thead class="thead-light">
<tr>
<th scope="col">User</th>
<th scope="col">Status</th>
<th scope="col">Posted Date</th>
<th scope="col">Views</th></tr></thead>
<% 
//display top 10 tweets from datastore
	DatastoreService ds=DatastoreServiceFactory.getDatastoreService(); //Create instance of DataStore (ds)
	Entity e=new Entity("tweet");  //creates new entity called tweet 
	Query q=new Query("tweet").addSort("visited_count", SortDirection.DESCENDING); //Create query string for tweet based on descending order of tweets visited count
	PreparedQuery pq = ds.prepare(q); //send this query to datastore ds
	int count=0;
	//loop to display tweets till count value reaches from 0 to 9 (top 10)
	for (Entity result : pq.asIterable()) {
		if(count<10){
			  //out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
			  String first_name = (String) result.getProperty("first_name"); //fetch first_name of user who posted tweet
			  String lastName = (String) result.getProperty("last_name"); //fetch last_name of user who posted tweet
			
			  String status = (String) result.getProperty("status"); //fetch status of user who posted tweet
			  Long id = (Long) result.getKey().getId(); //fetch id of user who posted tweet
			  String time = (String) result.getProperty("timestamp"); //fetch timestamp of the tweet
			  Long visited_count = (Long)((result.getProperty("visited_count"))); //fetch how many times the tweet was visited
%>
			  <tbody>
			  <tr>
			  <td scope="row"><%= first_name+" "+lastName %> </td>
			  <td><%= status %></td>
			  <td><%=time %></td> 
			  <td><%= visited_count %></td></tr></tbody>
			<%  Entity s=ds.get(KeyFactory.createKey("tweet", id)); 
			  s.setProperty("visited_count", visited_count+1); 
			  ds.put(s); //increment visited count and store it in the data store
			  count++; //increment count by 1
		}
	}
%>
</table>
</body>
</html>

