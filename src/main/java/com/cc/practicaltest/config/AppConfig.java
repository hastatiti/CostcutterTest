package com.cc.practicaltest.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@ComponentScan(basePackages = "com.cc.practicaltest")
@EnableTransactionManagement
public class AppConfig {
    private static final String dbDriver = "com.mysql.jdbc.Driver";
    private static final String dbUrl = "jdbc:mysql://practical-test.c2qqcx7fu6oj.us-east-2.rds.amazonaws.com:3306/practicaltest?useSSL=false";
    private static final String dbUsername = "test_user";
    private static final String dbPassword = "testDB@123";

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(dbDriver);
        dataSource.setUrl(dbUrl);
        dataSource.setUsername(dbUsername);
        dataSource.setPassword(dbPassword);
        return dataSource;
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}
