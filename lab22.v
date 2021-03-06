module lab22(//input Count,
			output reg [7:0] DATA_R, DATA_G, DATA_B,
			output reg [2:0] COMM,
			output reg [2:0] s = 3'b000,
			output reg [2:0] s4 = 3'b000,
			input left, right, change, down,
			output enable,
			output IH,
			output testled,
			output reg [0:7] level = 8'b00000000,
			output reg [0:6] z = 7'b0000001,
			output reg COM1,
			output reg COM4,
			output reg aud,
			input CLK);
			assign enable = 1'b1;
			int now = 0; 
			reg newblock;
			int level_n = 0;
			reg [2:0] next_s = 3'b010;
	var bit [0:7] blank = 8'b11111111;
			
	var bit [7:0][7:0] blank_Char = '{8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111,
												8'b11111111};
	var bit [0:7][0:7] windows_Char = '{8'b10000001,
													8'b01111110,
													8'b01011110,
													8'b01011110,
													8'b10000001,
													8'b01111110,
													8'b01011110,
													8'b10011101};
	var bit [0:10][0:11] front_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] blank_front_Char = '{12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111,
															12'b111111111111};
	var bit [0:10][0:11] back_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] backup_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] back_test_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] front_test_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] back_test_two_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111,
													12'b111111111111};
	var bit [0:10][0:11] over_Char = '{12'b111111111111,
													12'b111111111111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111110111,
													12'b111111111111};
	
	parameter logic [0:3] tetris [0:111] = '{//I
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  
													  4'b1111,
													  4'b1111,
													  4'b1111,
													  4'b0000,
													  
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  4'b0111,
													  
													  4'b1111,
													  4'b1111,
													  4'b1111,
													  4'b0000,
													  //J
													  4'b1011,
													  4'b1011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0111,
													  4'b0001,
													  4'b1111,
													  
													  4'b0011,
													  4'b0111,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b1101,
													  4'b1111,
													  //L
													  4'b0111,
													  4'b0111,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b0111,
													  4'b1111,
													  
													  4'b0011,
													  4'b1011,
													  4'b1011,
													  4'b1111,
													  
													  4'b1111,
													  4'b1101,
													  4'b0001,
													  4'b1111,
													  //O
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b0011,
													  4'b1111,
													  //S
													  4'b1111,
													  4'b1001,
													  4'b0011,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  
													  4'b1111,
													  4'b1001,
													  4'b0011,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  //T
													  4'b1111,
													  4'b1011,
													  4'b0001,
													  4'b1111,
													  
													  4'b0111,
													  4'b0011,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0001,
													  4'b1011,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b1011,
													  4'b1111,
													  //Z
													  4'b1111,
													  4'b0011,
													  4'b1001,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b0111,
													  4'b1111,
													  
													  4'b1111,
													  4'b0011,
													  4'b1001,
													  4'b1111,
													  
													  4'b1011,
													  4'b0011,
													  4'b0111,
													  4'b1111};
	
	divfreq F0 (CLK, CLK_div);
	divfreq2 F1 (CLK, CLK_div2);
	divfreq_change F4 (CLK, CLK_div_change);
	liangzhu_player F5 (CLK,aud);
	byte cnt;
	byte seven_cnt;
	int x;
	int y;
	byte tmp_x;
	byte tmp_y;
	reg flag1;
	reg [0:1] rotate = 2'b00;
	int over;
	int clean_flag;

	initial
		begin
			cnt = 0;
			seven_cnt = 0;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			IH = 0;
			newblock <= 0;
			x = 5;
			y = 9;
			tmp_x = 0;
			tmp_y = 0;
			rotate = 0;
			flag1 <= 1'b1;
			//s <= next_s;
			//next_s <= s4%7;
			over = 0;
			z <= 7'b0000001;
			level_n = 0;
		end
	
	always @(posedge CLK_div)// update screen
		begin
			if(cnt >= 7)
				cnt <= 0;
			else
				cnt <= cnt+1;
			COMM <= cnt;
			
			
			if(newblock)
			begin
				//testled <= 1'b0;
				back_Char <= back_Char&front_Char;
				s <= next_s;
				//next_s <= s4%7; //get new block
				//s <= s4%7;

				//clean whole line
				for(int j=0;j<8;j++)
				begin
					
					clean_flag = 1;
					for(int i=2;i<10;i++)
						if(back_Char[i][j]==1'b1)
							clean_flag = 0;
					
					//if((~clean_Char&~back_Char)==(~clean_Char)) //old
					if(clean_flag)
					begin
						for(int i=0;i<11;i++)
							begin
								for(int element=j;element<7;element++)
									back_Char[i][element] <= back_Char[i][element+1];
								back_Char[i][7] <= 1'b1;
							end
						//level max -> level up (speed up)
						if(level == 8'b11000000)//if you want to level up quickly, change to 8'b10000000 will level up very fast and easy
						begin
							level_n = level_n + 1;
							level <= 8'b00000000;
							
						end
						//level plus
						else
							level <= {1'b1, level[0:6]};
					end
				end
				
				//game over
				if(~over_Char&~back_Char) //vector "every bit AND", a quickly way
				begin
					front_Char <= blank_front_Char;
					back_Char <= blank_front_Char;
					over = 1;
					level <= 8'b00000000;
					level_n = 0;
				end
				
			end
			
			//clean
			front_Char <= blank_front_Char;
			//GAME OVER will NOT show new blocks, windows cry only
			if(over==0)
			begin
			for(int i=0;i<4;i++)
				begin
					front_Char[x+i][y+:4] <= tetris[s*16+i+rotate*4];
				end
			end
			
			//print
			//DATA_B <= clean_Char[cnt+2][0:7];
			DATA_R <= front_Char[cnt+2][0:7];
			//DATA_G <= front_Char[cnt+2][0:7];
			//DATA_B <= front_Char[cnt+2][0:7];
			DATA_G <= back_Char[cnt+2][0:7] & front_Char[cnt+2][0:7];
			DATA_B <= back_Char[cnt+2][0:7] & front_Char[cnt+2][0:7];
			
			//print level number
			//Hexadecimal to 7SEG
			if(seven_cnt == 0)
			begin
				COM1 = 0;
				COM4 = 1;
				if(level_n==0)
					z <= 7'b0000001;
				else if(level_n==1)
					z <= 7'b1001111;
				else if(level_n==2)
					z <= 7'b0010010; 
				else if(level_n==3)
					z <= 7'b0000110;
				else if(level_n==4)
					z <= 7'b1001100;
				else if(level_n==5)
					z <= 7'b0100100; 
				else if(level_n==6)
					z <= 7'b0100000;
				else if(level_n==7)
					z <= 7'b0001111;
				else if(level_n==8)
					z <= 7'b0000000;
				else if(level_n==9)
					z <= 7'b0000100;
				else
					z <= 7'b0000000;
				seven_cnt <= 1;
			end
			else
			begin
				COM1 = 1;
				COM4 = 0;
				if(next_s==0)
					z <= 7'b1111001;
				else if(next_s==1)
					z <= 7'b1000111;
				else if(next_s==2)
					z <= 7'b1110001; 
				else if(next_s==3)
					z <= 7'b1100010;
				else if(next_s==4)
					z <= 7'b1101100;
				else if(next_s==5)
					z <= 7'b1001110; 
				else if(next_s==6)
					z <= 7'b1011010;
				else
					z <= 7'b0000000;
				seven_cnt <= 0;
			end
			
			//print GAME OVER :(
			if(over>0&&over<50000)
			begin
				DATA_B <= ~windows_Char[cnt];
				DATA_G <= windows_Char[cnt];
				DATA_R <= windows_Char[cnt];
				over++;
			end
			else if(over>=50000)
			begin
				DATA_B <= 8'b11111111;
				over=0;
			end
			//prepare for touch check
			for(int i=0;i<11;i++)
			begin
				back_test_Char[i] <= {1'b0, back_Char[i][0:7],3'b111};
				back_test_two_Char[i] <= {2'b00, back_Char[i][0:5],4'b1111};
				front_test_Char[i] <= {front_Char[i][0:8],3'b111};
			end
		end
	always @(posedge CLK_div2)// quickly add number as random base
		begin
			s4 <= s4 + 1'b1;
		end
	always @(posedge CLK_div_change)
		begin
			if(over==0)
			begin
				int count = 0;
				int dcount = 0;
				int slow = 0;
				//user input
				if(slow > 10)
				begin
					slow = 0;
					if(change)
					begin
						rotate <= rotate + 1'b1;
					end
					else if(left && front_Char[2]==12'b111111111111)
						x = x - 1;
					else if(right && front_Char[9]==12'b111111111111)
						x = x + 1;
				end
				else
					slow++;
				
				if(newblock==1)
				begin
					newblock<=0;
					next_s <= s4%7;
				end
				else if(down && y>0 &&~(~front_test_Char&~back_test_two_Char) && dcount == 0)
				begin
					y = y - 1;
					dcount = 1;
					count = 0;
				end
				else if(count>40 - 4*level_n)
				begin
					count <= 0;
					dcount = 1;
					
					if(~front_test_Char&~back_test_Char)//頩
						begin
							newblock <= 1;
							x = 5;
							y = 9;
							rotate <= 0;
						end	
					else if(y>0)
						y = y - 1;
					else
					begin
						newblock <= 1;
						x = 5;
						y = 9;
						rotate <= 0;
				end
			end
			else
				count++;
			
			//prevent user full down too fast
			if(dcount>20&&~(~front_test_Char&~back_test_two_Char))
				dcount = 0;
			else if(~(~front_test_Char&~back_test_two_Char))
				dcount = dcount + 1;
			else
				dcount = 0;
			
			//fix tetris overflow
			if(x==1 && tetris[s*16+rotate*4]!=4'b1111)
				x = x + 1;
			if(x==0 && s==0 && (rotate==0||rotate==2))
				x = x + 2;
			else if(x==-1 && s==0 && (rotate==0||rotate==2))
				x = x + 3;
		
			end
		end
		
endmodule

//update front and do lots of things immediately
module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count > 2000)//2000
		begin
			Count <= 25'b0;
			CLK_div <= ~CLK_div;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

//generate random number
module divfreq2(input CLK, output reg CLK_div2);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count >= 333)
		begin
			Count <= 25'b0;
			CLK_div2 <= ~CLK_div2;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

//tetris full down speed
module divfreq_change(input CLK, output reg CLK_div_change);
reg [24:0] Count;
always @(posedge CLK)
begin
	if(Count >= 500000)
		begin
			Count <= 25'b0;
			CLK_div_change <= ~CLK_div_change;
		end
		else
			Count <= Count + 1'b1;
end
endmodule

module liangzhu_player (
	clk,
	//i_button_n,
	o_audio
);

input clk;
//input i_button_n;
output o_audio;

reg [23:0] counter_4Hz;
reg [23:0] counter_6MHz;
reg [13:0] count;
reg [13:0] origin;
reg audio_reg;
reg clk_6MHz;
reg clk_4Hz;
reg [4:0] note;
reg [7:0] len;

//assign o_audio = i_button_n ?  1'b1 : audio_reg;
assign o_audio = audio_reg;

always @ (posedge clk) begin
	counter_6MHz <= counter_6MHz + 1'b1;
	if (counter_6MHz == 1) begin
		clk_6MHz = ~clk_6MHz;
		counter_6MHz <= 24'b0;
	end
end

always @ (posedge clk) begin
	counter_4Hz <= counter_4Hz + 1'b1;
	if (counter_4Hz == 5999999) begin	
		clk_4Hz = ~clk_4Hz;
		counter_4Hz <= 24'b0;
	end
end

always @ (posedge clk_6MHz) begin
    if(count == 16383) begin
        count = origin;
        audio_reg = ~audio_reg;
    end else
		count = count + 1;
end


always @ (posedge clk_4Hz) begin
	case (note)
		'd1: origin <= 'd4916;
		'd2: origin <= 'd6168;
		'd3: origin <= 'd7281;
		'd4: origin <= 'd7791;
		'd5: origin <= 'd8730;
		'd6: origin <= 'd9565;
		'd7: origin <= 'd10310;
		'd8: origin <= 'd010647;
		'd9: origin <= 'd011272;
		'd10: origin <= 'd011831;
		'd11: origin <= 'd012087;
		'd12: origin <= 'd012556;
		'd13: origin <= 'd012974;
		'd14: origin <= 'd013346;
		'd15: origin <= 'd13516;
		'd16: origin <= 'd13829;
		'd17: origin <= 'd14108;
		'd18: origin <= 'd11535;
		'd19: origin <= 'd14470;
		'd20: origin <= 'd14678;
		'd21: origin <= 'd14864;
		default: origin <= 'd011111;
    endcase             
end

always @ (posedge clk_4Hz) begin
	if (len == 63)
		len <= 0;
    else
		len <= len + 1;
	case (len)
		0: note <= 9;
		1: note <= 9;
		2: note <= 9;
		3: note <= 6;
		4: note <= 7;
		5: note <= 8;
		6: note <= 8;
		7: note <= 7;
		8: note <= 6;
		9: note <= 5;
		10: note <= 5;
		11: note <= 5;
		12: note <= 7;
		13: note <= 9;
		14: note <= 8;
		15: note <= 7;
		16: note <= 6;
		17: note <= 6;
		18: note <= 6;
		19: note <= 7;
		20: note <= 8;
		21: note <= 8;
		22: note <= 9;
		23: note <= 9;
		24: note <= 6;
		25: note <= 6;
		26: note <= 4;
		27: note <= 4;
		28: note <= 4;
		29: note <= 4;
		30: note <= 4;
		31: note <= 4;
		32: note <= 4;
		33: note <= 6;
		34: note <= 8;
		35: note <= 8;
		36: note <= 10;
		37: note <= 12;
		38: note <= 12;
		39: note <= 11;
		40: note <= 10;
		41: note <= 9;
		42: note <= 9;
		43: note <= 7;
		44: note <= 9;
		45: note <= 9;
		46: note <= 8;
		47: note <= 7;
		48: note <= 6;
		49: note <= 6;
		50: note <= 6;
		51: note <= 7;
		52: note <= 8;
		53: note <= 8;
		54: note <= 9;
		55: note <= 9;
		56: note <= 7;
		57: note <= 7;
		58: note <= 6;
		59: note <= 6;
		60: note <= 6;
		61: note <= 6;
		62: note <= 6;
		63: note <= 6;
	endcase            
end
endmodule