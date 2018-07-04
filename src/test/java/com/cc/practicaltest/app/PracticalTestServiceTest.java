package com.cc.practicaltest.app;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import java.time.LocalDate;

/**
 * Test class for PracticalTestService.
 *
 * OPTIONAL - Write unit tests for uninvoiced order functionality here.
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class PracticalTestServiceTest {
    @Mock
    private PracticalTestRepository mockRepository;

    @InjectMocks
    private PracticalTestService service;

    @Test
    public void countOrdersMustCallRepositoryExactlyOnceWithSuppliedDate() {
        LocalDate testDate = LocalDate.of(2018, 6, 1);
        service.countOrders(testDate);
        verify(mockRepository, times(1)).getOrdersOnOrAfter(testDate);
    }
}
