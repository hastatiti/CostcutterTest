package com.cc.practicaltest.app;

import org.springframework.jdbc.core.RowMapper;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public class Order {
    private Integer orderNumber;
    private Integer customerNumber;
    private Integer employeeNumber;
    private BigDecimal salePrice;
    private BigDecimal deposit;
    private LocalDate orderDate;

    public Order() {

    }

    public Integer getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(Integer orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Integer getCustomerNumber() {
        return customerNumber;
    }

    public void setCustomerNumber(Integer customerNumber) {
        this.customerNumber = customerNumber;
    }

    public Integer getEmployeeNumber() {
        return employeeNumber;
    }

    public void setEmployeeNumber(Integer employeeNumber) {
        this.employeeNumber = employeeNumber;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDate orderDate) {
        this.orderDate = orderDate;
    }

    public static class OrderRowMapper implements RowMapper<Order> {
        @Override
        public Order mapRow(ResultSet rs, int rowNumber) throws SQLException {
            Order order = new Order();
            order.setOrderNumber(rs.getInt("order_number"));
            order.setCustomerNumber(rs.getInt("customer_number"));
            order.setEmployeeNumber(rs.getInt("employee_number"));
            order.setSalePrice(rs.getBigDecimal("sale_price"));
            order.setDeposit(rs.getBigDecimal("deposit"));
            order.setOrderDate(rs.getDate("order_date").toLocalDate());
            return order;
        }
    }
}
