package com.cc.practicaltest.app;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class OrderRowMapperTest {
    @Mock
    private ResultSet mockResultSet;

    private static final Integer ORDER_NUMBER = 23;
    private static final Integer CUSTOMER_NUMBER = 234;
    private static final Integer EMPLOYEE_NUMBER = 77;
    private static final BigDecimal SALE_PRICE = new BigDecimal("10000.00");
    private static final BigDecimal DEPOSIT = new BigDecimal("1000.00");
    private static final LocalDate ORDER_DATE = LocalDate.of(2018, 5, 31);

    @Test
    public void orderMustBeBuiltCorrectly() throws SQLException {
        when(mockResultSet.getInt("order_number")).thenReturn(ORDER_NUMBER);
        when(mockResultSet.getInt("customer_number")).thenReturn(CUSTOMER_NUMBER);
        when(mockResultSet.getInt("employee_number")).thenReturn(EMPLOYEE_NUMBER);
        when(mockResultSet.getBigDecimal("sale_price")).thenReturn(SALE_PRICE);
        when(mockResultSet.getBigDecimal("deposit")).thenReturn(DEPOSIT);
        when(mockResultSet.getDate("order_date")).thenReturn(Date.valueOf(ORDER_DATE));
        Order order = new Order.OrderRowMapper().mapRow(mockResultSet, 1);
        assertEquals(order.getOrderNumber(), ORDER_NUMBER);
        assertEquals(order.getCustomerNumber(), CUSTOMER_NUMBER);
        assertEquals(order.getEmployeeNumber(), EMPLOYEE_NUMBER);;
        assertEquals(order.getSalePrice().compareTo(SALE_PRICE), 0);
        assertEquals(order.getDeposit().compareTo(DEPOSIT), 0);
        assertEquals(order.getOrderDate(), ORDER_DATE);
    }
}
