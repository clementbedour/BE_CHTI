#include "DriverJeuLaser.h"
#include "ServiceJeuLaser.h"
#include "GestionSon.h"


extern int PeriodeSonMicroSec;


int main(void)
{
// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================


	
/* Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers */
CLOCK_Configure();

/* Configuration du son (voir ServiceJeuLaser.h) 
 Insérez votre code d'initialisation des parties matérielles gérant le son ....*/	


ServJeuLASER_Son_Init(PeriodeSonMicroSec,1, GestionSon_callback);
Timer_1234_Init_ff(TIM2,72000000);
Active_IT_Debordement_Timer(TIM2,2,GestionSon_Start);
	

//============================================================================	
	
	
while	(1)
	{
		
	}
}


