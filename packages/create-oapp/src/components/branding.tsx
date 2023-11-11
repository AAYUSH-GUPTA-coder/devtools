import { Text } from "ink"
import Gradient from "ink-gradient"
import React from "react"

export const Logo: React.FC = () => (
    <Gradient name="rainbow">
        <Text>{logo}</Text>
    </Gradient>
)

// prettier-ignore
const logo = `
     **********                                                                                                                  
   **************                                                                                                                
 ******************                                                                                                              
********************                                                                                                             
*********  *********                                                                                                             
*********  *********          ****                                                 ***********                                   
*********  *********          ****                                                 ***********                                   
   ******  *********          ****        *************    ****  ******   *******       ****    ******    *** **   ******        
 ********  *********          ****      *********** ****  **** ********** *******      ****   **********  ****** **********      
*********  ********           ****     ****    ****  ******** *********** ****        ****    *********** ****  ****    ****     
*********  ******             ****     ****    ****   ******* *********** ****      *****    ************ ***   ****    ****     
*********  *********          ********* ***********   ******   ********** ****     *********************  ***    **********  ****
*********  *********          *********  **********    ****     ********  ****     ***********  ********  ***      *******   ****
*********  *********                                 *****                                                                       
********************                                 ****                                                                        
 ******************                                                                                                              
  ****************                                                                                                               
     **********                                                                                                                  

`
