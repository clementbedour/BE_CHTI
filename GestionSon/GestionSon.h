#ifndef GESTIONSON_H
#define GESTIONSON_H

/**
	* @brief  Réinitialise la variable GestionSon_Index
  * @note   L' horloge doit etre au dessus du timer pour le callback*LongueurSon
	* @param  None
  * @retval None
  */

//void GestionSon_Start(void);
extern void GestionSon_Start(void);
/**
	* @brief  Utilise GestionSon_Index pour calculer le PWM
  * @note   None
	* @param  None
  * @retval None
  */

//void GestionSon_callback(void);
extern void GestionSon_callback(void);
#endif