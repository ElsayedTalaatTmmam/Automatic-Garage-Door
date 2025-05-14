module FSM_Automatic_Garage_Door_Controller (

input  wire  CLK,RST,
input  wire  Active,
input  wire  UP_Max,DN_Max,
output reg   Up_Motor,
output reg   Down_Motor
);
/********************************** Parameter ************************************/
localparam IDLE  = 2'b00,
           Mv_Up = 2'b01,
           Mv_Dn = 2'b10;

/******************************* Internal Signal *********************************/
reg [1:0] current_state,next_state;

/******************************* Sequential Block *********************************/
always @(posedge CLK , negedge RST)
  begin
    if(!RST)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

/******************************* Combinational ablocks  ******************************/
/*************************************** STATES **************************************/
always @(*)
  begin
     if(Active==0)
       begin
        next_state = IDLE; 
       end
     else
      begin
       case (current_state)

         IDLE : begin
           if(DN_Max && !UP_Max)
             next_state= Mv_Up;
           else if(UP_Max && !DN_Max)
             next_state= Mv_Dn; 
           else 
             next_state= IDLE;
                end  
 
          Mv_Up : begin
            if(UP_Max && !DN_Max)
              next_state= IDLE;
            else
              next_state= Mv_Up;
                end
           
          Mv_Dn : begin
            if(DN_Max && !UP_Max)
              next_state= IDLE;
            else
              next_state= Mv_Dn;
                end

          default : next_state = IDLE;

      endcase
    end
  end

/*************************************** OUTPUT **************************************/
always @(*)
   begin
     Up_Motor  ='b0;
     Down_Motor ='b0;
       case (current_state)
              IDLE : begin
                   Up_Motor  ='b0;
                   Down_Motor ='b0;
                end  
 
          Mv_Up : begin
                   Up_Motor  ='b1;
                   Down_Motor ='b0;
                end
           
          Mv_Dn : begin
                   Up_Motor  ='b0;
                   Down_Motor ='b1;
                end

          default : begin  
                   Up_Motor  ='b0;
                   Down_Motor ='b0;
                    end
   endcase
  end
endmodule 