@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0  # Gán giá trị đầu vào ban đầu
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    dut._log.info("Bắt đầu chạy FSM NTT")
    
    # Kích hoạt tín hiệu start (giả sử bạn đưa start vào bit 0 của ui_in hoặc tùy theo thiết kế top-level của bạn)
    dut.ui_in.value = 1  
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0  

    # Chờ quá trình tính toán diễn ra (hoặc chờ tín hiệu done)
    # Tổng thời gian cho 7 tầng là 896 chu kỳ clock
    for cycle in range(950):
        await ClockCycles(dut.clk, 1)
        # Bạn có thể thêm các câu lệnh assert hoặc in log kiểm tra tại đây nếu muốn

    dut._log.info("Kết thúc kiểm thử")
