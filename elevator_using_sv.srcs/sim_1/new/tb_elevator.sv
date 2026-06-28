`timescale 1ns/1ps

module tb_elevator_using_sv;

    // Testbench signals
    logic clk, reset;
    logic request_up, request_down, door_sensor, emergency;
    logic move_up, move_down, door_open, door_close;

    // Instantiate DUT (Device Under Test)
    elevator_fsm dut (
        .clk(clk),
        .reset(reset),
        .request_up(request_up),
        .request_down(request_down),
        .door_sensor(door_sensor),
        .emergency(emergency),
        .move_up(move_up),
        .move_down(move_down),
        .door_open(door_open),
        .door_close(door_close)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        request_up = 0;
        request_down = 0;
        door_sensor = 0;
        emergency = 0;

        // Apply reset
        #10 reset = 0;

        // Scenario 1: Request Up
        #10 request_up = 1;
        #20 request_up = 0;   // Clear request
        #30 door_sensor = 1;  // Door opens at floor
        #10 door_sensor = 0;

        // Scenario 2: Request Down
        #20 request_down = 1;
        #20 request_down = 0;
        #30 door_sensor = 1;
        #10 door_sensor = 0;

        // Scenario 3: Emergency Stop
        #20 emergency = 1;
        #20 emergency = 0;

        // End simulation
        #50 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | State Outputs: move_up=%b move_down=%b door_open=%b door_close=%b emergency=%b",
                 $time, move_up, move_down, door_open, door_close, emergency);
    end

endmodule
