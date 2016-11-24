/******************************************************************************
LSM9DS1_Registers.h
SFE_LSM9DS1 Library - LSM9DS1 Register Map
Jim Lindblom @ SparkFun Electronics
Original Creation Date: April 21, 2015
https://github.com/sparkfun/LSM9DS1_Breakout

This file defines all registers internal to the gyro/accel and magnetometer
devices in the LSM9DS1.

Development environment specifics:
	IDE: Arduino 1.6.0
	Hardware Platform: Arduino Uno
	LSM9DS1 Breakout Version: 1.0

This code is beerware; if you see me (or any other SparkFun employee) at the
local, and you've found our code helpful, please buy us a round!

Distributed as-is; no warranty is given.
******************************************************************************/

#ifndef __LSM9DS1_Registers_H__
#define __LSM9DS1_Registers_H__

#include "soc-hw.h" //Para poder tener las definiciones uint

/////////////////////////////////////////
// Direcciones del magnetometro y del  //
// acelerometro-giroscopio deacuerdo a //
// la matrix-creator                   //
/////////////////////////////////////////
#define mAddress	  		 0x1C  //Magnetometro
#define agAddress	         0x6A  //Acelerometro-giroscopio  
/////////////////////////////////////////
// LSM9DS1 Accel/Gyro (XL/G) Registers //
/////////////////////////////////////////
#define ACT_THS				0x04
#define ACT_DUR				0x05
#define INT_GEN_CFG_XL		0x06
#define INT_GEN_THS_X_XL	0x07
#define INT_GEN_THS_Y_XL	0x08
#define INT_GEN_THS_Z_XL	0x09
#define INT_GEN_DUR_XL		0x0A
#define REFERENCE_G			0x0B
#define INT1_CTRL			0x0C
#define INT2_CTRL			0x0D
#define WHO_AM_I_AG			0x0F
#define CTRL_REG1_G			0x10
#define CTRL_REG2_G			0x11
#define CTRL_REG3_G			0x12
#define ORIENT_CFG_G		0x13
#define INT_GEN_SRC_G		0x14
#define OUT_TEMP_L			0x15
#define OUT_TEMP_H			0x16
#define STATUS_REG_0		   0x17
#define OUT_X_L_G			   0x18
#define OUT_X_H_G			   0x19
#define OUT_Y_L_G			   0x1A
#define OUT_Y_H_G			   0x1B
#define OUT_Z_L_G			   0x1C
#define OUT_Z_H_G			   0x1D
#define CTRL_REG4			   0x1E
#define CTRL_REG5_XL		   0x1F
#define CTRL_REG6_XL		   0x20
#define CTRL_REG7_XL		   0x21
#define CTRL_REG8			   0x22
#define CTRL_REG9			   0x23
#define CTRL_REG10			0x24
#define INT_GEN_SRC_XL		0x26
#define STATUS_REG_1		   0x27
#define OUT_X_L_XL			0x28
#define OUT_X_H_XL			0x29
#define OUT_Y_L_XL			0x2A
#define OUT_Y_H_XL			0x2B
#define OUT_Z_L_XL			0x2C
#define OUT_Z_H_XL			0x2D
#define FIFO_CTRL			   0x2E
#define FIFO_SRC			   0x2F
#define INT_GEN_CFG_G		0x30
#define INT_GEN_THS_XH_G	0x31
#define INT_GEN_THS_XL_G	0x32
#define INT_GEN_THS_YH_G	0x33
#define INT_GEN_THS_YL_G	0x34
#define INT_GEN_THS_ZH_G	0x35
#define INT_GEN_THS_ZL_G	0x36
#define INT_GEN_DUR_G		0x37

///////////////////////////////
// LSM9DS1 Magneto Registers //
///////////////////////////////
#define OFFSET_X_REG_L_M	0x05
#define OFFSET_X_REG_H_M	0x06
#define OFFSET_Y_REG_L_M	0x07
#define OFFSET_Y_REG_H_M	0x08
#define OFFSET_Z_REG_L_M	0x09
#define OFFSET_Z_REG_H_M	0x0A
#define WHO_AM_I_M			0x0F
#define CTRL_REG1_M			0x20
#define CTRL_REG2_M			0x21
#define CTRL_REG3_M			0x22
#define CTRL_REG4_M			0x23
#define CTRL_REG5_M			0x24
#define STATUS_REG_M		   0x27
#define OUT_X_L_M			   0x28
#define OUT_X_H_M			   0x29
#define OUT_Y_L_M			   0x2A
#define OUT_Y_H_M			   0x2B
#define OUT_Z_L_M			   0x2C
#define OUT_Z_H_M			   0x2D
#define INT_CFG_M			   0x30
#define INT_SRC_M			   0x30
#define INT_THS_L_M			0x32
#define INT_THS_H_M			0x33

////////////////////////////////
// LSM9DS1 WHO_AM_I Responses //
////////////////////////////////
#define WHO_AM_I_AG_RSP		0x68  //0110-1000
#define WHO_AM_I_M_RSP		0x3D  //0011-1101

/*=========================================================================
    CONFIG REGISTER (R/W)
    -----------------------------------------------------------------------*/
    /*=======================
    //CTRL_REG1_G (0X10)
    -----------------------*/ 

		// CTRL_REG1_G (Valor por defecto: 0x00)
		// [ODR_G2][ODR_G1][ODR_G0][FS_G1][FS_G0][0][BW_G1][BW_G0]
		// ODR_G[2:0] - Output data rate selection (sampleRate)
		// FS_G[1:0] - Gyroscope full-scale selection (fullScaleSel)
		// BW_G[1:0] - Gyroscope bandwidth selection (bandWidth)
	
		// To disable gyro, set sample rate bits to 0. We'll only set sample
		// rate if the gyro is enabled.

      //gyro sampleRate
		#define ag_ctrl1_sampleRate_14hz_9mhz    (0x20) //0010-0000
		#define ag_ctrl1_sampleRate_59hz_5mhz    (0x40) //0100-0000
		#define ag_ctrl1_sampleRate_119hz        (0x60) //0110-0000
		#define ag_ctrl1_sampleRate_238hz        (0x80) //1000-0000
		#define ag_ctrl1_sampleRate_476hz        (0xA0) //1010-0000
		#define ag_ctrl1_sampleRate_952hz        (0xCO) //1100-0000
      //gyro fullScaleSel
		#define ag_ctrl1_fullScaleSel_245_dps    (0x00) //0000-0000
		#define ag_ctrl1_fullScaleSel_500_dps    (0x08) //0000-1000
		#define ag_ctrl1_fullScaleSel_2000_dps   (0x18) //0001-1000
      //gyro bandWidth
		#define ag_ctrl1_bandWidth_1             (0x00) //0000-0000  
		#define ag_ctrl1_bandWidth_2             (0x01) //0000-0001
		#define ag_ctrl1_bandWidth_3             (0x02) //0000-0010
		#define ag_ctrl1_bandWidth_4             (0x03) //0000-0011    

    /*=======================
    //CTRL_REG2_G (0X11)
    -----------------------*/ 

		// CTRL_REG2_G (Default value: 0x00)
		// [0][0][0][0][INT_SEL1][INT_SEL0][OUT_SEL1][OUT_SEL0]
		// INT_SEL[1:0] - INT selection configuration
		// OUT_SEL[1:0] - Out selection configuration

        // Nota: Se deja por defecto en cero

		#define ag_ctrl2_Default                 (0x00) //0000-0000   

    /*=======================
    //CTRL_REG3_G (0X12)
    -----------------------*/ 

	// CTRL_REG3_G (Default value: 0x00)
	// [LP_mode][HP_EN][0][0][HPCF3_G][HPCF2_G][HPCF1_G][HPCF0_G]
	// LP_mode - Low-power mode enable (0: disabled, 1: enabled)
	// HP_EN - HPF enable (0:disabled, 1: enabled)
	// HPCF_G[3:0] - HPF cutoff frequency

		#define ag_ctrl3_Default                 (0x00) //0000-0000 

	
    #define INA219_CONFIG_BADCRES_MASK             (0x0780)  // Bus ADC Resolution Mask
    #define INA219_CONFIG_BADCRES_9BIT             (0x0080)  // 9-bit bus res = 0..511
    #define INA219_CONFIG_BADCRES_10BIT            (0x0100)  // 10-bit bus res = 0..1023
    #define INA219_CONFIG_BADCRES_11BIT            (0x0200)  // 11-bit bus res = 0..2047
    #define INA219_CONFIG_BADCRES_12BIT            (0x0400)  // 12-bit bus res = 0..4097
    
    #define INA219_CONFIG_SADCRES_MASK             (0x0078)  // Shunt ADC Resolution and Averaging Mask
    #define INA219_CONFIG_SADCRES_9BIT_1S_84US     (0x0000)  // 1 x 9-bit shunt sample
    #define INA219_CONFIG_SADCRES_10BIT_1S_148US   (0x0008)  // 1 x 10-bit shunt sample
    #define INA219_CONFIG_SADCRES_11BIT_1S_276US   (0x0010)  // 1 x 11-bit shunt sample
    #define INA219_CONFIG_SADCRES_12BIT_1S_532US   (0x0018)  // 1 x 12-bit shunt sample
    #define INA219_CONFIG_SADCRES_12BIT_2S_1060US  (0x0048)	 // 2 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_4S_2130US  (0x0050)  // 4 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_8S_4260US  (0x0058)  // 8 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_16S_8510US (0x0060)  // 16 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_32S_17MS   (0x0068)  // 32 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_64S_34MS   (0x0070)  // 64 x 12-bit shunt samples averaged together
    #define INA219_CONFIG_SADCRES_12BIT_128S_69MS  (0x0078)  // 128 x 12-bit shunt samples averaged together
	
    #define INA219_CONFIG_MODE_MASK                (0x0007)  // Operating Mode Mask
    #define INA219_CONFIG_MODE_POWERDOWN           (0x0000)
    #define INA219_CONFIG_MODE_SVOLT_TRIGGERED     (0x0001)
    #define INA219_CONFIG_MODE_BVOLT_TRIGGERED     (0x0002)
    #define INA219_CONFIG_MODE_SANDBVOLT_TRIGGERED (0x0003)
    #define INA219_CONFIG_MODE_ADCOFF              (0x0004)
    #define INA219_CONFIG_MODE_SVOLT_CONTINUOUS    (0x0005)
    #define INA219_CONFIG_MODE_BVOLT_CONTINUOUS    (0x0006)
    #define INA219_CONFIG_MODE_SANDBVOLT_CONTINUOUS (0x0007)	
/*=========================================================================*/

////////////////////////////////
//     LSM9DS1 FUNCTIONS      //
////////////////////////////////

uint8_t mReadByte(uint8_t subAddress);
uint8_t agReadByte(uint8_t subAddress);
void initGyro();
#endif
