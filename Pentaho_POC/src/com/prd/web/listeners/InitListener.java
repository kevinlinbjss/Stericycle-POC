package com.prd.web.listeners;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import org.pentaho.reporting.engine.classic.core.ClassicEngineBoot;

@WebListener
public class InitListener implements ServletContextListener {

    public void contextInitialized(ServletContextEvent event) {
      ClassicEngineBoot.getInstance().start();
    }
    
    public void contextDestroyed(ServletContextEvent event) {
    }
}