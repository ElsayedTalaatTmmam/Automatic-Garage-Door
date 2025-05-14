`timescale 1ns/1ps
module FSM_Garage_TB ();
/*******************************  Parameter  **********************************/
parameter CLK_Period = 20;

/*******************************  TB Signals  *********************************/
reg  CLK_TB,RST_TB;
reg  Active_TB;
reg  UP_Max_TB,DN_Max_TB;
wire Up_Motor_TB,Down_Motor_TB;

/******************************* Instantiation *********************************/
FSM_Automatic_Garage_Door_Controller DUT (
.CLK(CLK_TB),
.RST(RST_TB),
.Active(Active_TB),
.UP_Max(UP_Max_TB),
.DN_Max(DN_Max_TB),
.Up_Motor(Up_Motor_TB),
.Down_Motor(Down_Motor_TB)
);

/******************************* clock generator *********************************/
always #(CLK_Period/2) CLK_TB = ~CLK_TB;

/*******************************   Cases   *********************************/
initial 
   begin 
  $dumpfile("FSM_Garage.vcd") ;       
  $dumpvars; 

   CLK_TB = 1'b0;
   RST_TB = 1'b1;
   Active_TB = 1'b0;
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b0;
#(CLK_Period);
   RST_TB = 1'b0;
#(CLK_Period);
   RST_TB = 1'b1;

////////////////////////////////////////////////////////////
 $display (" Test Case 1 ");
   #7
   Active_TB = 1'b1;   // UP door
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b1)
     $display (" Test Case 1 : is passed ");
   else $display (" Test Case 1 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 2 ");
   #7
   Active_TB = 1'b0;    // ONLY one Signal is HIGH
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b0 && Down_Motor_TB == 1'b0)
     $display (" Test Case 2 : is passed ");
   else $display (" Test Case 2 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 3 ");
   #7
   Active_TB = 1'b1;    // DOWN door
   UP_Max_TB = 1'b1;
   DN_Max_TB = 1'b0;
   #14
   if (Down_Motor_TB== 1'b1 )
     $display (" Test Case 3 : is passed ");
   else $display (" Test Case 3 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 4 ");
   #7
   Active_TB = 1'b0;   // ONLY one Signal is HIGH
   UP_Max_TB = 1'b1;
   DN_Max_TB = 1'b0;
   #14
   if (Down_Motor_TB== 1'b0)
     $display (" Test Case 4 : is passed ");
   else $display (" Test Case 4 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 5 ");
   #7
   Active_TB = 1'b0;
   UP_Max_TB = 1'b1;  // UP and DOWN are HIGH
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b0 && Down_Motor_TB== 1'b0)
     $display (" Test Case 5 : is passed ");
   else $display (" Test Case 5 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 6 ");
   #7
   Active_TB = 1'b1;      // ALL Signals are HIGH
   UP_Max_TB = 1'b1;
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b0 && Down_Motor_TB== 1'b0)
     $display (" Test Case 6 : is passed ");
   else $display (" Test Case 6 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 7 ");     // ONLY Active is HIGH 
   #7
   Active_TB = 1'b1;         
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b0;
   #14
   if (Up_Motor_TB== 1'b0 && Down_Motor_TB== 1'b0)
     $display (" Test Case 7 : is passed ");
   else $display (" Test Case 7 : is faild ");

/////////////////////////////////////////////////////////////
 $display (" Test Case 8 ");
   #7
   Active_TB = 1'b1;
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b0 ) // is already down from case 3 ... should go to IDLE first
     $display (" Test Case 8 : is passed ");
   else $display (" Test Case 8 : is faild ");

/////////////////////////////////////////////////////////////
$display (" Test Case 8 ");
   #7
   Active_TB = 1'b1;
   UP_Max_TB = 1'b0;
   DN_Max_TB = 1'b1;
   #14
   if (Up_Motor_TB== 1'b1 ) // from down state to idle state
     $display (" Test Case 8 : is passed ");
   else $display (" Test Case 8 : is faild ");

/////////////////////////////////////////////////////////////
$display (" Test Case 9  ");
   #7
   Active_TB = 1'b1;
   UP_Max_TB = 1'b1; // To make state idle
   DN_Max_TB = 1'b0;
   #40               // time UP --> IDLE --> DOWN
   if (Down_Motor_TB== 1'b1 ) // from down state to idle state
     $display (" Test Case 9 : is passed ");
   else $display (" Test Case 9 : is faild ");

   #100  
   $finish ;
   end
endmodule 