package words.util;


import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import org.slf4j.*;

/**
 * Application Lifecycle Listener implementation class ServletContextListener
 *
 */
@WebListener
public class ServletContextListener implements javax.servlet.ServletContextListener {
	Logger log;
    /**
     * Default constructor. 
     */
    public ServletContextListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0)  { 
    	log.info("LogContextListener stop");
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent arg0)  { 
    	log = LoggerFactory.getLogger(this.getClass());
    	
    	log.info("this.getClass() at listener : " + this.getClass());
    	log.info("LogContextListener start");
    }
	
}
