`default_nettype none

module tt_um_ntt_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [11:0] data_in_bus;
    wire [11:0] data_out_bus;
    wire start;
    wire mode;
    wire done;

    // 1. MAPPING INPUTS
    assign data_in_bus[7:0]  = ui_in[7:0];        
    assign data_in_bus[11:8] = uio_in[3:0];        
    assign start             = uio_in[4];         
    assign mode              = uio_in[5];         

    // 2. MAPPING OUTPUTS
    assign uo_out[7:0]   = data_out_bus[7:0];     
    assign uio_out[3:0]  = data_out_bus[11:8];    
    assign uio_out[4]    = 1'b0;                  
    assign uio_out[5]    = 1'b0;                  
    assign uio_out[6]    = done;                  
    assign uio_out[7]    = 1'b0;                  

    // 3. ĐIỀU KHIỂN HƯỚNG PIN
    assign uio_oe[3:0] = {4{done}};  
    assign uio_oe[4]   = 1'b0;                    
    assign uio_oe[5]   = 1'b0;                    
    assign uio_oe[6]   = 1'b1;                    
    assign uio_oe[7]   = 1'b0;                    

    wire _unused = &{ena, uio_in[7:6], 1'b0};

    // 4. INSTANTIATE SINGLE TOP
    ntt_top u_ntt_top (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .mode(mode),
        .data_in(data_in_bus),
        .data_out(data_out_bus),
        .done(done)
    );

endmodule
