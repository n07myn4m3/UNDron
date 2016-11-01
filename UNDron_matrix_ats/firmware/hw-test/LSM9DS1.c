#include "LSM9DS1.h"
#include "soc-hw.h"

uint8_t mReadByte(uint8_t subAddress)
{
	return I2CreadByte(mAddress, subAddress);
}


/*
uint16_t config = INA219_CONFIG_BVOLTAGERANGE_16V |
                    INA219_CONFIG_GAIN_1_40MV |
                    INA219_CONFIG_BADCRES_12BIT |
                    INA219_CONFIG_SADCRES_12BIT_1S_532US |
                    INA219_CONFIG_MODE_SANDBVOLT_CONTINUOUS;

wireWriteRegister(INA219_REG_CONFIG, config);
*/
              
