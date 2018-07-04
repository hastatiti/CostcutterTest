package com.cc.practicaltest.app;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/**
 * Class responsible for business logic.
 */
@Service
public class PracticalTestService {
    private static final Logger log = LoggerFactory.getLogger(PracticalTestService.class);

    @Autowired
    private PracticalTestRepository repository;

    /**
     * Example method to display order count
     * @param date the date from which to count orders
     */
    public void countOrders(LocalDate date) {
        List<Order> orders = repository.getOrdersOnOrAfter(date);
        log.info("Order count since {}: {}", date, orders.size());
    }

}
