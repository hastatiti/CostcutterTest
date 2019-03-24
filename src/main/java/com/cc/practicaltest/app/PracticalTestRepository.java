package com.cc.practicaltest.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
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
   
   /* to find order information which are missing on invoice for the last
    28 days*/
    private static final String UNINVOICED_ORDERS_QUERY = 
    		"select ord.order_number, ord.order_date, count(veco.vehicle_number) as vehicle_number, "
    		+ "cust.forename, cust.surname, (ord.sale_price - ord.deposit) as TotalLeftToPay\n" + 
	 		"from orders ord\n" + 
	 		"left join invoices inv on ord.order_number = inv.order_number\n" + 
	 		"left join customers cust on ord.customer_number = cust.customer_number\n" + 
	 		"left join ordered_vehicles veco on ord.order_number = veco.order_number\n" + 
	 		"where ord.order_date >= (CURDATE() - INTERVAL 28 DAY)\n" + 
	 		"and ord.order_number not in(select order_number from invoices)\n" + 
	 		"group by ord.order_number "
	 		+ "order by ord.order_date desc";
    
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
    
    // retrieve all uninvoiced orders placed in the last 28 days
    public String getUninvoicedOrders() {
    	return jdbcTemplate.query(UNINVOICED_ORDERS_QUERY, new ResultSetExtractor<String>() {
            @Override
            public String extractData(ResultSet rs) throws SQLException,
                                                           DataAccessException {
            	//to save the resultSet
            	List<String> uninvoicedOrdersList = new ArrayList<>();
            	String uninvoicedOrderDetails = null;
            	
				while (rs.next()) {

					String orderNumber = rs.getString("order_number");

					// Format the date
					Date mydate = rs.getDate("order_date");
					LocalDate date = mydate.toLocalDate();
					DateTimeFormatter f = DateTimeFormatter.ofPattern("dd/MM/yyyy");
					String orderDate = date.format(f);

					String noOfVehicles = rs.getString("vehicle_number");
					String forename = rs.getString("forename");
					String surname = rs.getString("surname");
					String leftToPay = rs.getString("TotalLeftToPay");

					// Add all results into a list
					Collections.addAll(uninvoicedOrdersList, "\n" + orderNumber, orderDate, noOfVehicles, forename,
							surname, leftToPay);
					// Convert into string for display purposes
					uninvoicedOrderDetails = String.join("\t", uninvoicedOrdersList);
				}
				return uninvoicedOrderDetails;
            }
        });
    }
}

