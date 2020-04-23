/**
This source code is to set and store the user data in the gae datastore and in the cookies for the page
**/

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query.SortDirection;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;

/**
 * Servlet implementation class DataStoreServlet
 */

@WebServlet(
	    name = "DataStoreServlet",
	    urlPatterns = {"/DataStoreServlet"}
	)
public class DataStoreServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DataStoreServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//timestamp when tweet was created
				DateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				//Create instance of DataStore (ds)
				DatastoreService ds=DatastoreServiceFactory.getDatastoreService();
				//creates new entity called tweet
				Entity e=new Entity("tweet");
				//set up various properties of tweet entity, with name value pairs
				e.setProperty("status",req.getParameter("text_content"));
				e.setProperty("user_id", req.getParameter("user_id"));
				e.setProperty("first_name", req.getParameter("first_name"));
				e.setProperty("last_name", req.getParameter("last_name"));
				e.setProperty("picture", req.getParameter("picture"));
				e.setProperty("visited_count", 0);
				//create cookies for app user's details and add them to the client response
				Cookie user_id = new Cookie("user_id", req.getParameter("user_id"));	
				Cookie first_name= new Cookie("first_name",req.getParameter("first_name"));
				Cookie last_name=new Cookie("last_name", req.getParameter("last_name"));
				Cookie picture = new Cookie("picture", req.getParameter("picture"));
				resp.addCookie(user_id);
				resp.addCookie(first_name);
				resp.addCookie(last_name);
				resp.addCookie(picture);
				Date date = new Date();
		        System.out.println(sdf.format(date));
				e.setProperty("timestamp", sdf.format(date));
				
				//put entity in datastore
				Key id=ds.put(e);
				
				//to send tweet url with id and message, appending buffer url and app url, when sendind via direct tweet method
				StringBuffer sb=new StringBuffer();
				String url = req.getRequestURL().toString();
				String baseURL = url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath() + "/";
				sb.append(baseURL+"direct_tweet.jsp?id="+id.getId());
				req.setAttribute("status", sb);
				req.getRequestDispatcher("tweet.jsp").forward(req, resp);
	}
}

	
