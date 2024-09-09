# APB Timer Test Plan

## 1. Basic Functionality Tests

### 1.1 32-bit Mode Tests
- Verify that both 32-bit timers (low and high) can be configured and operated independently
- Test the functionality of input_lo, output_lo, input_hi, and output_hi pins

### 1.2 64-bit Mode Tests
- Confirm that the timer operates as a single 64-bit timer when configured in 64-bit mode
- Verify that both high and low input pins are driven correctly
- Check that the output is correctly driven on the low pin

## 2. Timer Operation Tests

### 2.1 Timer with Both Prescaler and ref_clk Disabled
- Verify that the counter increments on every positive edge of Hclk
- Confirm that the interrupt is triggered when the count reaches the compare value

### 2.2 Timer with Prescaler Disabled and ref_clk Enabled
- Check that the counter starts incrementing only after detecting the reference clock's edge
- Verify that the counter increments on every positive edge of the reference clock

### 2.3 Timer with Prescaler Enabled and ref_clk Disabled
- Confirm that the prescaler operates correctly before the counter starts
- Verify that the counter increments on every positive edge of Hclk after the prescaler target is reached

### 2.4 Timer with Prescaler Enabled and ref_clk Enabled
- Test that the counter starts only after both the prescaler target is reached and the reference clock's edge is detected
- Verify that the counter increments on every positive edge of the reference clock

## 3. Mode Tests

### 3.1 One-shot Mode
- Confirm that the timer is completely disabled after reaching the target count for the first time

### 3.2 Compare Clear Mode
- Verify that the timer count resets to '0' when it reaches the target compare count
- Check that interrupts are generated multiple times if the counter keeps reaching the target compare count

## 4. Feature Tests

### 4.1 Mode Selection
- Test switching between 32-bit and 64-bit modes using the MODE_64_BIT configuration

### 4.2 Counter Reset
- Verify that the RESET_BIT in CFG_REG_LO and CFG_REG_HI correctly resets the counter value

### 4.3 Clock Source Selection
- Test enabling and disabling the ref_clk using the REF_CLK_EN_BIT
- Verify that the timer uses the correct clock source in each case

### 4.4 Prescaler functionality
- Test enabling and disabling the prescaler using the PRESCALER_BIT
- Verify that the prescaler divisor works correctly with different values

### 4.5 Counter Enable/Disable
- Check that the ENABLE_BIT correctly starts and stops the counter

### 4.6 MTIME Mode
- Test the MODE_MTIME_BIT functionality in 64-bit mode
- Verify that interrupts are generated when count == compare_value, even if IRQ_bit is not set

### 4.7 External Control
- Test the stoptimer_i pin functionality to stop the counter operation
- Verify the busy_o pin indicates when any counter is enabled

### 4.8 Counter Value Manipulation
- Test overwriting the counter value directly using TIMER_VAL_LO and TIMER_VAL_HI registers
- Verify setting initial counter values

## 5. Interrupt Tests

### 5.1 Interrupt Generation
- Verify that interrupts are generated correctly when the counter reaches the compare value
- Test interrupt behavior in both 32-bit and 64-bit modes

### 5.2 Interrupt Enable/Disable
- Check that the IRQ_BIT correctly enables and disables interrupt generation

## 6. Register Tests

### 6.1 Register Read/Write
- Verify that all registers (CFG_REG_LO, CFG_REG_HI, TIMER_VAL_LO, TIMER_VAL_HI, TIMER_CMP_LO, TIMER_CMP_HI) can be read from and written to correctly

### 6.2 Write Strobe Registers
- Test the functionality of write strobe registers (TIMER_START_LO, TIMER_START_HI, TIMER_RESET_LO, TIMER_RESET_HI)

## 7. Edge Case and Stress Tests

### 7.1 Boundary Values
- Test the timers with minimum and maximum possible values for counters and compare registers

### 7.2 Rapid Mode Switching
- Rapidly switch between 32-bit and 64-bit modes to ensure stability

### 7.3 Multiple Interrupt Handling
- Generate multiple interrupts in quick succession and verify correct handling

### 7.4 Clock Domain Crossing
- Test behavior when switching between ref_clk and Hclk, especially near counter increment boundaries

## 8. Error Handling and Recovery Tests

### 8.1 Invalid Configurations
- Attempt to set invalid configurations and verify appropriate error handling or rejection

### 8.2 Overflow Handling
- Test behavior when counters overflow, especially in 64-bit mode

## 9. Performance Tests

### 9.1 Timing Accuracy
- Measure and verify the timing accuracy of the timer in various configurations

### 9.2 Interrupt Latency
- Measure the latency between the counter reaching the compare value and the interrupt being generated

## 10. Integration Tests

### 10.1 APB Bus Interface
- Verify correct operation of the timer when accessed through the APB bus interface

### 10.2 System-level Integration
- Test the timer's functionality when integrated with other system components
