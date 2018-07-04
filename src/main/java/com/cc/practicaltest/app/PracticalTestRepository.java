package com.cc.practicaltest.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Class responsible for database access.
 *
 * For documentation on how to use NamedParameterJdbcTemplate see:
 * https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/jdbc/core/namedparam/NamedParameterJdbcTemplate.html
 */
@Repository
public class PracticalTestRepository {
    private NamedParameterJdbcTemplate jdbcTemplate;

    private static final String FETCH_ORDERS_QUERY
            = "SELECT * FROM practicaltest.orders WHERE order_date >= :date";

    @Autowired
    public void setDataSource(DataSource dataSource) {
        jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
    }

    /**
     * Returns from the database list of orders since the supplier date
     * @param date the date from which to return orders
     * @return a list of orders
     */
    public List<Order> getOrdersOnOrAfter(LocalDate date) {
        Map<String, Object> params = new HashMap<>();
        params.put("date", date);
        return jdbcTemplate.query(FETCH_ORDERS_QUERY, params, new Order.OrderRowMapper());
    }
}
