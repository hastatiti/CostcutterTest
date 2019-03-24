package com.cc.practicaltest;

import ch.qos.logback.classic.util.ContextInitializer;
import com.cc.practicaltest.app.PracticalTestService;
import com.cc.practicaltest.config.AppConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Main class, solely used for instantiating service bean and method invocation.
 */
public class App 
{
    private static final Logger log = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {
        log.info("Starting application...");

        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        PracticalTestService service = context.getBean(PracticalTestService.class);

        // Example invocation
        service.countOrders(LocalDate.of(2017,1,1));
        
        //starting point of invokation of uninvoiced orders 
        service.showUninvoiced();
    }
}
