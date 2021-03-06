#include "LSM9DS1.h"
#include "soc-hw.h"

uint8_t mReadByte(uint8_t subAddress)
{
	return I2CreadByte(mAddress, subAddress);
}

uint8_t agReadByte(uint8_t subAddress)
{
	return I2CreadByte(agAddress, subAddress);
}

void agWriteByte(uint8_t subAddress,uint8_t data)
{
	I2CwriteByte(agAddress, subAddress, data);
}

void initGyro()
{

// PRIMER REGISTRO
/*Como guía se seleccionara un ODR de 952hz con un ancho de banda de 33 Hz (1)
  y un valor a full escala de 245 DPS*/
	agWriteByte(CTRL_REG1_G,
		ag_ctrl1_sampleRate_952hz     |
		ag_ctrl1_fullScaleSel_245_dps |
        ag_ctrl1_bandWidth_1);

// SEGUNDO REGISTRO
// Se dejara el valor por defecto
	agWriteByte(CTRL_REG2_G, ag_ctrl2_Default );

// TERCER REGISTRO
// Se dejara el valor por defecto
	agWriteByte(CTRL_REG3_G, ag_ctrl3_Default );
}

/*
uint16_t config = INA219_CONFIG_BVOLTAGERANGE_16V |
                    INA219_CONFIG_GAIN_1_40MV |
                    INA219_CONFIG_BADCRES_12BIT |
                    INA219_CONFIG_SADCRES_12BIT_1S_532US |
                    INA219_CONFIG_MODE_SANDBVOLT_CONTINUOUS;

wireWriteRegister(INA219_REG_CONFIG, config);
*/
              
