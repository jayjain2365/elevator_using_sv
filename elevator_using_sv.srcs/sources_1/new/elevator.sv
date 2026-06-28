`timescale 1ns / 1ps

module elevator_using_sv #(
    parameter N_FLOORS = 4
)(
    input  logic clk, reset,
    input  logic [N_FLOORS-1:0] requests,
    input  logic emergency,

    output logic move_up, move_down,
    output logic door_open, door_close
);

    // ================================
    // STATES
    // ================================
    typedef enum logic [2:0] {
        IDLE,
        MOVE,
        DOOR_OPEN,
        DOOR_WAIT,
        DOOR_CLOSE,
        EMERGENCY
    } state_t;

    typedef enum logic {
        UP,
        DOWN
    } direction_t;

    state_t current_state, next_state;
    direction_t dir;

    // ================================
    // SIGNALS
    // ================================
    logic [$clog2(N_FLOORS)-1:0] current_floor;
    logic [N_FLOORS-1:0] req_reg;
    logic [3:0] door_timer;

    logic req_above, req_below;
    integer i;

    // ================================
    // STATE REGISTER
    // ================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // ================================
    // REQUEST STORAGE
    // ================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            req_reg <= 0;
        else begin
            req_reg <= req_reg | requests;
            if (current_state == DOOR_OPEN)
                req_reg[current_floor] <= 0;
        end
    end

    // ================================
    // CHECK REQUESTS ABOVE & BELOW
    // ================================
    always_comb begin
        req_above = 0;
        req_below = 0;
        for (i = 0; i < N_FLOORS; i = i + 1) begin
            if ((i > current_floor) && req_reg[i])
                req_above = 1;
            if ((i < current_floor) && req_reg[i])
                req_below = 1;
        end
    end

    // ================================
    // DIRECTION CONTROL
    // ================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            dir <= UP;
        else if (current_state == IDLE) begin
            if (req_above)
                dir <= UP;
            else if (req_below)
                dir <= DOWN;
        end
        else if (current_state == MOVE) begin
            if (dir == UP && !req_above && req_below)
                dir <= DOWN;
            else if (dir == DOWN && !req_below && req_above)
                dir <= UP;
        end
    end

    // ================================
    // FLOOR MOVEMENT
    // ================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_floor <= 0;
        else if (current_state == MOVE) begin
            if (dir == UP && current_floor < N_FLOORS-1)
                current_floor <= current_floor + 1;
            else if (dir == DOWN && current_floor > 0)
                current_floor <= current_floor - 1;
        end
    end

    // ================================
    // DOOR TIMER (unchanged)
    // ================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            door_timer <= 0;
        else if (current_state == DOOR_WAIT)
            door_timer <= door_timer + 1;
        else
            door_timer <= 0;
    end

    // ================================
    // NEXT STATE LOGIC
    // ================================
    always_comb begin
    next_state = current_state;
    unique case (current_state)
        IDLE: begin
            if (emergency)
                next_state = EMERGENCY;
            else if (|req_reg)
                next_state = MOVE;
        end
        MOVE: begin
            if (emergency)
                next_state = EMERGENCY;
            else if (req_reg[current_floor])
                next_state = DOOR_OPEN;
        end
        DOOR_OPEN: next_state = DOOR_WAIT;
        DOOR_WAIT: if (door_timer == 5) next_state = DOOR_CLOSE;
        DOOR_CLOSE: next_state = (|req_reg) ? MOVE : IDLE;
        EMERGENCY: next_state = (!emergency) ? IDLE : EMERGENCY;
        default:   next_state = IDLE;
    endcase
end

    // ================================
    // OUTPUT LOGIC
    // ================================
// ================================
// OUTPUT LOGIC
// ================================
always_comb begin
    move_up   = 0;
    move_down = 0;
    door_open = 0;
    door_close= 0;

    unique case (current_state)
        MOVE: begin
            if (dir == UP)
                move_up = 1;
            else
                move_down = 1;
        end

        DOOR_OPEN:  door_open  = 1;
        DOOR_CLOSE: door_close = 1;

        // Explicitly handle other states
        IDLE: ;          // no outputs active
        DOOR_WAIT: ;     // no outputs active
        EMERGENCY: ;     // no outputs active

        default: ;       // safety net
    endcase
end

endmodule
